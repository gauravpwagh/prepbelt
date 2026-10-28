import '../../../core/db/enums.dart';
import '../../../core/ui/app_icons.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Names and icons for source types and units, shared by the Sources
/// screens.
extension SourceTypeLabels on SourceType {
  String label(AppLocalizations l10n) => switch (this) {
    SourceType.pdf => l10n.sourceTypePdf,
    SourceType.book => l10n.sourceTypeBook,
    SourceType.video => l10n.sourceTypeVideo,
    SourceType.link => l10n.sourceTypeLink,
    SourceType.notes => l10n.sourceTypeNotes,
    SourceType.qbank => l10n.sourceTypeQbank,
  };

  AppIcon get icon => switch (this) {
    SourceType.pdf => AppIcon.pdf,
    SourceType.book => AppIcon.book,
    SourceType.video => AppIcon.video,
    SourceType.link => AppIcon.link,
    SourceType.notes => AppIcon.notes,
    SourceType.qbank => AppIcon.qbank,
  };
}

extension UnitTypeLabels on UnitType {
  /// "480 pages", "95 min", "300 questions".
  String count(AppLocalizations l10n, int n) => l10n.sourceUnits(name, n);

  /// A chapter's range: "pp. 40–62" for pages, else "40–62".
  String range(AppLocalizations l10n, int start, int end) =>
      this == UnitType.page
      ? l10n.addSourceRangePages(start, end)
      : l10n.addSourceRange(start, end);

  /// Title of a chapter split by size: "Pages 1–20".
  String chunkTitle(AppLocalizations l10n, int start, int end) =>
      switch (this) {
        UnitType.page => l10n.addSourceChunkPages(start, end),
        UnitType.minute => l10n.addSourceChunkMinutes(start, end),
        UnitType.question => l10n.addSourceChunkQuestions(start, end),
        UnitType.item => l10n.addSourceRange(start, end),
      };

  /// One position in a source: "p. 121", "32 min", "Q12".
  String at(AppLocalizations l10n, int unit) => switch (this) {
    UnitType.page => l10n.unitAtPage(unit),
    UnitType.minute => l10n.unitAtMinute(unit),
    UnitType.question => l10n.unitAtQuestion(unit),
    UnitType.item => '$unit',
  };
}

/// "45 min", "2 h", "1 h 20 min".
String formatMinutes(AppLocalizations l10n, int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return l10n.durationMinutes(m);
  if (m == 0) return l10n.durationHours(h);
  return l10n.durationHoursMinutes(h, m);
}
