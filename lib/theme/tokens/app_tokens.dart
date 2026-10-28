import 'package:flutter/material.dart';

/// Colour tokens from docs/06-screens.md and design/mockups/ (light), with
/// a dark set derived from them. Widgets read these, never literals.
@immutable
final class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.ink,
    required this.muted,
    required this.ground,
    required this.surface,
    required this.line,
    required this.lineDashed,
    required this.chipBorder,
    required this.placeholderStroke,
    required this.accent,
    required this.onAccent,
    required this.accentText,
    required this.accentSoft,
    required this.accentShadow,
    required this.hero,
    required this.heroText,
    required this.heroMuted,
    required this.heroSubtle,
    required this.heroTrack,
    required this.readiness,
    required this.warningBg,
    required this.warningBorder,
    required this.warningText,
    required this.flame,
    required this.importanceHigh,
    required this.importanceMedium,
    required this.importanceLow,
    required this.gridEmpty,
  });

  /// Light values, exactly as in the mockups.
  static const light = AppColors(
    ink: Color(0xFF151A2D),
    muted: Color(0xFF5A6178),
    ground: Color(0xFFF3F4F8),
    surface: Color(0xFFFFFFFF),
    line: Color(0xFFE2E5EE),
    lineDashed: Color(0xFFC7CBE0),
    chipBorder: Color(0xFFD6DAE6),
    placeholderStroke: Color(0xFF9CA2B8),
    accent: Color(0xFF4338CA),
    onAccent: Color(0xFFFFFFFF),
    accentText: Color(0xFF4338CA),
    accentSoft: Color(0xFFEEF0FF),
    accentShadow: Color(0x524338CA),
    hero: Color(0xFF151A2D),
    heroText: Color(0xFFFFFFFF),
    heroMuted: Color(0xFFAEB4CC),
    heroSubtle: Color(0xFFD5D9E8),
    heroTrack: Color(0xFF2E3550),
    readiness: Color(0xFF8FD14F),
    warningBg: Color(0xFFFFF7EC),
    warningBorder: Color(0xFFF3D7AE),
    warningText: Color(0xFF7A4100),
    flame: Color(0xFFC2410C),
    importanceHigh: Color(0xFFC2410C),
    importanceMedium: Color(0xFFF0997B),
    importanceLow: Color(0xFFF5C4B3),
    gridEmpty: Color(0xFFE2E5EE),
  );

  /// Dark values, derived: same hues, text kept at 4.5:1 or better on
  /// [surface], accent fill keeps white text above 4.5:1.
  static const dark = AppColors(
    ink: Color(0xFFECEEF6),
    muted: Color(0xFFA6ACC2),
    ground: Color(0xFF0D1120),
    surface: Color(0xFF161B2E),
    line: Color(0xFF2A3048),
    lineDashed: Color(0xFF3D4565),
    chipBorder: Color(0xFF3A4160),
    placeholderStroke: Color(0xFF7E86A3),
    accent: Color(0xFF5048D6),
    onAccent: Color(0xFFFFFFFF),
    accentText: Color(0xFFA9A4FF),
    accentSoft: Color(0xFF23264A),
    accentShadow: Color(0x00000000),
    hero: Color(0xFF222844),
    heroText: Color(0xFFFFFFFF),
    heroMuted: Color(0xFFAEB4CC),
    heroSubtle: Color(0xFFD5D9E8),
    heroTrack: Color(0xFF363E62),
    readiness: Color(0xFF8FD14F),
    warningBg: Color(0xFF2A2013),
    warningBorder: Color(0xFF5C4220),
    warningText: Color(0xFFF5C98A),
    flame: Color(0xFFF07A3E),
    importanceHigh: Color(0xFFE0622A),
    importanceMedium: Color(0xFFF0997B),
    importanceLow: Color(0xFFF5C4B3),
    gridEmpty: Color(0xFF2A3048),
  );

  /// Primary text, dark cards, selected chips.
  final Color ink;

  /// Secondary text.
  final Color muted;

  /// Screen background.
  final Color ground;

  /// Cards.
  final Color surface;

  /// Card borders, dividers.
  final Color line;

  /// Dashed border of new-material cards.
  final Color lineDashed;

  /// Unselected chip border.
  final Color chipBorder;

  /// Dashed outline of a not-started belt.
  final Color placeholderStroke;

  /// Primary button fill, active nav.
  final Color accent;
  final Color onAccent;

  /// Accent used as text or icon on [surface].
  final Color accentText;

  /// Tags such as "from template".
  final Color accentSoft;
  final Color accentShadow;

  /// Dark hero cards (exam card) and their text.
  final Color hero;
  final Color heroText;
  final Color heroMuted;
  final Color heroSubtle;
  final Color heroTrack;
  final Color readiness;

  /// Weak-links card.
  final Color warningBg;
  final Color warningBorder;
  final Color warningText;

  /// Streak flame.
  final Color flame;

  /// 4 px importance bars.
  final Color importanceHigh;
  final Color importanceMedium;
  final Color importanceLow;

  final Color gridEmpty;

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      ground: l(ground, other.ground),
      surface: l(surface, other.surface),
      line: l(line, other.line),
      lineDashed: l(lineDashed, other.lineDashed),
      chipBorder: l(chipBorder, other.chipBorder),
      placeholderStroke: l(placeholderStroke, other.placeholderStroke),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentText: l(accentText, other.accentText),
      accentSoft: l(accentSoft, other.accentSoft),
      accentShadow: l(accentShadow, other.accentShadow),
      hero: l(hero, other.hero),
      heroText: l(heroText, other.heroText),
      heroMuted: l(heroMuted, other.heroMuted),
      heroSubtle: l(heroSubtle, other.heroSubtle),
      heroTrack: l(heroTrack, other.heroTrack),
      readiness: l(readiness, other.readiness),
      warningBg: l(warningBg, other.warningBg),
      warningBorder: l(warningBorder, other.warningBorder),
      warningText: l(warningText, other.warningText),
      flame: l(flame, other.flame),
      importanceHigh: l(importanceHigh, other.importanceHigh),
      importanceMedium: l(importanceMedium, other.importanceMedium),
      importanceLow: l(importanceLow, other.importanceLow),
      gridEmpty: l(gridEmpty, other.gridEmpty),
    );
  }
}

/// Corner radii.
abstract final class AppRadii {
  static const double chip = 12;
  static const double button = 12;
  static const double card = 16;
  static const double hero = 20;
  static const double sheet = 22;
  static const double navAdd = 18;
  static const double pill = 999;
}

/// Spacing used by the mockups.
abstract final class AppSpace {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 20;
  static const double xxxl = 24;
}

/// Minimum touch target (CLAUDE.md, accessibility).
const double kMinTouchTarget = 44;

abstract final class AppFonts {
  static const heading = 'Bricolage Grotesque';
  static const body = 'Manrope';
}

/// Text styles from the mockups. Colours are applied by [AppTheme].
abstract final class AppText {
  /// "Today's training".
  static const display = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.15,
  );

  /// "74 days to go".
  static const heroTitle = TextStyle(
    fontFamily: AppFonts.heading,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// "4 sessions · 1 h 45 m".
  static const section = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// Session task title.
  static const cardTitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const body = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// Date line, subtitles.
  static const subtitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  /// Source and range line.
  static const caption = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  /// "REVIEW · 20 MIN".
  static const overline = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    height: 1.3,
  );

  /// "fading", "new" under a belt.
  static const badgeCaption = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const navLabel = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11.5,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const button = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const chip = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}

extension AppThemeX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
