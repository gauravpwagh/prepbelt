import 'package:drift/drift.dart';

import '../../../core/config/review_config.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';
import '../../../engines/review/review_engine.dart';
import '../../../engines/review/review_types.dart';
import 'task_repository.dart';

/// Writes the append-only Review log and keeps the TaskState cache in step
/// with it through the review engine. Events go under the task's id, so
/// pause and resume are undoable with the task's other changes; reviews
/// are not (decision D9).
final class ReviewRepository extends EventSourcedRepository {
  ReviewRepository(super.ctx, {required this.config});

  /// Current engine configuration (defaults merged with settings).
  final Future<ReviewConfig> Function() config;

  static const entity = TaskRepository.entity;
  static const _pause = 'pause';
  static const _resume = 'resume';

  Future<ReviewEngine> _engine() async => ReviewEngine(await config());

  /// Records one review at the current time: appends the Review row,
  /// updates TaskState through the engine and logs an Event, in one
  /// transaction.
  Future<Review> record({
    required String taskId,
    required Rating rating,
    ReviewKind kind = ReviewKind.review,
    int durationSec = 0,
    int? resumeUnit,
  }) async {
    final engine = await _engine();
    return mutate(
      entity: entity,
      entityId: taskId,
      op: EventOp.review,
      data: {'rating': rating.value, 'kind': kind.name},
      body: (rec) async {
        final row = await _stateRow(taskId);
        final state = toReviewState(row);
        if (state.paused) {
          throw const InvalidOperationError('Resume the task to review it');
        }
        final at = fromUtcMs(rec.now);
        final out = engine.applyReview(state, rating, at);
        final review = await rec.insert(
          db.reviews,
          ReviewsCompanion(
            id: Value(rec.newId()),
            taskId: Value(taskId),
            at: Value(rec.now),
            kind: Value(kind),
            rating: Value(rating.value),
            durationSec: Value(durationSec),
            resumeUnit: Value(resumeUnit),
            levelBefore: Value(out.levelBefore),
            levelAfter: Value(out.levelAfter),
            stabilityAfter: Value(out.stabilityAfter),
            dueAfter: Value(out.dueAfter.millisecondsSinceEpoch),
          ),
        );
        await rec.update(db.taskStates, row.id, toCompanion(out.state));
        return review;
      },
    );
  }

  /// Pauses a task: no decay and no due date until it resumes.
  Future<void> pause(String taskId) async {
    final engine = await _engine();
    await mutate<void>(
      entity: entity,
      entityId: taskId,
      op: EventOp.update,
      data: {'action': _pause},
      body: (rec) async {
        final row = await _stateRow(taskId);
        final state = toReviewState(row);
        if (state.paused) {
          throw const InvalidOperationError('Task is already paused');
        }
        await rec.update(
          db.tasks,
          taskId,
          const TasksCompanion(status: Value(TaskStatus.paused)),
        );
        await rec.update(
          db.taskStates,
          row.id,
          toCompanion(engine.pause(state, fromUtcMs(rec.now))),
        );
      },
    );
  }

  /// Resumes a paused task; its due date moves later by the paused time.
  Future<void> resume(String taskId) async {
    final engine = await _engine();
    await mutate<void>(
      entity: entity,
      entityId: taskId,
      op: EventOp.update,
      data: {'action': _resume},
      body: (rec) async {
        final row = await _stateRow(taskId);
        final state = toReviewState(row);
        if (!state.paused) {
          throw const InvalidOperationError('Task is not paused');
        }
        await rec.update(
          db.tasks,
          taskId,
          const TasksCompanion(status: Value(TaskStatus.active)),
        );
        await rec.update(
          db.taskStates,
          row.id,
          toCompanion(engine.resume(state, fromUtcMs(rec.now))),
        );
      },
    );
  }

  /// The task's review log, oldest first.
  Future<List<Review>> reviewsFor(String taskId) =>
      (db.select(db.reviews)
            ..where((r) => r.taskId.equals(taskId))
            ..orderBy([
              (r) => OrderingTerm.asc(r.at),
              (r) => OrderingTerm.asc(r.hlc),
            ]))
          .get();

  /// Pause intervals from the task's standing pause and resume events.
  Future<List<PauseInterval>> pausesFor(String taskId) async {
    final events = (await effectiveEvents(entity, taskId)).reversed;
    final intervals = <PauseInterval>[];
    PauseInterval? open;
    for (final e in events) {
      final action = EventPayload.decode(e.payload).data?['action'];
      if (action == _pause) {
        open = PauseInterval(start: fromUtcMs(e.createdAt), order: e.hlc);
      } else if (action == _resume && open != null) {
        intervals.add(open.copyWith(end: fromUtcMs(e.createdAt)));
        open = null;
      }
    }
    return [...intervals, ?open];
  }

  /// Recomputes one task's state from its Review rows and pauses.
  Future<ReviewState> rebuildState(String taskId) async {
    final engine = await _engine();
    final reviews = [
      for (final r in await reviewsFor(taskId))
        ReviewRecord(
          at: fromUtcMs(r.at),
          rating: Rating.fromValue(r.rating),
          order: r.hlc,
        ),
    ];
    return engine.rebuild(reviews, await pausesFor(taskId));
  }

  /// The rebuild command: recomputes every TaskState from the Review log
  /// and writes the ones that differ (each with an Event). Returns how
  /// many tasks were checked.
  Future<int> rebuildAll() async {
    final rows = await db.select(db.taskStates).get();
    for (final row in rows) {
      final rebuilt = await rebuildState(row.taskId);
      if (rebuilt == toReviewState(row)) continue;
      await mutate<void>(
        entity: entity,
        entityId: row.taskId,
        op: EventOp.update,
        data: {'action': 'rebuild'},
        body: (rec) => rec.update(db.taskStates, row.id, toCompanion(rebuilt)),
      );
    }
    return rows.length;
  }

  Future<TaskState> _stateRow(String taskId) async {
    final row = await (db.select(
      db.taskStates,
    )..where((s) => s.taskId.equals(taskId))).getSingleOrNull();
    if (row == null || row.deletedAt != null) {
      throw NotFoundError('task $taskId');
    }
    return row;
  }

  static ReviewState toReviewState(TaskState row) => ReviewState(
    level: row.level,
    stability: row.fsrsStability,
    difficulty: row.fsrsDifficulty,
    lastReviewAt: row.lastReviewAt == null
        ? null
        : fromUtcMs(row.lastReviewAt!),
    dueAt: row.dueAt == null ? null : fromUtcMs(row.dueAt!),
    reps: row.reps,
    lapses: row.lapses,
    pausedAt: row.pausedAt == null ? null : fromUtcMs(row.pausedAt!),
  );

  static TaskStatesCompanion toCompanion(ReviewState s) => TaskStatesCompanion(
    level: Value(s.level),
    fsrsStability: Value(s.stability),
    fsrsDifficulty: Value(s.difficulty),
    lastReviewAt: Value(s.lastReviewAt?.millisecondsSinceEpoch),
    dueAt: Value(s.dueAt?.millisecondsSinceEpoch),
    reps: Value(s.reps),
    lapses: Value(s.lapses),
    pausedAt: Value(s.pausedAt?.millisecondsSinceEpoch),
  );
}
