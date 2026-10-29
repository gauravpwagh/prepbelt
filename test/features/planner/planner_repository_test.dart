import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/planner/data/planner_repository.dart';
import 'package:prepbelt/features/session/data/session_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/reading_repository.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';

import '../../support/test_db.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late PlannerRepository planner;
  late SessionRepository sessions;
  late ExamRepository exams;
  late SourceRepository sources;
  late SurveyRepository survey;

  setUp(() {
    final t = openTestContext(start: DateTime(2026, 10, 28, 9).toUtc());
    db = t.db;
    clock = t.clock;
    final reviews = ReviewRepository(
      t.ctx,
      config: () async => const ReviewConfig(),
    );
    sessions = SessionRepository(t.ctx, reviews: reviews);
    planner = PlannerRepository(
      t.ctx,
      sessions: sessions,
      reviews: reviews,
      reading: ReadingRepository(t.ctx, reviews: reviews),
    );
    exams = ExamRepository(t.ctx);
    sources = SourceRepository(t.ctx);
    survey = SurveyRepository(t.ctx);
  });
  tearDown(() => db.close());

  Future<List<PlanItem>> items() =>
      (db.select(db.planItems)..orderBy([
            (p) => OrderingTerm.asc(p.date),
            (p) => OrderingTerm.asc(p.order),
          ]))
          .get();

  Future<void> book(String examId) async {
    final s = await sources.createWithChunks(
      type: SourceType.book,
      title: 'HC Verma Vol 1',
      unitType: UnitType.page,
      totalUnits: 100,
      chapters: const [
        ChunkDraft(title: 'Ch 1', startUnit: 1, endUnit: 20),
        ChunkDraft(title: 'Ch 2', startUnit: 21, endUnit: 40),
        // Ch 3 has no task yet: the planner explores it (D27).
        ChunkDraft(title: 'Ch 3', startUnit: 41, endUnit: 100),
      ],
    );
    final chunks = await (db.select(db.chunks)).get();
    chunks.sort((a, b) => a.startUnit!.compareTo(b.startUnit!));
    final reading = ReadingRepository(sessions.ctx, reviews: sessions.reviews);
    await reading.addTask(
      s.id,
      chunkIds: [chunks[0].id],
      title: 'Units',
      examId: examId,
    );
    await reading.addTask(
      s.id,
      chunkIds: [chunks[1].id],
      title: 'Motion',
      examId: examId,
    );
  }

  test('no exam, no plan', () async {
    expect(await planner.replan(), isNull);
    expect(await items(), isEmpty);
  });

  test('a replan writes the plan from today to the day before the exam, '
      'with first reads, reviews and the explore item', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    await book(exam.id);
    final result = await planner.replan();
    expect(result!.fits, isTrue);

    final all = await items();
    expect(all.first.date, '2026-10-28');
    expect(all.last.date.compareTo('2027-01-10'), lessThan(0));
    expect(all.map((p) => p.kind).toSet(), {
      PlanItemKind.firstRead,
      PlanItemKind.review,
      PlanItemKind.finalReview,
      PlanItemKind.explore,
    });
    final day0 = all.where((p) => p.date == '2026-10-28').toList();
    expect(day0.map((p) => p.order), [for (var i = 0; i < day0.length; i++) i]);
    expect(
      day0.fold(0, (s, p) => s + p.estMinutes),
      lessThanOrEqualTo(90 + 10),
      reason: 'default 90 minutes a day',
    );
    expect(all.map((p) => p.generation).toSet(), hasLength(1));
  });

  test('finishing a planned session marks it done; the next replan keeps '
      'it and plans the rest of the day around it', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    await book(exam.id);
    await planner.replan();
    final first = (await items()).first;
    expect(first.kind, PlanItemKind.firstRead);

    await sessions.start(first.taskId!);
    clock.advance(const Duration(minutes: 30));
    await sessions.finish(rating: Rating.good, minutes: 30);
    await planner.replan();

    final today = (await items()).where((p) => p.date == '2026-10-28');
    expect(
      today.where((p) => p.status == PlanItemStatus.done).map((p) => p.id),
      [first.id],
    );
    final planned = today.where((p) => p.status == PlanItemStatus.planned);
    expect(
      planned.fold(0, (s, p) => s + p.estMinutes),
      lessThanOrEqualTo(60 + 10),
      reason: '90 minutes less the 30 studied',
    );
  });

  test('a missed day: yesterday\'s sessions become moved and are replanned '
      'from today', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    await book(exam.id);
    await planner.replan();
    final yesterday = (await items())
        .where((p) => p.date == '2026-10-28')
        .toList();

    clock.advance(const Duration(days: 1));
    await planner.replan();
    final all = await items();
    for (final p in yesterday) {
      expect(all.firstWhere((q) => q.id == p.id).status, PlanItemStatus.moved);
    }
    expect(
      all.where(
        (p) => p.date == '2026-10-29' && p.status == PlanItemStatus.planned,
      ),
      isNotEmpty,
    );
  });

  test('the survey and an exam link set importance; Create tasks with '
      'an exam plans every chapter', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    final s = await sources.createWithChunks(
      type: SourceType.book,
      title: 'Book',
      unitType: UnitType.page,
      totalUnits: 40,
      chapters: const [
        ChunkDraft(title: 'A', startUnit: 1, endUnit: 20),
        ChunkDraft(title: 'B', startUnit: 21, endUnit: 40),
      ],
    );
    await survey.createTasks(s.id, examId: exam.id);
    final input = await planner.input();
    expect(input!.tasks, hasLength(2));
    expect(input.explores, isEmpty, reason: 'every chapter has a task');
  });
}
