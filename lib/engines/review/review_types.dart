import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_types.freezed.dart';

/// How well the student recalled a task. Values match `Review.rating`.
enum Rating {
  forgot(1),
  hard(2),
  good(3),
  easy(4);

  const Rating(this.value);

  final int value;

  static Rating fromValue(int value) =>
      values.firstWhere((r) => r.value == value);
}

/// The review engine's view of one task's mastery: the fields of the
/// `TaskState` cache, with times as UTC [DateTime]s.
@freezed
abstract class ReviewState with _$ReviewState {
  const factory ReviewState({
    /// 0 = not started, 1..7 = stored level.
    @Default(0) int level,
    double? stability,
    double? difficulty,

    /// Anchor for decay. Shifted forward by pauses (decision D6).
    DateTime? lastReviewAt,
    DateTime? dueAt,
    @Default(0) int reps,
    @Default(0) int lapses,
    DateTime? pausedAt,
  }) = _ReviewState;

  const ReviewState._();

  bool get started => reps > 0;
  bool get paused => pausedAt != null;
}

/// The result of one review.
@freezed
abstract class ReviewOutcome with _$ReviewOutcome {
  const factory ReviewOutcome({
    required ReviewState state,
    required int levelBefore,
    required int levelAfter,
    required double stabilityAfter,
    required DateTime dueAfter,
  }) = _ReviewOutcome;
}

/// One logged review, as replayed by `rebuild`.
@freezed
abstract class ReviewRecord with _$ReviewRecord {
  const factory ReviewRecord({
    required DateTime at,
    required Rating rating,

    /// Tie-breaker for events at the same instant (the row's HLC).
    @Default('') String order,
  }) = _ReviewRecord;
}

/// A period during which a task was paused. [end] is null while it still is.
@freezed
abstract class PauseInterval with _$PauseInterval {
  const factory PauseInterval({
    required DateTime start,
    DateTime? end,
    @Default('') String order,
  }) = _PauseInterval;
}

/// What a badge should show right now.
@freezed
abstract class LevelDisplay with _$LevelDisplay {
  const factory LevelDisplay({
    /// Displayed level: the stored level, one lower while fading.
    required int level,

    /// Shine as a stripe count.
    required int stripes,

    /// Overdue with recall below the fading threshold.
    required bool fading,

    /// Current recall estimate, null when not started.
    double? retrievability,
  }) = _LevelDisplay;
}
