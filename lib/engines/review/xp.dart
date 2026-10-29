import 'review_types.dart';

/// XP for one review: [perWeight] × the rating's weight, plus
/// [promotionBonus] when it earned a belt (docs/02-data-model.md, "XP and
/// streaks"). XP is derived from the Review log, never stored.
int xpForReview(
  Rating rating, {
  required bool promoted,
  required int perWeight,
  required List<int> ratingWeights,
  required int promotionBonus,
}) =>
    perWeight * ratingWeights[rating.value - 1] +
    (promoted ? promotionBonus : 0);
