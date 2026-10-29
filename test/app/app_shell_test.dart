import 'package:flutter/material.dart';
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
import 'package:prepbelt/features/today/state/reminder_providers.dart';
import 'package:prepbelt/platform/notifications/reminder_scheduler.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../support/pump.dart';
import '../support/test_db.dart';

void main() {
  late AppDatabase db;
  final clock = FakeClock(DateTime.utc(2026, 10, 28, 9));

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  /// Lets Drift streams deliver (they run on real async), then settles.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pumpAndSettle();
    }
  }

  /// Drift streams close with a zero timer; flush it before teardown.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(seconds: 1));
  }

  Future<void> launch(WidgetTester tester, {bool onboarded = true}) async {
    final ctx = await tester.runAsync(() async {
      final ctx = await createWriteContext(db, clock);
      if (onboarded) {
        await SettingsRepository(ctx).set(SettingKeys.onboarded, true);
      }
      return ctx;
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(clock),
          appDatabaseProvider.overrideWithValue(db),
          writeContextProvider.overrideWithValue(ctx!),
          shareInboxProvider.overrideWithValue(const NoShareInbox()),
          reminderSchedulerProvider.overrideWithValue(const NoReminders()),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await settle(tester);
  }

  testWidgets('a fresh install opens first launch: name and minutes, the '
      'reminder, then skip the exam to land on Today', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await launch(tester, onboarded: false);
    expect(find.text('Exam prep, belt by belt.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Asha');
    await tester.tap(find.bySemanticsLabel('More time'));
    await tester.pump();
    expect(find.text('1 h 45 min'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('A nudge each evening?'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await settle(tester);
    expect(find.text('What are you preparing for?'), findsOneWidget);
    await tester.tap(find.text('Skip for now'));
    await settle(tester);
    expect(find.text("Today's training"), findsOneWidget);

    final settings = await tester.runAsync(
      () async =>
          SettingsRepository(await createWriteContext(db, clock)).getAll(),
    );
    expect(
      (
        settings![SettingKeys.studentName],
        settings[SettingKeys.onboarded],
        settings[SettingKeys.reminderEnabled],
      ),
      ('Asha', true, false),
    );
    final week = await tester.runAsync(
      () => db.select(db.availabilities).get(),
    );
    expect(week!.map((a) => a.minutes).toSet(), {105});
    await unmount(tester);
  });

  testWidgets('launches to Today, which points to adding a source', (
    tester,
  ) async {
    await launch(tester);
    expect(find.text("Today's training"), findsOneWidget);
    expect(find.text('Wednesday, 28 Oct'), findsOneWidget);
    expect(find.text('Nothing to train yet'), findsOneWidget);
    for (final tab in ['Today', 'Exams', 'Sources', 'Progress']) {
      expect(find.bySemanticsLabel(tab), findsOneWidget);
    }
    await unmount(tester);
  });

  testWidgets('bottom navigation switches tabs', (tester) async {
    await launch(tester);
    await tester.tap(find.bySemanticsLabel('Sources'));
    await settle(tester);
    expect(find.text('No sources yet'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Quick add'));
    await tester.pumpAndSettle();
    expect(find.text('Add source'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('nav bar meets touch-target and label guidelines', (
    tester,
  ) async {
    await launch(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await unmount(tester);
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
