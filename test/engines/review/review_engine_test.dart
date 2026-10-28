import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/engines/review/review_engine.dart';
import 'package:prepbelt/engines/review/review_types.dart';

void main() {
  late FakeClock clock;
  late ReviewEngine engine;

  /// 10 Jan 2027 exam: reviews may be due until midnight starting exam day.
  final exam = DateTime.utc(2027, 1, 10);

  setUp(() {
    clock = FakeClock(DateTime.utc(2026, 10, 28, 9));
    engine = ReviewEngine(const ReviewConfig());
  });

  ReviewOutcome review(ReviewState s, Rating rating, {DateTime? deadline}) =>
      engine.applyReview(s, rating, clock.now(), deadline: deadline);

  /// First read plus Good reviews on each due date; returns every outcome.
  List<ReviewOutcome> goodHistory(int reviews, {DateTime? deadline}) {
    var state = const ReviewState();
    final outcomes = <ReviewOutcome>[];
    for (var i = 0; i <= reviews; i++) {
      final out = review(state, Rating.good, deadline: deadline);
      outcomes.add(out);
      state = out.state;
      if (state.dueAt != null) clock.set(state.dueAt!);
    }
    return outcomes;
  }

  group('belts', () {
    test('the first read earns White and each Good review the next belt, '
        'in order: 5 scheduled reviews reach Brown', () {
      final outs = goodHistory(5, deadline: exam);
      expect(outs.map((o) => o.levelAfter), [1, 2, 3, 4, 5, 6]);
      expect(outs.map((o) => o.stepAfter), [0, 1, 2, 3, 4, 5]);
      expect(outs.last.dueAfter, isNull, reason: 'schedule complete');
    });

    test('even an Easy first read earns only White', () {
      expect(review(const ReviewState(), Rating.easy).levelAfter, 1);
    });

    test('Black needs one more review after the schedule, by choice', () {
      final brown = goodHistory(5, deadline: exam).last.state;
      clock.advance(const Duration(days: 2));
      final out = review(brown, Rating.good, deadline: exam);
      expect(out.levelAfter, 7);
      expect(review(out.state, Rating.good).levelAfter, 7, reason: 'top');
    });

    test('a review that is not Good keeps the belt, dims it, repeats the '
        'step the next day, and a Good review then promotes', () {
      final state = goodHistory(2, deadline: exam).last.state; // Orange
      final hard = review(state, Rating.hard, deadline: exam);
      expect(hard.levelAfter, state.level);
      expect(hard.stepAfter, state.step);
      expect(hard.state.dim, 1);
      expect(hard.state.lapses, 1);
      expect(hard.dueAfter, clock.now().add(const Duration(days: 1)));

      clock.set(hard.dueAfter!);
      final forgot = review(hard.state, Rating.forgot, deadline: exam);
      expect(forgot.state.dim, 2);
      expect(forgot.levelAfter, state.level);

      clock.set(forgot.dueAfter!);
      final good = review(forgot.state, Rating.good, deadline: exam);
      expect(good.levelAfter, state.level + 1);
      expect(good.state.dim, 0);
    });
  });

  group('targets set the number of reviews', () {
    test('one review per belt above White, capped at the full schedule', () {
      expect(engine.plannedReviewsFor(7), 5, reason: 'High → Black');
      expect(engine.plannedReviewsFor(5), 4, reason: 'Medium → Blue');
      expect(engine.plannedReviewsFor(4), 3, reason: 'Low → Green');
      expect(engine.plannedReviewsFor(2), 1);
      expect(engine.plannedReviewsFor(1), 1, reason: 'at least one');
      expect(engine.plannedReviewsFor(null), 5);
    });

    test('a Blue target plans 4 reviews with growing gaps before the exam; '
        'more reviews by choice still earn belts', () {
      var state = const ReviewState();
      final times = <DateTime>[];
      final levels = <int>[];
      while (true) {
        final out = engine.applyReview(
          state,
          Rating.good,
          clock.now(),
          deadline: exam,
          planned: 4,
        );
        times.add(clock.now());
        levels.add(out.levelAfter);
        state = out.state;
        if (state.dueAt == null) break;
        clock.set(state.dueAt!);
      }
      expect(levels, [1, 2, 3, 4, 5]);
      final gaps = [
        for (var i = 1; i < times.length; i++)
          times[i].difference(times[i - 1]).inDays,
      ];
      for (var i = 1; i < gaps.length; i++) {
        expect(gaps[i], greaterThan(gaps[i - 1]), reason: 'gaps $gaps');
      }
      expect(exam.difference(times.last).inDays, lessThan(10));

      clock.advance(const Duration(hours: 2));
      final extra = engine.applyReview(state, Rating.good, clock.now());
      expect(extra.levelAfter, 6);
    });
  });

  group('schedule', () {
    test('5 reviews with growing gaps, all before the exam', () {
      final outs = goodHistory(5, deadline: exam);
      final times = [for (final o in outs) o.state.lastReviewAt!];
      final gaps = [
        for (var i = 1; i < times.length; i++)
          times[i].difference(times[i - 1]).inDays,
      ];
      expect(gaps, hasLength(5));
      for (var i = 1; i < gaps.length; i++) {
        expect(gaps[i], greaterThan(gaps[i - 1]), reason: 'gaps $gaps');
      }
      expect(times.last.isAfter(exam), isFalse);
      expect(exam.difference(times.last).inDays, lessThan(7));
    });

    test('a close exam crams all 5 reviews into the days left', () {
      final close = clock.now().add(const Duration(days: 6));
      final outs = goodHistory(5, deadline: close);
      expect(outs.last.levelAfter, 6);
      for (final o in outs) {
        expect(o.state.lastReviewAt!.isAfter(close), isFalse);
      }
    });

    test('without an exam the gaps are 1, 3, 7, 14 and 30 days', () {
      final outs = goodHistory(5);
      final gaps = [
        for (var i = 1; i < outs.length; i++)
          outs[i].state.lastReviewAt!
              .difference(outs[i - 1].state.lastReviewAt!)
              .inDays,
      ];
      expect(gaps, [1, 3, 7, 14, 30]);
    });

    test('an early review counts as the next step and the rest re-fit', () {
      final first = review(const ReviewState(), Rating.good, deadline: exam);
      clock.set(first.dueAfter!.subtract(const Duration(days: 3)));
      final early = review(first.state, Rating.good, deadline: exam);
      expect(early.stepAfter, 1);
      expect(early.levelAfter, 2);
      expect(early.dueAfter!.isAfter(clock.now()), isTrue);
      expect(early.dueAfter!.isAfter(exam), isFalse);
    });

    test('nothing is scheduled after the exam deadline', () {
      final state = review(const ReviewState(), Rating.good).state;
      clock.set(exam.add(const Duration(hours: 9)));
      expect(review(state, Rating.hard, deadline: exam).dueAfter, isNull);
      expect(review(state, Rating.good, deadline: exam).dueAfter, isNull);
    });

    test('changing the configuration changes the schedule without code '
        'changes', () {
      final short = ReviewEngine(
        ReviewConfig.fromSettings({
          SettingKeys.scheduledReviews: 3,
          SettingKeys.reviewGapDaysWithoutExam: [2, 4, 8],
        }),
      );
      var state = const ReviewState();
      final levels = <int>[];
      final gaps = <int>[];
      for (var i = 0; i < 4; i++) {
        if (state.lastReviewAt != null) {
          gaps.add(clock.now().difference(state.lastReviewAt!).inDays);
        }
        final out = short.applyReview(state, Rating.good, clock.now());
        levels.add(out.levelAfter);
        state = out.state;
        if (state.dueAt != null) clock.set(state.dueAt!);
      }
      expect(gaps, [2, 4, 8]);
      expect(levels, [1, 2, 3, 4]);
      expect(state.dueAt, isNull);
    });
  });

  group('brightness', () {
    test('an overdue belt dims gradually without dropping, and one Good '
        'review restores it', () {
      final state = goodHistory(3, deadline: exam).last.state; // Green
      final due = state.dueAt!;
      LevelDisplay at(Duration after) => engine.display(state, due.add(after));

      expect(engine.display(state, due).dim, 0);
      expect(engine.display(state, due).stripes, 2);
      expect(at(const Duration(hours: 1)).dim, 1);
      expect(at(const Duration(hours: 1)).stripes, 1);
      expect(at(const Duration(days: 2, hours: 1)).dim, 2);
      expect(at(const Duration(days: 4, hours: 1)).fading, isTrue);
      expect(at(const Duration(days: 40)).dim, Defaults.maxDimSteps);
      expect(at(const Duration(days: 40)).level, state.level);
      expect(
        engine.displayedLevel(state, due.add(const Duration(days: 40))),
        state.level,
      );

      clock.set(due.add(const Duration(days: 5)));
      final restored = review(state, Rating.good, deadline: exam).state;
      final shown = engine.display(restored, clock.now());
      expect(shown.dim, 0);
      expect(shown.stripes, 2);
      expect(shown.fading, isFalse);
    });

    test('not started shows no belt', () {
      final shown = engine.display(const ReviewState(), clock.now());
      expect(shown.level, 0);
      expect(shown.overdue, isFalse);
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

    test('with an exam, resuming re-fits the schedule before it', () {
      final state = review(
        const ReviewState(),
        Rating.good,
        deadline: exam,
      ).state;
      final paused = engine.pause(state, clock.now());
      clock.advance(const Duration(days: 30));
      final resumed = engine.resume(paused, clock.now(), deadline: exam);
      expect(resumed.dueAt!.isAfter(clock.now()), isTrue);
      expect(resumed.dueAt!.isAfter(exam), isFalse);
    });

    test('paused tasks do not fade and cannot be reviewed', () {
      final state = review(const ReviewState(), Rating.good).state;
      final paused = engine.pause(state, clock.now());
      final later = clock.now().add(const Duration(days: 60));
      expect(engine.display(paused, later).dim, 0);
      expect(() => review(paused, Rating.good), throwsStateError);
    });
  });

  group('rebuild', () {
    for (final withExam in [false, true]) {
      test('equals the incremental state for seeded random histories '
          '(${withExam ? 'with' : 'without'} an exam)', () {
        for (var seed = 1; seed <= 8; seed++) {
          final random = Random(seed);
          final c = FakeClock(DateTime.utc(2026, 9, 1, 8));
          final deadline = withExam ? DateTime.utc(2027, 3, 1) : null;
          var incremental = const ReviewState();
          final reviews = <ReviewRecord>[];
          final pauses = <PauseInterval>[];
          DateTime? pauseStart;

          for (var step = 0; step < 20 + random.nextInt(20); step++) {
            c.advance(
              Duration(
                days: random.nextInt(12),
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
                incremental = engine.resume(
                  incremental,
                  c.now(),
                  deadline: deadline,
                );
                pauseStart = null;
              }
            } else {
              final rating = Rating.values[random.nextInt(4)];
              reviews.add(ReviewRecord(at: c.now(), rating: rating));
              incremental = engine
                  .applyReview(incremental, rating, c.now(), deadline: deadline)
                  .state;
            }
          }
          if (pauseStart != null) pauses.add(PauseInterval(start: pauseStart));

          expect(
            engine.rebuild(
              reviews.reversed.toList(),
              pauses: pauses,
              deadline: deadline,
            ),
            incremental,
            reason: 'seed $seed',
          );
        }
      });
    }

    test('of no reviews is the not-started state', () {
      expect(engine.rebuild(const []), const ReviewState());
    });
  });
}
