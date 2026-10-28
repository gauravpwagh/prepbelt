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

  /// Good and Easy earn the next belt; Forgot and Hard do not.
  bool get passed => this == good || this == easy;

  static Rating fromValue(int value) =>
      values.firstWhere((r) => r.value == value);
}

/// The review engine's view of one task: the fields of the `TaskState`
/// cache, with times as UTC [DateTime]s.
@freezed
abstract class ReviewState with _$ReviewState {
  const factory ReviewState({
    /// 0 = not started, 1..7 = belt.
    @Default(0) int level,

    /// Scheduled reviews passed so far (beyond the schedule, voluntary
    /// reviews keep counting).
    @Default(0) int step,

    /// Dim steps from reviews that were not Good. Reset by a Good review.
    /// Above 0 means the current step is being retried.
    @Default(0) int dim,

    /// Time of the last review. Shifted forward by pauses (decision D6).
    DateTime? lastReviewAt,

    /// When the next review is due; null when none is scheduled.
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
    required int stepAfter,
    DateTime? dueAfter,
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
    /// The belt, 0 when not started. Never lowered by fading.
    required int level,

    /// 0 = full brightness .. maxDimSteps = faded.
    required int dim,

    /// Brightness as stripes: 2 at full brightness, then 1, then 0.
    required int stripes,

    /// Dimmed as far as it goes: drawn faded with the word "fading".
    required bool fading,

    /// A scheduled review is past due.
    required bool overdue,
  }) = _LevelDisplay;
}
