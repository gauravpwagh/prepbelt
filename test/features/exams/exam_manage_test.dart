import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/app/app.dart';
import 'package:prepbelt/app/router.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/core/ui/buttons.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
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
  test('edit, mark as done and remove are each undoable; tasks stay', () async {
    final t = openTestContext();
    addTearDown(t.db.close);
    final exams = ExamRepository(t.ctx);
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    final s = await SourceRepository(t.ctx).createWithChunks(
      type: SourceType.book,
      title: 'Book',
      unitType: UnitType.page,
      totalUnits: 20,
      chapters: const [ChunkDraft(title: 'Ch 1', startUnit: 1, endUnit: 20)],
    );
    await SurveyRepository(t.ctx).createTasks(s.id, examId: exam.id);

    Future<Exam> row() => (t.db.select(
      t.db.exams,
    )..where((e) => e.id.equals(exam.id))).getSingle();

    await exams.edit(exam.id, name: 'JEE Main 2027', date: '2027-01-24');
    expect(
      ((await row()).name, (await row()).date),
      ('JEE Main 2027', '2027-01-24'),
    );
    await exams.undo(exam.id);
    expect((await row()).name, 'JEE Main');

    await exams.markDone(exam.id);
    expect((await row()).status, ExamStatus.done);
    expect(await exams.watchCurrent().first, isNull, reason: 'none upcoming');
    // A new exam can be added once the old one is done.
    final next = await exams.create(name: 'JEE Advanced', date: '2027-05-20');
    expect((await exams.watchCurrent().first)?.id, next.id);
    await exams.softDelete(next.id);
    await exams.undo(exam.id);
    expect((await row()).status, ExamStatus.upcoming);

    await exams.softDelete(exam.id);
    expect((await row()).deletedAt, isNotNull);
    expect(await t.db.select(t.db.tasks).get(), hasLength(1));
    expect(await t.db.select(t.db.examTasks).get(), hasLength(1));
    await exams.undo(exam.id);
    expect((await row()).deletedAt, isNull);
  });

  testWidgets('Exam screen menu: edit the name, mark as done with Undo, '
      'remove after confirming', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 1300)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final t = openTestContext(start: DateTime(2026, 10, 28, 9).toUtc());
    await tester.runAsync(() async {
      await SettingsRepository(t.ctx).set(SettingKeys.onboarded, true);
      await ExamRepository(t.ctx).create(name: 'JEE Main', date: '2027-01-10');
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
    expect(find.text('JEE Main'), findsOneWidget);
    final menu = find.byWidgetPredicate(
      (w) => w is RoundIconButton && w.semanticLabel == 'Exam options',
    );

    // Edit.
    await tester.tap(menu);
    await settle();
    await tester.tap(find.text('Edit exam'));
    await settle();
    expect(find.text('Sun 10 Jan 2027'), findsOneWidget);
    expect(find.text('Time each day'), findsNothing);
    await tester.enterText(find.byType(TextField), 'JEE Main 2027');
    await tester.tap(find.text('Save'));
    await settle();
    expect(find.text('JEE Main 2027'), findsOneWidget);

    // Mark as done, then Undo.
    await tester.tap(menu);
    await settle();
    await tester.tap(find.text('Mark as done'));
    await settle();
    expect(find.text('No exam yet'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await settle();
    expect(find.text('JEE Main 2027'), findsOneWidget);

    // Remove, after confirming.
    await tester.tap(menu);
    await settle();
    await tester.tap(find.text('Remove exam'));
    await settle();
    expect(find.text('Remove JEE Main 2027?'), findsOneWidget);
    await tester.tap(find.text('Remove'));
    await settle();
    expect(find.text('No exam yet'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 60)),
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.runAsync(t.db.close);
  });
}
