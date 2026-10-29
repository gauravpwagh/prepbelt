import 'package:drift/drift.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';
import '../../../engines/reading/reading_math.dart';
import '../../tasks/data/review_repository.dart';
import 'source_repository.dart';
import 'task_writer.dart';

/// One chapter on the Source chapters screen.
final class ChapterProgress {
  const ChapterProgress({
    required this.chunk,
    this.survey,
    this.importance,
    this.taskId,
    this.taskTitle,
    this.taskLevel = 0,
    this.taskDim = 0,
    this.taskOrder = 0,
    this.readUnits = 0,
  });

  final Chunk chunk;
  final ChunkSurvey? survey;

  /// For the exam; null without one or before the survey sets it.
  final Importance? importance;
  final String? taskId;
  final String? taskTitle;
  final int taskLevel;
  final int taskDim;

  /// This chapter's place in its task: 0 for the first (D27).
  final int taskOrder;

  /// Units of the chapter already explored.
  final int readUnits;

  UnitRange? get range => switch ((chunk.startUnit, chunk.endUnit)) {
    (final int s, final int e) => UnitRange(s, e),
    _ => null,
  };

  int get sizeUnits => range?.size ?? 0;
  bool get hasTask => taskId != null;

  /// The task has its first read (it is White or above).
  bool get read => taskLevel > 0;
  bool get finished => read || (sizeUnits > 0 && readUnits >= sizeUnits);
  bool get partlyRead => !finished && readUnits > 0;
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

  /// Explored ranges (D28), merged.
  final List<UnitRange> explored;

  /// The open sitting of this source, if any.
  final ReadingSession? open;

  int get totalUnits => source.totalUnits ?? 0;
  bool get readable => totalUnits > 0;
  UnitRange get whole => UnitRange(1, totalUnits);
  int get exploredUnits => coveredUnits(explored, whole);

  /// "Done with this source": nothing more to read (D47).
  bool get finished => source.finishedAt != null;

  /// The first unit not yet read; null once all of it is, or once the
  /// student is done with the source.
  int? get position =>
      readable && !finished ? firstUncovered(explored, whole) : null;

  /// Splits as it is read (D47): each saved sitting becomes the next part.
  /// True once a sitting made a part, or while no chapter has a range.
  bool get progressive =>
      source.progressive || !chapters.any((c) => c.range != null);

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
  /// source. None once finished.
  int get unitsToExplore {
    if (!readable || finished) return 0;
    if (progressive) return totalUnits - exploredUnits;
    return chapters.fold(
      0,
      (sum, c) => c.hasTask ? sum : sum + c.sizeUnits - c.readUnits,
    );
  }

  int get taskCount => {for (final c in chapters) ?c.taskId}.length;
  int get withoutTask => chapters.where((c) => !c.hasTask).length;
  int get surveyedCount => chapters.where((c) => c.survey != null).length;

  /// What saving [sitting] would do, by index into [chapters].
  SavePlan planFor(UnitRange sitting) {
    final withRanges = [
      for (final c in chapters)
        if (c.range != null) c,
    ];
    final plan = planSave(
      chapters: [
        for (final c in withRanges)
          ChapterState(range: c.range!, hasTask: c.hasTask, read: c.read),
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
    final linkOf = {
      for (final l in links) l.readTable(db.taskChunks).chunkId: l,
    };

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

    // Explored: saved sittings and chapters whose task has its first read.
    final readRanges = <UnitRange>[
      for (final s in saved)
        if (s.endUnit case final end?) UnitRange(s.startUnit, end),
      for (final r in rows)
        if (linkOf[r.readTable(db.chunks).id] case final l?)
          if (l.readTable(db.taskStates).level > 0)
            if (r.readTable(db.chunks) case Chunk(
              startUnit: final int s,
              endUnit: final int e,
            ))
              UnitRange(s, e),
    ];
    final explored = unionOf(readRanges);

    return SourceProgress(
      source: source,
      sittings: saved,
      explored: explored,
      open: open,
      chapters: [
        for (final r in rows)
          _chapter(r, linkOf[r.readTable(db.chunks).id], explored),
      ],
    );
  }

  ChapterProgress _chapter(
    TypedResult r,
    TypedResult? link,
    List<UnitRange> explored,
  ) {
    final chunk = r.readTable(db.chunks);
    final task = link?.readTable(db.tasks);
    final state = link?.readTable(db.taskStates);
    final c = ChapterProgress(chunk: chunk);
    return ChapterProgress(
      chunk: chunk,
      survey: r.readTableOrNull(db.chunkSurveys),
      importance: r.readTableOrNull(db.examChunks)?.importance,
      taskId: task?.id,
      taskTitle: task?.title,
      taskLevel: state?.level ?? 0,
      taskDim: state?.dim ?? 0,
      taskOrder: link?.readTable(db.taskChunks).order ?? 0,
      readUnits: c.range == null ? 0 : coveredUnits(explored, c.range!),
    );
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
  /// first read; tasks already made for finished chapters get their first
  /// read; [taskNow] chapters (partly read) become not-started tasks (D29).
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
    int minPartMinutes = 0,
    bool partNow = false,
    bool finish = false,
  }) async {
    final s = await _session(sessionId);
    if (s.status != ReadingStatus.open) {
      throw const InvalidOperationError('This reading is already closed');
    }
    final p = (await progress(s.sourceId, examId: examId))!;
    final last = p.readable ? p.totalUnits : endUnit;
    final end = endUnit.clamp(s.startUnit, last);
    final range = UnitRange(s.startUnit, end);
    final plan = p.planFor(range);
    final sittings = [...p.savedSittings, Sitting(range, minutes)];
    final part = p.progressive ? p.nextPart(range) : null;
    final makePart =
        part != null &&
        part.size > 0 &&
        (partNow ||
            finish ||
            !p.holds(range, minutes, minPartMinutes: minPartMinutes));
    final context =
        plan.newTasks.isEmpty && plan.firstReads.isEmpty && !makePart
        ? null
        : await _writer.firstReadContext();

    int secondsOn(Iterable<ChapterProgress> chapters) =>
        (chapters.fold<double>(
                  0,
                  (sum, c) => sum + minutesOn(c.range!, sittings),
                ) *
                60)
            .round();

    final created = <String>[];
    var reads = 0;
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
          ),
        );
        for (final run in plan.newTasks) {
          final chapters = [for (final i in run) p.chapters[i]];
          final draft = TaskDraft(
            title: taskTitleFor([for (final c in chapters) c.chunk.title]),
            chapters: [for (final c in chapters) c.chunk],
            importance: TaskWriter.highest(chapters.map((c) => c.importance)),
            firstReadSec: secondsOn(chapters),
          );
          await _writer.insert(rec, draft, examId: examId, firstRead: context);
          created.add(draft.title);
        }
        // A task's first read waits until all its chapters are read.
        final byTask = <String, List<ChapterProgress>>{};
        for (final i in plan.firstReads) {
          byTask.putIfAbsent(p.chapters[i].taskId!, () => []);
        }
        final after = unionOf([...p.explored, range]);
        for (final taskId in byTask.keys) {
          final chapters = [
            for (final c in p.chapters)
              if (c.taskId == taskId) c,
          ];
          final done = chapters.every(
            (c) =>
                c.range != null && coveredUnits(after, c.range!) >= c.sizeUnits,
          );
          if (!done) continue;
          await _writer.recordFirstRead(
            rec,
            taskId,
            seconds: secondsOn(chapters),
            context: context!,
            targetLevel: await _targetLevel(taskId, examId),
          );
          reads++;
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
              firstReadSec: (minutesOn(part, sittings) * 60).round(),
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
        for (final i in plan.partial) {
          final c = p.chapters[i];
          if (c.hasTask || !taskNow.contains(c.chunk.id)) continue;
          await _writer.insert(
            rec,
            TaskDraft(
              title: c.chunk.title,
              chapters: [c.chunk],
              importance: c.importance,
            ),
            examId: examId,
          );
          created.add(c.chunk.title);
        }
      },
    );
    return SaveOutcome(
      tasksCreated: created,
      firstReads: reads,
      held: part != null && !makePart && part.size > 0 ? part : null,
      partial: [
        for (final i in plan.partial)
          if (!taskNow.contains(p.chapters[i].chunk.id))
            p.chapters[i].chunk.title,
      ],
    );
  }

  /// "Add task": one task over [chunkIds] (consecutive chapters without a
  /// task). With [alreadyRead] the first read is recorded now (D29), with
  /// any time the student's sittings spent on these chapters.
  Future<String> addTask(
    String sourceId, {
    required List<String> chunkIds,
    required String title,
    Importance? importance,
    bool alreadyRead = false,
    String? examId,
  }) async {
    final p = await progress(sourceId, examId: examId);
    if (p == null) throw NotFoundError('source $sourceId');
    final chapters = [
      for (final c in p.chapters)
        if (chunkIds.contains(c.chunk.id)) c,
    ];
    if (chapters.isEmpty || chapters.any((c) => c.hasTask)) {
      throw const InvalidOperationError('These chapters already have a task');
    }
    final seconds =
        (chapters.fold<double>(
                  0,
                  (sum, c) => c.range == null
                      ? sum
                      : sum + minutesOn(c.range!, p.savedSittings),
                ) *
                60)
            .round();
    final context = alreadyRead ? await _writer.firstReadContext() : null;
    return mutate(
      entity: entity,
      entityId: sourceId,
      op: EventOp.update,
      data: {'action': 'addTask'},
      body: (rec) => _writer.insert(
        rec,
        TaskDraft(
          title: title.trim().isEmpty ? chapters.first.chunk.title : title,
          chapters: [for (final c in chapters) c.chunk],
          importance: importance,
          firstReadSec: alreadyRead ? seconds : null,
        ),
        examId: examId,
        firstRead: context,
      ),
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
