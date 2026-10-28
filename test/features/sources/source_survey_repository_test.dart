import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/platform/files/file_store.dart';

import '../../support/test_db.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late SourceRepository sources;
  late SurveyRepository survey;
  late ExamRepository exams;

  setUp(() {
    final t = openTestContext();
    db = t.db;
    clock = t.clock;
    sources = SourceRepository(t.ctx);
    survey = SurveyRepository(t.ctx);
    exams = ExamRepository(t.ctx);
  });
  tearDown(() => db.close());

  void tick() => clock.advance(const Duration(minutes: 1));

  final chapters = chaptersFromOutline(const [
    OutlineEntry('Ch 1 Introduction', 1),
    OutlineEntry('Ch 2 Vectors', 12, [
      OutlineEntry('2.1 Addition', 12),
      OutlineEntry('2.2 Products', 20),
    ]),
    OutlineEntry('Ch 3 Rest and motion', 40),
  ], 62);

  Future<Source> addBook() => sources.createWithChunks(
    type: SourceType.pdf,
    title: 'HC Verma Vol 1',
    unitType: UnitType.page,
    totalUnits: 62,
    chapters: chapters,
    file: const StoredFile(
      relativePath: 'sources/a.pdf',
      bytes: 1024,
      sha256: 'abc123',
    ),
  );

  test('createWithChunks saves source, file and nested chapters as one '
      'undoable event', () async {
    final source = await addBook();
    final chunks = await sources.watchChunks(source.id).first;
    expect(chunks, hasLength(5));
    final ch2 = chunks.firstWhere((c) => c.title == 'Ch 2 Vectors');
    final parts = chunks.where((c) => c.parentChunkId == ch2.id);
    expect(parts.map((c) => (c.title, c.startUnit, c.endUnit)), [
      ('2.1 Addition', 12, 19),
      ('2.2 Products', 20, 39),
    ]);
    expect(ch2.sizeUnits, 28);
    expect((await sources.findByFileHash('abc123'))?.id, source.id);
    expect(await db.select(db.events).get(), hasLength(1));

    tick();
    await sources.undo(source.id);
    expect(await sources.watchChunks(source.id).first, isEmpty);
    expect(await sources.findByFileHash('abc123'), isNull);
  });

  test('survey answers per chapter, with importance for the exam', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    final source = await addBook();
    var items = await survey.items(source.id, examId: exam.id);
    expect(items.map((i) => i.chunk.title), [
      'Ch 1 Introduction',
      'Ch 2 Vectors',
      'Ch 3 Rest and motion',
    ], reason: 'parts are not surveyed separately');
    expect(items.any((i) => i.surveyed), isFalse);

    final ch3 = items.last.chunk.id;
    await survey.answer(
      ch3,
      difficulty: 3,
      familiarity: 1,
      examId: exam.id,
      importance: Importance.high,
    );
    items = await survey.items(source.id, examId: exam.id);
    expect(items.last.surveyed, isTrue);
    expect(items.last.survey!.difficulty, 3);
    expect(items.last.importance, Importance.high);

    tick();
    await survey.answer(ch3, familiarity: 2);
    expect((await survey.items(source.id)).last.survey!.difficulty, 3);
    expect((await survey.items(source.id)).last.survey!.familiarity, 2);

    tick();
    await survey.undo(ch3);
    expect((await survey.items(source.id)).last.survey!.familiarity, 1);
    tick();
    await survey.undo(ch3);
    expect((await survey.items(source.id)).last.surveyed, isFalse);
  });

  test('answerRemaining fills only unsurveyed chapters, undoably', () async {
    final exam = await exams.create(name: 'JEE Main', date: '2027-01-10');
    final source = await addBook();
    final first = (await survey.items(source.id)).first.chunk.id;
    await survey.answer(first, difficulty: 1, familiarity: 2);

    tick();
    final n = await survey.answerRemaining(
      source.id,
      difficulty: 2,
      familiarity: 0,
      examId: exam.id,
      importance: Importance.medium,
    );
    expect(n, 2);
    final items = await survey.items(source.id, examId: exam.id);
    expect(items.every((i) => i.surveyed), isTrue);
    expect(items.first.survey!.difficulty, 1, reason: 'left as answered');
    expect(items.skip(1).map((i) => i.importance), [
      Importance.medium,
      Importance.medium,
    ]);

    tick();
    await sources.undo(source.id);
    final after = await survey.items(source.id, examId: exam.id);
    expect(after.where((i) => i.surveyed), hasLength(1));
  });

  test('watchItems emits as answers change', () async {
    final source = await addBook();
    final seen = <int>[];
    final sub = survey
        .watchItems(source.id)
        .listen((items) => seen.add(items.where((i) => i.surveyed).length));
    addTearDown(sub.cancel);
    await pumpEventQueue();
    await survey.answer(
      (await survey.items(source.id)).first.chunk.id,
      difficulty: 2,
      familiarity: 0,
    );
    await pumpEventQueue();
    expect(seen, [0, 1]);
  });

  test(
    'a duplicate file is found by hash only while its source lives',
    () async {
      final source = await addBook();
      tick();
      await sources.softDelete(source.id);
      expect(await sources.findByFileHash('abc123'), isNull);
      expect(
        await (db.select(
          db.sourceFiles,
        )..where((f) => f.sha256.equals('abc123'))).get(),
        hasLength(1),
      );
    },
  );
}
