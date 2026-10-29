import 'dart:math';

import 'package:drift/drift.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';
import '../../../engines/reading/reading_math.dart';
import '../../tasks/data/review_repository.dart';
import 'source_repository.dart';
import 'task_writer.dart';

/// One task on a chapter: the whole chapter, some pages of it, or part k
/// of n (D49).
final class ChapterTask {
  const ChapterTask({
    required this.taskId,
    required this.title,
    this.level = 0,
    this.dim = 0,
    this.order = 0,
    this.range,
    this.part,
    this.parts,
    this.firstReadSec = 0,
  });

  final String taskId;
  final String title;
  final int level;
  final int dim;

  /// This chapter's place in the task: 0 for the first (D27).
  final int order;

  /// Units of the chapter the task covers, when the chapter has them.
  final UnitRange? range;

  /// Part [part] of [parts] of a chapter without page numbers.
  final int? part;
  final int? parts;

  /// Time of its first read, 0 before it.
  final int firstReadSec;

  bool get read => level > 0;
}

/// One chapter on the Source chapters screen.
final class ChapterProgress {
  const ChapterProgress({
    required this.chunk,
    this.survey,
    this.importance,
    this.tasks = const [],
    this.readUnits = 0,
    this.slot,
    this.inProgress = false,
  });

  final Chunk chunk;
  final ChunkSurvey? survey;

  /// For the exam; null without one or before the survey sets it.
  final Importance? importance;

  /// Its tasks in reading order: one for the whole chapter, or its parts.
  final List<ChapterTask> tasks;

  /// Units of the chapter already explored.
  final int readUnits;

  /// In a source read by chapter (D49), the chapter's place as a unit:
  /// chapter 3 is units 3–3.
  final UnitRange? slot;

  /// Read by chapter: a sitting stopped inside it.
  final bool inProgress;

  UnitRange? get range =>
      slot ??
      switch ((chunk.startUnit, chunk.endUnit)) {
        (final int s, final int e) => UnitRange(s, e),
        _ => null,
      };

  int get sizeUnits => range?.size ?? 0;

  /// Units of the chapter [task] covers.
  UnitRange? rangeOf(ChapterTask task) => slot ?? task.range ?? range;

  /// Tasks covering part of the chapter: some pages, or part k of n.
  List<ChapterTask> get parts => [
    for (final t in tasks)
      if (t.part != null || (t.range != null && t.range != range)) t,
  ];

  /// Pages of the chapter without a task, in order (chapters with pages).
  List<UnitRange> get uncovered {
    final r = range;
    if (r == null || slot != null) return const [];
    if (tasks.any((t) => t.range == null || t.range == r)) return const [];
    return gapsIn(r, [for (final t in tasks) ?t.range]);
  }

  /// Every unit of the chapter has a task.
  bool get hasTask {
    if (tasks.isEmpty) return false;
    final split = tasks.where((t) => t.parts != null).toList();
    if (split.isNotEmpty) {
      final n = split.first.parts!;
      return {for (final t in split) t.part}.length >= n;
    }
    return uncovered.isEmpty;
  }

  String? get taskId => tasks.firstOrNull?.taskId;
  String? get taskTitle => tasks.firstOrNull?.title;
  int get taskLevel => tasks.firstOrNull?.level ?? 0;
  int get taskDim => tasks.firstOrNull?.dim ?? 0;
  int get taskOrder => tasks.firstOrNull?.order ?? 0;

  /// All of it has a task, and every one of them has its first read.
  bool get read => hasTask && tasks.every((t) => t.read);
  bool get finished => read || (sizeUnits > 0 && readUnits >= sizeUnits);
  bool get partlyRead => !finished && (readUnits > 0 || inProgress);
}

/// A source with its chapters, sittings and reading position.
final class SourceProgress {
  const SourceProgress({
    required this.source,
    required this.chapters,
    required this.sittings,
    required this.explored,
    this.open,
  });

  final Source source;
  final List<ChapterProgress> chapters;

  /// Saved sittings, oldest first.
  final List<ReadingSession> sittings;

  /// Explored ranges (D28), merged. Read by chapter, a chapter is one unit.
  final List<UnitRange> explored;

  /// The open sitting of this source, if any.
  final ReadingSession? open;

  /// Read chapter by chapter (D49): it has chapters and none has page
  /// numbers. Links are not read this way.
  bool get byChapter =>
      isByChapter(source, [for (final c in chapters) c.chunk]);

  static bool isByChapter(Source source, List<Chunk> chapters) =>
      source.type != SourceType.link &&
      chapters.isNotEmpty &&
      chapters.every((c) => c.startUnit == null);

  /// Units of reading: chapters when read by chapter, else the source's.
  int get totalUnits => byChapter ? chapters.length : source.totalUnits ?? 0;
  bool get readable => totalUnits > 0;
  UnitRange get whole => UnitRange(1, totalUnits);
  int get exploredUnits => coveredUnits(explored, whole);

  /// "Done with this source": nothing more to read (D47).
  bool get finished => source.finishedAt != null;

  /// The first unit not yet read; null once all of it is, or once the
  /// student is done with the source.
  int? get position =>
      readable && !finished ? firstUncovered(explored, whole) : null;

  /// The chapter at [position] when read by chapter.
  ChapterProgress? get current => switch (position) {
    final p? when byChapter => chapters[p - 1],
    _ => null,
  };

  /// Splits as it is read (D47): each saved sitting becomes the next part.
  /// True once a sitting made a part, or while it has no chapters with
  /// page numbers and is not read by chapter.
  bool get progressive =>
      !byChapter &&
      (source.progressive || !chapters.any((c) => c.range != null));

  /// Where the next part starts: after the last one. Sittings too short
  /// for a part are held and join the next one.
  int get nextPartStart => chapters.fold(
    1,
    (start, c) => switch (c.chunk.endUnit) {
      final end? when end >= start => end + 1,
      _ => start,
    },
  );

  /// The part saving [sitting] would make in a progressive source.
  UnitRange nextPart(UnitRange sitting) =>
      UnitRange(nextPartStart, sitting.end);

  /// Minutes spent on [nextPart], held sittings included.
  double minutesOnNextPart(UnitRange sitting, int minutes) => minutesOn(
    nextPart(sitting),
    [...savedSittings, Sitting(sitting, minutes)],
  );

  /// Whether saving [sitting] holds it instead of making a part: it is
  /// under [minPartMinutes] with held sittings, and not the end.
  bool holds(UnitRange sitting, int minutes, {required int minPartMinutes}) =>
      progressive &&
      sitting.end < totalUnits &&
      minutesOnNextPart(sitting, minutes) < minPartMinutes;

  /// Units still to read for the plan's "Continue" item: unread units of
  /// chapters without a task, or everything unread in a progressive
  /// source. Read by chapter, these are chapters. None once finished.
  int get unitsToExplore {
    if (!readable || finished) return 0;
    if (progressive) return totalUnits - exploredUnits;
    return chapters.fold(
      0,
      (sum, c) => c.tasks.isNotEmpty ? sum : sum + c.sizeUnits - c.readUnits,
    );
  }

  /// Minutes a chapter takes to read, for a source read by chapter (D49):
  /// the median first read of its chapters once [samples] are read, else
  /// its pages shared equally at [pagePace], else [fallback].
  double minutesPerChapter({
    required double pagePace,
    int samples = Defaults.chapterCalibrationSamples,
    double fallback = Defaults.chapterMinutesDefault,
  }) {
    final read = <double>[];
    for (final c in chapters) {
      if (!c.read) continue;
      // A task over several chapters shares its time among them.
      final sec = c.tasks.fold<double>(0, (sum, t) {
        final span = chapters
            .where((o) => o.tasks.any((x) => x.taskId == t.taskId))
            .length;
        return sum + t.firstReadSec / (span == 0 ? 1 : span);
      });
      if (sec > 0) read.add(sec / 60);
    }
    if (read.length >= samples) {
      read.sort();
      final mid = read.length ~/ 2;
      return read.length.isOdd ? read[mid] : (read[mid - 1] + read[mid]) / 2;
    }
    final pages = source.totalUnits;
    if (pages != null && pages > 0 && chapters.isNotEmpty) {
      return pages / chapters.length * pagePace;
    }
    return fallback;
  }

  int get taskCount => {
    for (final c in chapters)
      for (final t in c.tasks) t.taskId,
  }.length;
  int get withoutTask => chapters.where((c) => !c.hasTask).length;
  int get surveyedCount => chapters.where((c) => c.survey != null).length;

  /// What saving [sitting] would do, by index into [chapters]. A chapter
  /// with any task goes to first reads, never to a new task.
  SavePlan planFor(UnitRange sitting) {
    if (sitting.size == 0) return const SavePlan();
    final withRanges = [
      for (final c in chapters)
        if (c.range != null) c,
    ];
    final plan = planSave(
      chapters: [
        for (final c in withRanges)
          ChapterState(
            range: c.range!,
            hasTask: c.tasks.isNotEmpty,
            read: c.read,
          ),
      ],
      explored: explored,
      sitting: sitting,
    );
    int full(int i) => chapters.indexOf(withRanges[i]);
    return SavePlan(
      newTasks: [
        for (final run in plan.newTasks) [for (final i in run) full(i)],
      ],
      firstReads: [for (final i in plan.firstReads) full(i)],
      partial: [for (final i in plan.partial) full(i)],
    );
  }

  /// The first run of pages of chapter [index] that are read once
  /// [sitting] is saved and have no task: what "Make … a task now" makes
  /// a task of (D49). Null read by chapter.
  UnitRange? readWithoutTask(int index, UnitRange sitting) {
    final c = chapters[index];
    if (c.slot != null) return null;
    final after = unionOf([...explored, sitting]);
    return [
      for (final gap in c.uncovered)
        for (final r in after)
          if (gap.overlap(r) > 0)
            UnitRange(max(gap.start, r.start), min(gap.end, r.end)),
    ].firstOrNull;
  }

  /// Units of chapter [index] read once [sitting] is saved.
  int readUnitsAfter(int index, UnitRange sitting) {
    final r = chapters[index].range;
    return r == null ? 0 : coveredUnits(unionOf([...explored, sitting]), r);
  }

  List<Sitting> get savedSittings => [
    for (final s in sittings)
      if ((s.endUnit, s.minutes) case (final int end, final int m))
        Sitting(UnitRange(s.startUnit, end), m),
  ];
}

/// What saving a sitting did.
final class SaveOutcome {
  const SaveOutcome({
    this.tasksCreated = const [],
    this.firstReads = 0,
    this.partial = const [],
    this.held,
  });

  /// A progressive sitting too short for a part, held for the next one.
  final UnitRange? held;

  /// Titles of the tasks created.
  final List<String> tasksCreated;

  /// Existing tasks that got their first read.
  final int firstReads;

  /// Titles of chapters left partly read.
  final List<String> partial;
}

/// Reading a source as you go (D27): sittings, the reading position, and
/// tasks added per chapter. Writes go under the source's id, so the
/// Sources screens can undo them.
final class ReadingRepository extends EventSourcedRepository {
  ReadingRepository(super.ctx, {required this.reviews});

  final ReviewRepository reviews;

  static const entity = SourceRepository.entity;

  TaskWriter get _writer => TaskWriter(db, reviews: reviews);

  // ------------------------------------------------------------- Reads

  /// The open sitting of any source; at most one exists.
  Future<ReadingSession?> openSession() => _openQuery().getSingleOrNull();

  Stream<ReadingSession?> watchOpenSession() =>
      _openQuery().watchSingleOrNull();

  SimpleSelectStatement<$ReadingSessionsTable, ReadingSession> _openQuery() =>
      db.select(db.readingSessions)
        ..where(
          (s) =>
              s.status.equalsValue(ReadingStatus.open) & s.deletedAt.isNull(),
        )
        ..limit(1);

  Stream<SourceProgress?> watchProgress(String sourceId, {String? examId}) => db
      .customSelect(
        'SELECT 1',
        readsFrom: {
          db.sources,
          db.chunks,
          db.chunkSurveys,
          db.examChunks,
          db.tasks,
          db.taskChunks,
          db.taskStates,
          db.readingSessions,
        },
      )
      .watch()
      .asyncMap((_) => progress(sourceId, examId: examId));

  /// The source with its chapters in reading order (parts from bookmarks
  /// left out), their tasks and how much of each is read.
  Future<SourceProgress?> progress(String sourceId, {String? examId}) async {
    final source =
        await (db.select(db.sources)
              ..where((s) => s.id.equals(sourceId) & s.deletedAt.isNull()))
            .getSingleOrNull();
    if (source == null) return null;

    final rows =
        await (db.select(db.chunks).join([
                leftOuterJoin(
                  db.chunkSurveys,
                  db.chunkSurveys.chunkId.equalsExp(db.chunks.id) &
                      db.chunkSurveys.deletedAt.isNull(),
                ),
                leftOuterJoin(
                  db.examChunks,
                  db.examChunks.chunkId.equalsExp(db.chunks.id) &
                      db.examChunks.examId.equals(examId ?? '') &
                      db.examChunks.deletedAt.isNull(),
                ),
              ])
              ..where(
                db.chunks.sourceId.equals(sourceId) &
                    db.chunks.parentChunkId.isNull() &
                    db.chunks.deletedAt.isNull(),
              )
              ..orderBy([
                OrderingTerm.asc(db.chunks.startUnit, nulls: NullsOrder.last),
                OrderingTerm.asc(db.chunks.order),
              ]))
            .get();
    final chunkIds = [for (final r in rows) r.readTable(db.chunks).id];

    final links =
        await (db.select(db.taskChunks).join([
              innerJoin(
                db.tasks,
                db.tasks.id.equalsExp(db.taskChunks.taskId) &
                    db.tasks.deletedAt.isNull() &
                    // A split's original is archived; its parts stand in.
                    db.tasks.status.isNotValue(TaskStatus.archived.name),
              ),
              innerJoin(
                db.taskStates,
                db.taskStates.taskId.equalsExp(db.tasks.id),
              ),
            ])..where(
              db.taskChunks.chunkId.isIn(chunkIds) &
                  db.taskChunks.deletedAt.isNull(),
            ))
            .get();
    // Each chapter's tasks in reading order, with their first reads.
    final taskIds = {for (final l in links) l.readTable(db.tasks).id};
    final firstReadSec = <String, int>{};
    if (taskIds.isNotEmpty) {
      for (final r
          in await (db.select(db.reviews)..where(
                (r) =>
                    r.taskId.isIn(taskIds) &
                    r.kind.equalsValue(ReviewKind.firstRead) &
                    r.deletedAt.isNull(),
              ))
              .get()) {
        firstReadSec[r.taskId] = (firstReadSec[r.taskId] ?? 0) + r.durationSec;
      }
    }
    final tasksOf = <String, List<ChapterTask>>{};
    for (final l in links) {
      final link = l.readTable(db.taskChunks);
      final task = l.readTable(db.tasks);
      final state = l.readTable(db.taskStates);
      (tasksOf[link.chunkId] ??= []).add(
        ChapterTask(
          taskId: task.id,
          title: task.title,
          level: state.level,
          dim: state.dim,
          order: link.order,
          range: switch ((link.startUnit, link.endUnit)) {
            (final int s, final int e) => UnitRange(s, e),
            _ => null,
          },
          part: link.part,
          parts: link.parts,
          firstReadSec: firstReadSec[task.id] ?? 0,
        ),
      );
    }
    for (final list in tasksOf.values) {
      list.sort(
        (a, b) => (a.range?.start ?? a.part ?? 0).compareTo(
          b.range?.start ?? b.part ?? 0,
        ),
      );
    }
    final chunks = [for (final r in rows) r.readTable(db.chunks)];
    final byChapter = SourceProgress.isByChapter(source, chunks);
    UnitRange? slotOf(int i) => byChapter ? UnitRange(i + 1, i + 1) : null;

    final sittings =
        await (db.select(db.readingSessions)
              ..where(
                (s) =>
                    s.sourceId.equals(sourceId) &
                    s.status.isIn([
                      ReadingStatus.open.name,
                      ReadingStatus.saved.name,
                    ]) &
                    s.deletedAt.isNull(),
              )
              ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
            .get();
    final saved = [
      for (final s in sittings)
        if (s.status == ReadingStatus.saved) s,
    ];
    final open = [
      for (final s in sittings)
        if (s.status == ReadingStatus.open) s,
    ].firstOrNull;

    // Explored: saved sittings and the units of tasks with a first read.
    // Read by chapter, a sitting that stopped inside a chapter has not
    // finished it.
    final readRanges = <UnitRange>[
      for (final s in saved)
        if (s.endUnit case final end?)
          if ((s.inChapter ? end - 1 : end) >= s.startUnit)
            UnitRange(s.startUnit, s.inChapter ? end - 1 : end),
    ];
    for (final (i, chunk) in chunks.indexed) {
      final c = ChapterProgress(
        chunk: chunk,
        tasks: tasksOf[chunk.id] ?? const [],
        slot: slotOf(i),
      );
      if (byChapter) {
        if (c.read) readRanges.add(c.range!);
        continue;
      }
      for (final t in c.tasks) {
        if (t.read) {
          if (c.rangeOf(t) case final r?) readRanges.add(r);
        }
      }
    }
    final explored = unionOf(readRanges);
    final touched = byChapter
        ? unionOf([
            for (final s in saved)
              if (s.endUnit case final end?) UnitRange(s.startUnit, end),
          ])
        : const <UnitRange>[];

    return SourceProgress(
      source: source,
      sittings: saved,
      explored: explored,
      open: open,
      chapters: [
        for (final (i, r) in rows.indexed)
          _chapter(r, tasksOf, explored, touched, slotOf(i)),
      ],
    );
  }

  ChapterProgress _chapter(
    TypedResult r,
    Map<String, List<ChapterTask>> tasksOf,
    List<UnitRange> explored,
    List<UnitRange> touched,
    UnitRange? slot,
  ) {
    final chunk = r.readTable(db.chunks);
    final c = ChapterProgress(chunk: chunk, slot: slot);
    final range = c.range;
    final read = range == null ? 0 : coveredUnits(explored, range);
    return ChapterProgress(
      chunk: chunk,
      survey: r.readTableOrNull(db.chunkSurveys),
      importance: r.readTableOrNull(db.examChunks)?.importance,
      tasks: tasksOf[chunk.id] ?? const [],
      readUnits: read,
      slot: slot,
      inProgress: slot != null && read == 0 && coveredUnits(touched, slot) > 0,
    );
  }

  /// Minutes a chapter of source [id] takes, when it is read by chapter
  /// (D49): calibrated from its first reads, else from its pages.
  Future<double> minutesPerChapter(String id) async {
    final p = await progress(id);
    if (p == null) return Defaults.chapterMinutesDefault;
    final unit = p.source.unitType;
    final perUnit = await pace(
      unit,
      defaultPace: switch (unit) {
        UnitType.page => Defaults.pacePageMin,
        UnitType.minute => Defaults.paceVideoMinuteMin,
        UnitType.question => Defaults.paceQuestionMin,
        UnitType.item => Defaults.paceItemMin,
      },
    );
    return p.minutesPerChapter(pagePace: perUnit);
  }

  /// Minutes per unit for the "Up to page" guess (D30), from the latest
  /// saved sittings of sources measured in [unitType].
  Future<double> pace(UnitType unitType, {required double defaultPace}) async {
    final rows =
        await (db.select(db.readingSessions).join([
                innerJoin(
                  db.sources,
                  db.sources.id.equalsExp(db.readingSessions.sourceId),
                ),
              ])
              ..where(
                db.sources.unitType.equalsValue(unitType) &
                    db.readingSessions.status.equalsValue(ReadingStatus.saved) &
                    db.readingSessions.deletedAt.isNull(),
              )
              ..orderBy([OrderingTerm.desc(db.readingSessions.endedAt)])
              ..limit(Defaults.readingPaceSittings))
            .get();
    return paceFrom([
      for (final r in rows)
        if (r.readTable(db.readingSessions) case ReadingSession(
          endUnit: final int end,
          minutes: final int m,
        ))
          Sitting(UnitRange(r.readTable(db.readingSessions).startUnit, end), m),
    ], defaultPace: defaultPace);
  }

  // ------------------------------------------------------------ Writes

  /// Opens a sitting of [sourceId] from its reading position. Only one
  /// sitting may be open at a time.
  Future<ReadingSession> start(String sourceId) async {
    if (await openSession() != null) {
      throw const InvalidOperationError('Finish the open reading first');
    }
    if (await (db.select(db.activeSessions)..limit(1)).getSingleOrNull() !=
        null) {
      throw const InvalidOperationError('Finish the open review first');
    }
    final p = await progress(sourceId);
    if (p == null) throw NotFoundError('source $sourceId');
    final from = p.position;
    if (from == null) {
      throw InvalidOperationError(
        p.finished ? 'This source is marked done' : 'This source is fully read',
      );
    }
    return mutate(
      entity: entity,
      entityId: sourceId,
      op: EventOp.update,
      data: {'action': 'startReading'},
      body: (rec) => rec.insert(
        db.readingSessions,
        ReadingSessionsCompanion(
          id: Value(rec.newId()),
          sourceId: Value(sourceId),
          startedAt: Value(rec.now),
          startUnit: Value(from),
          status: const Value(ReadingStatus.open),
        ),
      ),
    );
  }

  /// "I didn't read": closes the sitting and records nothing else.
  Future<void> discard(String sessionId) async {
    final s = await _session(sessionId);
    await mutate<void>(
      entity: entity,
      entityId: s.sourceId,
      op: EventOp.update,
      data: {'action': 'discardReading'},
      body: (rec) => rec.update(
        db.readingSessions,
        sessionId,
        ReadingSessionsCompanion(
          endedAt: Value(rec.now),
          status: const Value(ReadingStatus.discarded),
        ),
      ),
    );
  }

  /// What saving the open sitting up to [endUnit] would do, for the
  /// sheet's live preview.
  Future<SavePlan> preview(
    String sessionId, {
    required int endUnit,
    String? examId,
  }) async {
    final s = await _session(sessionId);
    final p = (await progress(s.sourceId, examId: examId))!;
    return p.planFor(UnitRange(s.startUnit, endUnit));
  }

  /// Saves the open sitting: the units [s.startUnit]..[endUnit] took
  /// [minutes]. Whole chapters read become one task per run with their
  /// first read, and tasks whose units are all read now get theirs.
  /// Pages of a finished chapter that no part covers become a task per
  /// gap; [taskNow] chapters (partly read) get a task for the pages read so
  /// far, with its first read (D49). Titles of such tasks come from
  /// [pagesTitle].
  ///
  /// Read by chapter (D49), [endUnit] is a chapter; with [inChapter] the
  /// student is still in it, and [partsDone] of its parts are finished.
  ///
  /// In a progressive source (D47) the sitting, with any held ones before
  /// it, becomes the next part: a chapter titled by [partTitle] and its
  /// task with the first read. Under [minPartMinutes] it is held instead,
  /// unless [partNow] or [finish]. [finish] marks the source done.
  /// One undoable operation.
  Future<SaveOutcome> save(
    String sessionId, {
    required int endUnit,
    required int minutes,
    String? examId,
    Set<String> taskNow = const {},
    String Function(int start, int end)? partTitle,
    String Function(String chapter, int start, int end)? pagesTitle,
    int minPartMinutes = 0,
    bool partNow = false,
    bool finish = false,
    bool inChapter = false,
    int partsDone = 0,
  }) async {
    final s = await _session(sessionId);
    if (s.status != ReadingStatus.open) {
      throw const InvalidOperationError('This reading is already closed');
    }
    final p = (await progress(s.sourceId, examId: examId))!;
    final last = p.readable ? p.totalUnits : endUnit;
    final end = endUnit.clamp(s.startUnit, last);
    final touched = UnitRange(s.startUnit, end);
    final stillIn = p.byChapter && inChapter;
    // What the sitting finished: read by chapter, not the chapter it
    // stopped in.
    final range = stillIn ? UnitRange(s.startUnit, end - 1) : touched;
    final plan = p.planFor(range);
    final sittings = [...p.savedSittings, Sitting(touched, minutes)];
    final after = unionOf([...p.explored, if (range.size > 0) range]);
    int secondsOn(Iterable<UnitRange> ranges) =>
        (ranges.fold<double>(0, (m, r) => m + minutesOn(r, sittings)) * 60)
            .round();
    String pages(Chunk chunk, UnitRange r) =>
        pagesTitle?.call(chunk.title, r.start, r.end) ??
        '${chunk.title} · ${r.start}–${r.end}';

    final part = p.progressive ? p.nextPart(range) : null;
    final makePart =
        part != null &&
        part.size > 0 &&
        (partNow ||
            finish ||
            !p.holds(range, minutes, minPartMinutes: minPartMinutes));

    // Whole chapters finished without any task: one task per run.
    final drafts = <TaskDraft>[
      for (final run in plan.newTasks)
        if ([for (final i in run) p.chapters[i]] case final chapters)
          TaskDraft(
            title: taskTitleFor([for (final c in chapters) c.chunk.title]),
            chapters: [for (final c in chapters) c.chunk],
            importance: TaskWriter.highest(chapters.map((c) => c.importance)),
            firstReadSec: secondsOn([for (final c in chapters) c.range!]),
          ),
    ];

    // First reads for tasks whose units are all read now.
    final reads = <String, int>{};
    void readTask(ChapterTask t) {
      if (t.read || reads.containsKey(t.taskId) || t.parts != null) return;
      final ranges = [
        for (final c in p.chapters)
          for (final x in c.tasks)
            if (x.taskId == t.taskId) ?c.rangeOf(x),
      ];
      if (ranges.any((r) => coveredUnits(after, r) < r.size)) return;
      reads[t.taskId] = secondsOn(ranges);
    }

    // Parts k of n share the chapter's time not given to earlier parts.
    void readParts(ChapterProgress c, int upTo) {
      final split = [
        for (final t in c.tasks)
          if (t.parts != null) t,
      ];
      final fresh = [
        for (final t in split)
          if (!t.read && t.part! <= upTo) t,
      ];
      if (fresh.isEmpty) return;
      final given = split.fold<int>(0, (sum, t) => sum + t.firstReadSec);
      final left = max(0, secondsOn([c.range!]) - given);
      for (final t in fresh) {
        reads[t.taskId] = left ~/ fresh.length;
      }
    }

    for (final i in {...plan.firstReads, ...plan.partial}) {
      final c = p.chapters[i];
      c.tasks.forEach(readTask);
      final finished =
          c.range != null && coveredUnits(after, c.range!) >= c.sizeUnits;
      if (finished) readParts(c, 1 << 20);
      if (!finished) continue;
      // Pages of a finished chapter that no part covers.
      for (final gap in c.uncovered) {
        if (c.tasks.isEmpty) break;
        drafts.add(
          TaskDraft(
            title: pages(c.chunk, gap),
            chapters: [c.chunk],
            importance: c.importance,
            range: gap,
            firstReadSec: secondsOn([gap]),
          ),
        );
      }
    }
    if (stillIn && partsDone > 0) readParts(p.chapters[end - 1], partsDone);

    // "Make the pages read so far a task" for partly read chapters.
    for (final i in plan.partial) {
      final c = p.chapters[i];
      if (!taskNow.contains(c.chunk.id) || c.slot != null) continue;
      final read = p.readWithoutTask(i, range);
      if (read == null) continue;
      drafts.add(
        TaskDraft(
          title: pages(c.chunk, read),
          chapters: [c.chunk],
          importance: c.importance,
          range: read,
          firstReadSec: secondsOn([read]),
        ),
      );
    }

    final context = drafts.isEmpty && reads.isEmpty && !makePart
        ? null
        : await _writer.firstReadContext();
    final targets = {
      for (final id in reads.keys) id: await _targetLevel(id, examId),
    };

    final created = <String>[];
    await mutate<void>(
      entity: entity,
      entityId: s.sourceId,
      op: EventOp.update,
      data: {'action': 'saveReading', 'endUnit': end, 'minutes': minutes},
      body: (rec) async {
        await rec.update(
          db.readingSessions,
          sessionId,
          ReadingSessionsCompanion(
            endedAt: Value(rec.now),
            endUnit: Value(end),
            minutes: Value(minutes),
            status: const Value(ReadingStatus.saved),
            inChapter: Value(stillIn),
          ),
        );
        for (final draft in drafts) {
          await _writer.insert(rec, draft, examId: examId, firstRead: context);
          created.add(draft.title);
        }
        for (final MapEntry(key: taskId, value: seconds) in reads.entries) {
          await _writer.recordFirstRead(
            rec,
            taskId,
            seconds: seconds,
            context: context!,
            targetLevel: targets[taskId],
          );
        }
        if (part != null && !p.source.progressive) {
          await rec.update(
            db.sources,
            s.sourceId,
            const SourcesCompanion(progressive: Value(true)),
          );
        }
        if (makePart) {
          final title =
              partTitle?.call(part.start, part.end) ??
              '${part.start}–${part.end}';
          final chunk = await rec.insert(
            db.chunks,
            ChunksCompanion(
              id: Value(rec.newId()),
              sourceId: Value(s.sourceId),
              title: Value(title),
              order: Value(p.chapters.length),
              startUnit: Value(part.start),
              endUnit: Value(part.end),
              sizeUnits: Value(part.size),
            ),
          );
          await _writer.insert(
            rec,
            TaskDraft(
              title: title,
              chapters: [chunk],
              firstReadSec: secondsOn([part]),
            ),
            examId: examId,
            firstRead: context,
          );
          created.add(title);
        }
        if (finish && !p.finished) {
          await rec.update(
            db.sources,
            s.sourceId,
            SourcesCompanion(finishedAt: Value(rec.now)),
          );
        }
      },
    );
    return SaveOutcome(
      tasksCreated: created,
      firstReads: reads.length,
      held: part != null && !makePart && part.size > 0 ? part : null,
      partial: [
        for (final i in plan.partial)
          if (!taskNow.contains(p.chapters[i].chunk.id))
            p.chapters[i].chunk.title,
      ],
    );
  }

  /// "Add task" (D49): one task over [chunkIds] (consecutive chapters
  /// without a task); or, on one chapter, a task over [pages] of it, or
  /// [parts] tasks splitting a chapter without page numbers ([partTitle]
  /// names each). With [alreadyRead] the first read is recorded now (D29),
  /// with any time the student's sittings spent on them. Returns the first
  /// new task's id.
  Future<String> addTask(
    String sourceId, {
    required List<String> chunkIds,
    required String title,
    Importance? importance,
    bool alreadyRead = false,
    String? examId,
    UnitRange? pages,
    int? parts,
    String Function(int part, int parts)? partTitle,
  }) async {
    final p = await progress(sourceId, examId: examId);
    if (p == null) throw NotFoundError('source $sourceId');
    final chapters = [
      for (final c in p.chapters)
        if (chunkIds.contains(c.chunk.id)) c,
    ];
    if (chapters.isEmpty) throw NotFoundError('chapters $chunkIds');
    final one = chapters.first;
    double on(UnitRange r) => minutesOn(r, p.savedSittings);
    final drafts = <TaskDraft>[];

    if (parts != null) {
      if (chapters.length != 1 || one.tasks.isNotEmpty || parts < 2) {
        throw const InvalidOperationError('Only a chapter without a task');
      }
      final each = one.range == null || !one.finished
          ? 0
          : (on(one.range!) * 60 / parts).round();
      for (var k = 1; k <= parts; k++) {
        drafts.add(
          TaskDraft(
            title:
                partTitle?.call(k, parts) ?? '${one.chunk.title} · $k/$parts',
            chapters: [one.chunk],
            importance: importance,
            part: k,
            parts: parts,
            firstReadSec: alreadyRead && one.finished ? each : null,
          ),
        );
      }
    } else if (pages != null) {
      final r = one.range;
      if (chapters.length != 1 ||
          r == null ||
          one.slot != null ||
          pages.start < r.start ||
          pages.end > r.end ||
          pages.size == 0 ||
          one.tasks.any((t) => (one.rangeOf(t)?.overlap(pages) ?? 1) > 0)) {
        throw const InvalidOperationError('Those pages already have a task');
      }
      drafts.add(
        TaskDraft(
          title: title,
          chapters: [one.chunk],
          importance: importance,
          range: pages,
          firstReadSec: alreadyRead ? (on(pages) * 60).round() : null,
        ),
      );
    } else {
      if (chapters.any((c) => c.tasks.isNotEmpty)) {
        throw const InvalidOperationError('These chapters already have a task');
      }
      drafts.add(
        TaskDraft(
          title: title.trim().isEmpty ? one.chunk.title : title,
          chapters: [for (final c in chapters) c.chunk],
          importance: importance,
          firstReadSec: alreadyRead
              ? (chapters.fold<double>(
                          0,
                          (sum, c) =>
                              c.range == null ? sum : sum + on(c.range!),
                        ) *
                        60)
                    .round()
              : null,
        ),
      );
    }
    final context = drafts.any((d) => d.firstReadSec != null)
        ? await _writer.firstReadContext()
        : null;
    return mutate(
      entity: entity,
      entityId: sourceId,
      op: EventOp.update,
      data: {'action': 'addTask', 'tasks': drafts.length},
      body: (rec) async {
        final ids = [
          for (final d in drafts)
            await _writer.insert(rec, d, examId: examId, firstRead: context),
        ];
        return ids.first;
      },
    );
  }

  /// "Done with this source" (D47): no more reading, no "Continue" item;
  /// unread units stay unread. False reopens it. Undoable.
  Future<void> setFinished(String sourceId, {required bool finished}) =>
      mutate<void>(
        entity: entity,
        entityId: sourceId,
        op: EventOp.update,
        data: {'action': finished ? 'finishSource' : 'reopenSource'},
        body: (rec) => rec.update(
          db.sources,
          sourceId,
          SourcesCompanion(finishedAt: Value(finished ? rec.now : null)),
        ),
      );

  /// Undoes the latest change to the source (a save, an added task).
  Future<void> undo(String sourceId) => undoLatest(entity, sourceId);

  Future<int?> _targetLevel(String taskId, String? examId) async {
    if (examId == null) return null;
    final link =
        await (db.select(db.examTasks)..where(
              (e) =>
                  e.examId.equals(examId) &
                  e.taskId.equals(taskId) &
                  e.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    return link?.targetLevel;
  }

  Future<ReadingSession> _session(String id) async {
    final s = await (db.select(
      db.readingSessions,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (s == null || s.deletedAt != null) throw NotFoundError('reading $id');
    return s;
  }
}
