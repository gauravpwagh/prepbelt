@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/features/settings/ui/review_gaps_sheet.dart';
import 'package:prepbelt/features/settings/ui/settings_screen.dart';
import 'package:prepbelt/features/sources/state/study_files.dart';

import '../support/pump.dart';

Widget settings({String? busy}) => Scaffold(
  body: SettingsBody(
    settings: const {
      SettingKeys.reminderAsked: true,
      SettingKeys.reminderEnabled: true,
      SettingKeys.reminderTime: '19:30',
    },
    week: const [90, 90, 90, 90, 90, 90, 240],
    folder: const FolderStatus(
      folder: 'folder',
      label: 'Documents/PrepBelt',
      available: true,
    ),
    device: DeviceState(
      folder: 'folder',
      backupAt: DateTime(2026, 11, 1, 8, 12).millisecondsSinceEpoch,
    ),
    busy: busy,
    onEditWeek: () {},
    onReviewGaps: () {},
    onReminder: (_) {},
    onReminderTime: () {},
    onExport: () {},
    onRestore: () {},
    onDiagnostics: () {},
  ),
);

void main() {
  setUpAll(() => initializeDateFormatting('en'));
  goldenBoth('settings', settings, height: 900);
  goldenBoth('settings_360', settings, width: 360, height: 940);
  goldenBoth(
    'review_gaps_sheet',
    () => Scaffold(
      body: ReviewGapsSheet(gaps: const [1, 3, 7, 14, 30, 60], onSave: (_) {}),
    ),
    height: 640,
  );

  testWidgets('review gaps: a gap never goes below the one before, and '
      'Save returns the new list (D53)', (tester) async {
    List<int>? saved;
    await tester.pumpWidget(
      themed(ReviewGapsSheet(gaps: const [1, 3], onSave: (g) => saved = g)),
    );
    // Review 2 at 3 days: shorter steps to 2, then 1, then stops at Review
    // 1's gap.
    final shorter = find.bySemanticsLabel('Shorter gap before review 2');
    await tester.tap(shorter);
    await tester.pump();
    await tester.tap(shorter);
    await tester.pump();
    expect(find.text('1 day'), findsNWidgets(2));
    await tester.tap(shorter, warnIfMissed: false);
    await tester.pump();
    expect(find.text('1 day'), findsNWidgets(2), reason: 'never below 1');
    await tester.tap(find.text('Add a review'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    expect(saved, [1, 1, 2]);
  });
}
