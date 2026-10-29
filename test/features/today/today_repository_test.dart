import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/session/data/session_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/reading_repository.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';
import 'package:prepbelt/features/today/data/today_repository.dart';

import '../../support/test_db.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late ReviewRepository reviews;
  late TodayRepository today;
  late SourceRepository sources;
  late SurveyRepository survey;
  late ExamRepository exams;

  setUp(() {
    final t = openTestContext();
    db = t.db;
    clock = t.clock;
    reviews = ReviewRepository(t.ctx, config: () async => const ReviewConfig());
    today = TodayRepository(
      db,
      sessions: SessionRepository(t.ctx, reviews: reviews),
      reading: ReadingRepository(t.ctx, reviews: reviews),
    );
    sources = SourceRepository(t.ctx);
    survey = SurveyRepository(t.ctx);
    exams = ExamRepository(t.ctx);
  });
  tearDown(() => db.close());

  Future<List<TodayItem>> items() {
    final now = clock.now();
    final start = DateTime.utc(now.year, now.month, now.day);
    return today.items(
      dayStart: start.millisecondsSinceEpoch,
      dayEnd: start.add(const Duration(days: 1)).millisecondsSinceEpoch,
    );
  }

  /// Six 10-page chapters, one task each; returns task ids in chapter order.
  Future<List<String>> tasks({String? examId}) async {
    final s = await sources.createWithChunks(
      type: SourceType.book,
      title: 'Book',
      unitType: UnitType.page,
      totalUnits: 60,
      chapters: [
        for (var i = 0; i < 6; i++)
          ChunkDraft(
            title: 'Ch ${i + 1}',
            startUnit: i * 10 + 1,
            endUnit: i * 10 + 10,
          ),
      ],
    );
    final chunks = await db.select(db.chunks).get();
    chunks.sort((a, b) => a.startUnit!.compareTo(b.startUnit!));
    // Ch 6 matters most for the exam; the rest stay Medium.
    if (examId != null) {
      await survey.answer(
        chunks.last.id,
        difficulty: 2,
        familiarity: 0,
        examId: examId,
        importance: Importance.high,
      );
    }
    await survey.createTasks(s.id, examId: examId);
    final links = await db.select(db.taskChunks).get();
    return [
      for (final c in chunks) links.firstWhere((l) => l.chunkId == c.id).taskId,
    ];
  }

  test('overdue first, then due today, then two first reads by importance; '
      'paused and not-yet-due tasks stay off', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    final ids = await tasks(examId: exam.id);

    // Ch 1 read 10 days ago, Ch 2 read 2 days ago (first review due
    // later), Ch 3 read yesterday and paused.
    clock.advance(const Duration(days: -10));
    await reviews.record(
      taskId: ids[0],
      rating: Rating.good,
      kind: ReviewKind.firstRead,
    );
    clock.advance(const Duration(days: 8));
    await reviews.record(
      taskId: ids[1],
      rating: Rating.good,
      kind: ReviewKind.firstRead,
    );
    clock.advance(const Duration(days: 1));
    await reviews.record(
      taskId: ids[2],
      rating: Rating.good,
      kind: ReviewKind.firstRead,
    );
    await reviews.pause(ids[2]);
    clock.advance(const Duration(days: 1));

    final list = await items();
    final state0 = await (db.select(
      db.taskStates,
    )..where((s) => s.taskId.equals(ids[0]))).getSingle();
    expect(state0.dueAt! < clock.nowMs(), isTrue, reason: 'Ch 1 is overdue');

    // Ch 2's first review is days away (the gaps fit 74 days before the
    // exam), so it is not on today's list.
    expect(list.map((i) => (i.kind, i.info!.task.id)).toList(), [
      (TodayKind.overdue, ids[0]),
      (TodayKind.firstRead, ids[5]),
      (TodayKind.firstRead, ids[3]),
    ]);
    expect(list.first.overdueDays, greaterThan(0));
    // 10 pages at 3 min a page = 30 min first read; first review 35%.
    expect(list.first.minutes, 11);
    expect(list.last.minutes, 30);
  });

  test('three boxes (D50): every review due, overdue first; not started; '
      'next reviews ahead, soonest first; paused tasks in none', () async {
    final ids = await tasks();
    clock.advance(const Duration(days: -10));
    await reviews.record(
      taskId: ids[0],
      rating: Rating.good,
      kind: ReviewKind.firstRead,
    );
    clock.advance(const Duration(days: 10));
    // Read today: their first reviews are on later days.
    await reviews.record(
      taskId: ids[1],
      rating: Rating.good,
      kind: ReviewKind.firstRead,
    );
    await reviews.record(
      taskId: ids[2],
      rating: Rating.good,
      kind: ReviewKind.firstRead,
    );
    await reviews.pause(ids[3]);

    final now = clock.now();
    final start = DateTime.utc(now.year, now.month, now.day);
    final b = await today.boxes(
      dayStart: start.millisecondsSinceEpoch,
      dayEnd: start.add(const Duration(days: 1)).millisecondsSinceEpoch,
      today: start.toIso8601String().substring(0, 10),
    );
    expect(b.due.map((i) => (i.kind, i.info!.task.id)), [
      (TodayKind.overdue, ids[0]),
    ]);
    expect(b.fresh.map((i) => i.info!.task.id), [ids[4], ids[5]]);
    expect(b.ahead.map((i) => i.info!.task.id).toSet(), {ids[1], ids[2]});
    expect(b.ahead.first.dueAt! <= b.ahead.last.dueAt!, isTrue);
    expect(b.hasPlan, isFalse);
  });

  test('nothing due and no tasks gives an empty day', () async {
    expect(await items(), isEmpty);
  });
}
