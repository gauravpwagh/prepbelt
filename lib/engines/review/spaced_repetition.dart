import 'package:freezed_annotation/freezed_annotation.dart';

import 'review_types.dart';

part 'spaced_repetition.freezed.dart';

/// Memory of a reviewed task, as a scheduler sees it.
@freezed
abstract class SrsMemory with _$SrsMemory {
  const factory SrsMemory({
    required double stability,
    required double difficulty,
    required DateTime lastReviewAt,
  }) = _SrsMemory;
}

/// A scheduler's answer to one review.
@freezed
abstract class SrsResult with _$SrsResult {
  const factory SrsResult({
    required double stability,
    required double difficulty,
    required DateTime dueAt,
  }) = _SrsResult;
}

/// Spaced-repetition maths, behind our own interface so the algorithm or
/// package can be replaced (CLAUDE.md rule 6).
abstract interface class SpacedRepetition {
  /// Applies [rating] at [at] to [memory] (null for the first review).
  SrsResult schedule(SrsMemory? memory, Rating rating, DateTime at);

  /// Predicted recall (0..1) of [memory] at [now].
  double retrievability(SrsMemory memory, DateTime now);
}
