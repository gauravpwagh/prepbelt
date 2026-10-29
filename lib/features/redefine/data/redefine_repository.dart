import 'dart:math';

import 'package:drift/drift.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';
import '../../session/data/session_repository.dart';
import '../../tasks/data/task_repository.dart';

/// Redefinition operations (docs/02-data-model.md, "Redefinition
/// operations"): rename, importance, scope and split. Each runs in one
/// transaction, logs one Event under the task (so it can be undone) and
/// never touches the Review log. Pause and resume live in
/// `ReviewRepository`.
final class RedefineRepository extends EventSourcedRepository {
  RedefineRepository(super.ctx, {required this.sessions});

  final SessionRepository sessions;

  static const entity = TaskRepository.entity;

  /// Event `data.action` values of redefinitions, for "Undo last change".
  static const actions = {
    'rename',
    'importance',
    'scope',
    'split',
    'pause',
    'resume',
  };

  Future<void> rename(String taskId, String title) => mutate<void>(
    entity: entity,
    entityId: taskId,
    op: EventOp.update,
    data: {'action': 'rename'},
    body: (rec) =>
        rec.update(db.tasks, taskId, TasksCompanion(title: Value(title))),
  );

  /// Sets the task's importance for [examId]; its belt target follows.
  Future<void> setImportance(
    String examId,
    String taskId,
    Importance importance, {
    required int targetLevel,
  }) async {
    final link =
        await (db.select(db.examTasks)..where(
              (l) =>
                  l.examId.equals(examId) &
                  l.taskId.equals(taskId) &
                  l.deletedAt.isNull(),
            ))
            .getSingle();
    await mutate<void>(
      entity: entity,
      entityId: taskId,
      op: EventOp.update,
      data: {'action': 'importance', 'importance': importance.name},
      body: (rec) => rec.update(
        db.examTasks,
        link.id,
        ExamTasksCompanion(
          importance: Value(importance),
          targetLevel: Value(targetLevel),
          importanceOverridden: const Value(true),
        ),
      ),
    );
  }

  /// Changes a one-part task's range to [start]–[end] (units of its
  /// source). Shrinking keeps the belt. Expanding either keeps one task
  /// whose belt dims one step until the next Good review, or, with
  /// [splitAdded], makes the added pages a new task at level 0 (one per
  /// side added). Returns the new tasks' ids.
  Future<List<String>> setScope(
    String taskId, {
    required int start,
    required int end,
    bool splitAdded = true,
  }) async {
    final info = await sessions.load(taskId);
    if (info.parts.length != 1 || info.range == null) {
      throw const InvalidOperationError('Only a one-part task can be rescoped');
    }
    if (start > end) throw const InvalidOperationError('Start after end');
    final part = info.parts.single;
    final (from, to) = (info.range!.start, info.range!.end);
    final added = [
      if (start < from) (start, from - 1),
      if (end > to) (to + 1, end),
    ];
    final created = <String>[];
    await mutate<void>(
      entity: entity,
      entityId: taskId,
      op: EventOp.update,
      data: {
        'action': 'scope',
        'start': start,
        'end': end,
        'splitAdded': splitAdded,
      },
      body: (rec) async {
        if (added.isEmpty || !splitAdded) {
          await rec.update(
            db.taskChunks,
            part.link.id,
            TaskChunksCompanion(startUnit: Value(start), endUnit: Value(end)),
          );
          if (added.isNotEmpty && info.state.level > 0) {
            // Kept as one: more to know, so the belt dims a step.
            await rec.update(
              db.taskStates,
              info.state.id,
              TaskStatesCompanion(
                dim: Value(min(Defaults.maxDimSteps, info.state.dim + 1)),
              ),
            );
          }
          return;
        }
        // Shrink to the old range on any side that only grew, then give
        // each added side its own task.
        await rec.update(
          db.taskChunks,
          part.link.id,
          TaskChunksCompanion(
            startUnit: Value(max(start, from)),
            endUnit: Value(min(end, to)),
          ),
        );
        for (final (a, b) in added) {
          final id = await _newTask(
            rec,
            title: '${info.task.title} (${a == b ? a : '$a–$b'})',
            copyFrom: null,
            parentId: taskId,
            op: LineageOp.expand,
          );
          await rec.insert(
            db.taskChunks,
            TaskChunksCompanion(
              id: Value(rec.newId()),
              taskId: Value(id),
              chunkId: Value(part.chunk.id),
              startUnit: Value(a),
              endUnit: Value(b),
              order: const Value(0),
            ),
          );
          await _copyExamLinks(rec, from: taskId, to: id, fresh: true);
          created.add(id);
        }
      },
    );
    return created;
  }

  /// Splits a task with a page range after unit [after] into two tasks
  /// named [titleA] and [titleB]. Both inherit the belt, stripes, step and
  /// exam links; the second is due a day later so they don't land on the
  /// same day. The original is archived and linked by lineage. Returns
  /// both new ids.
  Future<(String, String)> split(
    String taskId, {
    required int after,
    required String titleA,
    required String titleB,
  }) async {
    final info = await sessions.load(taskId);
    final range = info.range;
    if (range == null) {
      throw const InvalidOperationError('Only a task with a range can split');
    }
    if (after < range.start || after >= range.end) {
      throw const InvalidOperationError('The split point must be inside');
    }
    final active = await sessions.active();
    if (active?.taskId == taskId) {
      throw const InvalidOperationError('Finish the open session first');
    }
    late String a, b;
    await mutate<void>(
      entity: entity,
      entityId: taskId,
      op: EventOp.split,
      data: {'action': 'split', 'after': after},
      body: (rec) async {
        a = await _newTask(
          rec,
          title: titleA,
          copyFrom: info.state,
          parentId: taskId,
          op: LineageOp.split,
        );
        b = await _newTask(
          rec,
          title: titleB,
          copyFrom: info.state,
          parentId: taskId,
          op: LineageOp.split,
          staggerDays: 1,
        );
        var orderA = 0, orderB = 0;
        for (final p in info.parts) {
          final s = p.link.startUnit ?? p.chunk.startUnit!;
          final e = p.link.endUnit ?? p.chunk.endUnit!;
          Future<void> link(String task, int from, int to, int order) =>
              rec.insert(
                db.taskChunks,
                TaskChunksCompanion(
                  id: Value(rec.newId()),
                  taskId: Value(task),
                  chunkId: Value(p.chunk.id),
                  startUnit: Value(from),
                  endUnit: Value(to),
                  order: Value(order),
                ),
              );
          if (s <= after) await link(a, s, min(e, after), orderA++);
          if (e > after) await link(b, max(s, after + 1), e, orderB++);
        }
        await _copyExamLinks(rec, from: taskId, to: a);
        await _copyExamLinks(rec, from: taskId, to: b);
        await rec.update(
          db.tasks,
          taskId,
          const TasksCompanion(status: Value(TaskStatus.archived)),
        );
      },
    );
    return (a, b);
  }

  /// The latest redefinition of [taskId] that can still be undone: the
  /// task's own, or the split that created it. Null when the latest
  /// change is a review or there is none.
  Future<({String entityId, String action})?> undoable(String taskId) async {
    Future<({String entityId, String action})?> of(String id) async {
      final e = await latestUndoable(entity, id);
      if (e == null || e.op == EventOp.review) return null;
      final action = EventPayload.decode(e.payload).data?['action'];
      return action is String && actions.contains(action)
          ? (entityId: id, action: action)
          : null;
    }

    final own = await of(taskId);
    if (own != null) return own;
    // A part of a split: undoing the split brings the original back, as
    // long as neither part has a review since.
    final parent =
        await (db.select(db.taskLineages)..where(
              (l) =>
                  l.childTaskId.equals(taskId) &
                  l.op.equalsValue(LineageOp.split) &
                  l.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (parent == null) return null;
    final split = await of(parent.parentTaskId);
    if (split?.action != 'split') return null;
    final parts =
        await (db.select(db.taskLineages)..where(
              (l) =>
                  l.parentTaskId.equals(parent.parentTaskId) &
                  l.deletedAt.isNull(),
            ))
            .get();
    for (final p in parts) {
      final reviewed =
          await (db.select(db.reviews)
                ..where(
                  (r) =>
                      r.taskId.equals(p.childTaskId) &
                      r.at.isBiggerThanValue(p.at),
                )
                ..limit(1))
              .getSingleOrNull();
      if (reviewed != null) return null;
    }
    return split;
  }

  /// Undoes what [undoable] found.
  Future<void> undo(String taskId) async {
    final target = await undoable(taskId);
    if (target == null) {
      throw NothingToUndoError('task $taskId has nothing to undo');
    }
    await undoLatest(entity, target.entityId);
  }

  Future<String> _newTask(
    ChangeRecorder rec, {
    required String title,
    required TaskState? copyFrom,
    required String parentId,
    required LineageOp op,
    int staggerDays = 0,
  }) async {
    final id = rec.newId();
    final parent = await (db.select(
      db.tasks,
    )..where((t) => t.id.equals(parentId))).getSingle();
    await rec.insert(
      db.tasks,
      TasksCompanion(
        id: Value(id),
        title: Value(title),
        kind: Value(parent.kind),
        status: const Value(TaskStatus.active),
        topicId: Value(parent.topicId),
        needsDetail: const Value(false),
      ),
    );
    final s = copyFrom;
    final due = s?.dueAt;
    await rec.insert(
      db.taskStates,
      TaskStatesCompanion(
        id: Value(rec.newId()),
        taskId: Value(id),
        level: Value(s?.level ?? 0),
        step: Value(s?.step ?? 0),
        dim: Value(s?.dim ?? 0),
        lastReviewAt: Value(s?.lastReviewAt),
        dueAt: Value(
          due == null ? null : due + staggerDays * Duration.millisecondsPerDay,
        ),
        reps: Value(s?.reps ?? 0),
        lapses: Value(s?.lapses ?? 0),
        pausedAt: Value(s?.pausedAt),
      ),
    );
    await rec.insert(
      db.taskLineages,
      TaskLineagesCompanion(
        id: Value(rec.newId()),
        childTaskId: Value(id),
        parentTaskId: Value(parentId),
        op: Value(op),
        at: Value(rec.now),
      ),
    );
    return id;
  }

  /// Copies [from]'s exam links to [to]. [fresh] tasks keep importance
  /// and target, but not a student override.
  Future<void> _copyExamLinks(
    ChangeRecorder rec, {
    required String from,
    required String to,
    bool fresh = false,
  }) async {
    final links = await (db.select(
      db.examTasks,
    )..where((l) => l.taskId.equals(from) & l.deletedAt.isNull())).get();
    for (final l in links) {
      await rec.insert(
        db.examTasks,
        ExamTasksCompanion(
          id: Value(rec.newId()),
          examId: Value(l.examId),
          taskId: Value(to),
          importance: Value(l.importance),
          targetLevel: Value(l.targetLevel),
          importanceOverridden: Value(!fresh && l.importanceOverridden),
          triageKeep: Value(!fresh && l.triageKeep),
          dropped: Value(!fresh && l.dropped),
        ),
      );
    }
  }
}
