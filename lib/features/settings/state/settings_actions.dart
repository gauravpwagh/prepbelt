import 'dart:convert';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_info.dart';
import '../../../core/config/defaults.dart';
import '../../../core/providers/core_providers.dart';
import '../../../platform/files/backup_files.dart';
import '../../exams/state/exam_providers.dart';
import '../../planner/state/planner_providers.dart';
import '../../sources/state/source_providers.dart';
import '../../today/state/reminder_providers.dart';
import '../data/backup_repository.dart';
import 'settings_providers.dart';

export '../../../platform/files/backup.dart' show BackupError, BackupProblem;

part 'settings_actions.g.dart';

@Riverpod(keepAlive: true)
BackupFiles backupFiles(Ref ref) => const SystemBackupFiles();

@Riverpod(keepAlive: true)
Future<BackupRepository> backupRepository(Ref ref) async => BackupRepository(
  ref.watch(appDatabaseProvider),
  documents: (await ref.watch(fileStoreProvider.future)).root,
  clock: ref.watch(clockProvider),
);

/// What the Settings screen changes (design/notes/settings.md).
@Riverpod(keepAlive: true)
class SettingsActions extends _$SettingsActions {
  @override
  void build() {}

  Future<void> setReminder({
    required bool on,
    required ReminderText text,
  }) async {
    final settings = ref.read(settingsRepositoryProvider);
    var enabled = on;
    if (on && await settings.get(SettingKeys.reminderAsked) != true) {
      enabled = await ref.read(reminderSchedulerProvider).requestPermission();
    }
    await settings.set(SettingKeys.reminderAsked, true);
    await settings.set(SettingKeys.reminderEnabled, enabled);
    await ref.read(remindersProvider.notifier).sync(text);
  }

  /// [time] as "HH:mm".
  Future<void> setReminderTime(String time, ReminderText text) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.reminderTime, time);
    await ref.read(remindersProvider.notifier).sync(text);
  }

  Future<void> setWeek(List<int> minutes) async {
    await ref.read(examRepositoryProvider).setWeek('week', minutes);
    await ref.read(plannerProvider.notifier).replanNow();
  }

  /// Exports a backup through the save dialog. False if cancelled.
  Future<bool> exportBackup() async {
    final repo = await ref.read(backupRepositoryProvider.future);
    final bytes = await repo.export();
    final day = ref
        .read(clockProvider)
        .now()
        .toLocal()
        .toIso8601String()
        .substring(0, 10);
    return ref
        .read(backupFilesProvider)
        .save('prepbelt-backup-$day.zip', bytes);
  }

  /// Picks a backup and stages it for the next start. Null if cancelled;
  /// otherwise when the backup was made. Throws [BackupError].
  Future<DateTime?> stageRestore() async {
    final bytes = await ref.read(backupFilesProvider).pick();
    if (bytes == null) return null;
    final repo = await ref.read(backupRepositoryProvider.future);
    return repo.stageRestore(bytes);
  }

  Future<void> cancelRestore() async =>
      (await ref.read(backupRepositoryProvider.future)).cancelRestore();

  Future<bool> exportDiagnostics() async {
    final repo = await ref.read(backupRepositoryProvider.future);
    final json = await repo.diagnostics(appVersion: appVersion);
    return ref
        .read(backupFilesProvider)
        .save(
          'prepbelt-diagnostics.json',
          Uint8List.fromList(utf8.encode(json)),
        );
  }
}
