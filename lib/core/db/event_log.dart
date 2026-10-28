import 'dart:convert';

import 'package:drift/drift.dart';

import '../ids/ids.dart';
import '../result/result.dart';
import '../time/clock.dart';
import '../time/hlc.dart';
import 'app_database.dart';

/// Everything a write needs: the database, time, ids and sync stamps.
final class WriteContext {
  WriteContext({
    required this.db,
    required this.clock,
    required this.ids,
    required this.deviceId,
  }) : hlc = Hlc(clock: clock, deviceId: deviceId);

  final AppDatabase db;
  final Clock clock;
  final IdGenerator ids;
  final String deviceId;
  final Hlc hlc;
}

/// One row changed by an operation, as raw SQL column values.
final class RowChange {
  const RowChange({
    required this.table,
    required this.id,
    required this.before,
    required this.after,
  });

  factory RowChange.fromJson(Map<String, Object?> json) => RowChange(
    table: json['table']! as String,
    id: json['id']! as String,
    before: json['before'] as Map<String, Object?>?,
    after: json['after'] as Map<String, Object?>?,
  );

  final String table;
  final String id;

  /// Null when the operation created the row.
  final Map<String, Object?>? before;

  /// The full row after the change.
  final Map<String, Object?>? after;

  Map<String, Object?> toJson() => {
    'table': table,
    'id': id,
    'before': before,
    'after': after,
  };
}

/// Decoded `Event.payload`.
final class EventPayload {
  const EventPayload({required this.changes, this.undoOf, this.data});

  factory EventPayload.decode(String payload) {
    final json = jsonDecode(payload) as Map<String, Object?>;
    return EventPayload(
      changes: [
        for (final c in json['changes']! as List<Object?>)
          RowChange.fromJson(c! as Map<String, Object?>),
      ],
      undoOf: json['undoOf'] as String?,
      data: json['data'] as Map<String, Object?>?,
    );
  }

  final List<RowChange> changes;

  /// Set on events written by undo: the id of the event they reversed.
  final String? undoOf;

  /// Operation-specific extras (for example a review's rating).
  final Map<String, Object?>? data;

  String encode() => jsonEncode({
    'changes': [for (final c in changes) c.toJson()],
    'undoOf': ?undoOf,
    'data': ?data,
  });
}

/// Performs writes inside a transaction and remembers each row's
/// before and after state for the operation's Event.
final class ChangeRecorder {
  ChangeRecorder._(this._ctx, this.now, this.hlc);

  final WriteContext _ctx;

  /// The operation's timestamp, used for every row it touches.
  final int now;

  /// The operation's HLC stamp, used for every row it touches.
  final String hlc;
  final List<RowChange> _changes = [];

  AppDatabase get _db => _ctx.db;

  /// A new UUIDv7.
  String newId() => _ctx.ids.next();

  /// Inserts a row. The companion must set `id`; convention columns other
  /// than `id` are filled here.
  Future<R> insert<T extends Table, R>(
    TableInfo<T, R> table,
    Insertable<R> row,
  ) async {
    final columns = row.toColumns(true);
    final id = _idOf(columns);
    final filled = RawValuesInsertable<R>({
      ...columns,
      'created_at': Variable<int>(now),
      'updated_at': Variable<int>(now),
      'hlc': Variable<String>(hlc),
      'device_id': Variable<String>(_ctx.deviceId),
    });
    await _db.into(table).insert(filled);
    final after = await _read(table, id);
    _changes.add(
      RowChange(
        table: table.actualTableName,
        id: id,
        before: null,
        after: _raw(table, after),
      ),
    );
    return after;
  }

  /// Updates the columns set in [patch] on row [id].
  Future<R> update<T extends Table, R>(
    TableInfo<T, R> table,
    String id,
    Insertable<R> patch,
  ) async {
    final before = await _read(table, id);
    final columns = {
      ...patch.toColumns(true),
      'updated_at': Variable<int>(now),
      'hlc': Variable<String>(hlc),
    };
    await (_db.update(table)..where((_) => _idColumn(table).equals(id))).write(
      RawValuesInsertable<R>(columns),
    );
    final after = await _read(table, id);
    _changes.add(
      RowChange(
        table: table.actualTableName,
        id: id,
        before: _raw(table, before),
        after: _raw(table, after),
      ),
    );
    return after;
  }

  /// Soft-deletes row [id] by setting `deletedAt`.
  Future<void> softDelete(TableInfo<Table, Object?> table, String id) async {
    final before = _raw(table, await _read(table, id));
    await _put(table, id, {...before, 'deleted_at': now}, before: before);
  }

  /// Writes [values] (raw SQL column values) over row [id], creating it if
  /// needed. Used by undo to put a row back as it was.
  Future<void> restore(
    String tableName,
    String id,
    Map<String, Object?> values,
  ) async {
    final table = _tableNamed(tableName);
    final existing = await _readOrNull(table, id);
    await _put(
      table,
      id,
      values,
      before: existing == null ? null : _raw(table, existing),
    );
  }

  /// Soft-deletes a row that the reversed operation created.
  Future<void> unCreate(String tableName, String id) =>
      softDelete(_tableNamed(tableName), id);

  /// Upserts a full row given as raw SQL values, stamping it with this
  /// operation's time and HLC, and records the change.
  ///
  /// Plain SQL rather than drift's typed upsert: drift drops null columns
  /// from data-class rows, and undo must be able to write nulls back.
  Future<void> _put(
    TableInfo<Table, Object?> table,
    String id,
    Map<String, Object?> values, {
    required Map<String, Object?>? before,
  }) async {
    final data = {...values, 'updated_at': now, 'hlc': hlc};
    final names = data.keys.map((c) => '"$c"').toList();
    await _db.customStatement(
      'INSERT INTO "${table.actualTableName}" (${names.join(', ')}) '
      'VALUES (${List.filled(names.length, '?').join(', ')}) '
      'ON CONFLICT ("id") DO UPDATE SET '
      '${names.map((n) => '$n = excluded.$n').join(', ')}',
      data.values.toList(),
    );
    _db.notifyUpdates({TableUpdate.onTable(table, kind: UpdateKind.update)});
    final after = await _read(table, id);
    _changes.add(
      RowChange(
        table: table.actualTableName,
        id: id,
        before: before,
        after: _raw(table, after),
      ),
    );
  }

  TableInfo<Table, Object?> _tableNamed(String name) =>
      _db.allTables.firstWhere((t) => t.actualTableName == name);

  Future<R> _read<T extends Table, R>(TableInfo<T, R> table, String id) async {
    final row = await _readOrNull(table, id);
    if (row == null) {
      throw NotFoundError('${table.actualTableName} $id');
    }
    return row;
  }

  Future<R?> _readOrNull<T extends Table, R>(
    TableInfo<T, R> table,
    String id,
  ) => (_db.select(
    table,
  )..where((_) => _idColumn(table).equals(id))).getSingleOrNull();

  GeneratedColumn<String> _idColumn(TableInfo<Table, Object?> table) =>
      table.columnsByName['id']! as GeneratedColumn<String>;

  Map<String, Object?> _raw<R>(TableInfo<Table, R> table, R row) {
    final columns = (row as Insertable<R>).toColumns(false);
    return {
      for (final e in columns.entries)
        e.key: _db.typeMapping.mapToSqlVariable(
          (e.value as Variable<Object>).value,
        ),
    };
  }

  static String _idOf(Map<String, Expression<Object>> columns) {
    final id = columns['id'];
    if (id is! Variable<String> || id.value == null) {
      throw ArgumentError('insert needs an id');
    }
    return id.value!;
  }
}

/// Writes rows together with their Event, in one transaction.
///
/// Repositories extend this; nothing else writes the database.
abstract base class EventSourcedRepository {
  EventSourcedRepository(this.ctx);

  final WriteContext ctx;

  AppDatabase get db => ctx.db;

  /// Runs [body] in a transaction and appends one Event describing every
  /// row it changed. Returns what [body] returns.
  Future<T> mutate<T>({
    required String entity,
    required String entityId,
    required EventOp op,
    required Future<T> Function(ChangeRecorder rec) body,
    Map<String, Object?>? data,
    String? undoOf,
  }) {
    return db.transaction(() async {
      final rec = ChangeRecorder._(ctx, ctx.clock.nowMs(), ctx.hlc.next());
      final result = await body(rec);
      await db
          .into(db.events)
          .insert(
            EventsCompanion.insert(
              id: rec.newId(),
              createdAt: rec.now,
              updatedAt: rec.now,
              hlc: rec.hlc,
              deviceId: ctx.deviceId,
              entity: entity,
              entityId: entityId,
              op: op,
              payload: EventPayload(
                changes: rec._changes,
                undoOf: undoOf,
                data: data,
              ).encode(),
            ),
          );
      return result;
    });
  }

  /// Events for one entity, newest first.
  Future<List<Event>> eventsFor(String entity, String entityId) =>
      (db.select(db.events)
            ..where(
              (e) => e.entity.equals(entity) & e.entityId.equals(entityId),
            )
            ..orderBy([(e) => OrderingTerm.desc(e.hlc)]))
          .get();

  /// The newest event for the entity that is not an undo and has not been
  /// undone, or null.
  Future<Event?> latestUndoable(String entity, String entityId) async {
    final events = await eventsFor(entity, entityId);
    final undone = <String>{};
    for (final e in events) {
      final payload = EventPayload.decode(e.payload);
      if (payload.undoOf != null) {
        undone
          ..add(payload.undoOf!)
          ..add(e.id);
      }
    }
    for (final e in events) {
      if (!undone.contains(e.id)) return e;
    }
    return null;
  }

  /// Reverses the latest not-yet-undone event of an entity, in a new
  /// transaction that logs its own Event. Repeated calls walk further back.
  Future<void> undoLatest(String entity, String entityId) async {
    final target = await latestUndoable(entity, entityId);
    if (target == null) {
      throw NothingToUndoError('$entity $entityId has nothing to undo');
    }
    if (target.op == EventOp.review) {
      throw const InvalidOperationError(
        'Reviews are append-only and cannot be undone',
      );
    }
    final payload = EventPayload.decode(target.payload);
    await mutate<void>(
      entity: entity,
      entityId: entityId,
      op: _inverseOp(target.op),
      undoOf: target.id,
      body: (rec) async {
        for (final change in payload.changes.reversed) {
          final before = change.before;
          if (before == null) {
            await rec.unCreate(change.table, change.id);
          } else {
            await rec.restore(change.table, change.id, before);
          }
        }
      },
    );
  }

  static EventOp _inverseOp(EventOp op) => switch (op) {
    EventOp.create => EventOp.delete,
    EventOp.delete => EventOp.update,
    EventOp.update => EventOp.update,
    EventOp.split => EventOp.merge,
    EventOp.merge => EventOp.split,
    EventOp.review => EventOp.review,
  };
}
