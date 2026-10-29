import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/router.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/core/ui/app_icons.dart';
import 'package:prepbelt/core/ui/buttons.dart';
import 'package:prepbelt/features/settings/data/settings_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/today/state/reminder_providers.dart';
import 'package:prepbelt/platform/notifications/reminder_scheduler.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../../support/test_db.dart';

void main() {
  testWidgets('Sources: the options button removes a source and its tasks '
      'after confirming; Undo brings them back', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1300)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final t = openTestContext(start: DateTime(2026, 10, 28, 9).toUtc());
    await tester.runAsync(() async {
      await SettingsRepository(t.ctx).set(SettingKeys.onboarded, true);
      final s = await SourceRepository(t.ctx).createWithChunks(
        type: SourceType.book,
        title: 'HC Verma',
        unitType: UnitType.page,
        totalUnits: 40,
        chapters: const [
          ChunkDraft(title: 'Ch 1', startUnit: 1, endUnit: 20),
          ChunkDraft(title: 'Ch 2', startUnit: 21, endUnit: 40),
        ],
      );
      await SurveyRepository(t.ctx).createTasks(s.id);
    });

    Future<void> settle() async {
      for (var i = 0; i < 4; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 60)),
        );
        await tester.pumpAndSettle();
      }
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(t.clock),
          appDatabaseProvider.overrideWithValue(t.db),
          writeContextProvider.overrideWithValue(t.ctx),
          shareInboxProvider.overrideWithValue(const NoShareInbox()),
          reminderSchedulerProvider.overrideWithValue(const NoReminders()),
          routerProvider.overrideWithValue(
            buildRouter(initialLocation: Routes.sources),
          ),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await settle();
    expect(find.text('HC Verma'), findsOneWidget);
    Future<int> tasks() => tester
        .runAsync(
          () async => [
            for (final t in await t.db.select(t.db.tasks).get())
              if (t.deletedAt == null) t,
          ].length,
        )
        .then((n) => n!);

    await tester.tap(
      find.byWidgetPredicate((w) => w is AppIconView && w.icon == AppIcon.more),
    );
    await settle();
    await tester.tap(find.text('Remove'));
    await settle();
    expect(find.text('Remove HC Verma?'), findsOneWidget);
    expect(find.textContaining('its 2 tasks'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextLinkButton, 'Remove'));
    await settle();
    expect(find.text('HC Verma'), findsNothing);
    expect(await tasks(), 0);

    await tester.tap(find.text('Undo'));
    await settle();
    expect(find.text('HC Verma'), findsOneWidget);
    expect(await tasks(), 2);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 60)),
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.runAsync(t.db.close);
  });
}
