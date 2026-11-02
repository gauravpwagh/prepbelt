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

  /// First read plus Solid reviews on each due date, until nothing more is
  /// due or [max] reviews; returns every outcome.
  List<ReviewOutcome> solidHistory({DateTime? deadline, int max = 12}) {
    var state = const ReviewState();
    final outcomes = <ReviewOutcome>[];
    for (var i = 0; i <= max; i++) {
      final out = review(state, Rating.solid, deadline: deadline);
      outcomes.add(out);
      state = out.state;
      if (state.dueAt == null) break;
      clock.set(state.dueAt!);
    }
    return outcomes;
  }

  /// Days between consecutive reviews of [outs].
  List<int> gapsOf(List<ReviewOutcome> outs) => [
    for (var i = 1; i < outs.length; i++)
      outs[i].state.lastReviewAt!
          .difference(outs[i - 1].state.lastReviewAt!)
          .inDays,
  ];

  group('belts', () {
    test('the first read earns White and each Solid review the next belt: '
        'the sixth reaches Black', () {
      final outs = solidHistory(deadline: exam);
      expect(outs.map((o) => o.levelAfter), [1, 2, 3, 4, 5, 6, 7]);
      expect(outs.map((o) => o.stepAfter), [0, 1, 2, 3, 4, 5, 6]);
      expect(outs.last.dueAfter, isNull, reason: 'nothing after the final');
    });

    test('a first read earns only White, whatever its rating', () {
      expect(review(const ReviewState(), Rating.forgot).levelAfter, 1);
    });

    test('a Shaky or Forgot review keeps the belt, dims it, repeats the step '
        'the next day, and a Solid review then promotes', () {
      final state = solidHistory(deadline: exam, max: 2).last.state; // Orange
      final shaky = review(state, Rating.shaky, deadline: exam);
      expect(shaky.levelAfter, state.level);
      expect(shaky.stepAfter, state.step);
      expect(shaky.state.dim, 1);
      expect(shaky.state.lapses, 1);
      expect(shaky.dueAfter, clock.now().add(const Duration(days: 1)));

      clock.set(shaky.dueAfter!);
      final forgot = review(shaky.state, Rating.forgot, deadline: exam);
      expect(forgot.state.dim, 2);
      expect(forgot.levelAfter, state.level);

      clock.set(forgot.dueAfter!);
      final solid = review(forgot.state, Rating.solid, deadline: exam);
      expect(solid.levelAfter, state.level + 1);
      expect(solid.state.dim, 0);
    });

    test('ratings stored before D53 read as the new ones', () {
      expect(Rating.fromValue(1), Rating.forgot);
      expect(Rating.fromValue(2), Rating.shaky, reason: 'Hard');
      expect(Rating.fromValue(3), Rating.solid, reason: 'Good');
      expect(Rating.fromValue(4), Rating.solid, reason: 'Easy');
    });
  });

  group('schedule (D53)', () {
    test('without an exam: 1, 3, 7, 14, 30, 60 days, then 60 again', () {
      expect(gapsOf(solidHistory(max: 7)), [1, 3, 7, 14, 30, 60, 60]);
    });

    test('an exam 73 days away: the default gaps, then a final review on '
        'the last day because 60 more would pass it', () {
      final outs = solidHistory(deadline: exam);
      final gaps = gapsOf(outs);
      expect(gaps.take(5), [1, 3, 7, 14, 30]);
      expect(gaps, hasLength(6));
      expect(outs.last.state.lastReviewAt, exam);
    });

    test('an exam 60 days away: no final review when fewer than 7 days are '
        'left after the fifth', () {
      final outs = solidHistory(deadline: DateTime.utc(2026, 12, 27));
      expect(gapsOf(outs), [1, 3, 7, 14, 30]);
      expect(outs.last.levelAfter, 6);
    });

    test('an exam 40 days away squeezes 5 reviews in, a day first', () {
      final close = DateTime.utc(2026, 12, 7);
      final outs = solidHistory(deadline: close);
      expect(gapsOf(outs), [1, 2, 5, 10, 21]);
      expect(outs.last.state.lastReviewAt!.isAfter(close), isFalse);
    });

    test('with fewer than 6 days left, one review a day', () {
      final outs = solidHistory(deadline: DateTime.utc(2026, 11, 1));
      expect(gapsOf(outs), [1, 1, 1]);
    });

    test('an early review counts as the next step and the rest re-fit', () {
      final first = review(const ReviewState(), Rating.solid, deadline: exam);
      clock.set(first.dueAfter!.subtract(const Duration(hours: 12)));
      final early = review(first.state, Rating.solid, deadline: exam);
      expect(early.stepAfter, 1);
      expect(early.levelAfter, 2);
      expect(early.dueAfter!.isAfter(clock.now()), isTrue);
      expect(early.dueAfter!.isAfter(exam), isFalse);
    });

    test('nothing is scheduled after the exam deadline', () {
      final state = review(const ReviewState(), Rating.solid).state;
      clock.set(exam.add(const Duration(hours: 9)));
      expect(review(state, Rating.shaky, deadline: exam).dueAfter, isNull);
      expect(review(state, Rating.solid, deadline: exam).dueAfter, isNull);
    });

    test('planned reviews: those that fit before the exam, or six', () {
      const fresh = ReviewState();
      final now = clock.now();
      expect(engine.plannedReviews(fresh, now, deadline: exam), 6);
      expect(
        engine.plannedReviews(fresh, now, deadline: DateTime.utc(2026, 12, 7)),
        5,
      );
      expect(engine.plannedReviews(fresh, now), 6);
    });

    test('changing the configuration changes the schedule without code '
        'changes', () {
      final short = ReviewEngine(
        ReviewConfig.fromSettings({
          SettingKeys.reviewGapDays: [2, 4, 8],
        }),
      );
      var state = const ReviewState();
      final gaps = <int>[];
      for (var i = 0; i < 5; i++) {
        if (state.lastReviewAt != null) {
          gaps.add(clock.now().difference(state.lastReviewAt!).inDays);
        }
        state = short.applyReview(state, Rating.solid, clock.now()).state;
        clock.set(state.dueAt!);
      }
      expect(gaps, [2, 4, 8, 8]);
    });

    test('gaps from settings must be whole days, 1 to 365, never shorter '
        'than the one before', () {
      expect(ReviewConfig.validGapDays([1, 3, 3, 10]), [1, 3, 3, 10]);
      expect(ReviewConfig.validGapDays([3, 1]), isNull);
      expect(ReviewConfig.validGapDays([0, 2]), isNull);
      expect(ReviewConfig.validGapDays([1.5]), isNull);
      expect(ReviewConfig.validGapDays([400]), isNull);
      expect(ReviewConfig.validGapDays(<int>[]), isNull);
      expect(ReviewConfig.validGapDays('1,3'), isNull);
      expect(
        ReviewConfig.fromSettings({SettingKeys.reviewGapDays: [5, 2]}).gapDays,
        Defaults.reviewGapDays,
      );
    });
  });

  group('brightness', () {
    test('an overdue belt dims gradually without dropping, and one Solid '
        'review restores it', () {
      final state = solidHistory(deadline: exam, max: 3).last.state; // Green
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
      final restored = review(state, Rating.solid, deadline: exam).state;
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
      final state = review(const ReviewState(), Rating.solid).state;
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
        Rating.solid,
        deadline: exam,
      ).state;
      final paused = engine.pause(state, clock.now());
      clock.advance(const Duration(days: 30));
      final resumed = engine.resume(paused, clock.now(), deadline: exam);
      expect(resumed.dueAt!.isAfter(clock.now()), isTrue);
      expect(resumed.dueAt!.isAfter(exam), isFalse);
    });

    test('paused tasks do not fade and cannot be reviewed', () {
      final state = review(const ReviewState(), Rating.solid).state;
      final paused = engine.pause(state, clock.now());
      final later = clock.now().add(const Duration(days: 60));
      expect(engine.display(paused, later).dim, 0);
      expect(() => review(paused, Rating.solid), throwsStateError);
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
              final rating = Rating.values[random.nextInt(3)];
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
