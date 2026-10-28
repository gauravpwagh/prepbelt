import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
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
  late AppDatabase db;
  late FakeClock clock;
  late SourceRepository sources;
  late ReadingRepository reading;
  late SurveyRepository survey;
  late ExamRepository exams;

  setUp(() {
    final t = openTestContext();
    db = t.db;
    clock = t.clock;
    sources = SourceRepository(t.ctx);
    survey = SurveyRepository(t.ctx);
    exams = ExamRepository(t.ctx);
    reading = ReadingRepository(
      t.ctx,
      reviews: ReviewRepository(
        t.ctx,
        config: () async => const ReviewConfig(),
      ),
    );
  });
  tearDown(() => db.close());

  void wait(int minutes) => clock.advance(Duration(minutes: minutes));

  // Chapters: 1–10, 11–30, 31–45, 46–60.
  Future<Source> addBook() => sources.createWithChunks(
    type: SourceType.pdf,
    title: 'HC Verma Vol 1',
    unitType: UnitType.page,
    totalUnits: 60,
    chapters: const [
      ChunkDraft(title: 'Ch 1', startUnit: 1, endUnit: 10),
      ChunkDraft(title: 'Ch 2', startUnit: 11, endUnit: 30),
      ChunkDraft(title: 'Ch 3', startUnit: 31, endUnit: 45),
      ChunkDraft(title: 'Ch 4', startUnit: 46, endUnit: 60),
    ],
  );

  Future<List<(String, int, int)>> firstReads() async => [
    for (final r in await db.select(db.reviews).get())
      if (r.deletedAt == null) (r.kind.name, r.durationSec, r.levelAfter),
  ];

  test('a sitting turns whole chapters into one task with its time; a '
      'partly read chapter waits for the next sitting', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    final book = await addBook();
    await survey.answer(
      (await reading.progress(book.id))!.chapters[1].chunk.id,
      difficulty: 2,
      familiarity: 0,
      examId: exam.id,
      importance: Importance.high,
    );

    final s1 = await reading.start(book.id);
    expect(s1.startUnit, 1);
    expect(() => reading.start(book.id), throwsA(isA<InvalidOperationError>()));
    wait(60);
    final out1 = await reading.save(
      s1.id,
      endUnit: 40,
      minutes: 80,
      examId: exam.id,
    );
    expect(out1.tasksCreated, ['Ch 1 – Ch 2']);
    expect(out1.partial, ['Ch 3']);

    var p = (await reading.progress(book.id, examId: exam.id))!;
    expect(p.position, 41);
    expect(p.exploredUnits, 40);
    expect(p.chapters.map((c) => (c.taskOrder, c.read, c.readUnits)), [
      (0, true, 10),
      (1, true, 20),
      (0, false, 10),
      (0, false, 0),
    ]);
    // 30 of the 40 pages, at 2 min a page.
    expect(await firstReads(), [('firstRead', 3600, 1)]);
    final examTask = await db.select(db.examTasks).getSingle();
    expect(
      (examTask.importance, examTask.targetLevel),
      (Importance.high, 7),
      reason: 'the highest importance of its chapters',
    );

    wait(60);
    final s2 = await reading.start(book.id);
    expect(s2.startUnit, 41);
    final out2 = await reading.save(s2.id, endUnit: 50, minutes: 30);
    expect(out2.tasksCreated, ['Ch 3']);
    expect(out2.partial, ['Ch 4']);
    // Ch 3: 10 pages of sitting 1 (20 min) + 5 pages of sitting 2 (15 min).
    expect((await firstReads()).last, ('firstRead', 35 * 60, 1));
    p = (await reading.progress(book.id))!;
    expect(p.position, 51);
  });

  test('undo of a save removes its tasks and reopens the sitting', () async {
    final book = await addBook();
    final s = await reading.start(book.id);
    wait(5);
    await reading.save(s.id, endUnit: 10, minutes: 20);
    expect((await reading.progress(book.id))!.taskCount, 1);

    wait(1);
    await reading.undo(book.id);
    final p = (await reading.progress(book.id))!;
    expect(p.taskCount, 0);
    expect(p.open?.id, s.id);
    expect(await firstReads(), isEmpty);
  });

  test('"I didn\'t read" records nothing', () async {
    final book = await addBook();
    final s = await reading.start(book.id);
    await reading.discard(s.id);
    final p = (await reading.progress(book.id))!;
    expect((p.open, p.position, p.taskCount), (null, 1, 0));
  });

  test(
    'a task made now gets its first read when the chapter is finished',
    () async {
      final book = await addBook();
      final ch3 = (await reading.progress(book.id))!.chapters[2].chunk.id;
      await reading.addTask(book.id, chunkIds: [ch3], title: '');
      expect(await firstReads(), isEmpty);

      final s = await reading.start(book.id);
      wait(10);
      final out = await reading.save(s.id, endUnit: 45, minutes: 90);
      expect(out.tasksCreated, ['Ch 1 – Ch 2']);
      expect(out.firstReads, 1);
      expect((await firstReads()).map((r) => r.$2), [60 * 60, 30 * 60]);
    },
  );

  test('"Make it a task now" creates a not-started task', () async {
    final book = await addBook();
    final ch3 = (await reading.progress(book.id))!.chapters[2].chunk.id;
    final s = await reading.start(book.id);
    final out = await reading.save(
      s.id,
      endUnit: 35,
      minutes: 70,
      taskNow: {ch3},
    );
    expect(out.tasksCreated, ['Ch 1 – Ch 2', 'Ch 3']);
    expect(out.partial, isEmpty);
    final p = (await reading.progress(book.id))!;
    expect(p.chapters[2].hasTask, isTrue);
    expect(p.chapters[2].read, isFalse);
  });

  test('Add task over two chapters, already read', () async {
    final book = await addBook();
    final ids = [
      for (final c in (await reading.progress(book.id))!.chapters.skip(2))
        c.chunk.id,
    ];
    await reading.addTask(
      book.id,
      chunkIds: ids,
      title: 'Motion and forces',
      alreadyRead: true,
    );
    final p = (await reading.progress(book.id))!;
    expect(p.taskCount, 1);
    expect(p.chapters.skip(2).map((c) => (c.taskOrder, c.read)), [
      (0, true),
      (1, true),
    ]);
    expect(p.position, 1, reason: 'Ch 1 is still unread');
    expect(p.exploredUnits, 30);
    expect(
      () => reading.addTask(book.id, chunkIds: [ids.first], title: 'x'),
      throwsA(isA<InvalidOperationError>()),
    );
  });

  test('pace follows saved sittings of the same unit type', () async {
    final book = await addBook();
    expect(await reading.pace(UnitType.page, defaultPace: 3), 3);
    for (var i = 0; i < 3; i++) {
      final s = await reading.start(book.id);
      wait(1);
      await reading.save(s.id, endUnit: s.startUnit + 9, minutes: 10);
    }
    expect(await reading.pace(UnitType.page, defaultPace: 3), 2);
  });

  test('Create N tasks covers unsurveyed chapters too', () async {
    final book = await addBook();
    expect(await survey.createTasks(book.id), 4);
  });
}
