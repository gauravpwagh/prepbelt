@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/features/onboarding/ui/onboarding_screen.dart';

import '../../support/pump.dart';

Widget step(int i) => Scaffold(
  body: OnboardingBody(
    step: i,
    name: TextEditingController(text: i == 0 ? 'Asha' : ''),
    minutes: 105,
    onMinutes: (_) {},
    onContinue: () {},
    onReminder: (_) {},
    onAddExam: () {},
    onSkip: () {},
  ),
);

void main() {
  for (final i in [0, 1, 2]) {
    goldenBoth('onboarding_$i', () => step(i), height: 844);
  }
  goldenBoth('onboarding_0_360', () => step(0), width: 360, height: 760);

  testWidgets('first launch at 1.3x text size', (tester) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
        child: themed(step(0)),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_text130_light.png'),
    );
  });
}
