import 'dart:isolate';

import 'package:drift/drift.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../engines/planner/estimate.dart';
import '../../../engines/planner/planner.dart';
import '../../../engines/planner/triage.dart';
import '../../../engines/review/review_engine.dart';
import '../../session/data/session_repository.dart';
import '../../sources/data/reading_repository.dart';
import '../../tasks/data/review_repository.dart';

/// `YYYY-MM-DD` of a day key.
String dateText(DateTime day) => day.toIso8601String().substring(0, 10);

/// Runs the planner (docs/04-planner-spec.md) over stored data and keeps
/// the PlanItem rows. PlanItems are a cache of the plan: each run replaces
/// the planned rows from today on, keeps past and done rows, and marks
/// rows left planned on earlier days as `moved`. One Event per run records
/// it; the rows themselves are written directly (they are regenerated,
/// never edited, so undo has nothing to restore).
final class PlannerRepository extends EventSourcedRepository {
  PlannerRepository(
    super.ctx, {
    required this.sessions,
    required this.reviews,
    required this.reading,
  });

  final SessionRepository sessions;
  final ReviewRepository reviews;
  final ReadingRepository reading;

  static const entity = 'plan';

  Future<Exam?> upcomingExam() =>
      (db.select(db.exams)
            ..where(
              (e) =>
                  e.deletedAt.isNull() &
                  e.status.equalsValue(ExamStatus.upcoming),
            )
            ..orderBy([(e) => OrderingTerm.asc(e.date)])
            ..limit(1))
          .getSingleOrNull();

  /// The planner's input for today, or null without an upcoming exam.
  /// [alsoKeep] marks extra tasks as kept, for "what would keeping this
  /// task cut instead?".
  Future<PlannerInput?> input({Set<String> alsoKeep = const {}}) async {
    final exam = await upcomingExam();
    if (exam == null) return null;
    final today = dayKey(ctx.clock.now().toLocal());
    final examDay = dayKey(DateTime.parse(exam.date));
    if (!examDay.isAfter(today)) return null;
    final engine = await reviews.loadEngine();

    final week = List.filled(7, Defaults.defaultDailyMinutes);
    for (final a in await (db.select(
      db.availabilities,
    )..where((a) => a.deletedAt.isNull())).get()) {
      week[a.weekday] = a.minutes;
    }
    final overrides = <DateTime, int>{
      for (final o in await (db.select(
        db.availabilityOverrides,
      )..where((o) => o.deletedAt.isNull())).get())
        dayKey(DateTime.parse(o.date)): o.minutes,
    };
    // Today's minutes less what was already studied today.
    final done = await _minutesDoneToday(today);
    final cap = overrides[today] ?? week[today.weekday - 1];
    overrides[today] = (cap - done).clamp(0, cap);

    final links = {
      for (final l in await (db.select(
        db.examTasks,
      )..where((l) => l.examId.equals(exam.id) & l.deletedAt.isNull())).get())
        l.taskId: l,
    };
    final rows =
        await (db.select(db.taskStates).join([
              innerJoin(db.tasks, db.tasks.id.equalsExp(db.taskStates.taskId)),
            ])..where(
              db.tasks.deletedAt.isNull() &
                  db.tasks.status.equalsValue(TaskStatus.active),
            ))
            .get();

    // Every part of every task, and every survey, in two queries.
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
                    db.sources.deletedAt.isNull(),
              )
              ..orderBy([OrderingTerm.asc(db.taskChunks.order)]))
            .get();
    final partsOf = <String, List<TaskPart>>{};
    for (final r in partRows) {
      final link = r.readTable(db.taskChunks);
      (partsOf[link.taskId] ??= []).add((
        chunk: r.readTable(db.chunks),
        source: r.readTable(db.sources),
        link: link,
      ));
    }
    final surveys = {
      for (final s in await db.select(db.chunkSurveys).get()) s.chunkId: s,
    };

    // Minutes per chapter of sources read by chapter (D49).
    final chapterMinutes = <String, double>{};
    for (final r in partRows) {
      final source = r.readTable(db.sources);
      if (r.readTable(db.chunks).startUnit != null ||
          chapterMinutes.containsKey(source.id)) {
        continue;
      }
      chapterMinutes[source.id] = await reading.minutesPerChapter(source.id);
    }

    final tasks = <PlanTask>[];
    final sourceIds = <String>{};
    for (final r in rows) {
      final state = r.readTable(db.taskStates);
      final link = links[state.taskId];
      if (link?.dropped ?? false) continue;
      final parts = partsOf[state.taskId] ?? const <TaskPart>[];
      final importance = switch (link?.importance) {
        Importance.high => PlanImportance.high,
        Importance.low => PlanImportance.low,
        _ => PlanImportance.medium,
      };
      final read = SessionRepository.estimateFirstRead(
        parts,
        surveys,
        chapterMinutes: chapterMinutes,
      );
      final first = parts.isEmpty ? null : parts.first;
      final survey = first == null ? null : surveys[first.chunk.id];
      if (first != null) sourceIds.add(first.source.id);
      tasks.add(
        PlanTask(
          id: state.taskId,
          state: ReviewRepository.toReviewState(state),
          importance: importance,
          planned: engine.plannedReviewsFor(link?.targetLevel),
          firstReadMinutes: read < 1 ? 15 : read,
          reviewMinutes: _reviewMinutesOf(read),
          difficulty: survey?.difficulty ?? 2,
          subject: first?.source.id ?? '',
          sourceKey: first?.source.id ?? '',
          sourceOrder: first?.chunk.startUnit ?? 0,
          keep: (link?.triageKeep ?? false) || alsoKeep.contains(state.taskId),
        ),
      );
    }

    final explores = <PlanExplore>[];
    for (final id in sourceIds) {
      final p = await reading.progress(id);
      final units = p?.unitsToExplore ?? 0;
      if (units <= 0) continue;
      explores.add(
        PlanExplore(
          sourceId: id,
          subject: id,
          // Read by chapter, the units are chapters (D49).
          minutes: p!.byChapter
              ? units * await reading.minutesPerChapter(id)
              : firstReadMinutes(
                  units: units,
                  unit: EffortUnit.values.byName(p.source.unitType.name),
                ),
        ),
      );
    }

    return PlannerInput(
      today: today,
      examDay: examDay,
      weekdayMinutes: week,
      overrides: overrides,
      tasks: tasks,
      explores: explores,
    );
  }

  /// Plans from today and stores it. Returns the result, or null without
  /// an upcoming exam (then any planned rows from today on are cleared).
  Future<TriageResult?> replan() async {
    final exam = await upcomingExam();
    final input = await this.input();
    final engine = await reviews.loadEngine();
    // Off the UI thread: a tight plan runs triage's search many times.
    final triaged = input == null
        ? null
        : await _triageInBackground(input, engine);
    final result = triaged?.plan;
    final today = dateText(dayKey(ctx.clock.now().toLocal()));
    await mutate<void>(
      entity: entity,
      entityId: exam?.id ?? 'none',
      op: EventOp.update,
      data: {
        'action': 'replan',
        'items': result?.entries.length ?? 0,
        'fits': result?.fits,
        'cuts': triaged?.cuts.length ?? 0,
      },
      body: (rec) async {
        // Missed sessions on earlier days become "moved".
        await (db.update(db.planItems)..where(
              (p) =>
                  p.date.isSmallerThanValue(today) &
                  p.status.equalsValue(PlanItemStatus.planned),
            ))
            .write(
              PlanItemsCompanion(
                status: const Value(PlanItemStatus.moved),
                updatedAt: Value(rec.now),
                hlc: Value(rec.hlc),
              ),
            );
        await (db.delete(db.planItems)..where(
              (p) =>
                  p.date.isBiggerOrEqualValue(today) &
                  p.status.equalsValue(PlanItemStatus.planned),
            ))
            .go();
        if (result == null) return;
        final generation = await _nextGeneration();
        await db.batch((b) {
          for (final e in result.entries) {
            b.insert(
              db.planItems,
              PlanItemsCompanion.insert(
                id: rec.newId(),
                createdAt: rec.now,
                updatedAt: rec.now,
                hlc: rec.hlc,
                deviceId: ctx.deviceId,
                date: dateText(e.day),
                taskId: Value(e.taskId),
                sourceId: Value(e.sourceId),
                examId: Value(exam!.id),
                kind: PlanItemKind.values.byName(e.kind.name),
                estMinutes: e.minutes,
                status: PlanItemStatus.planned,
                generation: generation,
                order: e.order,
              ),
            );
          }
        });
      },
    );
    return triaged;
  }

  /// Triage as it would be with [taskId] kept in full (nothing written).
  Future<TriageResult?> previewKeep(String taskId) async {
    final input = await this.input(alsoKeep: {taskId});
    if (input == null) return null;
    final engine = await reviews.loadEngine();
    return _triageInBackground(input, engine);
  }

  /// Today's plan items in order, re-read whenever the plan changes.
  Stream<List<PlanItem>> watchDay(DateTime day) =>
      (db.select(db.planItems)
            ..where((p) => p.date.equals(dateText(day)) & p.deletedAt.isNull())
            ..orderBy([(p) => OrderingTerm.asc(p.order)]))
          .watch();

  /// Every plan item from [from] on, for projections and the Exam screen.
  Future<List<PlanItem>> from(DateTime from) =>
      (db.select(db.planItems)..where(
            (p) =>
                p.date.isBiggerOrEqualValue(dateText(from)) &
                p.deletedAt.isNull(),
          ))
          .get();

  /// Fires whenever an input of the planner changes. The plan table is
  /// not an input, so replanning does not trigger itself.
  Stream<void> watchInputs() => db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          db.tasks,
          db.taskStates,
          db.taskChunks,
          db.examTasks,
          db.exams,
          db.availabilities,
          db.availabilityOverrides,
          db.chunkSurveys,
          db.readingSessions,
          db.sources,
        },
      )
      .watch()
      .map((_) {});

  Future<int> _minutesDoneToday(DateTime today) async {
    final start = DateTime(today.year, today.month, today.day);
    final end = DateTime(today.year, today.month, today.day + 1);
    final rows =
        await (db.select(db.reviews)..where(
              (r) =>
                  r.deletedAt.isNull() &
                  r.at.isBetweenValues(
                    start.toUtc().millisecondsSinceEpoch,
                    end.toUtc().millisecondsSinceEpoch - 1,
                  ),
            ))
            .get();
    return rows.fold<int>(0, (s, r) => s + (r.durationSec / 60).round());
  }

  Future<int> _nextGeneration() async {
    final max = db.planItems.generation.max();
    final row = await (db.selectOnly(
      db.planItems,
    )..addColumns([max])).getSingle();
    return (row.read(max) ?? 0) + 1;
  }
}

/// Triage in a background isolate. Top level, so the closure sent there
/// holds only the input and the engine (never the open database).
Future<TriageResult> _triageInBackground(
  PlannerInput input,
  ReviewEngine engine,
) => Isolate.run(() => triage(input, engine));

/// A task's review lengths from its first-read estimate; top level so the
/// closure carries only [read] to the planner's isolate.
int Function(int step) _reviewMinutesOf(double read) =>
    (step) => reviewMinutes(read, firstReview: step == 0);
