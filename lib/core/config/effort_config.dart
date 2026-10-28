import 'defaults.dart';

/// Effort-model inputs (docs/04-planner-spec.md, "Estimating effort").
/// Pure Dart, so engines may depend on it.
final class EffortConfig {
  const EffortConfig({
    this.pacePage = Defaults.pacePageMin,
    this.paceVideoMinute = Defaults.paceVideoMinuteMin,
    this.paceQuestion = Defaults.paceQuestionMin,
    this.paceItem = Defaults.paceItemMin,
    this.difficultyFactors = Defaults.difficultyFactors,
    this.familiarityFactors = Defaults.familiarityFactors,
    this.maxReadingSession = Defaults.maxReadingSessionMinutes,
  });

  final double pacePage;
  final double paceVideoMinute;
  final double paceQuestion;
  final double paceItem;

  /// Easy, Medium, Hard.
  final List<double> difficultyFactors;

  /// New, Seen it, Comfortable.
  final List<double> familiarityFactors;
  final int maxReadingSession;
}
