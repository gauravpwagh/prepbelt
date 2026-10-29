import 'dart:math';

import '../../core/config/effort_config.dart';

/// What a chunk is measured in. Mirrors `UnitType` without importing the
/// database layer.
enum EffortUnit { page, minute, question, item }

/// First-read estimate in minutes (docs/04-planner-spec.md):
/// `units × pace × d[difficulty] × f[familiarity]`.
///
/// [difficulty] is 1 Easy .. 3 Hard and [familiarity] 0 New .. 2
/// Comfortable, as stored in ChunkSurvey; unsurveyed chunks count as
/// Medium and New.
double firstReadMinutes({
  required int units,
  required EffortUnit unit,
  int difficulty = 2,
  int familiarity = 0,
  EffortConfig config = const EffortConfig(),
  double? pace,
}) {
  final perUnit =
      pace ??
      switch (unit) {
        EffortUnit.page => config.pacePage,
        EffortUnit.minute => config.paceVideoMinute,
        EffortUnit.question => config.paceQuestion,
        EffortUnit.item => config.paceItem,
      };
  return max(0, units) *
      perUnit *
      config.difficultyFactors[(difficulty - 1).clamp(0, 2)] *
      config.familiarityFactors[familiarity.clamp(0, 2)];
}

/// Minutes rounded to the nearest 5, as the survey shows them.
int roundToFive(double minutes) => (minutes / 5).round() * 5;

/// How many reading sessions a first read takes (at most
/// [EffortConfig.maxReadingSession] minutes each).
int readingSessions(
  double minutes, {
  EffortConfig config = const EffortConfig(),
}) => max(1, (minutes / config.maxReadingSession).ceil());

/// A review's estimate (docs/04-planner-spec.md): the first review is
/// [EffortConfig.firstReviewShare] of the first read, later ones
/// [EffortConfig.laterReviewShare], clamped to the review bounds.
int reviewMinutes(
  double firstRead, {
  required bool firstReview,
  EffortConfig config = const EffortConfig(),
}) =>
    (firstRead *
            (firstReview ? config.firstReviewShare : config.laterReviewShare))
        .round()
        .clamp(config.reviewMinMinutes, config.reviewMaxMinutes);
