import 'defaults.dart';

/// Tunable inputs of the review engine, merged from [Defaults] and the
/// `Setting` table. Pure Dart, so engines may depend on it.
final class ReviewConfig {
  const ReviewConfig({
    this.scheduledReviews = Defaults.scheduledReviews,
    this.gapWeights = Defaults.reviewGapWeights,
    this.gapDaysWithoutExam = Defaults.reviewGapDaysWithoutExam,
    this.retryGapDays = Defaults.retryGapDays,
    this.lastReviewDaysBeforeExam = Defaults.lastReviewDaysBeforeExam,
    this.overdueDaysPerDimStep = Defaults.overdueDaysPerDimStep,
    this.maxDimSteps = Defaults.maxDimSteps,
  });

  /// Builds a config from decoded `Setting` values keyed by [SettingKeys].
  /// Missing or malformed values fall back to [Defaults].
  factory ReviewConfig.fromSettings(Map<String, Object?> settings) {
    int? i(String key) => switch (settings[key]) {
      final num v => v.toInt(),
      _ => null,
    };
    List<int>? list(String key) => switch (settings[key]) {
      final List<Object?> v when v.isNotEmpty && v.every((e) => e is num) => [
        for (final e in v) (e! as num).toInt(),
      ],
      _ => null,
    };

    return ReviewConfig(
      scheduledReviews:
          i(SettingKeys.scheduledReviews) ?? Defaults.scheduledReviews,
      gapWeights:
          list(SettingKeys.reviewGapWeights) ?? Defaults.reviewGapWeights,
      gapDaysWithoutExam:
          list(SettingKeys.reviewGapDaysWithoutExam) ??
          Defaults.reviewGapDaysWithoutExam,
      retryGapDays: i(SettingKeys.retryGapDays) ?? Defaults.retryGapDays,
      lastReviewDaysBeforeExam:
          i(SettingKeys.lastReviewDaysBeforeExam) ??
          Defaults.lastReviewDaysBeforeExam,
      overdueDaysPerDimStep:
          i(SettingKeys.overdueDaysPerDimStep) ??
          Defaults.overdueDaysPerDimStep,
      maxDimSteps: i(SettingKeys.maxDimSteps) ?? Defaults.maxDimSteps,
    );
  }

  /// Scheduled reviews after the first read.
  final int scheduledReviews;

  /// Relative gap sizes before each scheduled review.
  final List<int> gapWeights;

  /// Gap days before each scheduled review when there is no exam.
  final List<int> gapDaysWithoutExam;
  final int retryGapDays;
  final int lastReviewDaysBeforeExam;
  final int overdueDaysPerDimStep;
  final int maxDimSteps;
}
