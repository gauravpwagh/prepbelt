import 'package:drift/drift.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../engines/planner/estimate.dart';
import '../../session/data/session_repository.dart';
import '../../sources/data/reading_repository.dart';

/// What a Today card is for. [ahead] is a review on a later day, and
/// [untasked] a source with chapters still to turn into tasks (D50).
enum TodayKind {
  overdue,
  review,
  finalReview,
  firstRead,
  explore,
  ahead,
  untasked,
}

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
    this.plannedToday = false,
    this.dueAt,
    this.withoutTask = 0,
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

  /// In today's plan (D50).
  final bool plannedToday;

  /// When the review is due (UTC ms), for reviews ahead.
  final int? dueAt;

  /// Chapters of an [TodayKind.untasked] source without a task.
  final int withoutTask;

  /// The task's id, or the explore item's source id.
  String get id => info?.task.id ?? source!.id;
}

/// Today's three boxes (D50, design/notes/today-boxes.md).
final class TodayBoxes {
  const TodayBoxes({
    this.due = const [],
    this.fresh = const [],
    this.ahead = const [],
    this.plannedMinutes = 0,
    this.plannedFirstReads = 0,
    this.hasPlan = false,
  });

  /// Every review due by the end of today, overdue first.
  final List<TodayItem> due;

  /// Tasks without a first read and sources with reading left, today's
  /// planned ones first.
  final List<TodayItem> fresh;

  /// Each task's next review on a later day, soonest first.
  final List<TodayItem> ahead;

  /// Minutes and first reads in today's plan.
  final int plannedMinutes;
  final int plannedFirstReads;

  /// There is an upcoming exam, so a plan.
  final bool hasPlan;
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

  /// Today's boxes, re-read whenever their inputs change. [dayStart] and
  /// [dayEnd] are the local day's bounds in UTC ms; [today] is its date.
  Stream<TodayBoxes> watchBoxes({
    required int dayStart,
    required int dayEnd,
    required String today,
  }) => db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          db.tasks,
          db.taskStates,
          db.taskChunks,
          db.chunks,
          db.reviews,
          db.examTasks,
          db.chunkSurveys,
          db.sources,
          db.planItems,
          db.readingSessions,
          db.exams,
        },
      )
      .watch()
      .asyncMap((_) => boxes(dayStart: dayStart, dayEnd: dayEnd, today: today));

  /// Today's three boxes (D50). Tasks, parts and surveys load in a few
  /// queries, not one per task.
  Future<TodayBoxes> boxes({
    required int dayStart,
    required int dayEnd,
    required String today,
  }) async {
    final importance = await _importance();
    final rows =
        await (db.select(db.taskStates).join([
              innerJoin(db.tasks, db.tasks.id.equalsExp(db.taskStates.taskId)),
            ])..where(
              db.tasks.deletedAt.isNull() &
                  db.tasks.status.equalsValue(TaskStatus.active) &
                  db.taskStates.pausedAt.isNull(),
            ))
            .get();
    final partRows =
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
                db.taskChunks.deletedAt.isNull() &
                    db.chunks.deletedAt.isNull() &
                    db.sources.deletedAt.isNull(),
              )
              ..orderBy([OrderingTerm.asc(db.taskChunks.order)]))
            .get();
    final partsOf = <String, List<TaskPart>>{};
    final chapterMinutes = <String, double>{};
    for (final r in partRows) {
      final link = r.readTable(db.taskChunks);
      final chunk = r.readTable(db.chunks);
      final source = r.readTable(db.sources);
      (partsOf[link.taskId] ??= []).add((
        chunk: chunk,
        source: source,
        link: link,
      ));
      if (chunk.startUnit == null && !chapterMinutes.containsKey(source.id)) {
        chapterMinutes[source.id] = await reading.minutesPerChapter(source.id);
      }
    }
    final surveys = {
      for (final s in await (db.select(
        db.chunkSurveys,
      )..where((s) => s.deletedAt.isNull())).get())
        s.chunkId: s,
    };
    double firstRead(List<TaskPart> parts) =>
        SessionRepository.estimateFirstRead(
          parts,
          surveys,
          chapterMinutes: chapterMinutes,
        );

    // The plan from today on: today's items, and when each task's first
    // read and each source's reading is planned.
    final plan =
        await (db.select(db.planItems)
              ..where(
                (p) =>
                    p.date.isBiggerOrEqualValue(today) &
                    p.status.equalsValue(PlanItemStatus.planned) &
                    p.deletedAt.isNull(),
              )
              ..orderBy([
                (p) => OrderingTerm.asc(p.date),
                (p) => OrderingTerm.asc(p.order),
              ]))
            .get();
    final todayPlan = [
      for (final p in plan)
        if (p.date == today) p,
    ];
    final planned = {for (final p in todayPlan) ?p.taskId: p};
    final readingToday = {
      for (final p in todayPlan)
        if (p.kind == PlanItemKind.explore) p.sourceId!: p,
    };
    final next = <String, (String, int)>{};
    for (final p in plan) {
      final key = p.taskId ?? p.sourceId;
      if (key == null || p.kind == PlanItemKind.review) continue;
      next.putIfAbsent(key, () => (p.date, p.order));
    }

    final due = <TodayItem>[];
    final fresh = <TodayItem>[];
    final ahead = <TodayItem>[];
    for (final r in rows) {
      final task = r.readTable(db.tasks);
      final state = r.readTable(db.taskStates);
      final parts = partsOf[task.id] ?? const <TaskPart>[];
      if (parts.isEmpty) continue;
      final info = SessionTask(task: task, state: state, parts: parts);
      final read = firstRead(parts);
      final p = planned[task.id];
      if (state.reps == 0) {
        fresh.add(
          TodayItem(
            kind: TodayKind.firstRead,
            info: info,
            minutes: p?.estMinutes ?? roundToFive(read).clamp(5, 999),
            importance: importance[task.id],
            plannedToday: p != null,
          ),
        );
        continue;
      }
      final at = state.dueAt;
      if (at == null) continue;
      final minutes =
          p?.estMinutes ??
          reviewMinutes(read, firstReview: state.step == 0 && state.dim == 0);
      if (at < dayEnd) {
        final overdue = at < dayStart;
        due.add(
          TodayItem(
            kind: p?.kind == PlanItemKind.finalReview
                ? TodayKind.finalReview
                : overdue
                ? TodayKind.overdue
                : TodayKind.review,
            info: info,
            minutes: minutes,
            importance: importance[task.id],
            overdueDays: overdue
                ? ((dayStart - at) / Duration.millisecondsPerDay).ceil()
                : 0,
            plannedToday: p != null,
            dueAt: at,
          ),
        );
      } else {
        ahead.add(
          TodayItem(
            kind: TodayKind.ahead,
            info: info,
            minutes: minutes,
            importance: importance[task.id],
            dueAt: at,
          ),
        );
      }
    }

    // Sources with reading left, or chapters still without tasks.
    for (final source in await (db.select(
      db.sources,
    )..where((s) => s.deletedAt.isNull())).get()) {
      final progress = await reading.progress(source.id);
      if (progress == null || progress.finished) continue;
      final units = progress.unitsToExplore;
      if (units > 0) {
        final p = readingToday[source.id];
        final minutes =
            p?.estMinutes ??
            roundToFive(
              progress.byChapter
                  ? units * await reading.minutesPerChapter(source.id)
                  : firstReadMinutes(
                      units: units,
                      unit: EffortUnit.values.byName(source.unitType.name),
                    ),
            ).clamp(5, 99999);
        fresh.add(
          TodayItem(
            kind: TodayKind.explore,
            minutes: minutes,
            source: source,
            position: progress.position,
            chapter: progress.current?.chunk.title,
            plannedToday: p != null,
          ),
        );
      } else if (progress.withoutTask > 0 && progress.chapters.isNotEmpty) {
        fresh.add(
          TodayItem(
            kind: TodayKind.untasked,
            minutes: 0,
            source: source,
            withoutTask: progress.withoutTask,
          ),
        );
      }
    }

    due.sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
    ahead.sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
    int rank(Importance? i) => i == null ? 1 : i.index;
    int planOrder(TodayItem i) => switch (next[i.id]) {
      (_, final order) when i.plannedToday => order,
      _ => 1 << 20,
    };
    fresh.sort((a, b) {
      if (a.plannedToday != b.plannedToday) return a.plannedToday ? -1 : 1;
      final byToday = planOrder(a).compareTo(planOrder(b));
      if (byToday != 0) return byToday;
      if ((a.kind == TodayKind.untasked) != (b.kind == TodayKind.untasked)) {
        return a.kind == TodayKind.untasked ? 1 : -1;
      }
      final da = next[a.id]?.$1, db_ = next[b.id]?.$1;
      if (da != db_) {
        if (da == null) return 1;
        if (db_ == null) return -1;
        return da.compareTo(db_);
      }
      final byImportance = rank(a.importance).compareTo(rank(b.importance));
      if (byImportance != 0) return byImportance;
      final pa = a.info?.parts.first, pb = b.info?.parts.first;
      final sa = pa?.source.title ?? a.source!.title;
      final sb = pb?.source.title ?? b.source!.title;
      final bySource = sa.compareTo(sb);
      if (bySource != 0) return bySource;
      return (pa?.chunk.startUnit ?? pa?.chunk.order ?? 0).compareTo(
        pb?.chunk.startUnit ?? pb?.chunk.order ?? 0,
      );
    });

    return TodayBoxes(
      due: due,
      fresh: fresh,
      ahead: ahead,
      plannedMinutes: todayPlan.fold(0, (sum, p) => sum + p.estMinutes),
      plannedFirstReads: todayPlan
          .where(
            (p) =>
                p.kind == PlanItemKind.firstRead ||
                p.kind == PlanItemKind.explore,
          )
          .length,
      hasPlan: await _exam() != null,
    );
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

  Future<Exam?> _exam() =>
      (db.select(db.exams)
            ..where(
              (e) =>
                  e.deletedAt.isNull() &
                  e.status.equalsValue(ExamStatus.upcoming),
            )
            ..limit(1))
          .getSingleOrNull();

  /// Importance per task for the upcoming exam.
  Future<Map<String, Importance>> _importance() async {
    final exam = await _exam();
    if (exam == null) return const {};
    final rows = await (db.select(
      db.examTasks,
    )..where((t) => t.examId.equals(exam.id) & t.deletedAt.isNull())).get();
    return {for (final r in rows) r.taskId: r.importance};
  }
}
