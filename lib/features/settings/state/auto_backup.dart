import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../sources/state/study_files.dart';
import 'settings_actions.dart';
import 'settings_providers.dart';

part 'auto_backup.g.dart';

/// A backup found in the study folder.
final class FolderBackup {
  const FolderBackup({required this.path, required this.day});

  final String path;

  /// Its local date, from the name ("2026-11-01").
  final DateTime day;
}

/// Automatic backups into the study folder (D51): the database only,
/// every `backup.everyDays` local days if something changed, the newest
/// [Defaults.backupKeep] kept. Kept alive: it runs as the app goes to the
/// background.
@Riverpod(keepAlive: true)
class AutoBackup extends _$AutoBackup {
  @override
  void build() {}

  bool _running = false;

  static final _name = RegExp(r'^prepbelt-backup-(\d{4}-\d{2}-\d{2})\.zip$');

  /// Backs up if one is due. Never throws.
  Future<void> maybeRun() async {
    if (_running) return;
    try {
      final folder = await ref.read(studyFilesProvider.notifier).folder();
      if (folder == null) return;
      final device = await ref.read(deviceProvider.future);
      final last = device.backupAt;
      if (last != null) {
        final every = switch (await ref
            .read(settingsRepositoryProvider)
            .get(SettingKeys.backupEveryDays)) {
          final num n => n.toInt(),
          _ => Defaults.backupEveryDays,
        };
        final now = ref.read(clockProvider).now().toLocal();
        final then = DateTime.fromMillisecondsSinceEpoch(last).toLocal();
        final days = DateTime(
          now.year,
          now.month,
          now.day,
        ).difference(DateTime(then.year, then.month, then.day)).inDays;
        if (days < every) return;
        final repo = await ref.read(backupRepositoryProvider.future);
        if (!await repo.changedSince(last)) return;
      }
      await runNow();
    } on Object {
      // Settings shows a failure recorded by runNow.
    }
  }

  /// Writes a backup now, replacing today's. False when there is no
  /// folder or it failed.
  Future<bool> runNow() async {
    final files = ref.read(studyFilesProvider.notifier);
    final device = ref.read(deviceProvider.notifier);
    final clock = ref.read(clockProvider);
    _running = true;
    try {
      final folder = await files.folder();
      if (folder == null) return false;
      final store = await ref.read(studyFolderProvider.future);
      final bytes = await (await ref.read(
        backupRepositoryProvider.future,
      )).export();
      final day = clock.now().toLocal().toIso8601String().substring(0, 10);
      await store.write(
        folder,
        '${Defaults.backupFolder}/prepbelt-backup-$day.zip',
        bytes,
      );
      final old = (await list(folder)).skip(Defaults.backupKeep);
      for (final b in old) {
        await store.delete(folder, b.path);
      }
      await device.change(
        (d) => d.copyWith(
          backupAt: clock.nowMs,
          backupFailedAt: () => null,
        ),
      );
      return true;
    } on Object {
      await device.change((d) => d.copyWith(backupFailedAt: clock.nowMs));
      return false;
    } finally {
      _running = false;
    }
  }

  /// Backups in [folder], newest first.
  Future<List<FolderBackup>> list(String folder) async {
    final store = await ref.read(studyFolderProvider.future);
    final found = <FolderBackup>[];
    for (final f in await store.list(folder, dir: Defaults.backupFolder)) {
      final m = _name.firstMatch(f.path.split('/').last);
      if (m == null) continue;
      found.add(FolderBackup(path: f.path, day: DateTime.parse(m.group(1)!)));
    }
    return found..sort((a, b) => b.day.compareTo(a.day));
  }

  /// Stages [backup] from [folder] for the next start (D43). Returns when
  /// it was made. Throws [BackupError].
  Future<DateTime?> stage(String folder, FolderBackup backup) async {
    final store = await ref.read(studyFolderProvider.future);
    final bytes = await store.read(folder, backup.path);
    if (bytes == null) return null;
    return (await ref.read(backupRepositoryProvider.future)).stageRestore(
      bytes,
    );
  }
}
