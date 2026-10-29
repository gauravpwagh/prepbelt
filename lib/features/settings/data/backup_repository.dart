import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/time/clock.dart';
import '../../../platform/files/backup.dart';

/// Backup, restore and diagnostics (design/notes/settings.md). Reads the
/// database; restore is staged for the next start ([Backup]).
final class BackupRepository {
  BackupRepository(this.db, {required this.documents, required this.clock});

  final AppDatabase db;
  final Directory documents;
  final Clock clock;

  /// A zip of everything: the database and the sources folder.
  Future<Uint8List> export() async {
    final tmp = Directory.systemTemp.createTempSync('prepbelt-backup');
    final copy = File(p.join(tmp.path, Backup.dbName));
    try {
      // A consistent copy, even while the app keeps writing.
      await db.customStatement('VACUUM INTO ?', [copy.path]);
      return Backup.build(
        databaseCopy: copy,
        documents: documents,
        schemaVersion: db.schemaVersion,
        createdAt: clock.now(),
      );
    } finally {
      tmp.deleteSync(recursive: true);
    }
  }

  /// Checks a backup and stages it for the next start. Returns when it
  /// was made. Throws [BackupError].
  DateTime stageRestore(Uint8List bytes) => Backup.stage(
    bytes,
    documents: documents,
    currentSchema: db.schemaVersion,
  );

  void cancelRestore() => Backup.cancelPending(documents);

  /// A diagnostics file for testers: versions, row counts, the latest
  /// changes (what happened, not the content) and settings other than the
  /// name. No file contents and no titles.
  Future<String> diagnostics({required String appVersion}) async {
    final counts = <String, int>{};
    for (final t in db.allTables) {
      final row = await db
          .customSelect('SELECT COUNT(*) AS n FROM "${t.actualTableName}"')
          .getSingle();
      counts[t.actualTableName] = row.read<int>('n');
    }
    final events =
        await (db.select(db.events)
              ..orderBy([(e) => OrderingTerm.desc(e.createdAt)])
              ..limit(200))
            .get();
    final settings = await db.select(db.settings).get();
    return const JsonEncoder.withIndent('  ').convert({
      'app': appVersion,
      'schemaVersion': db.schemaVersion,
      'createdAt': clock.now().toIso8601String(),
      'counts': counts,
      'settings': {
        for (final s in settings)
          if (s.key != SettingKeys.studentName) s.key: s.value,
      },
      'events': [
        for (final e in events)
          {
            'at': e.createdAt,
            'entity': e.entity,
            'op': e.op.name,
            'action': _action(e.payload),
          },
      ],
    });
  }

  static Object? _action(String payload) {
    try {
      final data = (jsonDecode(payload) as Map<String, Object?>)['data'];
      return data is Map ? data['action'] : null;
    } on Object {
      return null;
    }
  }
}
