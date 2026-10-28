import 'defaults.dart';

/// Tunable inputs of the review engine, merged from [Defaults] and the
/// `Setting` table. Pure Dart, so engines may depend on it.
final class ReviewConfig {
  const ReviewConfig({
    this.retentionTarget = Defaults.retentionTarget,
    this.levelStabilityThresholds = Defaults.levelStabilityThresholds,
    this.maxPromotionPerReview = Defaults.maxPromotionPerReview,
    this.stripeThresholds = Defaults.stripeThresholds,
    this.fadingRetrievability = Defaults.fadingRetrievability,
    this.fsrsParameters = Defaults.fsrsParameters,
    this.fsrsMaximumIntervalDays = Defaults.fsrsMaximumIntervalDays,
  });

  /// Builds a config from decoded `Setting` values keyed by [SettingKeys].
  /// Missing or malformed values fall back to [Defaults].
  factory ReviewConfig.fromSettings(Map<String, Object?> settings) {
    double? d(String key) => switch (settings[key]) {
      final num v => v.toDouble(),
      _ => null,
    };
    int? i(String key) => switch (settings[key]) {
      final num v => v.toInt(),
      _ => null,
    };
    List<double>? list(String key) => switch (settings[key]) {
      final List<Object?> v when v.every((e) => e is num) => [
        for (final e in v) (e! as num).toDouble(),
      ],
      _ => null,
    };

    return ReviewConfig(
      retentionTarget:
          d(SettingKeys.retentionTarget) ?? Defaults.retentionTarget,
      levelStabilityThresholds:
          list(SettingKeys.levelStabilityThresholds) ??
          Defaults.levelStabilityThresholds,
      maxPromotionPerReview:
          i(SettingKeys.maxPromotionPerReview) ??
          Defaults.maxPromotionPerReview,
      stripeThresholds:
          list(SettingKeys.stripeThresholds) ?? Defaults.stripeThresholds,
      fadingRetrievability:
          d(SettingKeys.fadingRetrievability) ?? Defaults.fadingRetrievability,
      fsrsParameters:
          list(SettingKeys.fsrsParameters) ?? Defaults.fsrsParameters,
      fsrsMaximumIntervalDays:
          i(SettingKeys.fsrsMaximumIntervalDays) ??
          Defaults.fsrsMaximumIntervalDays,
    );
  }

  final double retentionTarget;
  final List<double> levelStabilityThresholds;
  final int maxPromotionPerReview;
  final List<double> stripeThresholds;
  final double fadingRetrievability;
  final List<double>? fsrsParameters;
  final int fsrsMaximumIntervalDays;
}
