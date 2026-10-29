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
  testWidgets('add a task, then read, leave, come back and save', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final t = openTestContext();
    final clock = t.clock;
    final opener = _Opener();
    final book = await tester.runAsync(
      () => SourceRepository(t.ctx).createWithChunks(
        type: SourceType.book,
        title: 'NCERT Physics',
        unitType: UnitType.page,
        totalUnits: 60,
        chapters: const [
          ChunkDraft(title: 'Ch 1 Units', startUnit: 1, endUnit: 20),
          ChunkDraft(title: 'Ch 2 Motion', startUnit: 21, endUnit: 40),
          ChunkDraft(title: 'Ch 3 Force', startUnit: 41, endUnit: 60),
        ],
      ),
    );

    Future<void> settle() async {
      for (var i = 0; i < 3; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pumpAndSettle();
      }
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(clock),
          appDatabaseProvider.overrideWithValue(t.db),
          writeContextProvider.overrideWithValue(t.ctx),
          sourceOpenerProvider.overrideWithValue(opener),
          shareInboxProvider.overrideWithValue(const NoShareInbox()),
          reminderSchedulerProvider.overrideWithValue(const NoReminders()),
          routerProvider.overrideWithValue(
            buildRouter(initialLocation: Routes.sourceChapters(book!.id)),
          ),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await settle();
    expect(find.text('NCERT Physics'), findsOneWidget);
    expect(find.text('Start reading'), findsOneWidget);
    expect(find.text('Create 3 tasks'), findsOneWidget);

    // Add task on Ch 3, already read.
    await tester.tap(find.text('Add task').last);
    await settle();
    await tester.tap(find.text('Yes'));
    await tester.pump();
    await tester.tap(find.text('Create'));
    await settle();
    expect(find.text('Task added'), findsOneWidget);
    expect(find.text('Create 2 tasks'), findsOneWidget);
    expect(find.text('Read from p. 1'), findsNothing, reason: 'p. 1 is next');
    expect(find.text('Start reading'), findsOneWidget);

    // Read, leave the app for 45 minutes, come back.
    await tester.tap(find.text('Start reading'));
    await settle();
    expect(opener.opened, 1);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    clock.advance(const Duration(minutes: 45));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settle();
    expect(find.text('How far did you get?'), findsOneWidget);
    expect(find.text('You were away 45 min'), findsOneWidget);

    // 45 min at the default 3 min a page: the guess is p. 15.
    expect(find.text('p. 15'), findsOneWidget);
    await tester.tap(find.text('End of Ch 1 Units · p. 20'));
    await tester.pump();
    for (var i = 0; i < 20; i++) {
      await tester.tap(find.bySemanticsLabel('More').last);
      await tester.pump();
    }
    expect(find.text('p. 40'), findsOneWidget);
    expect(
      find.textContaining('Creates task Ch 1 Units – Ch 2 Motion'),
      findsOneWidget,
    );
    await tester.tap(find.text('Save'));
    await settle();
    expect(find.text('How far did you get?'), findsNothing);
    expect(find.text('Reading saved · 1 task created'), findsOneWidget);
    expect(find.text('Every chapter has a task.'), findsOneWidget);

    final reviews = await tester.runAsync(
      () => t.db.select(t.db.reviews).get(),
    );
    expect(reviews!.map((r) => r.durationSec).toList()..sort(), [0, 45 * 60]);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(t.db.close);
  });
}
