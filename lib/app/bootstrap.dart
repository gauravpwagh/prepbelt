import 'dart:convert';

import '../core/config/defaults.dart';
import '../core/db/app_database.dart';
import '../core/db/event_log.dart';
import '../core/ids/ids.dart';
import '../core/time/clock.dart';
import '../features/settings/data/settings_repository.dart';

/// Opens what every repository needs: reads this install's device id, or
/// creates and stores one on first launch.
Future<WriteContext> createWriteContext(AppDatabase db, Clock clock) async {
  final ids = IdGenerator(clock);
  final row = await (db.select(
    db.settings,
  )..where((s) => s.key.equals(SettingKeys.deviceId))).getSingleOrNull();
  if (row != null) {
    return WriteContext(
      db: db,
      clock: clock,
      ids: ids,
      deviceId: jsonDecode(row.value) as String,
    );
  }
  final ctx = WriteContext(
    db: db,
    clock: clock,
    ids: ids,
    deviceId: ids.next(),
  );
  await SettingsRepository(ctx).set(SettingKeys.deviceId, ctx.deviceId);
  return ctx;
}
