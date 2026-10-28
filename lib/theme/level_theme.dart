import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// How a theme shows fading recall.
enum DecayStyle { stripes, shine }

/// Badge sizes used across screens.
enum BadgeSize {
  /// Session cards (36 × 16).
  small,

  /// Exam card (44 × 18).
  medium,

  /// Hero cards and the result card (88 × 36).
  large,
}

/// What a level badge shows. Built from the review engine's display values.
@immutable
final class LevelBadgeData {
  const LevelBadgeData({
    required this.level,
    this.stripes = 0,
    this.fading = false,
    this.size = BadgeSize.small,
    this.showCaption = true,
  }) : assert(level >= 0 && level <= 7, 'level is 0..7'),
       assert(stripes >= 0, 'stripes is not negative');

  /// 0 = not started, 1..7 = displayed level.
  final int level;

  /// Shine shown as stripes (belts) or lustre (gems).
  final int stripes;

  /// True when recall has faded below the threshold on an overdue task.
  final bool fading;
  final BadgeSize size;

  /// Shows "fading" or "new" under the badge where it applies.
  final bool showCaption;
}

typedef LevelBadgeBuilder =
    Widget Function(BuildContext context, LevelBadgeData data);

/// Presentation of levels 1–7. Data stores only the number; a theme turns
/// it into names, colours and badges (CLAUDE.md rule 7).
@immutable
final class LevelTheme extends ThemeExtension<LevelTheme> {
  const LevelTheme({
    required this.id,
    required this.levelNames,
    required this.colors,
    required this.accentColors,
    required this.labelColors,
    required this.stripeColors,
    required this.numberColors,
    required this.outlineColors,
    required this.actionWord,
    required this.decayStyle,
    required this.examEmblem,
    required this.badgeBuilder,
  });

  /// Stable id stored in settings, e.g. `dojo`.
  final String id;

  /// Seven level names (index 0 = level 1), localised.
  final List<String Function(AppLocalizations l10n)> levelNames;

  /// Seven main colours (belt cloth, gem body).
  final List<Color> colors;

  /// Seven secondary colours (belt knot, gem facet).
  final List<Color> accentColors;

  /// Seven text colours that pass 4.5:1 on the surface, for labels such as
  /// "REVIEW · 20 MIN" next to a badge.
  final List<Color> labelColors;

  /// Seven stripe colours, chosen to contrast with each belt.
  final List<Color> stripeColors;

  /// Seven colours for the level number drawn on each badge.
  final List<Color> numberColors;

  /// Optional outline per level, for badges that would otherwise blend
  /// into the background (White on light, Black on dark).
  final List<Color?> outlineColors;

  /// "Promote" for belts, "Polish" for gems.
  final String Function(AppLocalizations l10n) actionWord;
  final DecayStyle decayStyle;

  /// Icon of the exam-level emblem.
  final IconData examEmblem;
  final LevelBadgeBuilder badgeBuilder;

  String levelName(AppLocalizations l10n, int level) =>
      levelNames[level - 1](l10n);

  Color colorFor(int level) => colors[level - 1];
  Color accentFor(int level) => accentColors[level - 1];
  Color labelFor(int level) => labelColors[level - 1];
  Color stripeFor(int level) => stripeColors[level - 1];
  Color numberFor(int level) => numberColors[level - 1];
  Color? outlineFor(int level) => outlineColors[level - 1];

  Widget badge(BuildContext context, LevelBadgeData data) =>
      badgeBuilder(context, data);

  @override
  LevelTheme copyWith() => this;

  @override
  LevelTheme lerp(LevelTheme? other, double t) =>
      t < 0.5 || other == null ? this : other;
}

extension LevelThemeX on BuildContext {
  LevelTheme get levels => Theme.of(this).extension<LevelTheme>()!;
}
