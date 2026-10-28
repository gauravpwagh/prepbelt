import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/survey/ui/survey_screen.dart';

import '../../support/pump.dart';
import '../../support/test_db.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  /// Lets drift streams deliver under the widget tester's fake time.
  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('survey flow writes answers through providers', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 900)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final t = openTestContext();
    await tester.runAsync(() => db.close());
    db = t.db;
    final ids = await tester.runAsync(() async {
      final exam = await ExamRepository(
        t.ctx,
      ).create(name: 'JEE Main', date: '2027-01-10');
      final source = await SourceRepository(t.ctx).createWithChunks(
        type: SourceType.book,
        title: 'HC Verma Vol 1',
        unitType: UnitType.page,
        totalUnits: 60,
        chapters: chaptersBySize(60, 20, label: (s, e) => 'Pages $s–$e'),
      );
      return (exam: exam.id, source: source.id);
    });

    var done = false;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(t.db),
          writeContextProvider.overrideWithValue(t.ctx),
        ],
        child: themed(
          SurveyScreen(sourceId: ids!.source, onDone: () => done = true),
        ),
      ),
    );
    await settle(tester);

    expect(find.text('Chapter 1 of 3'), findsOneWidget);
    expect(find.text('Pages 1–20'), findsOneWidget);
    expect(find.text('Mark the other 2 as Medium'), findsOneWidget);

    await tester.tap(find.text('Hard'));
    await tester.tap(find.text('High'));
    await tester.pump();
    expect(find.text('≈ 1 h 20 min'), findsOneWidget, reason: '20 × 3 × 1.33');
    expect(find.text('Black belt'), findsOneWidget);

    await tester.tap(find.text('Next chapter'));
    await settle(tester);
    expect(find.text('Chapter 2 of 3'), findsOneWidget);
    expect(find.text('Pages 21–40'), findsOneWidget);

    await tester.tap(find.text('Mark the other 1 as Medium'));
    await settle(tester);
    expect(done, isTrue);

    final items = await tester.runAsync(
      () => SurveyRepository(t.ctx).items(ids.source, examId: ids.exam),
    );
    expect(items!.every((i) => i.surveyed), isTrue);
    expect(items.first.survey!.difficulty, 3);
    expect(items.first.importance, Importance.high);
    expect(items[1].survey!.difficulty, 3, reason: 'carried from chapter 1');
    expect(items[2].importance, Importance.medium);

    // Unmount so drift's stream timers finish before the test ends.
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
    await tester.pump(const Duration(seconds: 1));
  });
}
