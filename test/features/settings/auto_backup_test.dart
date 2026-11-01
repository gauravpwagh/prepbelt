import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/core/time/clock.dart';
import 'package:prepbelt/features/settings/state/auto_backup.dart';
import 'package:prepbelt/features/settings/state/settings_providers.dart';
import 'package:prepbelt/features/sources/state/study_files.dart';

import '../../support/study_folder.dart';
import '../../support/test_db.dart';

void main() {
  late Directory tmp;

  setUp(() => tmp = Directory.systemTemp.createTempSync('auto_backup'));
  tearDown(() => tmp.deleteSync(recursive: true));

  ({ProviderContainer c, FakeClock clock}) open({bool chosen = true}) {
    final t = openTestContext(start: DateTime(2026, 11, 1, 8).toUtc());
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(t.db),
        writeContextProvider.overrideWithValue(t.ctx),
        clockProvider.overrideWithValue(t.clock),
        ...overrideStudyFolder(tmp, chosen: chosen),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await t.db.close();
    });
    return (c: c, clock: t.clock);
  }

  List<String> backups() {
    final dir = Directory('${tmp.path}/folder/${Defaults.backupFolder}');
    if (!dir.existsSync()) return const [];
    return [
      for (final f in dir.listSync())
        f.path.split(Platform.pathSeparator).last.split('/').last,
    ]..sort();
  }

  test('the first backup is written at once; another the same day waits, '
      'and one the next day only if something changed', () async {
    final (:c, :clock) = open();
    final backup = c.read(autoBackupProvider.notifier);
    final settings = c.read(settingsRepositoryProvider);
    await settings.set(SettingKeys.studentName, 'Asha');

    await backup.maybeRun();
    expect(backups(), ['prepbelt-backup-2026-11-01.zip']);
    final first = (await c.read(deviceProvider.future)).backupAt;
    expect(first, clock.nowMs());

    clock.advance(const Duration(hours: 3));
    await settings.set(SettingKeys.studentName, 'Asha K');
    await backup.maybeRun();
    expect((await c.read(deviceProvider.future)).backupAt, first);

    clock.set(DateTime(2026, 11, 2, 9).toUtc());
    await backup.maybeRun();
    expect(backups(), [
      'prepbelt-backup-2026-11-01.zip',
      'prepbelt-backup-2026-11-02.zip',
    ]);

    clock.set(DateTime(2026, 11, 3, 9).toUtc());
    await backup.maybeRun();
    expect(backups(), hasLength(2), reason: 'nothing changed since');
  });

  test('every 3 days waits three local days', () async {
    final (:c, :clock) = open();
    final backup = c.read(autoBackupProvider.notifier);
    final settings = c.read(settingsRepositoryProvider);
    await settings.set(SettingKeys.backupEveryDays, 3);
    await backup.maybeRun();
    for (final day in [2, 3]) {
      clock.set(DateTime(2026, 11, day, 9).toUtc());
      await settings.set(SettingKeys.studentName, 'day $day');
      await backup.maybeRun();
    }
    expect(backups(), hasLength(1));
    clock.set(DateTime(2026, 11, 4, 9).toUtc());
    await backup.maybeRun();
    expect(backups(), hasLength(2));
  });

  test('only the newest backups are kept', () async {
    final (:c, :clock) = open();
    final backup = c.read(autoBackupProvider.notifier);
    for (var day = 1; day <= Defaults.backupKeep + 2; day++) {
      clock.set(DateTime(2026, 11, day, 9).toUtc());
      expect(await backup.runNow(), isTrue);
    }
    expect(backups(), hasLength(Defaults.backupKeep));
    expect(backups().first, 'prepbelt-backup-2026-11-03.zip');
    final listed = await backup.list('${tmp.path}/folder');
    expect(listed.first.day, DateTime(2026, 11, 9));
  });

  test('without a folder nothing is written', () async {
    final (:c, clock: _) = open(chosen: false);
    final backup = c.read(autoBackupProvider.notifier);
    await backup.maybeRun();
    expect(await backup.runNow(), isFalse);
    expect(backups(), isEmpty);
  });
}
