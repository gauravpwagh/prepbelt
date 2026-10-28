import 'package:fsrs/fsrs.dart' as fsrs;

import '../../core/config/review_config.dart';
import 'review_types.dart';
import 'spaced_repetition.dart';

/// [SpacedRepetition] backed by the `fsrs` package. The only file in the
/// app that imports it.
///
/// No learning or relearning steps (sessions are at most daily) and no
/// fuzz (rebuild must be deterministic): decision D7.
final class FsrsScheduler implements SpacedRepetition {
  FsrsScheduler(ReviewConfig config)
    : _scheduler = fsrs.Scheduler(
        parameters: config.fsrsParameters ?? fsrs.defaultParameters,
        desiredRetention: config.retentionTarget,
        learningSteps: const [],
        relearningSteps: const [],
        maximumInterval: config.fsrsMaximumIntervalDays,
        enableFuzzing: false,
      );

  final fsrs.Scheduler _scheduler;

  @override
  SrsResult schedule(SrsMemory? memory, Rating rating, DateTime at) {
    final reviewed = _scheduler
        .reviewCard(
          _card(memory, at),
          fsrs.Rating.fromValue(rating.value),
          reviewDateTime: at.toUtc(),
        )
        .card;
    return SrsResult(
      stability: reviewed.stability!,
      difficulty: reviewed.difficulty!,
      dueAt: reviewed.due,
    );
  }

  @override
  double retrievability(SrsMemory memory, DateTime now) => _scheduler
      .getCardRetrievability(_card(memory, now), currentDateTime: now.toUtc());

  static fsrs.Card _card(SrsMemory? memory, DateTime at) => memory == null
      ? fsrs.Card(cardId: 0, due: at.toUtc())
      : fsrs.Card(
          cardId: 0,
          state: fsrs.State.review,
          stability: memory.stability,
          difficulty: memory.difficulty,
          lastReview: memory.lastReviewAt.toUtc(),
          due: at.toUtc(),
        );
}
