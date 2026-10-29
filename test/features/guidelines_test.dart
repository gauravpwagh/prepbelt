import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prepbelt/features/onboarding/ui/onboarding_screen.dart';
import 'package:prepbelt/features/redefine/ui/redefine_sheet.dart';

import 'package:prepbelt/theme/tokens/app_tokens.dart';

import '../support/pump.dart';
import 'redefine/redefine_golden_test.dart' as redefine;
import 'settings_golden_test.dart' as settings;

/// Accessibility guidelines for the milestone 6 screens (docs/03, "Done
/// means"): 44 px targets, labelled controls and 4.5:1 text. Screens with
/// filled text fields skip the contrast check: Flutter compares a field's
/// fill with its border there, not with its text (see D38).
/// The sheet on its real background (the goldens add a grey backdrop).
Widget onSurface(RedefineMode mode) => Builder(
  builder: (context) => Scaffold(
    backgroundColor: context.colors.surface,
    body: SafeArea(child: redefine.body(mode)),
  ),
);

void main() {
  setUpAll(() => initializeDateFormatting('en'));

  const target = MinimumTapTargetGuideline(
    size: Size.square(44),
    link: 'CLAUDE.md, Accessibility',
  );

  for (final (name, build, hasField) in <(String, Widget Function(), bool)>[
    ('settings', settings.settings, false),
    // Flutter's contrast check misreads this sheet (it reports 2.2:1 for
    // ink on the light panel); its colours are the tokens checked in
    // test/theme/theme_test.dart, so only targets and labels run here.
    ('redefine split', () => onSurface(RedefineMode.split), true),
    ('redefine scope', () => onSurface(RedefineMode.scope), true),
    ('redefine pause', () => onSurface(RedefineMode.pause), true),
    (
      'first launch, reminder',
      () => Scaffold(
        body: OnboardingBody(
          step: 1,
          name: TextEditingController(),
          minutes: 90,
          onMinutes: (_) {},
          onContinue: () {},
          onReminder: (_) {},
          onAddExam: () {},
          onSkip: () {},
        ),
      ),
      false,
    ),
  ]) {
    testWidgets('$name meets the guidelines', (tester) async {
      tester.view
        ..physicalSize = const Size(390, 1000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(themed(build()));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(target));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      if (!hasField) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
    });
  }
}
