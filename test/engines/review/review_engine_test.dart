import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/review/review_engine.dart';
import 'package:prepbelt/engines/review/review_types.dart';

import '../../../tool/check_imports.dart';

void main() {
  late FakeClock clock;
  late ReviewEngine engine;

  setUp(() {
    clock = FakeClock(DateTime.utc(2026, 10, 28, 9));
    engine = ReviewEngine(const ReviewConfig());
  });

  /// Reviews with [rating] at the clock's time and returns the outcome.
  ReviewOutcome review(ReviewState s, Rating rating) =>
      engine.applyReview(s, rating, clock.now());

  group('levels', () {
    test('Good reviews on their due dates promote one belt at a time, '
        'starting with level 1 at the first read', () {
      var state = const ReviewState();
      final levels = <int>[];
      final stabilities = <double>[];
      for (var i = 0; i < 12; i++) {
        final out = review(state, Rating.good);
        expect(out.levelBefore, state.level);
        levels.add(out.levelAfter);
        stabilities.add(out.stabilityAfter);
        state = out.state;
        clock.set(state.dueAt!);
      }
      expect(levels.first, 1, reason: 'first read sets level 1');
      for (var i = 1; i < levels.length; i++) {
        expect(levels[i] - levels[i - 1], inInclusiveRange(0, 1));
      }
      expect(levels.last, 7);
      expect(levels.toSet(), {1, 2, 3, 4, 5, 6, 7}, reason: 'none skipped');
      for (var i = 1; i < stabilities.length; i++) {
        expect(stabilities[i], greaterThan(stabilities[i - 1]));
      }
    });

    test('even an Easy first read sets level 1', () {
      final out = review(const ReviewState(), Rating.easy);
      expect(out.stabilityAfter, greaterThan(14));
      expect(out.levelAfter, 1);
    });

    test('levelFor follows the stability table', () {
      expect(engine.levelFor(0.5), 1);
      expect(engine.levelFor(2.99), 1);
      expect(engine.levelFor(3), 2);
      expect(engine.levelFor(7), 3);
      expect(engine.levelFor(14), 4);
      expect(engine.levelFor(30), 5);
      expect(engine.levelFor(60), 6);
      expect(engine.levelFor(120), 7);
      expect(engine.levelFor(5000), 7);
    });

    test('changing thresholds in configuration changes levelFor', () {
      final custom = ReviewEngine(
        ReviewConfig.fromSettings({
          SettingKeys.levelStabilityThresholds: [1, 2, 4, 8, 16, 32],
        }),
      );
      expect(engine.levelFor(10), 3);
      expect(custom.levelFor(10), 5);
      expect(custom.levelFor(40), 7);
    });

    test('Forgot after several Good reviews lowers stability and level', () {
      var state = const ReviewState();
      for (var i = 0; i < 6; i++) {
        state = review(state, Rating.good).state;
        clock.set(state.dueAt!);
      }
      final before = state;
      final out = review(state, Rating.forgot);
      expect(out.stabilityAfter, lessThan(before.stability!));
      expect(out.levelAfter, lessThanOrEqualTo(before.level));
      expect(out.state.lapses, 1);
      expect(out.state.reps, before.reps + 1);
      expect(
        out.dueAfter.difference(clock.now()),
        greaterThanOrEqualTo(const Duration(days: 1)),
      );
    });
  });

  group('shine and display', () {
    test('shineFor maps recall to 2, 1 or 0 stripes', () {
      expect(engine.shineFor(1), 2);
      expect(engine.shineFor(0.9), 2);
      expect(engine.shineFor(0.85), 1);
      expect(engine.shineFor(0.8), 1);
      expect(engine.shineFor(0.75), 0);
    });

    test('displayedLevel drops by one when overdue with R below 0.7, '
        'without changing the stored level; one Good review restores it', () {
      var state = const ReviewState();
      for (var i = 0; i < 4; i++) {
        state = review(state, Rating.good).state;
        clock.set(state.dueAt!);
      }
      final stored = state.level;
      expect(stored, greaterThanOrEqualTo(2));
      expect(engine.display(state, clock.now()).fading, isFalse);
      expect(engine.displayedLevel(state, clock.now()), stored);

      // Overdue, recall still at or above 0.7: shown at stored level.
      clock.advance(const Duration(days: 1));
      final r1 = engine.retrievability(state, clock.now())!;
      expect(r1, greaterThanOrEqualTo(0.7));
      expect(engine.displayedLevel(state, clock.now()), stored);

      // Let recall fall below 0.7.
      while (engine.retrievability(state, clock.now())! >= 0.7) {
        clock.advance(const Duration(days: 1));
      }
      final shown = engine.display(state, clock.now());
      expect(shown.level, stored - 1);
      expect(shown.fading, isTrue);
      expect(shown.stripes, 0);
      expect(state.level, stored, reason: 'stored level unchanged');

      final out = review(state, Rating.good);
      expect(out.levelAfter, greaterThanOrEqualTo(stored));
      final after = engine.display(out.state, clock.now());
      expect(after.fading, isFalse);
      expect(after.level, out.levelAfter);
      expect(after.stripes, 2);
    });

    test('a fading level-1 task still shows level 1', () {
      var state = review(const ReviewState(), Rating.hard).state;
      clock.advance(const Duration(days: 60));
      final shown = engine.display(state, clock.now());
      expect(shown.fading, isTrue);
      expect(shown.level, 1);
    });

    test('not started shows level 0 with no recall', () {
      final shown = engine.display(const ReviewState(), clock.now());
      expect(shown.level, 0);
      expect(shown.retrievability, isNull);
    });
  });

  group('pause', () {
    test('pausing for 10 days then resuming shifts dueAt by 10 days', () {
      final state = review(const ReviewState(), Rating.good).state;
      final due = state.dueAt!;
      clock.advance(const Duration(hours: 5));
      final paused = engine.pause(state, clock.now());
      clock.advance(const Duration(days: 10));
      final resumed = engine.resume(paused, clock.now());
      expect(resumed.dueAt, due.add(const Duration(days: 10)));
      expect(resumed.pausedAt, isNull);
    });

    test('paused tasks do not decay or turn overdue', () {
      var state = review(const ReviewState(), Rating.good).state;
      clock.advance(const Duration(days: 1));
      state = engine.pause(state, clock.now());
      final rAtPause = engine.retrievability(state, clock.now());
      clock.advance(const Duration(days: 90));
      expect(engine.retrievability(state, clock.now()), rAtPause);
      expect(engine.display(state, clock.now()).fading, isFalse);

      state = engine.resume(state, clock.now());
      expect(engine.retrievability(state, clock.now()), rAtPause);
    });

    test('reviewing a paused task is refused', () {
      final state = engine.pause(
        review(const ReviewState(), Rating.good).state,
        clock.now(),
      );
      expect(() => review(state, Rating.good), throwsStateError);
    });
  });

  group('rebuild', () {
    test('equals the incremental state for seeded random histories', () {
      for (var seed = 1; seed <= 8; seed++) {
        final random = Random(seed);
        final c = FakeClock(DateTime.utc(2026, 1, 1, 8));
        var incremental = const ReviewState();
        final reviews = <ReviewRecord>[];
        final pauses = <PauseInterval>[];
        DateTime? pauseStart;

        for (var step = 0; step < 30 + random.nextInt(30); step++) {
          c.advance(
            Duration(
              days: random.nextInt(20),
              minutes: random.nextInt(24 * 60),
            ),
          );
          final roll = random.nextDouble();
          if (incremental.started && pauseStart == null && roll < 0.08) {
            pauseStart = c.now();
            incremental = engine.pause(incremental, c.now());
          } else if (pauseStart != null) {
            if (roll < 0.5) {
              pauses.add(PauseInterval(start: pauseStart, end: c.now()));
              incremental = engine.resume(incremental, c.now());
              pauseStart = null;
            }
          } else {
            final rating = Rating.values[random.nextInt(4)];
            reviews.add(ReviewRecord(at: c.now(), rating: rating));
            incremental = engine
                .applyReview(incremental, rating, c.now())
                .state;
          }
        }
        if (pauseStart != null) pauses.add(PauseInterval(start: pauseStart));

        expect(
          engine.rebuild(reviews.reversed.toList(), pauses),
          incremental,
          reason: 'seed $seed',
        );
      }
    });

    test('of no reviews is the not-started state', () {
      expect(engine.rebuild(const []), const ReviewState());
    });
  });

  test('no file outside lib/engines/review imports fsrs', () {
    final offenders = checkImports(
      Directory('lib'),
    ).where((v) => v.contains('fsrs'));
    expect(offenders, isEmpty);
    final users = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.readAsStringSync().contains('package:fsrs/'))
        .map((f) => f.path.replaceAll(r'\', '/'))
        .toList();
    expect(users, ['lib/engines/review/fsrs_scheduler.dart']);
  });
}
