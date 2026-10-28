import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';

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
