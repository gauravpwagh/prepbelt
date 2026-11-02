import 'defaults.dart';

/// Tunable inputs of the review engine, merged from [Defaults] and the
/// `Setting` table. Pure Dart, so engines may depend on it.
final class ReviewConfig {
  const ReviewConfig({
    this.gapDays = Defaults.reviewGapDays,
    this.minReviews = Defaults.minReviewsBeforeExam,
    this.finalReviewMinDays = Defaults.finalReviewMinDays,
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

    return ReviewConfig(
      gapDays:
          validGapDays(settings[SettingKeys.reviewGapDays]) ??
          Defaults.reviewGapDays,
      minReviews:
          i(SettingKeys.minReviewsBeforeExam) ?? Defaults.minReviewsBeforeExam,
      finalReviewMinDays:
          i(SettingKeys.finalReviewMinDays) ?? Defaults.finalReviewMinDays,
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

  /// [value] as review gaps when it is a usable list: 1 to
  /// [Defaults.reviewGapsMax] whole days, each 1 to
  /// [Defaults.reviewGapMaxDays] and none shorter than the one before.
  static List<int>? validGapDays(Object? value) {
    if (value is! List<Object?> ||
        value.isEmpty ||
        value.length > Defaults.reviewGapsMax) {
      return null;
    }
    final days = <int>[];
    for (final v in value) {
      if (v is! num || v != v.roundToDouble()) return null;
      final d = v.toInt();
      if (d < 1 || d > Defaults.reviewGapMaxDays) return null;
      if (days.isNotEmpty && d < days.last) return null;
      days.add(d);
    }
    return days;
  }

  /// Days before each scheduled review; after the last, it repeats.
  final List<int> gapDays;

  /// Reviews squeezed in before the exam when the gaps do not fit.
  final int minReviews;

  /// A final review is added before the exam only with this many days
  /// left since the last review.
  final int finalReviewMinDays;
  final int retryGapDays;
  final int lastReviewDaysBeforeExam;
  final int overdueDaysPerDimStep;
  final int maxDimSteps;
}
