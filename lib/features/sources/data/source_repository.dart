import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
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

  Future<void> softDelete(String id) => mutate<void>(
    entity: entity,
    entityId: id,
    op: EventOp.delete,
    body: (rec) => rec.softDelete(db.sources, id),
  );

  /// Reverses the latest change to this source.
  Future<void> undo(String id) => undoLatest(entity, id);

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
