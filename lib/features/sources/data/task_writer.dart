import 'package:drift/drift.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../engines/reading/reading_math.dart';
import '../../../engines/review/review_engine.dart';
import '../../../engines/review/review_types.dart';
import '../../tasks/data/review_repository.dart';

/// A task to create from one or more consecutive chapters of a source.
final class TaskDraft {
  const TaskDraft({
    required this.title,
    required this.chapters,
    this.importance,
    this.firstReadSec,
    this.range,
    this.part,
    this.parts,
  });

  final String title;

  /// In reading order; each gets a TaskChunk.
  final List<Chunk> chapters;

  /// For the exam; Medium when null.
  final Importance? importance;

  /// When set, the first read is recorded now with this duration (D29).
  final int? firstReadSec;

  /// For a task over part of one chapter (D49): its units, or part [part]
  /// of [parts] of a chapter without them.
  final UnitRange? range;
  final int? part;
  final int? parts;
}

/// What recording a first read needs, loaded before the transaction.
final class FirstReadContext {
  const FirstReadContext({required this.engine, this.deadline});

  final ReviewEngine engine;
  final DateTime? deadline;
}

/// The one routine that turns chapters into tasks (D27), shared by the
/// survey, "Add task" and reading as you go, so the three routes cannot
/// drift apart. It writes inside the caller's operation.
final class TaskWriter {
  const TaskWriter(this.db, {this.reviews});

  final AppDatabase db;

  /// Needed only to record first reads.
  final ReviewRepository? reviews;

  /// The belt target an importance sets (docs/01-product.md, "Source
  /// survey"). The planner caps it by the time left before the exam.
  static int targetLevelFor(Importance importance) => switch (importance) {
    Importance.high => Defaults.targetLevelHigh,
    Importance.medium => Defaults.targetLevelMedium,
    Importance.low => Defaults.targetLevelLow,
  };

  /// The highest of [values], or null when there are none.
  static Importance? highest(Iterable<Importance?> values) {
    Importance? best;
    for (final v in values) {
      if (v != null && (best == null || v.index < best.index)) best = v;
    }
    return best;
  }

  /// Loads the review engine and deadline, when a first read is to be
  /// recorded.
  Future<FirstReadContext> firstReadContext() async {
    final r = reviews!;
    return FirstReadContext(
      engine: await r.loadEngine(),
      deadline: await r.deadline(),
    );
  }

  /// Creates the task, its level-0 state, a TaskChunk per chapter and,
  /// with [examId], its ExamTask; then the first read if the draft asks
  /// for one. Returns the task id.
  Future<String> insert(
    ChangeRecorder rec,
    TaskDraft draft, {
    String? examId,
    FirstReadContext? firstRead,
  }) async {
    final taskId = rec.newId();
    await rec.insert(
      db.tasks,
      TasksCompanion(
        id: Value(taskId),
        title: Value(draft.title),
        kind: const Value(TaskKind.learn),
        status: const Value(TaskStatus.active),
      ),
    );
    await rec.insert(
      db.taskStates,
      TaskStatesCompanion(
        id: Value(rec.newId()),
        taskId: Value(taskId),
        level: const Value(0),
      ),
    );
    for (final (i, c) in draft.chapters.indexed) {
      await rec.insert(
        db.taskChunks,
        TaskChunksCompanion(
          id: Value(rec.newId()),
          taskId: Value(taskId),
          chunkId: Value(c.id),
          startUnit: Value(draft.range?.start ?? c.startUnit),
          endUnit: Value(draft.range?.end ?? c.endUnit),
          order: Value(i),
          part: Value(draft.part),
          parts: Value(draft.parts),
        ),
      );
    }
    final importance = draft.importance ?? Importance.medium;
    final target = examId == null ? null : targetLevelFor(importance);
    if (examId != null) {
      await rec.insert(
        db.examTasks,
        ExamTasksCompanion(
          id: Value(rec.newId()),
          examId: Value(examId),
          taskId: Value(taskId),
          importance: Value(importance),
          targetLevel: Value(target!),
        ),
      );
    }
    if (draft.firstReadSec case final seconds?) {
      await recordFirstRead(
        rec,
        taskId,
        seconds: seconds,
        targetLevel: target,
        context: firstRead!,
      );
    }
    return taskId;
  }

  /// Records the first read of an existing task inside the operation.
  Future<void> recordFirstRead(
    ChangeRecorder rec,
    String taskId, {
    required int seconds,
    required FirstReadContext context,
    int? targetLevel,
  }) => reviews!.recordIn(
    rec,
    taskId: taskId,
    rating: Rating.good,
    kind: ReviewKind.firstRead,
    durationSec: seconds,
    engine: context.engine,
    deadline: context.deadline,
    planned: context.engine.plannedReviewsFor(targetLevel),
  );
}
