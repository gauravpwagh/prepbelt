import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

/// A whole-device backup (docs/05-architecture.md, "Backup"): a zip with
/// `manifest.json`, the SQLite database and the `sources/` folder of app
/// storage. Since the study folder (D51, version 2) PDFs live there, so
/// that folder is empty or holds only files not moved yet.
///
/// Restore is staged: the backup is unpacked next to the database and
/// swapped in by [applyPendingRestore] on the next start, before the
/// database opens, so no open connection ever sees the file change.
abstract final class Backup {
  static const format = 'prepbelt-backup';
  static const version = 2;
  static const dbName = 'prepbelt.sqlite';
  static const sourcesFolder = 'sources';
  static const _staging = 'restore';
  static const _ready = 'READY';

  /// Zips [databaseCopy] (a consistent copy of the database) and the
  /// sources folder under [documents].
  static Uint8List build({
    required File databaseCopy,
    required Directory documents,
    required int schemaVersion,
    required DateTime createdAt,
  }) {
    final archive = Archive();
    final sources = Directory(p.join(documents.path, sourcesFolder));
    final files = sources.existsSync()
        ? [
            for (final e in sources.listSync(recursive: true))
              if (e is File) e,
          ]
        : <File>[];
    final manifest = {
      'format': format,
      'version': version,
      'schemaVersion': schemaVersion,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'files': files.length,
    };
    archive
      ..addFile(ArchiveFile.string('manifest.json', jsonEncode(manifest)))
      ..addFile(ArchiveFile.bytes(dbName, databaseCopy.readAsBytesSync()));
    for (final f in files) {
      final rel = p
          .relative(f.path, from: documents.path)
          .replaceAll(r'\', '/');
      archive.addFile(ArchiveFile.bytes(rel, f.readAsBytesSync()));
    }
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  /// Checks [bytes] and unpacks them under [documents]/restore for the
  /// next start. Returns the backup's creation time.
  static DateTime stage(
    Uint8List bytes, {
    required Directory documents,
    required int currentSchema,
  }) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } on Object {
      throw const BackupError(BackupProblem.notABackup);
    }
    final manifestFile = archive.findFile('manifest.json');
    final dbFile = archive.findFile(dbName);
    if (manifestFile == null || dbFile == null) {
      throw const BackupError(BackupProblem.notABackup);
    }
    final Map<String, Object?> manifest;
    try {
      manifest =
          jsonDecode(utf8.decode(manifestFile.content as List<int>))
              as Map<String, Object?>;
    } on Object {
      throw const BackupError(BackupProblem.notABackup);
    }
    if (manifest['format'] != format) {
      throw const BackupError(BackupProblem.notABackup);
    }
    final schema = manifest['schemaVersion'];
    final backupVersion = manifest['version'];
    if (schema is! int ||
        schema > currentSchema ||
        (backupVersion is int && backupVersion > version)) {
      throw const BackupError(BackupProblem.tooNew);
    }

    final staging = Directory(p.join(documents.path, _staging));
    if (staging.existsSync()) staging.deleteSync(recursive: true);
    staging.createSync(recursive: true);
    for (final f in archive.files) {
      if (!f.isFile || f.name == 'manifest.json') continue;
      // Only the database and files under sources/ are restored.
      final name = f.name.replaceAll(r'\', '/');
      if (name != dbName && !name.startsWith('$sourcesFolder/')) continue;
      if (name.contains('..')) continue;
      final out = File(p.joinAll([staging.path, ...name.split('/')]));
      out.parent.createSync(recursive: true);
      out.writeAsBytesSync(f.content as List<int>);
    }
    File(
      p.join(staging.path, _ready),
    ).writeAsStringSync(manifest['createdAt'].toString());
    return DateTime.tryParse(manifest['createdAt'].toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  /// Drops a staged restore the student did not confirm.
  static void cancelPending(Directory documents) {
    final staging = Directory(p.join(documents.path, _staging));
    if (staging.existsSync()) staging.deleteSync(recursive: true);
  }

  /// Swaps a staged restore in. Call before the database opens. Returns
  /// true when a restore was applied.
  static bool applyPendingRestore(Directory documents) {
    final staging = Directory(p.join(documents.path, _staging));
    if (!File(p.join(staging.path, _ready)).existsSync()) return false;
    final db = File(p.join(documents.path, dbName));
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final f = File('${db.path}$suffix');
      if (f.existsSync()) f.deleteSync();
    }
    File(p.join(staging.path, dbName)).copySync(db.path);
    // Files in app storage come back only from a backup that holds some
    // (version 1); the study folder keeps its own.
    final sources = Directory(p.join(documents.path, sourcesFolder));
    final staged = Directory(p.join(staging.path, sourcesFolder));
    if (staged.existsSync()) {
      if (sources.existsSync()) sources.deleteSync(recursive: true);
      staged.renameSync(sources.path);
    }
    staging.deleteSync(recursive: true);
    return true;
  }
}

enum BackupProblem { notABackup, tooNew }

/// Why a file could not be restored.
final class BackupError implements Exception {
  const BackupError(this.problem);

  final BackupProblem problem;

  @override
  String toString() => 'BackupError($problem)';
}
