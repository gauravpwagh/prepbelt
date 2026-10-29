import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/result/result.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/redefine/data/redefine_repository.dart';
import 'package:prepbelt/features/session/data/session_repository.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/survey/data/survey_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';

import '../../support/test_db.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late RedefineRepository redefine;
  late ReviewRepository reviews;
  late SessionRepository sessions;
  late String taskId;
  late Exam exam;

  setUp(() async {
    final t = openTestContext();
    db = t.db;
    clock = t.clock;
    reviews = ReviewRepository(t.ctx, config: () async => const ReviewConfig());
    sessions = SessionRepository(t.ctx, reviews: reviews);
    redefine = RedefineRepository(t.ctx, sessions: sessions);
    exam = await ExamRepository(
      t.ctx,
    ).create(name: 'JEE Main', date: '2027-01-10');
    final s = await SourceRepository(t.ctx).createWithChunks(
      type: SourceType.book,
      title: 'HC Verma Vol 2',
      unitType: UnitType.page,
      totalUnits: 300,
      chapters: const [
        ChunkDraft(title: 'Thermodynamics', startUnit: 210, endUnit: 228),
      ],
    );
    await SurveyRepository(t.ctx).createTasks(s.id, examId: exam.id);
    taskId = (await db.select(db.tasks).getSingle()).id;
    // Read it, then two Good reviews: Orange (3).
    for (final kind in [
      ReviewKind.firstRead,
      ReviewKind.review,
      ReviewKind.review,
    ]) {
      await reviews.record(taskId: taskId, rating: Rating.good, kind: kind);
      clock.advance(const Duration(days: 5));
    }
  });
  tearDown(() => db.close());

  Future<TaskState> stateOf(String id) =>
      (db.select(db.taskStates)..where((s) => s.taskId.equals(id))).getSingle();

  test('rename and importance are undoable and leave mastery alone', () async {
    final before = await stateOf(taskId);
    await redefine.rename(taskId, 'Thermodynamics, 2nd law');
    await redefine.setImportance(
      exam.id,
      taskId,
      Importance.high,
      targetLevel: 7,
    );
    final link = await db.select(db.examTasks).getSingle();
    expect(
      (link.importance, link.targetLevel, link.importanceOverridden),
      (Importance.high, 7, true),
    );
    expect((await stateOf(taskId)).level, before.level);

    expect((await redefine.undoable(taskId))?.action, 'importance');
    await redefine.undo(taskId);
    expect(
      (await db.select(db.examTasks).getSingle()).importance,
      isNot(Importance.high),
    );
    await redefine.undo(taskId);
    expect((await db.select(db.tasks).getSingle()).title, 'Thermodynamics');
  });

  test('split: two parts with the belt, ranges and exam links, the second '
      'a day later; the original archived; undo brings it back', () async {
    final parent = await stateOf(taskId);
    final (a, b) = await redefine.split(
      taskId,
      after: 219,
      titleA: 'Part A',
      titleB: 'Part B',
    );
    final sa = await stateOf(a), sb = await stateOf(b);
    expect((sa.level, sa.step, sb.level, sb.step), (3, 2, 3, 2));
    expect(sa.dueAt, parent.dueAt);
    expect(sb.dueAt, parent.dueAt! + Duration.millisecondsPerDay);

    final ia = await sessions.load(a), ib = await sessions.load(b);
    expect(
      (ia.range, ib.range),
      ((start: 210, end: 219), (start: 220, end: 228)),
    );
    expect((await db.select(db.examTasks).get()).map((l) => l.taskId).toSet(), {
      taskId,
      a,
      b,
    });
    expect(
      (await (db.select(
        db.tasks,
      )..where((t) => t.id.equals(taskId))).getSingle()).status,
      TaskStatus.archived,
    );
    final lineage = await db.select(db.taskLineages).get();
    expect(lineage.map((l) => (l.childTaskId, l.parentTaskId, l.op)).toSet(), {
      (a, taskId, LineageOp.split),
      (b, taskId, LineageOp.split),
    });
    expect(await db.select(db.reviews).get(), hasLength(3), reason: 'kept');

    // From either part, the split is what undo reverses.
    expect((await redefine.undoable(b))?.action, 'split');
    await redefine.undo(b);
    final tasks = await (db.select(
      db.tasks,
    )..where((t) => t.deletedAt.isNull())).get();
    expect(tasks.map((t) => (t.id, t.status)), [(taskId, TaskStatus.active)]);
  });

  test('a split part reviewed since can no longer undo the split', () async {
    final (a, _) = await redefine.split(
      taskId,
      after: 219,
      titleA: 'A',
      titleB: 'B',
    );
    clock.advance(const Duration(days: 1));
    await reviews.record(taskId: a, rating: Rating.good);
    expect(await redefine.undoable(a), isNull);
    expect(() => redefine.undo(a), throwsA(isA<NothingToUndoError>()));
  });

  test('scope: shrinking keeps the belt; growing as one dims it a step; '
      'growing with a split makes the added pages a new task', () async {
    await redefine.setScope(taskId, start: 212, end: 226);
    expect((await sessions.load(taskId)).range, (start: 212, end: 226));
    expect((await stateOf(taskId)).dim, 0);

    await redefine.setScope(taskId, start: 212, end: 230, splitAdded: false);
    expect((await sessions.load(taskId)).range, (start: 212, end: 230));
    expect((await stateOf(taskId)).dim, 1);

    final added = await redefine.setScope(taskId, start: 205, end: 230);
    expect(added, hasLength(1));
    expect((await sessions.load(taskId)).range, (start: 212, end: 230));
    final fresh = await sessions.load(added.single);
    expect((fresh.range, fresh.state.level), ((start: 205, end: 211), 0));
    expect((await db.select(db.taskLineages).getSingle()).op, LineageOp.expand);
  });

  test('a split point outside the range is refused', () async {
    expect(
      () => redefine.split(taskId, after: 228, titleA: 'A', titleB: 'B'),
      throwsA(isA<InvalidOperationError>()),
    );
  });
}
