import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';
import 'chapter_split.dart';

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
}

/// A file already copied into app storage (see `FileStore`).
final class StoredFile {
  const StoredFile({
    required this.relativePath,
    required this.bytes,
    required this.sha256,
  });

  /// Relative to the app documents directory, e.g. `sources/<uuid>.pdf`.
  final String relativePath;
  final int bytes;
  final String sha256;
}
