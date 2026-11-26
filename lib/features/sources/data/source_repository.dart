import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import '../../../core/result/result.dart';
import '../../../engines/reading/reading_math.dart';
import '../../../platform/files/file_store.dart';
import 'chapter_split.dart';

/// A source with its survey progress, for the Sources list.
final class SourceSummary {
  const SourceSummary({
    required this.source,
    required this.chapterCount,
    required this.surveyedCount,
  });

  final Source source;

  /// Top-level chapters (parts from bookmarks are not counted).
  final int chapterCount;
  final int surveyedCount;

  bool get surveyed => chapterCount > 0 && surveyedCount >= chapterCount;
}

/// Writes and reads [Source] rows. Every write logs an Event.
final class SourceRepository extends EventSourcedRepository {
  SourceRepository(super.ctx);

  static const entity = 'source';

  Future<Source> create({
    required SourceType type,
    required String title,
    required UnitType unitType,
    String? uri,
    int? totalUnits,
  }) {
    final id = ctx.ids.next();
    return mutate(
      entity: entity,
      entityId: id,
      op: EventOp.create,
      body: (rec) => rec.insert(
        db.sources,
        SourcesCompanion(
          id: Value(id),
          type: Value(type),
          title: Value(title),
          unitType: Value(unitType),
          uri: Value(uri),
          totalUnits: Value(totalUnits),
        ),
      ),
    );
  }

  /// Saves a source with its stored file (if any) and its chapters, as one
  /// undoable operation (design/notes/add-source.md).
  Future<Source> createWithChunks({
    required SourceType type,
    required String title,
    required UnitType unitType,
    required List<ChunkDraft> chapters,
    String? uri,
    int? totalUnits,
    StoredFile? file,
  }) {
    final id = ctx.ids.next();
    return mutate(
      entity: entity,
      entityId: id,
      op: EventOp.create,
      body: (rec) async {
        final source = await rec.insert(
          db.sources,
          SourcesCompanion(
            id: Value(id),
            type: Value(type),
            title: Value(title),
            unitType: Value(unitType),
            uri: Value(uri),
            totalUnits: Value(totalUnits),
          ),
        );
        if (file != null) {
          await rec.insert(
            db.sourceFiles,
            SourceFilesCompanion(
              id: Value(rec.newId()),
              sourceId: Value(id),
              localPath: Value(file.relativePath),
              place: Value(file.place),
              bytes: Value(file.bytes),
              sha256: Value(file.sha256),
            ),
          );
        }
        Future<void> addAll(List<ChunkDraft> drafts, String? parentId) async {
          for (var i = 0; i < drafts.length; i++) {
            final d = drafts[i];
            final chunk = await rec.insert(
              db.chunks,
              ChunksCompanion(
                id: Value(rec.newId()),
                sourceId: Value(id),
                parentChunkId: Value(parentId),
                title: Value(d.title),
                order: Value(i),
                startUnit: Value(d.startUnit),
                endUnit: Value(d.endUnit),
                sizeUnits: Value(d.sizeUnits),
              ),
            );
            await addAll(d.children, chunk.id);
          }
        }

        await addAll(chapters, null);
        return source;
      },
    );
  }

  /// The live source that already holds a file with this hash, if any.
  Future<Source?> findByFileHash(String sha256) async {
    final query =
        db.select(db.sources).join([
          innerJoin(
            db.sourceFiles,
            db.sourceFiles.sourceId.equalsExp(db.sources.id),
          ),
        ])..where(
          db.sourceFiles.sha256.equals(sha256) &
              db.sources.deletedAt.isNull() &
              db.sourceFiles.deletedAt.isNull(),
        );
    final rows = await query.get();
    return rows.isEmpty ? null : rows.first.readTable(db.sources);
  }

  /// The stored file of a source, if it has one.
  Future<SourceFile?> fileOf(String sourceId) =>
      (db.select(db.sourceFiles)
            ..where((f) => f.sourceId.equals(sourceId) & f.deletedAt.isNull())
            ..limit(1))
          .getSingleOrNull();

  /// Every live source file, for moving them into a study folder.
  Future<List<SourceFile>> allFiles() async {
    final rows =
        await (db.select(db.sourceFiles).join([
              innerJoin(
                db.sources,
                db.sources.id.equalsExp(db.sourceFiles.sourceId),
              ),
            ])..where(
              db.sourceFiles.deletedAt.isNull() & db.sources.deletedAt.isNull(),
            ))
            .get();
    return [for (final r in rows) r.readTable(db.sourceFiles)];
  }

  /// Points source [sourceId]'s file somewhere else: moved into the study
  /// folder, found again, or relinked by the student (D51). [action] names
  /// it in the Event.
  Future<void> setFile(
    String sourceId,
    StoredFile file, {
    required String action,
  }) async {
    final existing = await fileOf(sourceId);
    await mutate(
      entity: entity,
      entityId: sourceId,
      op: EventOp.update,
      data: {'action': action},
      body: (rec) async {
        if (existing == null) {
          await rec.insert(
            db.sourceFiles,
            SourceFilesCompanion(
              id: Value(rec.newId()),
              sourceId: Value(sourceId),
              localPath: Value(file.relativePath),
              place: Value(file.place),
              bytes: Value(file.bytes),
              sha256: Value(file.sha256),
            ),
          );
        } else {
          await rec.update(
            db.sourceFiles,
            existing.id,
            SourceFilesCompanion(
              localPath: Value(file.relativePath),
              place: Value(file.place),
              bytes: Value(file.bytes),
              sha256: Value(file.sha256),
            ),
          );
        }
      },
    );
  }

  /// A source's chapters in reading order, top level first then parts.
  Stream<List<Chunk>> watchChunks(String sourceId) =>
      (db.select(db.chunks)
            ..where((c) => c.sourceId.equals(sourceId) & c.deletedAt.isNull())
            ..orderBy([
              (c) => OrderingTerm.asc(c.startUnit, nulls: NullsOrder.last),
              (c) => OrderingTerm.asc(c.order),
            ]))
          .watch();

  /// Changes the given fields. Pass `Value(null)` to clear a nullable one.
  Future<Source> update(
    String id, {
    Value<String> title = const Value.absent(),
    Value<String?> uri = const Value.absent(),
    Value<UnitType> unitType = const Value.absent(),
    Value<int?> totalUnits = const Value.absent(),
  }) => mutate(
    entity: entity,
    entityId: id,
    op: EventOp.update,
    body: (rec) => rec.update(
      db.sources,
      id,
      SourcesCompanion(
        title: title,
        uri: uri,
        unitType: unitType,
        totalUnits: totalUnits,
      ),
    ),
  );

  /// Tasks that go with source [id] when it is removed: those whose parts
  /// all come from it.
  Future<List<String>> tasksOf(String id) async {
    final chunkIds = await _chunkIds(id);
    if (chunkIds.isEmpty) return const [];
    final links =
        await (db.select(db.taskChunks).join([
              innerJoin(db.tasks, db.tasks.id.equalsExp(db.taskChunks.taskId)),
            ])..where(
              db.taskChunks.deletedAt.isNull() & db.tasks.deletedAt.isNull(),
            ))
            .get();
    final ownChunks = chunkIds.toSet();
    final byTask = <String, List<String>>{};
    for (final l in links) {
      final link = l.readTable(db.taskChunks);
      byTask.putIfAbsent(link.taskId, () => []).add(link.chunkId);
    }
    return [
      for (final MapEntry(key: task, value: chunks) in byTask.entries)
        if (chunks.every(ownChunks.contains)) task,
    ];
  }

  /// Removes source [id] with its chapters and the tasks made from it, as
  /// one undoable change. Reviews stay in the log (they are append-only);
  /// an open reading sitting of it is closed. Refused while a review of
  /// one of its tasks is open.
  Future<void> softDelete(String id) async {
    final chunkIds = await _chunkIds(id);
    final taskIds = await tasksOf(id);
    final active = await (db.select(
      db.activeSessions,
    )..limit(1)).getSingleOrNull();
    if (active != null && taskIds.contains(active.taskId)) {
      throw const InvalidOperationError('Finish the open review first');
    }
    final taskChunks = [
      for (final r
          in await (db.select(db.taskChunks)..where(
                (t) =>
                    (t.chunkId.isIn(chunkIds) | t.taskId.isIn(taskIds)) &
                    t.deletedAt.isNull(),
              ))
              .get())
        r.id,
    ];
    final surveys = [
      for (final r in await (db.select(
        db.chunkSurveys,
      )..where((t) => t.chunkId.isIn(chunkIds) & t.deletedAt.isNull())).get())
        r.id,
    ];
    final examChunks = [
      for (final r in await (db.select(
        db.examChunks,
      )..where((t) => t.chunkId.isIn(chunkIds) & t.deletedAt.isNull())).get())
        r.id,
    ];
    final examTasks = [
      for (final r in await (db.select(
        db.examTasks,
      )..where((t) => t.taskId.isIn(taskIds) & t.deletedAt.isNull())).get())
        r.id,
    ];
    final open = [
      for (final r
          in await (db.select(db.readingSessions)..where(
                (t) =>
                    t.sourceId.equals(id) &
                    t.status.equalsValue(ReadingStatus.open) &
                    t.deletedAt.isNull(),
              ))
              .get())
        r.id,
    ];
    await mutate<void>(
      entity: entity,
      entityId: id,
      op: EventOp.delete,
      data: {'tasks': taskIds.length},
      body: (rec) async {
        for (final r in open) {
          await rec.update(
            db.readingSessions,
            r,
            ReadingSessionsCompanion(
              endedAt: Value(rec.now),
              status: const Value(ReadingStatus.discarded),
            ),
          );
        }
        final rows = <(TableInfo<Table, Object?>, List<String>)>[
          (db.taskChunks, taskChunks),
          (db.chunkSurveys, surveys),
          (db.examChunks, examChunks),
          (db.examTasks, examTasks),
        ];
        for (final (table, ids) in rows) {
          for (final rowId in ids) {
            await rec.softDelete(table, rowId);
          }
        }
        for (final t in taskIds) {
          await rec.softDelete(db.tasks, t);
        }
        for (final c in chunkIds) {
          await rec.softDelete(db.chunks, c);
        }
        await rec.softDelete(db.sources, id);
      },
    );
  }

  Future<List<String>> _chunkIds(String sourceId) async => [
    for (final c in await (db.select(
      db.chunks,
    )..where((c) => c.sourceId.equals(sourceId) & c.deletedAt.isNull())).get())
      c.id,
  ];

  /// Reverses the latest change to this source.
  Future<void> undo(String id) => undoLatest(entity, id);

  /// Renames chapter [chunkId] and, given [start] and [end], moves it to
  /// those units, as one undoable change under the source (D56, D58).
  /// Tasks keep their own pages. A neighbour it overlaps at an edge gives
  /// those units up, and is renamed by [autoTitle] when its name was its
  /// range. With [endsSource] the source ends at [end]. Refused when it
  /// would swallow a chapter or cut one in two.
  Future<void> editChapter(
    String sourceId,
    String chunkId, {
    required String title,
    int? start,
    int? end,
    bool endsSource = false,
    String Function(int start, int end)? autoTitle,
  }) => _place(
    sourceId,
    chunkId: chunkId,
    title: title,
    start: start,
    end: end,
    endsSource: endsSource,
    autoTitle: autoTitle,
    action: 'editChapter',
  );

  /// Adds a chapter after the others (D56): units [start]–[end], or none
  /// for a source read by chapter. Overlaps work as in [editChapter].
  Future<Chunk> addChapter(
    String sourceId, {
    required String title,
    int? start,
    int? end,
    bool endsSource = false,
    String Function(int start, int end)? autoTitle,
  }) async => (await _place(
    sourceId,
    title: title,
    start: start,
    end: end,
    endsSource: endsSource,
    autoTitle: autoTitle,
    action: 'addChapter',
  ))!;

  /// Writes a chapter (a new one when [chunkId] is null) with the trims
  /// its range needs. Returns the new chapter.
  Future<Chunk?> _place(
    String sourceId, {
    required String title,
    required String action,
    String? chunkId,
    int? start,
    int? end,
    bool endsSource = false,
    String Function(int start, int end)? autoTitle,
  }) async {
    final chapters =
        await (db.select(db.chunks)..where(
              (c) =>
                  c.sourceId.equals(sourceId) &
                  c.parentChunkId.isNull() &
                  c.deletedAt.isNull(),
            ))
            .get();
    final byId = {for (final c in chapters) c.id: c};
    var fit = const ChapterFit();
    if (start != null && end != null) {
      if (start < 1 || end < start) {
        throw const InvalidOperationError('Pages out of order');
      }
      fit = fitChapter(UnitRange(start, end), {
        for (final c in chapters)
          if (c.id != chunkId && c.startUnit != null && c.endUnit != null)
            c.id: UnitRange(c.startUnit!, c.endUnit!),
      });
      if (fit.blocker case final id?) {
        throw InvalidOperationError('Would swallow ${byId[id]!.title}');
      }
    }
    final last = chapters.fold<int>(-1, (m, c) => c.order > m ? c.order : m);
    final units = start != null && end != null;
    return mutate(
      entity: entity,
      entityId: sourceId,
      op: EventOp.update,
      data: {'action': action},
      body: (rec) async {
        for (final MapEntry(key: id, value: r) in fit.trims.entries) {
          final old = byId[id]!;
          final renamed =
              autoTitle != null &&
              old.title == autoTitle(old.startUnit!, old.endUnit!);
          await rec.update(
            db.chunks,
            id,
            ChunksCompanion(
              title: renamed
                  ? Value(autoTitle(r.start, r.end))
                  : const Value.absent(),
              startUnit: Value(r.start),
              endUnit: Value(r.end),
              sizeUnits: Value(r.size),
            ),
          );
        }
        if (endsSource && units) {
          await rec.update(
            db.sources,
            sourceId,
            SourcesCompanion(totalUnits: Value(end)),
          );
        }
        if (chunkId != null) {
          await rec.update(
            db.chunks,
            chunkId,
            ChunksCompanion(
              title: Value(title),
              startUnit: units ? Value(start) : const Value.absent(),
              endUnit: units ? Value(end) : const Value.absent(),
              sizeUnits: units ? Value(end - start + 1) : const Value.absent(),
            ),
          );
          return null;
        }
        return rec.insert(
          db.chunks,
          ChunksCompanion(
            id: Value(rec.newId()),
            sourceId: Value(sourceId),
            title: Value(title),
            order: Value(last + 1),
            startUnit: Value(start),
            endUnit: Value(end),
            sizeUnits: Value(units ? end - start + 1 : null),
          ),
        );
      },
    );
  }

  /// Deletes chapter [chunkId] with its survey answers (D56), as one
  /// undoable change. Refused while any task covers it: the student
  /// deletes those tasks first.
  Future<void> deleteChapter(String sourceId, String chunkId) async {
    if (await chapterHasTasks(chunkId)) {
      throw const InvalidOperationError('Delete its tasks first');
    }
    final surveys = await (db.select(
      db.chunkSurveys,
    )..where((t) => t.chunkId.equals(chunkId) & t.deletedAt.isNull())).get();
    final exams = await (db.select(
      db.examChunks,
    )..where((t) => t.chunkId.equals(chunkId) & t.deletedAt.isNull())).get();
    await mutate<void>(
      entity: entity,
      entityId: sourceId,
      op: EventOp.update,
      data: {'action': 'deleteChapter'},
      body: (rec) async {
        for (final r in surveys) {
          await rec.softDelete(db.chunkSurveys, r.id);
        }
        for (final r in exams) {
          await rec.softDelete(db.examChunks, r.id);
        }
        await rec.softDelete(db.chunks, chunkId);
      },
    );
  }

  /// A live task covers some of chapter [chunkId].
  Future<bool> chapterHasTasks(String chunkId) async {
    final row =
        await (db.select(db.taskChunks).join([
                innerJoin(
                  db.tasks,
                  db.tasks.id.equalsExp(db.taskChunks.taskId) &
                      db.tasks.deletedAt.isNull(),
                ),
              ])
              ..where(
                db.taskChunks.chunkId.equals(chunkId) &
                    db.taskChunks.deletedAt.isNull(),
              )
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  Stream<List<Source>> watchAll() =>
      (db.select(db.sources)
            ..where((s) => s.deletedAt.isNull())
            ..orderBy([(s) => OrderingTerm.asc(s.title)]))
          .watch();

  Stream<Source?> watch(String id) => (db.select(
    db.sources,
  )..where((s) => s.id.equals(id) & s.deletedAt.isNull())).watchSingleOrNull();

  /// Every live source with its chapter and surveyed counts, unfinished
  /// surveys first, then by title (design/notes/sources-list.md).
  Stream<List<SourceSummary>> watchSummaries() {
    final chapters = db.chunks.id.count();
    final surveyed = db.chunkSurveys.id.count();
    final query =
        db.select(db.sources).join([
            leftOuterJoin(
              db.chunks,
              db.chunks.sourceId.equalsExp(db.sources.id) &
                  db.chunks.parentChunkId.isNull() &
                  db.chunks.deletedAt.isNull(),
              useColumns: false,
            ),
            leftOuterJoin(
              db.chunkSurveys,
              db.chunkSurveys.chunkId.equalsExp(db.chunks.id) &
                  db.chunkSurveys.deletedAt.isNull(),
              useColumns: false,
            ),
          ])
          ..addColumns([chapters, surveyed])
          ..where(db.sources.deletedAt.isNull())
          ..groupBy([db.sources.id]);
    return query.watch().map((rows) {
      final out = [
        for (final r in rows)
          SourceSummary(
            source: r.readTable(db.sources),
            chapterCount: r.read(chapters) ?? 0,
            surveyedCount: r.read(surveyed) ?? 0,
          ),
      ];
      return out..sort((a, b) {
        if (a.surveyed != b.surveyed) return a.surveyed ? 1 : -1;
        return a.source.title.toLowerCase().compareTo(
          b.source.title.toLowerCase(),
        );
      });
    });
  }
}
