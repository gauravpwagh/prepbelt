@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/ui/buttons.dart';
import 'package:prepbelt/core/ui/chips.dart';
import 'package:prepbelt/core/ui/session_card.dart';
import 'package:prepbelt/theme/level_theme.dart';
import 'package:prepbelt/theme/themes/dojo/belt_badge.dart';

import '../support/pump.dart';

/// The four sessions of design/mockups/1-today.html.
Widget todaySessions() => const Padding(
  padding: EdgeInsets.all(20),
  child: Column(
    children: [
      SessionCard(
        badge: LevelBadgeData(level: 4, stripes: 2),
        kindLabel: 'REVIEW · 20 MIN',
        title: 'Thermodynamics, 2nd law',
        subtitle: 'HC Verma Vol 2 · pp. 210–228',
        startLabel: 'Start Thermodynamics review',
        onStart: _noop,
      ),
      SizedBox(height: 10),
      SessionCard(
        badge: LevelBadgeData(level: 3, stripes: 1),
        kindLabel: 'REVIEW · 15 MIN',
        title: 'SN1 and SN2 reactions',
        subtitle: 'MS Chouhan · Ch 4',
        startLabel: 'Start SN1 and SN2 review',
        onStart: _noop,
      ),
      SizedBox(height: 10),
      SessionCard(
        badge: LevelBadgeData(level: 2, fading: true),
        kindLabel: 'OVERDUE 2 DAYS · 25 MIN',
        title: 'Electrostatics',
        subtitle: 'Class notes · pages 1–14',
        startLabel: 'Start Electrostatics review',
        onStart: _noop,
      ),
      SizedBox(height: 10),
      SessionCard(
        badge: LevelBadgeData(level: 0),
        kindLabel: 'FIRST READ · 45 MIN',
        title: 'Rotational motion',
        subtitle: 'HC Verma Vol 1 · pp. 166–197',
        startLabel: 'Start Rotational motion first read',
        onStart: _noop,
      ),
    ],
  ),
);

void _noop() {}

Widget allBelts() => Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final size in BadgeSize.values) ...[
        Wrap(
          spacing: 14,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            const BeltBadge(data: LevelBadgeData(level: 0)),
            for (var level = 1; level <= 7; level++)
              BeltBadge(
                data: LevelBadgeData(
                  level: level,
                  stripes: level % 3,
                  size: size,
                ),
              ),
            BeltBadge(data: LevelBadgeData(level: 5, fading: true, size: size)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    ],
  ),
);

Widget buttonsAndChips() => Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Row(
        children: [
          Expanded(
            child: SecondaryButton(label: 'Previous', onPressed: _noop),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: PrimaryButton(label: 'Next chapter', onPressed: _noop),
          ),
        ],
      ),
      const SizedBox(height: 10),
      const PrimaryButton(label: 'Pick a rating to finish', onPressed: null),
      const SizedBox(height: 16),
      const Row(
        children: [
          Expanded(
            child: ChoiceChipButton(
              label: 'High',
              selected: true,
              onPressed: _noop,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ChoiceChipButton(
              label: 'Medium',
              selected: false,
              onPressed: _noop,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: ChoiceChipButton(
              label: 'Low',
              selected: false,
              onPressed: _noop,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final (label, on) in [
            ('Edit', false),
            ('Scope', false),
            ('Split', true),
            ('Pause', false),
          ])
            PillChip(label: label, selected: on, onPressed: _noop),
          const TagChip(label: 'from template'),
        ],
      ),
    ],
  ),
);

void main() {
  goldenBoth('session_cards', todaySessions, height: 420);
  goldenBoth('session_cards_360', todaySessions, width: 360, height: 440);
  goldenBoth('belt_badges', allBelts, height: 420);
  goldenBoth('buttons_chips', buttonsAndChips, height: 300);

  testWidgets('session cards at 1.3x text size', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 520)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: themed(todaySessions()),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/session_cards_text130_light.png'),
    );
  });
}
