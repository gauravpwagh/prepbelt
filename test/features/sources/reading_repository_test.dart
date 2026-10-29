import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/result/result.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/reading/reading_math.dart';
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

  test(
    '"Make it a task now" makes the pages read so far a task with its '
    'first read; finishing the chapter makes the rest a task (D49)',
    () async {
      final book = await addBook();
      final ch3 = (await reading.progress(book.id))!.chapters[2].chunk.id;
      final s = await reading.start(book.id);
      final out = await reading.save(
        s.id,
        endUnit: 35,
        minutes: 70,
        taskNow: {ch3},
        pagesTitle: (ch, a, b) => '$ch · pp. $a–$b',
      );
      expect(out.tasksCreated, ['Ch 1 – Ch 2', 'Ch 3 · pp. 31–35']);
      expect(out.partial, isEmpty);
      var c3 = (await reading.progress(book.id))!.chapters[2];
      expect((c3.hasTask, c3.read, c3.parts.length), (false, false, 1));
      expect(c3.uncovered, [const UnitRange(36, 45)]);
      // 70 min over 35 pages: 10 min for pp. 31–35.
      expect((await firstReads()).last, ('firstRead', 10 * 60, 1));

      final s2 = await reading.start(book.id);
      expect(s2.startUnit, 36);
      final out2 = await reading.save(
        s2.id,
        endUnit: 45,
        minutes: 20,
        pagesTitle: (ch, a, b) => '$ch · pp. $a–$b',
      );
      expect(out2.tasksCreated, ['Ch 3 · pp. 36–45']);
      c3 = (await reading.progress(book.id))!.chapters[2];
      expect((c3.hasTask, c3.read, c3.parts.length), (true, true, 2));
    },
  );

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

  group('progressive splitting (D47)', () {
    // 100 pages, no chapters.
    Future<Source> addPdf() => sources.createWithChunks(
      type: SourceType.pdf,
      title: 'Notes',
      unitType: UnitType.page,
      totalUnits: 100,
      chapters: const [],
    );
    String title(int s, int e) => 'Pages $s–$e';

    Future<SaveOutcome> sit(
      String id,
      int end,
      int minutes, {
      bool partNow = false,
      bool finish = false,
    }) async {
      final s = await reading.start(id);
      return reading.save(
        s.id,
        endUnit: end,
        minutes: minutes,
        partTitle: title,
        minPartMinutes: 10,
        partNow: partNow,
        finish: finish,
      );
    }

    test('each sitting becomes the next part with its first read; a short '
        'one waits and joins the next', () async {
      final pdf = await addPdf();
      expect((await reading.progress(pdf.id))!.progressive, isTrue);
      expect((await reading.progress(pdf.id))!.unitsToExplore, 100);

      final out1 = await sit(pdf.id, 16, 40);
      expect(out1.tasksCreated, ['Pages 1–16']);
      expect(await firstReads(), [('firstRead', 40 * 60, 1)]);

      final out2 = await sit(pdf.id, 19, 5);
      expect(out2.tasksCreated, isEmpty);
      expect(out2.held, const UnitRange(17, 19));

      final out3 = await sit(pdf.id, 30, 25);
      expect(out3.tasksCreated, ['Pages 17–30']);
      final p = (await reading.progress(pdf.id))!;
      expect(p.source.progressive, isTrue);
      expect(
        [for (final c in p.chapters) c.chunk.title],
        ['Pages 1–16', 'Pages 17–30'],
      );
      expect(p.position, 31);
      expect(p.unitsToExplore, 70);
      // The held 5 minutes count toward the part.
      expect((await firstReads()).last, ('firstRead', 30 * 60, 1));
    });

    test(
      'a short sitting can be a part anyway; the last page ends it',
      () async {
        final pdf = await addPdf();
        expect((await sit(pdf.id, 3, 5, partNow: true)).tasksCreated, [
          'Pages 1–3',
        ]);
        expect((await sit(pdf.id, 100, 5)).tasksCreated, ['Pages 4–100']);
        expect((await reading.progress(pdf.id))!.position, isNull);
      },
    );

    test('"That was the last part" makes the part and marks the source '
        'done; undo brings both back', () async {
      final pdf = await addPdf();
      await sit(pdf.id, 20, 30);
      final out = await sit(pdf.id, 24, 5, finish: true);
      expect(out.tasksCreated, ['Pages 21–24']);
      var p = (await reading.progress(pdf.id))!;
      expect((p.finished, p.position, p.unitsToExplore), (true, null, 0));
      await expectLater(
        reading.start(pdf.id),
        throwsA(isA<InvalidOperationError>()),
      );

      await reading.undo(pdf.id);
      p = (await reading.progress(pdf.id))!;
      expect((p.finished, p.chapters.length), (false, 1));
    });
  });

  test('Done with this source stops the reading and the Continue item; '
      'reopening brings them back', () async {
    final book = await addBook();
    final s = await reading.start(book.id);
    await reading.save(s.id, endUnit: 10, minutes: 20);
    await reading.setFinished(book.id, finished: true);
    var p = (await reading.progress(book.id))!;
    expect((p.position, p.unitsToExplore, p.progressive), (null, 0, false));

    await reading.setFinished(book.id, finished: false);
    p = (await reading.progress(book.id))!;
    expect((p.position, p.unitsToExplore), (11, 50));
    await reading.undo(book.id);
    expect((await reading.progress(book.id))!.finished, isTrue);
  });

  group('reading by chapter, and parts of chapters (D49)', () {
    // 14 chapters, 140 pages, no page numbers per chapter.
    Future<Source> addCounted() => sources.createWithChunks(
      type: SourceType.pdf,
      title: 'Law notes',
      unitType: UnitType.page,
      totalUnits: 140,
      chapters: [for (var n = 1; n <= 14; n++) ChunkDraft(title: 'Ch $n')],
    );

    Future<SaveOutcome> sit(
      String id,
      int end,
      int minutes, {
      bool inChapter = false,
      int partsDone = 0,
    }) async {
      final s = await reading.start(id);
      return reading.save(
        s.id,
        endUnit: end,
        minutes: minutes,
        inChapter: inChapter,
        partsDone: partsDone,
      );
    }

    test('chapters are the units; a chapter still in progress keeps its '
        'share of time until a sitting finishes it', () async {
      final law = await addCounted();
      var p = (await reading.progress(law.id))!;
      expect(
        (p.byChapter, p.progressive, p.totalUnits, p.position),
        (true, false, 14, 1),
      );
      expect(p.unitsToExplore, 14);

      expect((await sit(law.id, 3, 60)).tasksCreated, ['Ch 1 – Ch 3']);
      final out = await sit(law.id, 5, 40, inChapter: true);
      expect(out.tasksCreated, ['Ch 4']);
      p = (await reading.progress(law.id))!;
      expect((p.position, p.current?.chunk.title), (5, 'Ch 5'));
      expect(p.chapters[4].inProgress, isTrue);
      // 40 minutes over Ch 4 and Ch 5: 20 each.
      expect((await firstReads()).last, ('firstRead', 20 * 60, 1));

      final s = await reading.start(law.id);
      expect(s.startUnit, 5, reason: 'continues the chapter in progress');
      await reading.save(s.id, endUnit: 5, minutes: 10);
      expect((await firstReads()).last, ('firstRead', 30 * 60, 1));
      p = (await reading.progress(law.id))!;
      expect(
        (p.position, p.exploredUnits, p.chapters[4].inProgress),
        (6, 5, false),
      );
    });

    test('minutes per chapter: pages shared equally, then the median of '
        'first reads', () async {
      final law = await addCounted();
      var p = (await reading.progress(law.id))!;
      expect(p.minutesPerChapter(pagePace: 2), 20, reason: '140 / 14 × 2');
      await sit(law.id, 1, 30);
      await sit(law.id, 2, 50);
      await sit(law.id, 3, 40);
      p = (await reading.progress(law.id))!;
      expect(p.minutesPerChapter(pagePace: 2), 40);
    });

    test('part k of n: Add task splits a chapter; "Finished part 1 of 3" '
        'records it; finishing the chapter shares the rest', () async {
      final law = await addCounted();
      final ch1 = (await reading.progress(law.id))!.chapters[0];
      await reading.addTask(
        law.id,
        chunkIds: [ch1.chunk.id],
        title: '',
        parts: 3,
        partTitle: (k, n) => 'Ch 1 · part $k of $n',
      );
      var c1 = (await reading.progress(law.id))!.chapters[0];
      expect(
        [for (final t in c1.tasks) t.title],
        ['Ch 1 · part 1 of 3', 'Ch 1 · part 2 of 3', 'Ch 1 · part 3 of 3'],
      );
      expect((c1.hasTask, c1.read, c1.parts.length), (true, false, 3));
      await expectLater(
        reading.addTask(law.id, chunkIds: [ch1.chunk.id], title: 'x'),
        throwsA(isA<InvalidOperationError>()),
      );

      final out = await sit(law.id, 1, 30, inChapter: true, partsDone: 1);
      expect(out.firstReads, 1);
      expect((await firstReads()).last, ('firstRead', 30 * 60, 1));
      await sit(law.id, 1, 50);
      c1 = (await reading.progress(law.id))!.chapters[0];
      expect(c1.read, isTrue);
      // The 50 minutes left are shared by parts 2 and 3.
      expect((await firstReads()).skip(1).map((r) => r.$2), [25 * 60, 25 * 60]);
    });

    test('pages of a chapter: Add task makes a part; overlapping pages and '
        'the whole chapter are refused', () async {
      final book = await addBook();
      final ch2 = (await reading.progress(book.id))!.chapters[1];
      await reading.addTask(
        book.id,
        chunkIds: [ch2.chunk.id],
        title: 'Ch 2 · pp. 11–15',
        pages: const UnitRange(11, 15),
      );
      final c2 = (await reading.progress(book.id))!.chapters[1];
      expect((c2.hasTask, c2.parts.length), (false, 1));
      expect(c2.uncovered, [const UnitRange(16, 30)]);
      await expectLater(
        reading.addTask(
          book.id,
          chunkIds: [ch2.chunk.id],
          title: 'x',
          pages: const UnitRange(15, 20),
        ),
        throwsA(isA<InvalidOperationError>()),
      );
      await expectLater(
        reading.addTask(book.id, chunkIds: [ch2.chunk.id], title: 'x'),
        throwsA(isA<InvalidOperationError>()),
      );
      await reading.addTask(
        book.id,
        chunkIds: [ch2.chunk.id],
        title: 'Ch 2 · pp. 16–30',
        pages: const UnitRange(16, 30),
      );
      expect((await reading.progress(book.id))!.chapters[1].hasTask, isTrue);
    });
  });
}
