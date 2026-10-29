@Tags(['perf'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/engines/planner/planner.dart';
import 'package:prepbelt/engines/planner/triage.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/planner/data/planner_repository.dart';
import 'package:prepbelt/features/session/data/session_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/reading_repository.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';
import 'package:prepbelt/features/today/data/today_repository.dart';

import '../support/test_db.dart';

/// "Today opens in under 1 second with 500 tasks" and "a planner run under
/// 200 ms for 500 tasks" (docs/03, docs/04). A desktop is faster than a
/// mid-range phone, so these budgets are a third of the targets.
void main() {
  test(
    '500 tasks: plan input, triage and Today stay fast',
    () async {
      final t = openTestContext(start: DateTime(2026, 10, 28, 9).toUtc());
      addTearDown(t.db.close);
      final reviews = ReviewRepository(
        t.ctx,
        config: () async => const ReviewConfig(),
      );
      final sessions = SessionRepository(t.ctx, reviews: reviews);
      final reading = ReadingRepository(t.ctx, reviews: reviews);
      final planner = PlannerRepository(
        t.ctx,
        sessions: sessions,
        reviews: reviews,
        reading: reading,
      );
      final exam = await ExamRepository(
        t.ctx,
      ).create(name: 'JEE Main', date: '2027-01-10');
      // 20 books of 25 chapters.
      for (var b = 0; b < 20; b++) {
        final s = await SourceRepository(t.ctx).createWithChunks(
          type: SourceType.book,
          title: 'Book $b',
          unitType: UnitType.page,
          totalUnits: 500,
          chapters: [
            for (var c = 0; c < 25; c++)
              ChunkDraft(
                title: 'Ch ${c + 1}',
                startUnit: c * 20 + 1,
                endUnit: c * 20 + 20,
              ),
          ],
        );
        await SurveyRepository(t.ctx).createTasks(s.id, examId: exam.id);
      }
      // Half of them read and reviewed a little.
      final tasks = await t.db.select(t.db.tasks).get();
      expect(tasks, hasLength(500));
      for (final task in tasks.take(250)) {
        await reviews.record(
          taskId: task.id,
          rating: Rating.good,
          kind: ReviewKind.firstRead,
        );
      }

      final watch = Stopwatch()..start();
      final input = await planner.input();
      final inputMs = watch.elapsedMilliseconds;

      final engine = await reviews.loadEngine();
      // Warm up the JIT once: release builds are compiled ahead of time.
      plan(input!, engine);
      watch.reset();
      final single = plan(input, engine);
      final planMs = watch.elapsedMilliseconds;
      watch.reset();
      final result = triage(input, engine);
      final triageMs = watch.elapsedMilliseconds;

      await planner.replan();
      final today = TodayRepository(t.db, sessions: sessions, reading: reading);
      final items = await (t.db.select(
        t.db.planItems,
      )..where((p) => p.date.equals('2026-10-28'))).get();
      watch.reset();
      final cards = await today.fromPlan(
        items,
        dayStart: DateTime(2026, 10, 28).toUtc().millisecondsSinceEpoch,
      );
      final todayMs = watch.elapsedMilliseconds;
      // Today's three boxes (D50) read every task and source.
      watch.reset();
      final boxes = await today.boxes(
        dayStart: DateTime(2026, 10, 28).toUtc().millisecondsSinceEpoch,
        dayEnd: DateTime(2026, 10, 29).toUtc().millisecondsSinceEpoch,
        today: '2026-10-28',
      );
      final boxesMs = watch.elapsedMilliseconds;

      // ignore: avoid_print
      print(
        'input ${inputMs}ms, one plan ${planMs}ms '
        '(${single.entries.length} entries), triage ${triageMs}ms in the '
        'background (${result.cuts.length} cuts), Today ${todayMs}ms '
        '(${cards.length} cards), boxes ${boxesMs}ms '
        '(${boxes.due.length + boxes.fresh.length + boxes.ahead.length} rows)',
      );
      expect(planMs, lessThan(200 ~/ 3), reason: 'planner budget');
      expect(inputMs + todayMs, lessThan(1000 ~/ 3), reason: 'Today budget');
      expect(boxesMs, lessThan(1000 ~/ 3), reason: 'Today boxes budget');
      expect(result.plan.entries, isNotEmpty);
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
