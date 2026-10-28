import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/bootstrap.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/features/settings/data/settings_repository.dart';

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
    await tester.pumpAndSettle();
    expect(find.text('Sources arrives in a later milestone.'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Quick add'));
    await tester.pumpAndSettle();
    expect(find.text('Add source'), findsOneWidget);
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
}
