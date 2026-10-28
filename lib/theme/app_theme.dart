import 'package:flutter/material.dart';

import 'level_theme.dart';
import 'themes/dojo/dojo_theme.dart';
import 'tokens/app_tokens.dart';

/// Builds the Material theme from the tokens, plus the level theme.
abstract final class AppTheme {
  static ThemeData light({LevelTheme? levels}) => _build(
    Brightness.light,
    AppColors.light,
    levels ?? DojoTheme.of(Brightness.light),
  );

  static ThemeData dark({LevelTheme? levels}) => _build(
    Brightness.dark,
    AppColors.dark,
    levels ?? DojoTheme.of(Brightness.dark),
  );

  static ThemeData _build(
    Brightness brightness,
    AppColors c,
    LevelTheme levels,
  ) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      secondary: c.accentText,
      onSecondary: c.onAccent,
      error: c.flame,
      onError: c.onAccent,
      surface: c.surface,
      onSurface: c.ink,
      onSurfaceVariant: c.muted,
      outline: c.line,
      outlineVariant: c.line,
    );
    TextStyle s(TextStyle t, Color color) => t.copyWith(color: color);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.ground,
      fontFamily: AppFonts.body,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: TextTheme(
        displaySmall: s(AppText.display, c.ink),
        headlineSmall: s(AppText.heroTitle, c.ink),
        titleMedium: s(AppText.section, c.ink),
        titleSmall: s(AppText.cardTitle, c.ink),
        bodyMedium: s(AppText.body, c.ink),
        bodySmall: s(AppText.caption, c.muted),
        labelLarge: s(AppText.button, c.ink),
        labelMedium: s(AppText.subtitle, c.muted),
        labelSmall: s(AppText.overline, c.muted),
      ),
      dividerColor: c.line,
      extensions: [c, levels],
    );
  }
}
