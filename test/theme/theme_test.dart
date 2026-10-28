import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/ui/session_card.dart';
import 'package:prepbelt/theme/level_theme.dart';
import 'package:prepbelt/theme/themes/dojo/belt_badge.dart';
import 'package:prepbelt/theme/themes/dojo/dojo_theme.dart';
import 'package:prepbelt/theme/tokens/app_tokens.dart';

import '../support/pump.dart';

double contrast(Color a, Color b) {
  double lum(Color c) {
    double ch(double v) => v <= 0.03928
        ? v / 12.92
        : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
  }

  final l1 = lum(a), l2 = lum(b);
  return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
}

void main() {
  group('contrast (CLAUDE.md: text at least 4.5:1)', () {
    for (final (name, c) in [
      ('light', AppColors.light),
      ('dark', AppColors.dark),
    ]) {
      test('$name text tokens', () {
        for (final bg in [c.surface, c.ground]) {
          expect(contrast(c.ink, bg), greaterThanOrEqualTo(4.5));
          expect(contrast(c.muted, bg), greaterThanOrEqualTo(4.5));
          expect(contrast(c.accentText, bg), greaterThanOrEqualTo(4.5));
        }
        expect(contrast(c.onAccent, c.accent), greaterThanOrEqualTo(4.5));
        expect(contrast(c.heroText, c.hero), greaterThanOrEqualTo(4.5));
        expect(contrast(c.heroMuted, c.hero), greaterThanOrEqualTo(4.5));
        expect(contrast(c.warningText, c.warningBg), greaterThanOrEqualTo(4.5));
      });
    }

    test('belt label colours on the card surface', () {
      for (var i = 0; i < 7; i++) {
        expect(
          contrast(DojoTheme.labelsLight[i], AppColors.light.surface),
          greaterThanOrEqualTo(4.5),
          reason: 'light label for level ${i + 1}',
        );
        expect(
          contrast(DojoTheme.labelsDark[i], AppColors.dark.surface),
          greaterThanOrEqualTo(4.5),
          reason: 'dark label for level ${i + 1}',
        );
      }
    });

    test('level number on each knot is legible', () {
      for (var i = 0; i < 7; i++) {
        expect(
          contrast(DojoTheme.numbers[i], DojoTheme.knots[i]),
          greaterThanOrEqualTo(3),
          reason: 'level ${i + 1}',
        );
      }
    });
  });

  group('BeltBadge semantics', () {
    Future<String> labelOf(WidgetTester tester, LevelBadgeData data) async {
      await tester.pumpWidget(themed(Center(child: BeltBadge(data: data))));
      return tester.getSemantics(find.byType(BeltBadge)).label;
    }

    testWidgets('names belt, level and stripes, never colour alone', (
      tester,
    ) async {
      expect(
        await labelOf(tester, const LevelBadgeData(level: 4, stripes: 2)),
        'Green belt, level 4, 2 stripes',
      );
      expect(
        await labelOf(tester, const LevelBadgeData(level: 3, stripes: 1)),
        'Orange belt, level 3, 1 stripe',
      );
      expect(
        await labelOf(tester, const LevelBadgeData(level: 2, fading: true)),
        'Yellow belt, level 2, fading',
      );
      expect(
        await labelOf(tester, const LevelBadgeData(level: 0)),
        'Not started',
      );
    });

    testWidgets('shows the level number and the fading caption', (
      tester,
    ) async {
      await tester.pumpWidget(
        themed(
          const Center(
            child: BeltBadge(data: LevelBadgeData(level: 2, fading: true)),
          ),
        ),
      );
      expect(find.text('fading'), findsOneWidget);
    });
  });

  testWidgets('session card Start button is 44 px with a label', (
    tester,
  ) async {
    await tester.pumpWidget(
      themed(
        const Center(
          child: SessionCard(
            badge: LevelBadgeData(level: 4, stripes: 2),
            kindLabel: 'REVIEW · 20 MIN',
            title: 'Thermodynamics',
            subtitle: 'HC Verma',
            startLabel: 'Start Thermodynamics review',
            onStart: null,
          ),
        ),
      ),
    );
    final start = find.bySemanticsLabel('Start Thermodynamics review');
    expect(start, findsOneWidget);
    expect(tester.getSize(start), const Size(44, 44));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });
}
