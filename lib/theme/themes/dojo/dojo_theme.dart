import 'package:flutter/material.dart';

import '../../level_theme.dart';
import 'belt_badge.dart';

/// The default theme: martial-arts belts, white to black.
abstract final class DojoTheme {
  static const id = 'dojo';

  /// Belt cloth (docs/06-screens.md).
  static const cloth = [
    Color(0xFFF1EFE8), // White
    Color(0xFFFAC775), // Yellow
    Color(0xFFEF9F27), // Orange
    Color(0xFF639922), // Green
    Color(0xFF378ADD), // Blue
    Color(0xFF854F0B), // Brown
    Color(0xFF2C2C2A), // Black
  ];

  /// Knots: a darker shade of each belt. Yellow, Orange and Green are the
  /// mockup values; the others follow the same step.
  static const knots = [
    Color(0xFFD3D0C4),
    Color(0xFFD9A23F),
    Color(0xFFC27A12),
    Color(0xFF4E7A1B),
    Color(0xFF2A6CB0),
    Color(0xFF6A3F09),
    Color(0xFF111110),
  ];

  /// Stripes are black bars (mockup), light on Brown and Black so they
  /// stay visible.
  static const stripes = [
    Color(0xFF151A2D),
    Color(0xFF151A2D),
    Color(0xFF151A2D),
    Color(0xFF151A2D),
    Color(0xFF151A2D),
    Color(0xFFF1EFE8),
    Color(0xFFF1EFE8),
  ];

  /// Level number on the knot.
  static const numbers = [
    Color(0xFF151A2D),
    Color(0xFF151A2D),
    Color(0xFF151A2D),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
    Color(0xFFFFFFFF),
  ];

  /// Label text beside a belt on a light surface. Green, Orange and Yellow
  /// are the mockup values.
  static const labelsLight = [
    Color(0xFF5A6178),
    Color(0xFF8A5300),
    Color(0xFF8A4B00),
    Color(0xFF3B5E12),
    Color(0xFF1D5A9A),
    Color(0xFF854F0B),
    Color(0xFF2C2C2A),
  ];

  /// Label text beside a belt on a dark surface.
  static const labelsDark = [
    Color(0xFFD9D7CF),
    Color(0xFFFAC775),
    Color(0xFFF2B25A),
    Color(0xFF9BCB5E),
    Color(0xFF7DB5EE),
    Color(0xFFD49A5A),
    Color(0xFFC9C9C4),
  ];

  /// White needs an edge on light cards, Black on dark ones.
  static const outlinesLight = <Color?>[
    Color(0xFFB9B5A8),
    null,
    null,
    null,
    null,
    null,
    null,
  ];
  static const outlinesDark = <Color?>[
    null,
    null,
    null,
    null,
    null,
    null,
    Color(0xFF8A90A6),
  ];

  static LevelTheme of(Brightness brightness) => LevelTheme(
    id: id,
    levelNames: [
      (l) => l.beltWhite,
      (l) => l.beltYellow,
      (l) => l.beltOrange,
      (l) => l.beltGreen,
      (l) => l.beltBlue,
      (l) => l.beltBrown,
      (l) => l.beltBlack,
    ],
    colors: cloth,
    accentColors: knots,
    labelColors: brightness == Brightness.light ? labelsLight : labelsDark,
    stripeColors: stripes,
    numberColors: numbers,
    outlineColors: brightness == Brightness.light
        ? outlinesLight
        : outlinesDark,
    actionWord: (l) => l.levelActionPromote,
    decayStyle: DecayStyle.stripes,
    examEmblem: Icons.workspace_premium_outlined,
    badgeBuilder: (context, data) => BeltBadge(data: data),
  );
}
