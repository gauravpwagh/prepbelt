import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

/// A file in the study folder.
final class FolderFile {
  const FolderFile({
    required this.path,
    required this.bytes,
    required this.modifiedAt,
  });

  /// Inside the folder, with `/` ("Physics/Optics.pdf").
  final String path;
  final int bytes;

  /// UTC ms, 0 when unknown.
  final int modifiedAt;
}

/// A PDF the student picked.
final class FolderPick {
  const FolderPick({
    required this.name,
    required this.bytes,
    required this.localCopy,
    this.inFolder,
  });

  final String name;
  final int bytes;

  /// A readable copy on this device, for hashing and bookmarks. Delete it
  /// when done.
  final String localCopy;

  /// Its path inside the study folder when picked from there: it is then
  /// used in place, not copied.
  final String? inFolder;
}

/// The folder the student chooses, where source files live and backups
/// are written (D51, design/notes/study-folder.md). A folder is an opaque
/// id: a tree URI on Android, a directory path elsewhere.
abstract interface class StudyFolder {
  /// Lets the student choose a folder. Null if cancelled.
  Future<String?> choose();

  /// Gives up a folder no longer used.
  Future<void> release(String folder);

  /// The folder still exists and may be written.
  Future<bool> isAvailable(String folder);

  /// A short name for Settings ("Documents/PrepBelt").
  Future<String> label(String folder);

  /// Lets the student pick a PDF, starting in [folder]. Null if cancelled.
  Future<FolderPick?> pickPdf(String folder);

  Future<bool> exists(String folder, String path);

  /// Files under [dir] ("" for the top), with subfolders if [recursive].
  Future<List<FolderFile>> list(
    String folder, {
    String dir = '',
    bool recursive = false,
  });

  /// Copies the local file [from] to the folder's top level as [name], or
  /// "name (2)" if taken. Returns its path inside the folder.
  Future<String> copyIn(String folder, String from, String name);

  /// Writes [bytes] at [path], making folders, through a temporary file.
  Future<void> write(String folder, String path, Uint8List bytes);

  /// Null if there is no such file.
  Future<Uint8List?> read(String folder, String path);

  /// A local copy of [path] for reading; null if missing. Delete it after.
  Future<String?> copyOut(String folder, String path);

  Future<void> delete(String folder, String path);

  /// Opens a PDF in its app. False when missing or nothing could open it.
  Future<bool> open(String folder, String path);
}

/// Android: the Storage Access Framework, through `StudyFolderChannel.kt`.
final class SafStudyFolder implements StudyFolder {
  const SafStudyFolder();

  static const _channel = MethodChannel('prepbelt/folder');

  Future<T?> _call<T>(String method, Map<String, Object?> args) =>
      _channel.invokeMethod<T>(method, args);

  @override
  Future<String?> choose() => _call<String>('choose', {});

  @override
  Future<void> release(String folder) => _call<void>('release', {
    'folder': folder,
  });

  @override
  Future<bool> isAvailable(String folder) async {
    try {
      return await _call<bool>('available', {'folder': folder}) ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<String> label(String folder) async =>
      await _call<String>('label', {'folder': folder}) ?? '';

  @override
  Future<FolderPick?> pickPdf(String folder) async {
    final m = await _channel.invokeMapMethod<String, Object?>('pickPdf', {
      'folder': folder,
    });
    if (m == null) return null;
    return FolderPick(
      name: m['name']! as String,
      bytes: (m['bytes']! as num).toInt(),
      localCopy: m['localCopy']! as String,
      inFolder: m['inFolder'] as String?,
    );
  }

  @override
  Future<bool> exists(String folder, String path) async =>
      await _call<bool>('exists', {'folder': folder, 'path': path}) ?? false;

  @override
  Future<List<FolderFile>> list(
    String folder, {
    String dir = '',
    bool recursive = false,
  }) async {
    final rows =
        await _channel.invokeListMethod<Map<Object?, Object?>>('list', {
          'folder': folder,
          'path': dir,
          'recursive': recursive,
        }) ??
        const [];
    return [
      for (final r in rows)
        FolderFile(
          path: r['path']! as String,
          bytes: (r['bytes']! as num).toInt(),
          modifiedAt: (r['modified']! as num).toInt(),
        ),
    ];
  }

  @override
  Future<String> copyIn(String folder, String from, String name) async =>
      (await _call<String>('copyIn', {
        'folder': folder,
        'from': from,
        'name': name,
      }))!;

  @override
  Future<void> write(String folder, String path, Uint8List bytes) =>
      _call<void>('write', {'folder': folder, 'path': path, 'bytes': bytes});

  @override
  Future<Uint8List?> read(String folder, String path) =>
      _call<Uint8List>('read', {'folder': folder, 'path': path});

  @override
  Future<String?> copyOut(String folder, String path) =>
      _call<String>('copyOut', {'folder': folder, 'path': path});

  @override
  Future<void> delete(String folder, String path) =>
      _call<void>('delete', {'folder': folder, 'path': path});

  @override
  Future<bool> open(String folder, String path) async =>
      await _call<bool>('open', {'folder': folder, 'path': path}) ?? false;
}

/// A directory on this device: on iOS for now a PrepBelt folder in app
/// storage, and in tests a temporary directory. [choose] returns
/// [root] without asking.
class LocalStudyFolder implements StudyFolder {
  LocalStudyFolder(this.root, {this.pickFile});

  final Directory root;

  /// Picks a PDF and returns its path; defaults to file_picker.
  final Future<String?> Function()? pickFile;

  File _file(String folder, String path) =>
      File(p.joinAll([folder, ...p.posix.split(path)]));

  @override
  Future<String?> choose() async {
    await root.create(recursive: true);
    return root.path;
  }

  @override
  Future<void> release(String folder) async {}

  @override
  Future<bool> isAvailable(String folder) async =>
      Directory(folder).existsSync();

  @override
  Future<String> label(String folder) async => p.basename(folder);

  @override
  Future<FolderPick?> pickPdf(String folder) async {
    final String? path;
    if (pickFile case final pick?) {
      path = await pick();
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );
      path = result?.files.singleOrNull?.path;
    }
    if (path == null) return null;
    final file = File(path);
    final inside = p.isWithin(folder, path)
        ? p.relative(path, from: folder).replaceAll(r'\', '/')
        : null;
    final copy = p.join(
      (await Directory.systemTemp.createTemp('prepbelt-pick')).path,
      p.basename(path),
    );
    await file.copy(copy);
    return FolderPick(
      name: p.basename(path),
      bytes: await file.length(),
      localCopy: copy,
      inFolder: inside,
    );
  }

  @override
  Future<bool> exists(String folder, String path) async =>
      _file(folder, path).existsSync();

  @override
  Future<List<FolderFile>> list(
    String folder, {
    String dir = '',
    bool recursive = false,
  }) async {
    final d = Directory(p.joinAll([folder, ...p.posix.split(dir)]));
    if (!d.existsSync()) return const [];
    return [
      for (final e in d.listSync(recursive: recursive))
        if (e is File && !p.basename(e.path).endsWith('.part'))
          FolderFile(
            path: p.relative(e.path, from: folder).replaceAll(r'\', '/'),
            bytes: e.lengthSync(),
            modifiedAt: e.lastModifiedSync().millisecondsSinceEpoch,
          ),
    ];
  }

  @override
  Future<String> copyIn(String folder, String from, String name) async {
    final ext = p.extension(name);
    final base = p.basenameWithoutExtension(name);
    var candidate = name;
    for (var n = 2; File(p.join(folder, candidate)).existsSync(); n++) {
      candidate = '$base ($n)$ext';
    }
    await Directory(folder).create(recursive: true);
    await File(from).copy(p.join(folder, candidate));
    return candidate;
  }

  @override
  Future<void> write(String folder, String path, Uint8List bytes) async {
    final target = _file(folder, path);
    await target.parent.create(recursive: true);
    final tmp = File('${target.path}.part');
    await tmp.writeAsBytes(bytes, flush: true);
    await tmp.rename(target.path);
  }

  @override
  Future<Uint8List?> read(String folder, String path) async {
    final f = _file(folder, path);
    return f.existsSync() ? f.readAsBytes() : null;
  }

  @override
  Future<String?> copyOut(String folder, String path) async {
    final f = _file(folder, path);
    if (!f.existsSync()) return null;
    final dir = await Directory.systemTemp.createTemp('prepbelt-out');
    return (await f.copy(p.join(dir.path, p.basename(path)))).path;
  }

  @override
  Future<void> delete(String folder, String path) async {
    final f = _file(folder, path);
    if (f.existsSync()) await f.delete();
  }

  @override
  Future<bool> open(String folder, String path) async {
    final f = _file(folder, path);
    if (!f.existsSync()) return false;
    return (await OpenFilex.open(f.path)).type == ResultType.done;
  }
}

/// A safe file name from a source title: no path or reserved characters,
/// at most 80 characters, ending in [ext].
String fileNameFor(String title, String ext) {
  final clean = title
      .replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  final base = clean.isEmpty
      ? 'Source'
      : clean.length > 80
      ? clean.substring(0, 80).trim()
      : clean;
  return '$base$ext';
}
