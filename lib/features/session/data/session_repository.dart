import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';
import '../../../engines/planner/estimate.dart';
import '../../../engines/review/review_types.dart';
import '../../tasks/data/review_repository.dart';
import '../../tasks/data/task_repository.dart';

/// One chapter a task covers, with its source.
typedef TaskPart = ({Chunk chunk, Source source, TaskChunk link});

/// What the session and task screens need about one task.
final class SessionTask {
  const SessionTask({
    required this.task,
    required this.state,
    required this.parts,
    this.resumeUnit,
  });

  final Task task;
  final TaskState state;

  /// The chapters it covers, in order.
  final List<TaskPart> parts;

  /// Where the last session stopped inside the range, if it stopped early.
  final int? resumeUnit;

  /// The source Start opens: the first part's.
  Source? get source => parts.isEmpty ? null : parts.first.source;

  bool get firstRead => state.reps == 0;

  bool get paused => state.pausedAt != null || task.status == TaskStatus.paused;

  /// The unit range when every part is in one source with known ranges;
  /// null otherwise, and then the "Where did you stop?" stepper is hidden.
  ({int start, int end})? get range {
    final s = source;
    if (s == null) return null;
    int? start, end;
    for (final p in parts) {
      if (p.source.id != s.id) return null;
      final a = p.link.startUnit ?? p.chunk.startUnit;
      final b = p.link.endUnit ?? p.chunk.endUnit;
      if (a == null || b == null) return null;
      start = start == null || a < start ? a : start;
      end = end == null || b > end ? b : end;
    }
    return start == null ? null : (start: start, end: end!);
  }

  /// Where this session starts: the last stop, else the range start.
  int? get startUnit => resumeUnit ?? range?.start;
}

/// The review session (docs/05-architecture.md, "Open externally and the
/// return flow"). An ActiveSession row is written before the source opens,
/// so "Back from source" survives the OS closing the app. Finishing records
/// one review through [ReviewRepository].
///
/// ActiveSession is local and not synced, so it lacks the convention
/// columns [ChangeRecorder] fills; it is written directly inside [mutate],
/// and the Event records the action.
final class SessionRepository extends EventSourcedRepository {
  SessionRepository(super.ctx, {required this.reviews});

  final ReviewRepository reviews;

  static const entity = TaskRepository.entity;

  Future<ActiveSession?> active() =>
      (db.select(db.activeSessions)..limit(1)).getSingleOrNull();

  Stream<ActiveSession?> watchActive() =>
      (db.select(db.activeSessions)..limit(1)).watchSingleOrNull();

  Future<SessionTask> load(String taskId) async {
    final task =
        await (db.select(db.tasks)
              ..where((t) => t.id.equals(taskId) & t.deletedAt.isNull()))
            .getSingleOrNull();
    if (task == null) throw NotFoundError('task $taskId');
    final state = await (db.select(
      db.taskStates,
    )..where((s) => s.taskId.equals(taskId))).getSingle();
    final rows =
        await (db.select(db.taskChunks).join([
                innerJoin(
                  db.chunks,
                  db.chunks.id.equalsExp(db.taskChunks.chunkId),
                ),
                innerJoin(
                  db.sources,
                  db.sources.id.equalsExp(db.chunks.sourceId),
                ),
              ])
              ..where(
                db.taskChunks.taskId.equals(taskId) &
                    db.taskChunks.deletedAt.isNull() &
                    db.sources.deletedAt.isNull(),
              )
              ..orderBy([OrderingTerm.asc(db.taskChunks.order)]))
            .get();
    final parts = [
      for (final r in rows)
        (
          chunk: r.readTable(db.chunks),
          source: r.readTable(db.sources),
          link: r.readTable(db.taskChunks),
        ),
    ];
    final last =
        await (db.select(db.reviews)
              ..where((r) => r.taskId.equals(taskId) & r.deletedAt.isNull())
              ..orderBy([(r) => OrderingTerm.desc(r.at)])
              ..limit(1))
            .getSingleOrNull();
    final range = SessionTask(task: task, state: state, parts: parts).range;
    final stop = last?.resumeUnit;
    final resumes =
        range != null && stop != null && stop > range.start && stop < range.end;
    return SessionTask(
      task: task,
      state: state,
      parts: parts,
      resumeUnit: resumes ? stop : null,
    );
  }

  /// Opens a session on [taskId], replacing an abandoned one. Fails while a
  /// reading sitting is open: one thing at a time comes back to the app.
  Future<ActiveSession> start(String taskId) async {
    final info = await load(taskId);
    if (info.paused) {
      throw const InvalidOperationError('Resume the task to review it');
    }
    final reading =
        await (db.select(db.readingSessions)..where(
              (r) =>
                  r.status.equalsValue(ReadingStatus.open) &
                  r.deletedAt.isNull(),
            ))
            .get();
    if (reading.isNotEmpty) {
      throw const InvalidOperationError('Finish the open reading first');
    }
    return mutate(
      entity: entity,
      entityId: taskId,
      op: EventOp.update,
      data: {'action': 'startSession'},
      body: (rec) async {
        await db.delete(db.activeSessions).go();
        final id = rec.newId();
        await db
            .into(db.activeSessions)
            .insert(
              ActiveSessionsCompanion.insert(
                id: id,
                taskId: taskId,
                startedAt: rec.now,
                resumeUnit: Value(info.startUnit),
                createdAt: rec.now,
                updatedAt: rec.now,
              ),
            );
        return (db.select(
          db.activeSessions,
        )..where((s) => s.id.equals(id))).getSingle();
      },
    );
  }

  /// What each rating would do now, for the rating buttons and the result
  /// card. Nothing is written.
  Future<Map<Rating, ReviewOutcome>> preview(String taskId) async {
    final engine = await reviews.loadEngine();
    final deadline = await reviews.deadline();
    final planned = await reviews.plannedReviews(taskId);
    final row = await (db.select(
      db.taskStates,
    )..where((s) => s.taskId.equals(taskId))).getSingle();
    final state = ReviewRepository.toReviewState(row);
    final now = ctx.clock.now();
    return {
      for (final r in Rating.values)
        r: engine.applyReview(
          state,
          r,
          now,
          deadline: deadline,
          planned: planned,
        ),
    };
  }

  /// Records the review and closes the session. [stopUnit] is where the
  /// student stopped; short of the range end it becomes the next resume
  /// point.
  Future<Review> finish({
    required Rating rating,
    required int minutes,
    int? stopUnit,
  }) async {
    final session = await active();
    if (session == null) {
      throw const InvalidOperationError('No session is open');
    }
    final info = await load(session.taskId);
    final engine = await reviews.loadEngine();
    final deadline = await reviews.deadline();
    final planned = await reviews.plannedReviews(session.taskId);
    final end = info.range?.end;
    final resume = stopUnit != null && end != null && stopUnit < end
        ? stopUnit
        : null;
    return mutate(
      entity: entity,
      entityId: session.taskId,
      op: EventOp.review,
      data: {'rating': rating.value, 'action': 'finishSession'},
      body: (rec) async {
        final review = await reviews.recordIn(
          rec,
          taskId: session.taskId,
          rating: rating,
          kind: info.firstRead ? ReviewKind.firstRead : ReviewKind.review,
          durationSec: minutes * 60,
          resumeUnit: resume,
          engine: engine,
          deadline: deadline,
          planned: planned,
        );
        await db.delete(db.activeSessions).go();
        return review;
      },
    );
  }

  /// Leaves without rating: nothing is recorded.
  Future<void> discard() async {
    final session = await active();
    if (session == null) return;
    await mutate<void>(
      entity: entity,
      entityId: session.taskId,
      op: EventOp.update,
      data: {'action': 'discardSession'},
      body: (rec) => db.delete(db.activeSessions).go(),
    );
  }

  /// The first-read estimate of a task's chapters, from their surveys.
  Future<double> firstReadEstimate(SessionTask info) async {
    var total = 0.0;
    for (final p in info.parts) {
      final start = p.link.startUnit ?? p.chunk.startUnit;
      final end = p.link.endUnit ?? p.chunk.endUnit;
      if (start == null || end == null) continue;
      final survey = await (db.select(
        db.chunkSurveys,
      )..where((s) => s.chunkId.equals(p.chunk.id))).getSingleOrNull();
      total += firstReadMinutes(
        units: end - start + 1,
        unit: EffortUnit.values.byName(p.source.unitType.name),
        difficulty: survey?.difficulty ?? 2,
        familiarity: survey?.familiarity ?? 0,
      );
    }
    return total;
  }

  /// Minutes logged for a session open since [startedAt]: whole minutes,
  /// at least 1, at most [maxMinutes].
  static int minutesSince(int startedAt, int now, {required int maxMinutes}) =>
      ((now - startedAt) / 60000).round().clamp(1, maxMinutes);
}
