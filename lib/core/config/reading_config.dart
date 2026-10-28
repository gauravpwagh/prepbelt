import 'defaults.dart';

/// Tunable numbers of reading as you go (D27), merged from [Defaults] and
/// the `Setting` table.
final class ReadingConfig {
  const ReadingConfig({
    this.maxAwayMinutes = Defaults.readingMaxAwayMinutes,
    this.awayStepMinutes = Defaults.readingAwayStepMinutes,
    this.chapterChipWindow = Defaults.readingChapterChipWindow,
  });

  /// Missing or malformed values fall back to [Defaults].
  factory ReadingConfig.fromSettings(Map<String, Object?> settings) {
    int? i(String key) => switch (settings[key]) {
      final num v when v > 0 => v.toInt(),
      _ => null,
    };
    return ReadingConfig(
      maxAwayMinutes:
          i(SettingKeys.readingMaxAwayMinutes) ??
          Defaults.readingMaxAwayMinutes,
      awayStepMinutes:
          i(SettingKeys.readingAwayStepMinutes) ??
          Defaults.readingAwayStepMinutes,
      chapterChipWindow:
          i(SettingKeys.readingChapterChipWindow) ??
          Defaults.readingChapterChipWindow,
    );
  }

  final int maxAwayMinutes;
  final int awayStepMinutes;
  final int chapterChipWindow;

  /// Time away as the sheet pre-fills it: rounded to the step, at least
  /// one step, at most [maxAwayMinutes].
  int awayMinutes(Duration away) {
    final steps = (away.inSeconds / 60 / awayStepMinutes).round();
    return (steps * awayStepMinutes).clamp(awayStepMinutes, maxAwayMinutes);
  }
}
