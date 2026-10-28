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

  /// The latest time a review may be due: the start of the day that is
  /// `lastReviewDaysBeforeExam - 1` days before the upcoming exam (with the
  /// default of 1, midnight at the start of exam day). Null without an exam.
  Future<DateTime?> deadline() async {
    final exam = await _upcomingExam();
    if (exam == null) return null;
    final days = (await config()).lastReviewDaysBeforeExam;
    final day = DateTime.parse(exam.date);
    return DateTime(day.year, day.month, day.day - (days - 1)).toUtc();
  }

  /// How many reviews to plan for [taskId]: set by its belt target in the
  /// upcoming exam (High → Black plans 5, Medium → Blue 4, Low → Green 3);
  /// the full schedule when it has no target.
  Future<int> plannedReviews(String taskId) async {
    final engine = await _engine();
    final exam = await _upcomingExam();
    final link = exam == null
        ? null
        : await (db.select(db.examTasks)..where(
                (l) =>
                    l.examId.equals(exam.id) &
                    l.taskId.equals(taskId) &
                    l.deletedAt.isNull(),
              ))
              .getSingleOrNull();
    return engine.plannedReviewsFor(link?.targetLevel);
  }

  Future<Exam?> _upcomingExam() =>
      (db.select(db.exams)
            ..where(
              (e) =>
                  e.deletedAt.isNull() &
                  e.status.equalsValue(ExamStatus.upcoming),
            )
            ..orderBy([(e) => OrderingTerm.asc(e.date)])
            ..limit(1))
          .getSingleOrNull();

  /// Records one review at the current time: appends the Review row,
  /// updates TaskState through the engine and logs an Event, in one
  /// transaction. Any task may be reviewed early; it counts as its next
  /// step.
  Future<Review> record({
    required String taskId,
    required Rating rating,
    ReviewKind kind = ReviewKind.review,
    int durationSec = 0,
    int? resumeUnit,
  }) async {
    final engine = await _engine();
    final deadline = await this.deadline();
    final planned = await plannedReviews(taskId);
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
        final out = engine.applyReview(
          state,
          rating,
          at,
          deadline: deadline,
          planned: planned,
        );
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
            stepAfter: Value(out.stepAfter),
            dueAfter: Value(out.dueAfter?.millisecondsSinceEpoch),
          ),
        );
        await rec.update(db.taskStates, row.id, toCompanion(out.state));
        return review;
      },
    );
  }

  /// Pauses a task: no fading and nothing due until it resumes.
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

  /// Resumes a paused task; its schedule moves later by the paused time
  /// and re-fits before the exam.
  Future<void> resume(String taskId) async {
    final engine = await _engine();
    final deadline = await this.deadline();
    final planned = await plannedReviews(taskId);
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
          toCompanion(
            engine.resume(
              state,
              fromUtcMs(rec.now),
              deadline: deadline,
              planned: planned,
            ),
          ),
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
    return engine.rebuild(
      reviews,
      pauses: await pausesFor(taskId),
      deadline: await deadline(),
      planned: await plannedReviews(taskId),
    );
  }

  /// The rebuild command: recomputes every TaskState from the Review log
  /// and writes the ones that differ (each with an Event). It also re-fits
  /// every schedule to the current exam date. Returns how many tasks were
  /// checked.
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
    step: row.step,
    dim: row.dim,
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
    step: Value(s.step),
    dim: Value(s.dim),
    lastReviewAt: Value(s.lastReviewAt?.millisecondsSinceEpoch),
    dueAt: Value(s.dueAt?.millisecondsSinceEpoch),
    reps: Value(s.reps),
    lapses: Value(s.lapses),
    pausedAt: Value(s.pausedAt?.millisecondsSinceEpoch),
  );
}
