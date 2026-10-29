import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/bootstrap.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/features/settings/data/settings_repository.dart';
import 'package:prepbelt/features/settings/ui/settings_screen.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/tasks/data/task_repository.dart';
import 'package:prepbelt/features/tasks/state/task_providers.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../support/pump.dart';
import '../support/test_db.dart';

void main() {
  late AppDatabase db;
  final clock = FakeClock(DateTime.utc(2026, 10, 28, 9));

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  Future<void> launch(WidgetTester tester) async {
    final ctx = await tester.runAsync(() => createWriteContext(db, clock));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(clock),
          appDatabaseProvider.overrideWithValue(db),
          writeContextProvider.overrideWithValue(ctx!),
          shareInboxProvider.overrideWithValue(const NoShareInbox()),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('launches to the placeholder Today screen', (tester) async {
    await launch(tester);
    expect(find.text("Today's training"), findsOneWidget);
    expect(find.text('Wednesday, 28 Oct'), findsOneWidget);
    for (final tab in ['Today', 'Exams', 'Sources', 'Progress']) {
      expect(find.bySemanticsLabel(tab), findsOneWidget);
    }
  });

  testWidgets('bottom navigation switches tabs', (tester) async {
    await launch(tester);
    await tester.tap(find.bySemanticsLabel('Sources'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
    expect(find.text('No sources yet'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Quick add'));
    await tester.pumpAndSettle();
    expect(find.text('Add source'), findsOneWidget);
    // Drift streams close with a zero timer; flush it before teardown.
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('nav bar meets touch-target and label guidelines', (
    tester,
  ) async {
    await launch(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });

  test('bootstrap creates the device id once and logs it', () async {
    final first = await createWriteContext(db, clock);
    final second = await createWriteContext(db, clock);
    expect(second.deviceId, first.deviceId);
    expect(
      await SettingsRepository(first).get(SettingKeys.deviceId),
      first.deviceId,
    );
    expect(await db.select(db.events).get(), hasLength(1));
  });

  test('debug rebuild action runs the rebuild command', () async {
    final ctx = await createWriteContext(db, clock);
    await TaskRepository(ctx).create(title: 'Optics');
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(clock),
        appDatabaseProvider.overrideWithValue(db),
        writeContextProvider.overrideWithValue(ctx),
      ],
    );
    addTearDown(container.dispose);
    expect(await container.read(masteryRebuildProvider.notifier).run(), 1);
  });

  testWidgets('settings shows the debug rebuild action', (tester) async {
    final ctx = await tester.runAsync(() => createWriteContext(db, clock));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [writeContextProvider.overrideWithValue(ctx!)],
        child: themed(const SettingsScreen(showDebugActions: true)),
      ),
    );
    expect(find.text('Rebuild mastery from reviews'), findsOneWidget);
  });
}
