import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/router.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/sources/state/reading_providers.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/today/state/reminder_providers.dart';
import 'package:prepbelt/platform/notifications/reminder_scheduler.dart';
import 'package:prepbelt/platform/open_external/source_opener.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../../support/test_db.dart';

class _Opener implements SourceOpener {
  int opened = 0;

  @override
  Future<bool> open({File? file, String? uri}) async {
    opened++;
    return true;
  }
}

void main() {
  testWidgets('Today → Start → leave → back → rate Good → Done', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1200)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final t = openTestContext();
    final opener = _Opener();
    await tester.runAsync(() async {
      final s = await SourceRepository(t.ctx).createWithChunks(
        type: SourceType.link,
        title: 'Rotational motion lecture',
        unitType: UnitType.item,
        uri: 'https://youtu.be/x9',
        chapters: const [ChunkDraft(title: 'Rotational motion')],
      );
      await SurveyRepository(t.ctx).createTasks(s.id);
    });

    Future<void> settle() async {
      for (var i = 0; i < 4; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
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
          sourceOpenerProvider.overrideWithValue(opener),
          shareInboxProvider.overrideWithValue(const NoShareInbox()),
          reminderSchedulerProvider.overrideWithValue(const NoReminders()),
          routerProvider.overrideWithValue(buildRouter()),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await settle();
    expect(find.text("Today's training"), findsOneWidget);
    expect(find.text('Rotational motion'), findsOneWidget);
    expect(find.textContaining('FIRST READ'), findsOneWidget);

    await tester.tap(
      find.bySemanticsLabel('Start Rotational motion first read'),
    );
    await settle();
    expect(opener.opened, 1);

    // Away for 40 minutes, then back.
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden)
      ..handleAppLifecycleStateChanged(AppLifecycleState.paused);
    t.clock.advance(const Duration(minutes: 40));
    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.hidden)
      ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('First read'), findsOneWidget);
    expect(find.text('Pick a rating to finish'), findsOneWidget);

    await tester.tap(find.text('Good'));
    await settle();
    expect(find.text('White belt earned'), findsOneWidget);

    await tester.tap(find.text('Done · back to Today'));
    await settle();
    expect(find.text("Today's training"), findsOneWidget);
    expect(find.text('All done for today'), findsOneWidget);
    expect(find.text('1'), findsOneWidget, reason: 'a 1 day streak');

    final reviews = await tester.runAsync(
      () => t.db.select(t.db.reviews).get(),
    );
    expect(
      (
        reviews!.single.kind,
        reviews.single.durationSec,
        reviews.single.levelAfter,
      ),
      (ReviewKind.firstRead, 40 * 60, 1),
    );

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(t.db.close);
  });
}
