import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Saving and picking backup files. An interface so tests can run without
/// the platform dialogs.
abstract interface class BackupFiles {
  /// Saves [bytes] as [name] where the student chooses. False if cancelled.
  Future<bool> save(String name, Uint8List bytes);

  /// The bytes of a file the student picks, or null if cancelled.
  Future<Uint8List?> pick();
}

/// The platform's save and open dialogs (file_picker).
final class SystemBackupFiles implements BackupFiles {
  const SystemBackupFiles();

  @override
  Future<bool> save(String name, Uint8List bytes) async {
    final path = await FilePicker.platform.saveFile(
      fileName: name,
      bytes: bytes,
    );
    return path != null;
  }

  @override
  Future<Uint8List?> pick() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    final file = result?.files.singleOrNull;
    if (file == null) return null;
    if (file.bytes != null) return file.bytes;
    final path = file.path;
    return path == null ? null : File(path).readAsBytes();
  }
}
