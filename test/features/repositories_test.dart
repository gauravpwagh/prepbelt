import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/db/event_log.dart';
import 'package:prepbelt/core/result/result.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/features/exams/data/exam_repository.dart';
import 'package:prepbelt/features/settings/data/settings_repository.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/tasks/data/task_repository.dart';

import '../support/test_db.dart';

/// Row fields that undo restores; `updatedAt` and `hlc` move forward.
Map<String, Object?> content(Insertable<Object?> row) {
  final cols = row.toColumns(false);
  return {
    for (final e in cols.entries)
      if (e.key != 'updated_at' && e.key != 'hlc')
        e.key: (e.value as Variable<Object>).value,
  };
}

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late WriteContext ctx;

  setUp(() {
    final t = openTestContext();
    db = t.db;
    clock = t.clock;
    ctx = t.ctx;
  });
  tearDown(() => db.close());

  Future<List<Event>> events() =>
      (db.select(db.events)..orderBy([(e) => OrderingTerm.asc(e.hlc)])).get();

  void tick() => clock.advance(const Duration(minutes: 1));

  group('SourceRepository', () {
    late SourceRepository repo;
    setUp(() => repo = SourceRepository(ctx));

    test('every write logs exactly one Event with the row change', () async {
      final s = await repo.create(
        type: SourceType.book,
        title: 'HC Verma Vol 1',
        unitType: UnitType.page,
        totalUnits: 480,
      );
      expect(s.hlc, endsWith('test-device'));
      expect(s.createdAt, clock.nowMs());
      tick();
      await repo.update(s.id, title: const Value('HC Verma Vol. 1'));
      tick();
      await repo.softDelete(s.id);

      final log = await events();
      expect(log.map((e) => e.op), [
        EventOp.create,
        EventOp.update,
        EventOp.delete,
      ]);
      expect(
        log.every((e) => e.entity == 'source' && e.entityId == s.id),
        isTrue,
      );
      final update = EventPayload.decode(log[1].payload).changes.single;
      expect(update.table, 'sources');
      expect(update.before!['title'], 'HC Verma Vol 1');
      expect(update.after!['title'], 'HC Verma Vol. 1');
    });

    test('a failed write logs nothing', () async {
      await expectLater(
        repo.update('missing', title: const Value('x')),
        throwsA(isA<NotFoundError>()),
      );
      expect(await events(), isEmpty);
    });

    test(
      'undo restores the previous row, and repeated undo walks back',
      () async {
        final created = await repo.create(
          type: SourceType.pdf,
          title: 'Notes',
          unitType: UnitType.page,
        );
        tick();
        final renamed = await repo.update(
          created.id,
          title: const Value('Class notes'),
        );
        tick();
        await repo.update(created.id, uri: const Value('sources/a.pdf'));

        tick();
        await repo.undo(created.id);
        var row = await (db.select(
          db.sources,
        )..where((s) => s.id.equals(created.id))).getSingle();
        expect(content(row), content(renamed));

        tick();
        await repo.undo(created.id);
        row = await (db.select(
          db.sources,
        )..where((s) => s.id.equals(created.id))).getSingle();
        expect(content(row), content(created));

        // Undoing the create soft-deletes the row.
        tick();
        await repo.undo(created.id);
        expect(await repo.watch(created.id).first, isNull);
        await expectLater(
          repo.undo(created.id),
          throwsA(isA<NothingToUndoError>()),
        );

        // Each undo is itself logged, pointing at what it reversed.
        final log = await events();
        expect(log, hasLength(6));
        final undoOf = [
          for (final e in log.skip(3)) EventPayload.decode(e.payload).undoOf,
        ];
        expect(undoOf, [log[2].id, log[1].id, log[0].id]);
      },
    );

    test('undo of a delete brings the row back', () async {
      final s = await repo.create(
        type: SourceType.link,
        title: 'Lecture',
        unitType: UnitType.minute,
      );
      tick();
      await repo.softDelete(s.id);
      expect(await repo.watchAll().first, isEmpty);
      tick();
      await repo.undo(s.id);
      expect((await repo.watchAll().first).single.id, s.id);
    });

    test('watchAll emits on every write', () async {
      final seen = <int>[];
      final sub = repo.watchAll().listen((rows) => seen.add(rows.length));
      addTearDown(sub.cancel);
      await pumpEventQueue();
      await repo.create(
        type: SourceType.book,
        title: 'A',
        unitType: UnitType.page,
      );
      await pumpEventQueue();
      expect(seen, [0, 1]);
    });
  });

  group('TaskRepository', () {
    late TaskRepository repo;
    setUp(() => repo = TaskRepository(ctx));

    test(
      'create writes the task and a level-0 TaskState under one Event',
      () async {
        final t = await repo.create(title: 'Rotational motion');
        final state = await repo.getState(t.id);
        expect(state.level, 0);
        expect(t.status, TaskStatus.active);

        final log = await events();
        expect(log, hasLength(1));
        final changes = EventPayload.decode(log.single.payload).changes;
        expect(changes.map((c) => c.table), ['tasks', 'task_states']);
      },
    );

    test('undo of create removes both rows from view', () async {
      final t = await repo.create(title: 'Electrostatics');
      tick();
      await repo.undo(t.id);
      expect(await repo.watch(t.id).first, isNull);
      final state = await (db.select(
        db.taskStates,
      )..where((s) => s.taskId.equals(t.id))).getSingle();
      expect(state.deletedAt, isNotNull);
    });

    test('update and undo restore the previous row', () async {
      final t = await repo.create(title: 'SN1 reactions');
      tick();
      await repo.update(t.id, title: const Value('SN1 and SN2 reactions'));
      tick();
      await repo.undo(t.id);
      final row = await repo.watch(t.id).first;
      expect(content(row!), content(t));
    });
  });

  group('ExamRepository', () {
    late ExamRepository repo;
    setUp(() => repo = ExamRepository(ctx));

    test('logs events, undoes, and allows one upcoming exam', () async {
      final e = await repo.create(name: 'JEE Main', date: '2027-01-10');
      await expectLater(
        repo.create(name: 'Second', date: '2027-02-01'),
        throwsA(isA<InvalidOperationError>()),
      );
      tick();
      await repo.update(e.id, date: const Value('2027-01-12'));
      tick();
      await repo.softDelete(e.id);
      expect(await repo.watchCurrent().first, isNull);

      tick();
      await repo.undo(e.id);
      expect((await repo.watchCurrent().first)!.date, '2027-01-12');
      tick();
      await repo.undo(e.id);
      final row = await repo.watch(e.id).first;
      expect(content(row!), content(e));

      expect((await events()).map((ev) => ev.op), [
        EventOp.create,
        EventOp.update,
        EventOp.delete,
        EventOp.update,
        EventOp.update,
      ]);
    });
  });

  group('SettingsRepository', () {
    late SettingsRepository repo;
    setUp(() => repo = SettingsRepository(ctx));

    test('set, overwrite, remove, and undo each step', () async {
      await repo.set('review.retentionTarget', 0.9);
      tick();
      await repo.set('review.retentionTarget', 0.85);
      expect(await repo.get('review.retentionTarget'), 0.85);
      tick();
      await repo.remove('review.retentionTarget');
      expect(await repo.get('review.retentionTarget'), isNull);
      expect(await repo.getAll(), isEmpty);

      tick();
      await repo.undo('review.retentionTarget');
      expect(await repo.get('review.retentionTarget'), 0.85);
      tick();
      await repo.undo('review.retentionTarget');
      expect(await repo.get('review.retentionTarget'), 0.9);

      final log = await events();
      expect(log, hasLength(5));
      expect(log.every((e) => e.entityId == 'review.retentionTarget'), isTrue);
    });

    test('watchAll decodes JSON values', () async {
      await repo.set('review.levelStabilityThresholds', [
        3,
        7,
        14,
        30,
        60,
        120,
      ]);
      expect((await repo.watchAll().first)['review.levelStabilityThresholds'], [
        3,
        7,
        14,
        30,
        60,
        120,
      ]);
    });
  });
}
