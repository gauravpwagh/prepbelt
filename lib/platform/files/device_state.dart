import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// What belongs to this phone, not to the student's data (D51): the study
/// folder and when the last automatic backup ran. Kept in `device.json`
/// next to the database, outside it and outside backups, so a restore
/// never brings another phone's folder and noting a backup is not itself
/// a change.
final class DeviceState {
  const DeviceState({this.folder, this.backupAt, this.backupFailedAt});

  /// The study folder's id ([StudyFolder]), if chosen.
  final String? folder;

  /// UTC ms of the last automatic backup, and of a failure after it.
  final int? backupAt;
  final int? backupFailedAt;

  DeviceState copyWith({
    String? Function()? folder,
    int? Function()? backupAt,
    int? Function()? backupFailedAt,
  }) => DeviceState(
    folder: folder == null ? this.folder : folder(),
    backupAt: backupAt == null ? this.backupAt : backupAt(),
    backupFailedAt: backupFailedAt == null
        ? this.backupFailedAt
        : backupFailedAt(),
  );

  Map<String, Object?> toJson() => {
    'folder': folder,
    'backupAt': backupAt,
    'backupFailedAt': backupFailedAt,
  };

  static DeviceState fromJson(Map<String, Object?> j) => DeviceState(
    folder: j['folder'] as String?,
    backupAt: (j['backupAt'] as num?)?.toInt(),
    backupFailedAt: (j['backupFailedAt'] as num?)?.toInt(),
  );
}

/// Reads and writes `device.json` in [dir].
final class DeviceStateFile {
  const DeviceStateFile(this.dir);

  final Directory dir;

  File get _file => File(p.join(dir.path, 'device.json'));

  Future<DeviceState> read() async {
    try {
      if (!_file.existsSync()) return const DeviceState();
      return DeviceState.fromJson(
        jsonDecode(await _file.readAsString()) as Map<String, Object?>,
      );
    } on Object {
      return const DeviceState();
    }
  }

  Future<void> write(DeviceState state) async {
    await dir.create(recursive: true);
    final tmp = File('${_file.path}.part');
    await tmp.writeAsString(jsonEncode(state.toJson()), flush: true);
    await tmp.rename(_file.path);
  }
}
