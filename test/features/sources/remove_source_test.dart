import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/db/event_log.dart';
import 'package:prepbelt/core/result/result.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/reading_repository.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';

import '../../support/test_db.dart';

void main() {
  late ({AppDatabase db, FakeClock clock, WriteContext ctx}) t;
  late SourceRepository sources;
  late ReadingRepository reading;

  setUp(() {
    t = openTestContext();
    sources = SourceRepository(t.ctx);
    reading = ReadingRepository(
      t.ctx,
      reviews: ReviewRepository(
        t.ctx,
        config: () async => const ReviewConfig(),
      ),
    );
  });
  tearDown(() => t.db.close());

  Future<Source> addBook(String title) => sources.createWithChunks(
    type: SourceType.pdf,
    title: title,
    unitType: UnitType.page,
    totalUnits: 40,
    chapters: const [
      ChunkDraft(title: 'Ch 1', startUnit: 1, endUnit: 20),
      ChunkDraft(title: 'Ch 2', startUnit: 21, endUnit: 40),
    ],
  );

  Future<List<String>> liveTasks() async => [
    for (final task in await t.db.select(t.db.tasks).get())
      if (task.deletedAt == null) task.title,
  ];

  test(
    'removing a source takes its chapters, tasks and exam links; '
    'reviews stay; another source is untouched; undo restores it all',
    () async {
      final exam = await ExamRepository(
        t.ctx,
      ).create(name: 'JEE Main', date: '2027-01-10');
      final book = await addBook('HC Verma');
      final other = await addBook('Irodov');
      await SurveyRepository(t.ctx).createTasks(book.id, examId: exam.id);
      await SurveyRepository(t.ctx).createTasks(other.id, examId: exam.id);
      // A first read on one of the book's tasks.
      final s = await reading.start(book.id);
      await reading.save(s.id, endUnit: 20, minutes: 30, examId: exam.id);
      final reviews = (await t.db.select(t.db.reviews).get()).length;
      expect(reviews, 1);

      expect(await sources.tasksOf(book.id), hasLength(2));
      await sources.softDelete(book.id);

      expect(await liveTasks(), ['Ch 1', 'Ch 2'], reason: 'Irodov only');
      expect(await sources.tasksOf(book.id), isEmpty);
      final links = [
        for (final l in await t.db.select(t.db.examTasks).get())
          if (l.deletedAt == null) l,
      ];
      expect(links, hasLength(2));
      final chunks = [
        for (final c in await t.db.select(t.db.chunks).get())
          if (c.deletedAt == null) c.sourceId,
      ];
      expect(chunks, [other.id, other.id]);
      expect(await t.db.select(t.db.reviews).get(), hasLength(reviews));

      await sources.undo(book.id);
      expect(await liveTasks(), hasLength(4));
      expect(await sources.tasksOf(book.id), hasLength(2));
      expect((await reading.progress(book.id))!.position, 21);
    },
  );

  test('an open reading sitting is closed; an open review blocks it', () async {
    final book = await addBook('HC Verma');
    await SurveyRepository(t.ctx).createTasks(book.id);
    await reading.start(book.id);
    await sources.softDelete(book.id);
    expect(await reading.openSession(), isNull);
    await sources.undo(book.id);

    // The sitting is open again after undo; close it, then open a review.
    await reading.discard((await reading.openSession())!.id);
    final task = (await sources.tasksOf(book.id)).first;
    await t.db
        .into(t.db.activeSessions)
        .insert(
          ActiveSessionsCompanion.insert(
            id: 'a',
            taskId: task,
            startedAt: 0,
            createdAt: 0,
            updatedAt: 0,
          ),
        );
    await expectLater(
      sources.softDelete(book.id),
      throwsA(isA<InvalidOperationError>()),
    );
  });
}
