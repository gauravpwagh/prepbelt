import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/sources/state/study_files.dart';
import 'package:prepbelt/platform/files/device_state.dart';
import 'package:prepbelt/platform/files/file_store.dart';
import 'package:prepbelt/platform/files/study_folder.dart';

/// Overrides giving tests a study folder at [root]/folder, already chosen
/// (D51), with `device.json` under [root]/device and app storage under
/// [root]/app. Pass [appStorage] false when the test sets its own, and
/// [files] for a folder of the test's own (rooted at [root]/folder).
List<Override> overrideStudyFolder(
  Directory root, {
  bool chosen = true,
  bool appStorage = true,
  StudyFolder? files,
}) {
  final folder = Directory('${root.path}/folder')..createSync(recursive: true);
  final device = Directory('${root.path}/device')..createSync(recursive: true);
  if (chosen) {
    File(
      '${device.path}/device.json',
    ).writeAsStringSync(jsonEncode({'folder': folder.path}));
  }
  return [
    studyFolderProvider.overrideWith(
      (ref) async => files ?? LocalStudyFolder(folder),
    ),
    deviceStateFileProvider.overrideWith(
      (ref) async => DeviceStateFile(device),
    ),
    if (appStorage)
      fileStoreProvider.overrideWith(
        (ref) async => FileStore(
          root: Directory('${root.path}/app'),
          ids: ref.watch(writeContextProvider).ids,
        ),
      ),
  ];
}

