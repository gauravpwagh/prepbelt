import 'package:drift/drift.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../engines/planner/estimate.dart';
import '../../session/data/session_repository.dart';
import '../../sources/data/reading_repository.dart';

/// What a Today card is for.
enum TodayKind { overdue, review, finalReview, firstRead, explore }

/// One session card on Today: a task, or a source to keep reading (D27).
final class TodayItem {
  const TodayItem({
    required this.kind,
    required this.minutes,
    this.info,
    this.source,
    this.position,
    this.chapter,
    this.importance,
    this.overdueDays = 0,
  }) : assert(info != null || source != null, 'a task or a source');

  final TodayKind kind;
  final int minutes;

  /// The task; null for an explore item.
  final SessionTask? info;

  /// The source of an explore item, and where reading resumes.
  final Source? source;
  final int? position;

  /// Read by chapter (D49): the chapter reading resumes in.
  final String? chapter;
  final Importance? importance;

  /// Whole days past due, for "OVERDUE 2 DAYS".
  final int overdueDays;

  /// The task's id, or the explore item's source id.
  String get id => info?.task.id ?? source!.id;
}

/// Reads what Today shows. Until the planner exists (milestone 5) it lists
/// every review due by the end of today, overdue first (oldest first),
/// then at most [Defaults.todayFirstReadsWithoutPlan] not-started tasks as
/// first reads, most important first. Read-only.
final class TodayRepository {
  TodayRepository(this.db, {required this.sessions, required this.reading});

  final AppDatabase db;
  final SessionRepository sessions;
  final ReadingRepository reading;

  /// Today's items from the plan (docs/04-planner-spec.md): planned rows
  /// only, in plan order. [dayStart] (local midnight, UTC ms) tells
  /// overdue reviews apart.
  Future<List<TodayItem>> fromPlan(
    List<PlanItem> items, {
    required int dayStart,
  }) async {
    final importance = await _importance();
    final out = <TodayItem>[];
    for (final p in items) {
      if (p.status != PlanItemStatus.planned) continue;
      if (p.kind == PlanItemKind.explore) {
        final progress = await reading.progress(p.sourceId!);
        if (progress == null) continue;
        out.add(
          TodayItem(
            kind: TodayKind.explore,
            minutes: p.estMinutes,
            source: progress.source,
            position: progress.position,
            chapter: progress.current?.chunk.title,
          ),
        );
        continue;
      }
      final info = await _load(p.taskId!);
      if (info == null) continue;
      final due = info.state.dueAt;
      final overdue =
          p.kind != PlanItemKind.firstRead && due != null && due < dayStart;
      out.add(
        TodayItem(
          kind: switch (p.kind) {
            PlanItemKind.firstRead => TodayKind.firstRead,
            PlanItemKind.finalReview => TodayKind.finalReview,
            _ when overdue => TodayKind.overdue,
            _ => TodayKind.review,
          },
          minutes: p.estMinutes,
          info: info,
          importance: importance[info.task.id],
          overdueDays: overdue
              ? ((dayStart - due) / Duration.millisecondsPerDay).ceil()
              : 0,
        ),
      );
    }
    return out;
  }

  /// Today's items, re-read whenever tasks, reviews or surveys change.
  /// [dayStart] and [dayEnd] are the local day's bounds in UTC ms.
  Stream<List<TodayItem>> watch({required int dayStart, required int dayEnd}) =>
      db
          .customSelect(
            'SELECT 1',
            readsFrom: {
              db.tasks,
              db.taskStates,
              db.taskChunks,
              db.reviews,
              db.examTasks,
              db.chunkSurveys,
              db.sources,
            },
          )
          .watch()
          .asyncMap((_) => items(dayStart: dayStart, dayEnd: dayEnd));

  Future<List<TodayItem>> items({
    required int dayStart,
    required int dayEnd,
  }) async {
    final rows =
        await (db.select(db.taskStates).join([
              innerJoin(db.tasks, db.tasks.id.equalsExp(db.taskStates.taskId)),
            ])..where(
              db.tasks.deletedAt.isNull() &
                  db.tasks.status.equalsValue(TaskStatus.active) &
                  db.taskStates.pausedAt.isNull(),
            ))
            .get();
    final importance = await _importance();

    final due = <TaskState>[];
    final fresh = <TaskState>[];
    for (final r in rows) {
      final s = r.readTable(db.taskStates);
      if (s.reps == 0) {
        fresh.add(s);
      } else if (s.dueAt != null && s.dueAt! < dayEnd) {
        due.add(s);
      }
    }
    due.sort((a, b) => a.dueAt!.compareTo(b.dueAt!));

    final out = <TodayItem>[];
    for (final s in due) {
      final info = await _load(s.taskId);
      if (info == null) continue;
      final overdue = s.dueAt! < dayStart;
      out.add(
        TodayItem(
          kind: overdue ? TodayKind.overdue : TodayKind.review,
          info: info,
          minutes: reviewMinutes(
            await sessions.firstReadEstimate(info),
            firstReview: s.step == 0 && s.dim == 0,
          ),
          importance: importance[s.taskId],
          overdueDays: overdue
              ? ((dayStart - s.dueAt!) / Duration.millisecondsPerDay).ceil()
              : 0,
        ),
      );
    }

    final candidates = <TodayItem>[];
    for (final s in fresh) {
      final info = await _load(s.taskId);
      if (info == null || info.parts.isEmpty) continue;
      candidates.add(
        TodayItem(
          kind: TodayKind.firstRead,
          info: info,
          minutes: roundToFive(
            await sessions.firstReadEstimate(info),
          ).clamp(5, 999),
          importance: importance[s.taskId],
        ),
      );
    }
    int rank(Importance? i) => i == null ? 1 : i.index;
    candidates.sort((a, b) {
      final byImportance = rank(a.importance).compareTo(rank(b.importance));
      if (byImportance != 0) return byImportance;
      final pa = a.info!.parts.first, pb = b.info!.parts.first;
      final bySource = pa.source.title.compareTo(pb.source.title);
      if (bySource != 0) return bySource;
      return (pa.chunk.startUnit ?? 0).compareTo(pb.chunk.startUnit ?? 0);
    });
    out.addAll(candidates.take(Defaults.todayFirstReadsWithoutPlan));
    return out;
  }

  /// Times of every review, for the streak.
  Stream<List<int>> watchReviewTimes() {
    final at = db.reviews.at;
    return (db.selectOnly(db.reviews)
          ..addColumns([at])
          ..where(db.reviews.deletedAt.isNull()))
        .map((r) => r.read(at)!)
        .watch();
  }

  Future<SessionTask?> _load(String taskId) async {
    try {
      return await sessions.load(taskId);
    } on Object {
      return null;
    }
  }

  /// Importance per task for the upcoming exam.
  Future<Map<String, Importance>> _importance() async {
    final exam =
        await (db.select(db.exams)
              ..where(
                (e) =>
                    e.deletedAt.isNull() &
                    e.status.equalsValue(ExamStatus.upcoming),
              )
              ..limit(1))
            .getSingleOrNull();
    if (exam == null) return const {};
    final rows = await (db.select(
      db.examTasks,
    )..where((t) => t.examId.equals(exam.id) & t.deletedAt.isNull())).get();
    return {for (final r in rows) r.taskId: r.importance};
  }
}
