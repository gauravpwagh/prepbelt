import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/app_database.dart';
import '../db/event_log.dart';
import '../time/clock.dart';

part 'core_providers.g.dart';

/// The app's clock. Tests override it with a [FakeClock].
@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const SystemClock();

/// The open database. Overridden at bootstrap once the file is open.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) =>
    throw UnimplementedError('appDatabase is provided at bootstrap');

/// Database, clock, ids and device id for repositories. Overridden at
/// bootstrap once the device id is known.
@Riverpod(keepAlive: true)
WriteContext writeContext(Ref ref) =>
    throw UnimplementedError('writeContext is provided at bootstrap');
