import 'dart:math';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/db/event_log.dart';
import 'package:prepbelt/core/result/result.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/features/settings/data/settings_repository.dart';
import 'package:prepbelt/features/tasks/data/review_repository.dart';
import 'package:prepbelt/features/tasks/data/task_repository.dart';

import '../support/test_db.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late TaskRepository tasks;
  late ReviewRepository reviews;
  late SettingsRepository settings;

  setUp(() {
    final t = openTestContext();
    db = t.db;
    clock = t.clock;
    tasks = TaskRepository(t.ctx);
    settings = SettingsRepository(t.ctx);
    reviews = ReviewRepository(
      t.ctx,
      config: () async => ReviewConfig.fromSettings(await settings.getAll()),
    );
  });
  tearDown(() => db.close());

  Future<ReviewState> stateOf(String taskId) async =>
      ReviewRepository.toReviewState(await tasks.getState(taskId));

  Future<void> goodUntilDue(String taskId, int times) async {
    for (var i = 0; i < times; i++) {
      await reviews.record(taskId: taskId, rating: Rating.good);
      clock.set((await stateOf(taskId)).dueAt!);
    }
  }

  test(
    'record writes the Review row, TaskState and one Event together',
    () async {
      final task = await tasks.create(title: 'Thermodynamics');
      final review = await reviews.record(
        taskId: task.id,
        rating: Rating.good,
        kind: ReviewKind.firstRead,
        durationSec: 1320,
        resumeUnit: 228,
      );
      final state = await tasks.getState(task.id);

      expect(review.at, clock.nowMs());
      expect(review.levelBefore, 0);
      expect(review.levelAfter, 1);
      expect(review.stabilityAfter, state.fsrsStability);
      expect(review.dueAfter, state.dueAt);
      expect(review.resumeUnit, 228);
      expect(state.level, 1);
      expect(state.reps, 1);

      final events = await (db.select(
        db.events,
      )..where((e) => e.op.equalsValue(EventOp.review))).get();
      final changes = EventPayload.decode(events.single.payload).changes;
      expect(changes.map((c) => c.table), ['reviews', 'task_states']);
    },
  );

  test('a failed record writes nothing', () async {
    await expectLater(
      reviews.record(taskId: 'missing', rating: Rating.good),
      throwsA(isA<NotFoundError>()),
    );
    expect(await db.select(db.reviews).get(), isEmpty);
    expect(await db.select(db.events).get(), isEmpty);
  });

  test('Forgot after several Good reviews lowers stability and keeps every '
      'review; reviews cannot be undone', () async {
    final task = await tasks.create(title: 'Electrostatics');
    await goodUntilDue(task.id, 5);
    final before = await stateOf(task.id);

    await reviews.record(taskId: task.id, rating: Rating.forgot);
    final after = await stateOf(task.id);
    expect(after.stability, lessThan(before.stability!));
    expect(after.lapses, 1);
    expect(await reviews.reviewsFor(task.id), hasLength(6));

    await expectLater(
      tasks.undo(task.id),
      throwsA(isA<InvalidOperationError>()),
    );
    expect(await reviews.reviewsFor(task.id), hasLength(6));
  });

  test('pausing for 10 days then resuming shifts dueAt by 10 days', () async {
    final task = await tasks.create(title: 'Rotational motion');
    await reviews.record(taskId: task.id, rating: Rating.good);
    final due = (await stateOf(task.id)).dueAt!;

    clock.advance(const Duration(hours: 2));
    await reviews.pause(task.id);
    expect((await tasks.watch(task.id).first)!.status, TaskStatus.paused);
    await expectLater(
      reviews.record(taskId: task.id, rating: Rating.good),
      throwsA(isA<InvalidOperationError>()),
    );

    clock.advance(const Duration(days: 10));
    await reviews.resume(task.id);
    final resumed = await stateOf(task.id);
    expect(resumed.dueAt, due.add(const Duration(days: 10)));
    expect(resumed.pausedAt, isNull);
    expect((await tasks.watch(task.id).first)!.status, TaskStatus.active);
  });

  test('pause and resume can be undone, and rebuild still agrees', () async {
    final task = await tasks.create(title: 'SN1 and SN2');
    await reviews.record(taskId: task.id, rating: Rating.good);
    clock.advance(const Duration(days: 1));
    final beforePause = await stateOf(task.id);
    await reviews.pause(task.id);
    clock.advance(const Duration(days: 4));
    await reviews.resume(task.id);

    clock.advance(const Duration(minutes: 1));
    await tasks.undo(task.id); // undo resume: paused again, no shift
    expect((await stateOf(task.id)).pausedAt, isNotNull);
    expect(await reviews.rebuildState(task.id), await stateOf(task.id));

    clock.advance(const Duration(minutes: 1));
    await tasks.undo(task.id); // undo pause
    expect(await stateOf(task.id), beforePause);
    expect(await reviews.rebuildState(task.id), beforePause);
  });

  test('rebuild reproduces the incremental TaskState for seeded random '
      'histories, and repairs a corrupted cache', () async {
    for (var seed = 1; seed <= 5; seed++) {
      final random = Random(seed);
      final task = await tasks.create(title: 'Task $seed');
      var paused = false;
      for (var step = 0; step < 25; step++) {
        clock.advance(
          Duration(days: random.nextInt(15), minutes: random.nextInt(600)),
        );
        final roll = random.nextDouble();
        final started = (await stateOf(task.id)).started;
        if (started && !paused && roll < 0.1) {
          await reviews.pause(task.id);
          paused = true;
        } else if (paused) {
          if (roll < 0.5) {
            await reviews.resume(task.id);
            paused = false;
          }
        } else {
          await reviews.record(
            taskId: task.id,
            rating: Rating.values[random.nextInt(4)],
          );
        }
      }
      expect(
        await reviews.rebuildState(task.id),
        await stateOf(task.id),
        reason: 'seed $seed',
      );
    }

    final all = await db.select(db.taskStates).get();
    final expected = {
      for (final row in all) row.taskId: ReviewRepository.toReviewState(row),
    };
    await db
        .update(db.taskStates)
        .write(const TaskStatesCompanion(level: Value(7), reps: Value(99)));
    expect(await reviews.rebuildAll(), all.length);
    for (final MapEntry(key: id, value: state) in expected.entries) {
      expect(await stateOf(id), state);
    }
  });

  test('level thresholds from the Setting table change levels', () async {
    await settings.set(SettingKeys.levelStabilityThresholds, [
      0.5,
      1,
      2,
      4,
      8,
      16,
    ]);
    final task = await tasks.create(title: 'Optics');
    await goodUntilDue(task.id, 3);
    final fast = (await stateOf(task.id)).level;

    await settings.remove(SettingKeys.levelStabilityThresholds);
    final other = await tasks.create(title: 'Optics 2');
    await goodUntilDue(other.id, 2);
    // With default thresholds the second review's stability (about 11
    // days) earns only level 2; with the low ones the cap is the limit.
    expect(fast, 3);
    expect((await stateOf(other.id)).level, 2);
  });
}
