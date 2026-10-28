import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'core/db/app_database.dart';
import 'core/providers/core_providers.dart';
import 'core/time/clock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const clock = SystemClock();
  final db = AppDatabase.open();
  final ctx = await createWriteContext(db, clock);
  runApp(
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(clock),
        appDatabaseProvider.overrideWithValue(db),
        writeContextProvider.overrideWithValue(ctx),
      ],
      child: const PrepBeltApp(),
    ),
  );
}
