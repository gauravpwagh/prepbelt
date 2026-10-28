import '../../core/config/review_config.dart';
import 'fsrs_scheduler.dart';
import 'review_types.dart';
import 'spaced_repetition.dart';

/// Level, shine and scheduling rules of docs/02-data-model.md. Pure: every
/// time comes in as a parameter, every number from [config].
final class ReviewEngine {
  ReviewEngine(this.config, {SpacedRepetition? srs})
    : srs = srs ?? FsrsScheduler(config);

  final ReviewConfig config;
  final SpacedRepetition srs;

  /// The level that stability [stability] (days) earns, 1..7. Level 1 is
  /// the floor for any started task.
  int levelFor(double stability) {
    var level = 1;
    for (final threshold in config.levelStabilityThresholds) {
      if (stability >= threshold) level++;
    }
    return level;
  }

  /// Stripes for retrievability [r]: one per cut-off reached (decision D3).
  int shineFor(double r) =>
      config.stripeThresholds.where((cutoff) => r >= cutoff).length;

  /// Current recall estimate, or null before the first review. Paused
  /// tasks do not decay: recall is frozen at the moment of pausing.
  double? retrievability(ReviewState state, DateTime now) {
    final memory = _memory(state);
    if (memory == null) return null;
    return srs.retrievability(memory, state.pausedAt ?? now);
  }

  /// What to show now. The displayed level drops by one (never below 1)
  /// while the task is overdue and recall is below the fading threshold;
  /// the stored level is untouched.
  LevelDisplay display(ReviewState state, DateTime now) {
    final r = retrievability(state, now);
    if (r == null) {
      return const LevelDisplay(level: 0, stripes: 0, fading: false);
    }
    final overdue =
        !state.paused && state.dueAt != null && now.isAfter(state.dueAt!);
    final fading = overdue && r < config.fadingRetrievability;
    return LevelDisplay(
      level: fading ? (state.level - 1).clamp(1, 7) : state.level,
      stripes: fading ? 0 : shineFor(r),
      fading: fading,
      retrievability: r,
    );
  }

  /// The level to show at [now]. See [display].
  int displayedLevel(ReviewState state, DateTime now) =>
      display(state, now).level;

  /// Applies one review. The first review sets level 1; later ones move
  /// towards [levelFor] the new stability, up by at most
  /// `maxPromotionPerReview` (decision D2), down as far as it says.
  ReviewOutcome applyReview(ReviewState state, Rating rating, DateTime at) {
    if (state.paused) {
      throw StateError('Resume a paused task before reviewing it');
    }
    final result = srs.schedule(_memory(state), rating, at);
    final before = state.level;
    final after = state.started
        ? _clampLevel(
            [
              before + config.maxPromotionPerReview,
              levelFor(result.stability),
            ].reduce((a, b) => a < b ? a : b),
          )
        : 1;
    final next = state.copyWith(
      level: after,
      stability: result.stability,
      difficulty: result.difficulty,
      lastReviewAt: at,
      dueAt: result.dueAt,
      reps: state.reps + 1,
      lapses: state.lapses + (state.started && rating == Rating.forgot ? 1 : 0),
    );
    return ReviewOutcome(
      state: next,
      levelBefore: before,
      levelAfter: after,
      stabilityAfter: result.stability,
      dueAfter: result.dueAt,
    );
  }

  /// Freezes decay from [at]. Pausing a paused task changes nothing.
  ReviewState pause(ReviewState state, DateTime at) =>
      state.paused ? state : state.copyWith(pausedAt: at);

  /// Ends a pause at [at]: the due date and the decay anchor both move
  /// later by the paused duration (decision D6).
  ReviewState resume(ReviewState state, DateTime at) {
    final pausedAt = state.pausedAt;
    if (pausedAt == null) return state;
    final shift = at.difference(pausedAt);
    return state.copyWith(
      pausedAt: null,
      dueAt: state.dueAt?.add(shift),
      lastReviewAt: state.lastReviewAt?.add(shift),
    );
  }

  /// Recomputes a task's state from its review log and pause history
  /// (decision D4). Equal to applying the same events one by one.
  ReviewState rebuild(
    List<ReviewRecord> reviews, [
    List<PauseInterval> pauses = const [],
  ]) {
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
        _Event(review: final r?) => applyReview(state, r.rating, r.at).state,
        _Event(pause: true) => pause(state, e.at),
        _ => resume(state, e.at),
      };
    }
    return state;
  }

  static int _clampLevel(int level) => level.clamp(1, 7);

  static SrsMemory? _memory(ReviewState s) =>
      s.stability == null || s.difficulty == null || s.lastReviewAt == null
      ? null
      : SrsMemory(
          stability: s.stability!,
          difficulty: s.difficulty!,
          lastReviewAt: s.lastReviewAt!,
        );
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
