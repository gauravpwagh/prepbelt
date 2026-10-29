import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/router.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/today/state/reminder_providers.dart';
import 'package:prepbelt/platform/notifications/reminder_scheduler.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../../support/test_db.dart';

void main() {
  testWidgets('add an exam: tasks link to it, Today shows the plan, and '
      'the Exams tab shows the exam', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1300)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final t = openTestContext(start: DateTime(2026, 10, 28, 9).toUtc());
    await tester.runAsync(() async {
      final s = await SourceRepository(t.ctx).createWithChunks(
        type: SourceType.book,
        title: 'HC Verma Vol 1',
        unitType: UnitType.page,
        totalUnits: 60,
        chapters: const [
          ChunkDraft(title: 'Units', startUnit: 1, endUnit: 20),
          ChunkDraft(title: 'Motion', startUnit: 21, endUnit: 40),
          ChunkDraft(title: 'Forces', startUnit: 41, endUnit: 60),
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
            buildRouter(initialLocation: Routes.exams),
          ),
        ],
        child: const PrepBeltApp(),
      ),
    );
    await settle();
    expect(find.text('No exam yet'), findsOneWidget);

    await tester.tap(find.text('Add exam'));
    await settle();
    expect(
      find.textContaining('Your 3 tasks will count toward this exam'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'JEE Main');
    await tester.tap(find.text('Choose a date'));
    await tester.pumpAndSettle();
    // The picker opens 60 days after tomorrow (28 Dec); accept it.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('61 days from today'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('More time'));
    await tester.pump();
    expect(find.text('1 h 45 min'), findsOneWidget);

    await tester.tap(find.text('Add exam').last);
    await settle();

    // Today: the exam card and the plan's first reads.
    expect(find.text("Today's training"), findsOneWidget);
    expect(find.text('61 days to go'), findsOneWidget);
    expect(find.textContaining('FIRST READ'), findsWidgets);
    expect(find.text('Units'), findsOneWidget);

    final links = await tester.runAsync(
      () => t.db.select(t.db.examTasks).get(),
    );
    expect(links, hasLength(3));
    final week = await tester.runAsync(
      () => t.db.select(t.db.availabilities).get(),
    );
    expect(week!.map((a) => a.minutes).toSet(), {105});

    // The Exams tab now shows the exam.
    await tester.tap(find.bySemanticsLabel('Exams'));
    await settle();
    expect(find.text('JEE Main'), findsOneWidget);
    expect(find.text('Exam belt today'), findsOneWidget);
    expect(find.text('0 / 3'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 60)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(t.db.close);
  });
}
