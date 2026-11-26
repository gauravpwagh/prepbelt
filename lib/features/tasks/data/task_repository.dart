import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';

/// Writes and reads [Task] rows and their [TaskState] cache. Every write
/// logs an Event under the task's id.
final class TaskRepository extends EventSourcedRepository {
  TaskRepository(super.ctx);

  static const entity = 'task';

  /// Checklist items log under their own id, so ticking one never hides
  /// the task's "Undo last change".
  static const stepEntity = 'taskStep';

  /// Creates a task and its not-started TaskState (level 0) together.
  Future<Task> create({
    required String title,
    TaskKind kind = TaskKind.learn,
    String? topicId,
    bool needsDetail = false,
  }) {
    final id = ctx.ids.next();
    return mutate(
      entity: entity,
      entityId: id,
      op: EventOp.create,
      body: (rec) async {
        final task = await rec.insert(
          db.tasks,
          TasksCompanion(
            id: Value(id),
            title: Value(title),
            kind: Value(kind),
            status: const Value(TaskStatus.active),
            topicId: Value(topicId),
            needsDetail: Value(needsDetail),
          ),
        );
        await rec.insert(
          db.taskStates,
          TaskStatesCompanion(
            id: Value(rec.newId()),
            taskId: Value(id),
            level: const Value(0),
          ),
        );
        return task;
      },
    );
  }

  /// Rename, retopic or flag a task. No mastery effect.
  Future<Task> update(
    String id, {
    Value<String> title = const Value.absent(),
    Value<String?> topicId = const Value.absent(),
    Value<TaskKind> kind = const Value.absent(),
    Value<bool> needsDetail = const Value.absent(),
  }) => mutate(
    entity: entity,
    entityId: id,
    op: EventOp.update,
    body: (rec) => rec.update(
      db.tasks,
      id,
      TasksCompanion(
        title: title,
        topicId: topicId,
        kind: kind,
        needsDetail: needsDetail,
      ),
    ),
  );

  /// Deletes task [id] with its links to chapters and exams and its
  /// checklist, as one undoable change (D55). Reviews stay in the log
  /// (they are append-only). Refused while its review is open.
  Future<void> softDelete(String id) async {
    final active = await (db.select(
      db.activeSessions,
    )..limit(1)).getSingleOrNull();
    if (active?.taskId == id) {
      throw const InvalidOperationError('Finish the open review first');
    }
    final chunks = await (db.select(
      db.taskChunks,
    )..where((t) => t.taskId.equals(id) & t.deletedAt.isNull())).get();
    final exams = await (db.select(
      db.examTasks,
    )..where((t) => t.taskId.equals(id) & t.deletedAt.isNull())).get();
    final steps = await (db.select(
      db.taskSteps,
    )..where((t) => t.taskId.equals(id) & t.deletedAt.isNull())).get();
    await mutate<void>(
      entity: entity,
      entityId: id,
      op: EventOp.delete,
      body: (rec) async {
        for (final r in chunks) {
          await rec.softDelete(db.taskChunks, r.id);
        }
        for (final r in exams) {
          await rec.softDelete(db.examTasks, r.id);
        }
        for (final r in steps) {
          await rec.softDelete(db.taskSteps, r.id);
        }
        await rec.softDelete(db.tasks, id);
      },
    );
  }

  /// Reverses the latest change to this task (never a review).
  Future<void> undo(String id) => undoLatest(entity, id);

  /// The checklist of [taskId] (D55), in order.
  Stream<List<TaskStep>> watchSteps(String taskId) =>
      (db.select(db.taskSteps)
            ..where((t) => t.taskId.equals(taskId) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.order)]))
          .watch();

  /// Adds [title] at the end of [taskId]'s checklist.
  Future<TaskStep> addStep(String taskId, String title) async {
    final last =
        await (db.select(db.taskSteps)
              ..where((t) => t.taskId.equals(taskId) & t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.desc(t.order)])
              ..limit(1))
            .getSingleOrNull();
    final id = ctx.ids.next();
    return mutate(
      entity: stepEntity,
      entityId: id,
      op: EventOp.create,
      body: (rec) => rec.insert(
        db.taskSteps,
        TaskStepsCompanion(
          id: Value(id),
          taskId: Value(taskId),
          title: Value(title),
          order: Value((last?.order ?? -1) + 1),
        ),
      ),
    );
  }

  /// Ticks or unticks a checklist item. No effect on the belt or plan.
  Future<void> setStepDone(String stepId, {required bool done}) => mutate<void>(
    entity: stepEntity,
    entityId: stepId,
    op: EventOp.update,
    body: (rec) =>
        rec.update(db.taskSteps, stepId, TaskStepsCompanion(done: Value(done))),
  );

  Future<void> removeStep(String stepId) => mutate<void>(
    entity: stepEntity,
    entityId: stepId,
    op: EventOp.delete,
    body: (rec) => rec.softDelete(db.taskSteps, stepId),
  );

  /// Brings back a removed checklist item.
  Future<void> undoStep(String stepId) => undoLatest(stepEntity, stepId);

  Stream<List<Task>> watchAll() =>
      (db.select(db.tasks)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Stream<Task?> watch(String id) => (db.select(
    db.tasks,
  )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).watchSingleOrNull();

  Stream<TaskState?> watchState(String taskId) => (db.select(
    db.taskStates,
  )..where((s) => s.taskId.equals(taskId))).watchSingleOrNull();

  Future<TaskState> getState(String taskId) => (db.select(
    db.taskStates,
  )..where((s) => s.taskId.equals(taskId))).getSingle();
}
