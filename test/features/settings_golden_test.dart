@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prepbelt/core/config/defaults.dart';
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
}
