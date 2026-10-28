import 'dart:math';

import '../../core/config/review_config.dart';
import 'review_types.dart';

/// Belt and review-schedule rules of docs/02-data-model.md. Pure: every
/// time comes in as a parameter, every number from [config].
///
/// A task is first read (White), then reviewed [ReviewConfig.scheduledReviews]
/// times with growing gaps that all fit before the exam. Each Good review
/// earns the next belt; one that is not Good keeps the belt, dims it and
/// repeats the step. [deadline] is the latest time a review may be due
/// (the end of the day before the exam), or null when there is no exam.
final class ReviewEngine {
  ReviewEngine(this.config);

  final ReviewConfig config;

  static const _maxLevel = 7;

  /// Applies one review at [at]. Reviewing before the due date is allowed
  /// and counts as the next step; the remaining gaps re-fit.
  ReviewOutcome applyReview(
    ReviewState state,
    Rating rating,
    DateTime at, {
    DateTime? deadline,
  }) {
    if (state.paused) {
      throw StateError('Resume a paused task before reviewing it');
    }
    final ReviewState next;
    if (!state.started) {
      // The first read always earns White.
      next = state.copyWith(level: 1, step: 0, dim: 0);
    } else if (rating.passed) {
      next = state.copyWith(
        level: min(_maxLevel, state.level + 1),
        step: state.step + 1,
        dim: 0,
      );
    } else {
      next = state.copyWith(
        dim: min(config.maxDimSteps, state.dim + 1),
        lapses: state.lapses + 1,
      );
    }
    final reviewed = next.copyWith(reps: state.reps + 1, lastReviewAt: at);
    final scheduled = reviewed.copyWith(
      dueAt: dueFor(reviewed, deadline: deadline),
    );
    return ReviewOutcome(
      state: scheduled,
      levelBefore: state.level,
      levelAfter: scheduled.level,
      stepAfter: scheduled.step,
      dueAfter: scheduled.dueAt,
    );
  }

  /// When the next review is due: a retry after [ReviewConfig.retryGapDays]
  /// if the last review was not Good, otherwise the next scheduled step,
  /// with the remaining gaps fitted before [deadline] in the proportions of
  /// [ReviewConfig.gapWeights]. Null when nothing is left to schedule.
  DateTime? dueFor(ReviewState state, {DateTime? deadline}) {
    final last = state.lastReviewAt;
    if (last == null) return null;

    // No review is scheduled after the deadline; past it, nothing is due.
    DateTime? capped(DateTime due) {
      if (deadline == null) return due;
      if (!deadline.isAfter(last)) return null;
      return due.isAfter(deadline) ? deadline : due;
    }

    if (state.dim > 0) {
      return capped(last.add(Duration(days: config.retryGapDays)));
    }
    final remaining = config.scheduledReviews - state.step;
    if (remaining <= 0) return null;

    if (deadline == null) {
      final gaps = config.gapDaysWithoutExam;
      return last.add(Duration(days: gaps[min(state.step, gaps.length - 1)]));
    }

    final daysLeft = deadline.difference(last).inDays;
    if (daysLeft < 1) return deadline.isAfter(last) ? deadline : null;
    final weights = [
      for (var i = state.step; i < config.scheduledReviews; i++)
        config.gapWeights[min(i, config.gapWeights.length - 1)],
    ];
    final total = weights.reduce((a, b) => a + b);
    final share = (daysLeft * weights.first / total).round();
    // Leave at least a day for each later review when time allows.
    final gap = max(1, min(share, daysLeft - (remaining - 1)));
    return last.add(Duration(days: gap));
  }

  /// How far the belt is dimmed at [now]: one step per review that was not
  /// Good, plus one once a review is overdue and another every
  /// [ReviewConfig.overdueDaysPerDimStep] days after. Paused tasks do not
  /// fade.
  int dimAt(ReviewState state, DateTime now) {
    final due = state.dueAt;
    var dim = state.dim;
    if (!state.paused && due != null && now.isAfter(due)) {
      dim += 1 + now.difference(due).inDays ~/ config.overdueDaysPerDimStep;
    }
    return min(config.maxDimSteps, dim);
  }

  /// What to show now. The belt itself never drops; it dims instead.
  LevelDisplay display(ReviewState state, DateTime now) {
    if (!state.started) {
      return const LevelDisplay(
        level: 0,
        dim: 0,
        stripes: 0,
        fading: false,
        overdue: false,
      );
    }
    final dim = dimAt(state, now);
    return LevelDisplay(
      level: state.level,
      dim: dim,
      stripes: max(0, 2 - dim),
      fading: dim >= config.maxDimSteps,
      overdue:
          !state.paused && state.dueAt != null && now.isAfter(state.dueAt!),
    );
  }

  /// The belt to show at [now]: always the stored level.
  int displayedLevel(ReviewState state, DateTime now) =>
      display(state, now).level;

  /// Freezes the task from [at]: no fading, nothing due. Pausing a paused
  /// task changes nothing.
  ReviewState pause(ReviewState state, DateTime at) =>
      state.paused ? state : state.copyWith(pausedAt: at);

  /// Ends a pause at [at]. The last review time moves later by the paused
  /// duration and the schedule re-fits from there (decision D6): without
  /// an exam the due date moves by exactly the paused time.
  ReviewState resume(ReviewState state, DateTime at, {DateTime? deadline}) {
    final pausedAt = state.pausedAt;
    if (pausedAt == null) return state;
    final shifted = state.copyWith(
      pausedAt: null,
      lastReviewAt: state.lastReviewAt?.add(at.difference(pausedAt)),
    );
    return shifted.copyWith(dueAt: dueFor(shifted, deadline: deadline));
  }

  /// Recomputes a task's state from its review log and pause history
  /// (decision D4). Equal to applying the same events one by one with the
  /// same [deadline].
  ReviewState rebuild(
    List<ReviewRecord> reviews, {
    List<PauseInterval> pauses = const [],
    DateTime? deadline,
  }) {
    final events = <_Event>[
      for (final r in reviews) _Event(r.at, r.order, 1, review: r),
      for (final p in pauses) ...[
        _Event(p.start, p.order, 0, pause: true),
        if (p.end != null) _Event(p.end!, p.order, 2, pause: false),
      ],
    ]..sort();

    var state = const ReviewState();
    for (final e in events) {
      state = switch (e) {
        _Event(review: final r?) => applyReview(
          state,
          r.rating,
          r.at,
          deadline: deadline,
        ).state,
        _Event(pause: true) => pause(state, e.at),
        _ => resume(state, e.at, deadline: deadline),
      };
    }
    return state;
  }
}

/// A replayed event. Sorted by time, then by row order, then pause start
/// before review before pause end.
final class _Event implements Comparable<_Event> {
  _Event(this.at, this.order, this.rank, {this.review, this.pause});

  final DateTime at;
  final String order;
  final int rank;
  final ReviewRecord? review;
  final bool? pause;

  @override
  int compareTo(_Event other) {
    final byTime = at.compareTo(other.at);
    if (byTime != 0) return byTime;
    final byOrder = order.compareTo(other.order);
    if (byOrder != 0) return byOrder;
    return rank.compareTo(other.rank);
  }
}
