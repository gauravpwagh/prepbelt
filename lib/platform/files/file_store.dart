import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../../core/db/enums.dart';
import '../../core/ids/ids.dart';

/// A source file where it is kept: in the study folder, or in app storage
/// for installs from before it (D51).
final class StoredFile {
  const StoredFile({
    required this.relativePath,
    required this.bytes,
    required this.sha256,
    this.place = FilePlace.app,
  });

  /// Inside the study folder, or relative to the app documents directory
  /// (`sources/<uuid>.pdf`), by [place].
  final String relativePath;
  final FilePlace place;
  final int bytes;
  final String sha256;
}

/// Source files in app storage, from before the study folder (D51). Kept
/// to read those until a folder is chosen and they move into it, and for
/// hashing.
final class FileStore {
  FileStore({required this.root, required this.ids});

  /// The app documents directory.
  final Directory root;
  final IdGenerator ids;

  static const folder = 'sources';

  /// SHA-256 of [file] as lowercase hex, read in chunks.
  Future<String> hash(File file) async =>
      (await sha256.bind(file.openRead()).first).toString();

  /// Copies [file] in as `sources/<uuid><ext>`. Pass [sha] when already
  /// computed (to check for duplicates first).
  Future<StoredFile> copyIn(File file, {String? sha}) async {
    final digest = sha ?? await hash(file);
    final ext = p.extension(file.path).toLowerCase();
    final relative = p.posix.join(folder, '${ids.next()}$ext');
    final target = resolve(relative);
    await target.parent.create(recursive: true);
    await file.copy(target.path);
    return StoredFile(
      relativePath: relative,
      bytes: await target.length(),
      sha256: digest,
    );
  }

  /// The absolute file for a stored relative path.
  File resolve(String relativePath) =>
      File(p.joinAll([root.path, ...p.posix.split(relativePath)]));

  /// Removes a stored file, e.g. after the import is cancelled.
  Future<void> remove(String relativePath) async {
    final f = resolve(relativePath);
    if (f.existsSync()) await f.delete();
  }
}
