import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'core/db/app_database.dart';
import 'core/providers/core_providers.dart';
import 'core/time/clock.dart';
import 'platform/files/backup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const clock = SystemClock();
  // A restore staged in Settings replaces the database before it opens.
  Backup.applyPendingRestore(await getApplicationDocumentsDirectory());
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
