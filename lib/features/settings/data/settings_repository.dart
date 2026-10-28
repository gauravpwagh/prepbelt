import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/event_log.dart';

/// Key–value settings stored as JSON. Every write logs an Event whose
/// entity id is the key.
final class SettingsRepository extends EventSourcedRepository {
  SettingsRepository(super.ctx);

  static const entity = 'setting';

  /// Sets [key] to [value] (anything `jsonEncode` accepts).
  Future<void> set(String key, Object? value) async {
    final existing = await _row(key);
    final json = jsonEncode(value);
    await mutate<void>(
      entity: entity,
      entityId: key,
      op: existing == null ? EventOp.create : EventOp.update,
      body: (rec) async {
        if (existing == null) {
          await rec.insert(
            db.settings,
            SettingsCompanion(
              id: Value(rec.newId()),
              key: Value(key),
              value: Value(json),
            ),
          );
        } else {
          await rec.update(
            db.settings,
            existing.id,
            SettingsCompanion(value: Value(json), deletedAt: const Value(null)),
          );
        }
      },
    );
  }

  /// Removes [key], so its default applies again.
  Future<void> remove(String key) async {
    final existing = await _row(key);
    if (existing == null || existing.deletedAt != null) return;
    await mutate<void>(
      entity: entity,
      entityId: key,
      op: EventOp.delete,
      body: (rec) => rec.softDelete(db.settings, existing.id),
    );
  }

  Future<void> undo(String key) => undoLatest(entity, key);

  Future<Object?> get(String key) async {
    final row = await _row(key);
    return row == null || row.deletedAt != null ? null : jsonDecode(row.value);
  }

  /// All live settings, decoded.
  Future<Map<String, Object?>> getAll() async => _decode(await _live().get());

  Stream<Map<String, Object?>> watchAll() => _live().watch().map(_decode);

  SimpleSelectStatement<$SettingsTable, Setting> _live() =>
      db.select(db.settings)..where((s) => s.deletedAt.isNull());

  Future<Setting?> _row(String key) => (db.select(
    db.settings,
  )..where((s) => s.key.equals(key))).getSingleOrNull();

  static Map<String, Object?> _decode(List<Setting> rows) => {
    for (final r in rows) r.key: jsonDecode(r.value),
  };
}
