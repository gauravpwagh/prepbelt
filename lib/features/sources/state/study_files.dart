import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../platform/files/device_state.dart';
import '../../../platform/files/file_picking.dart';
import '../../../platform/files/file_store.dart';
import '../../../platform/files/study_folder.dart';
import 'reading_providers.dart';
import 'source_providers.dart';

export '../../../platform/files/device_state.dart' show DeviceState;

part 'study_files.g.dart';

/// The platform's study folder: the system folder picker on Android, a
/// PrepBelt folder in app storage elsewhere until iOS gets a picker (D51).
/// Tests override it.
@Riverpod(keepAlive: true)
Future<StudyFolder> studyFolder(Ref ref) async => Platform.isAndroid
    ? const SafStudyFolder()
    : LocalStudyFolder(
        Directory(
          p.join((await getApplicationDocumentsDirectory()).path, 'PrepBelt'),
        ),
      );

/// Picks PDFs in the study folder. Tests override it.
@Riverpod(keepAlive: true)
PdfPicker pdfPicker(Ref ref) =>
    FolderPdfPicker(() => ref.read(studyFolderProvider.future));

/// `device.json`, next to the database. Tests override it.
@Riverpod(keepAlive: true)
Future<DeviceStateFile> deviceStateFile(Ref ref) async =>
    DeviceStateFile((await ref.watch(fileStoreProvider.future)).root);

/// This phone's folder and backup times.
@Riverpod(keepAlive: true)
class Device extends _$Device {
  @override
  Future<DeviceState> build() async =>
      (await ref.watch(deviceStateFileProvider.future)).read();

  Future<void> change(DeviceState Function(DeviceState) f) async {
    final next = f(await future);
    await (await ref.read(deviceStateFileProvider.future)).write(next);
    state = AsyncData(next);
  }
}

/// The study folder as Settings shows it.
final class FolderStatus {
  const FolderStatus({this.folder, this.label, this.available = false});

  final String? folder;
  final String? label;
  final bool available;

  bool get chosen => folder != null;
}

@riverpod
Future<FolderStatus> folderStatus(Ref ref) async {
  final folder = (await ref.watch(deviceProvider.future)).folder;
  if (folder == null) return const FolderStatus();
  final files = await ref.watch(studyFolderProvider.future);
  final available = await files.isAvailable(folder);
  return FolderStatus(
    folder: folder,
    label: available ? await files.label(folder) : null,
    available: available,
  );
}

/// True when source files exist but no study folder is available: an
/// install from before it, or a folder that went away. Today asks then.
@riverpod
Future<bool> needsFolder(Ref ref) async {
  await ref.watch(sourcesProvider.future);
  final status = await ref.watch(folderStatusProvider.future);
  if (status.available) return false;
  return (await ref.read(sourceRepositoryProvider).allFiles()).isNotEmpty;
}

/// What Edit details shows of a source (D51).
final class SourceDetails {
  const SourceDetails({
    required this.source,
    required this.minTotal,
    this.fileName,
    this.fileFound = false,
  });

  final Source source;

  /// The lowest total pages or minutes: where the last chapter ends.
  final int minTotal;

  /// The file's path in the study folder, if the source has one.
  final String? fileName;
  final bool fileFound;
}

@riverpod
Future<SourceDetails?> sourceDetails(Ref ref, String id) async {
  final sources = ref.watch(sourceRepositoryProvider);
  final source = await ref.watch(sourceProvider(id).future);
  if (source == null) return null;
  final chunks = await sources.watchChunks(id).first;
  final minTotal = chunks.fold(
    0,
    (m, c) => c.endUnit != null && c.endUnit! > m ? c.endUnit! : m,
  );
  final file = await sources.fileOf(id);
  var found = false;
  if (file != null) {
    if (file.place == FilePlace.app) {
      found = (await ref.watch(
        fileStoreProvider.future,
      )).resolve(file.localPath).existsSync();
    } else {
      final folder = await ref.read(studyFilesProvider.notifier).folder();
      found =
          folder != null &&
          await (await ref.watch(
            studyFolderProvider.future,
          )).exists(folder, file.localPath);
    }
  }
  return SourceDetails(
    source: source,
    minTotal: minTotal,
    fileName: file == null ? null : p.posix.basename(file.localPath),
    fileFound: found,
  );
}

/// What opening a source's file came to.
enum OpenOutcome {
  opened,

  /// Nothing to open (a paper book), or no app could open it.
  failed,

  /// The file is not where it was, and was not found again.
  missing,

  /// The study folder is not chosen or not available.
  noFolder,
}

/// A file the student picked to relink a source to.
final class Replacement {
  const Replacement({
    required this.pick,
    required this.sha256,
    required this.same,
    this.usedBy,
  });

  final PickedFile pick;
  final String sha256;

  /// The same file as before (same SHA-256).
  final bool same;

  /// Another source already holding this file.
  final String? usedBy;
}

/// Source files in the study folder (D51, design/notes/study-folder.md):
/// choosing the folder, keeping a picked PDF, opening, finding a moved
/// file again and relinking. Kept alive: it awaits platform pickers.
@Riverpod(keepAlive: true)
class StudyFiles extends _$StudyFiles {
  @override
  void build() {}

  Future<StudyFolder> get _files => ref.read(studyFolderProvider.future);

  /// The study folder when chosen and available.
  Future<String?> folder() async {
    final folder = (await ref.read(deviceProvider.future)).folder;
    if (folder == null) return null;
    return await (await _files).isAvailable(folder) ? folder : null;
  }

  /// Lets the student choose a folder, makes it this phone's, and moves
  /// every source file into it. Null if cancelled.
  Future<String?> choose() async {
    final files = await _files;
    final chosen = await files.choose();
    if (chosen == null) return null;
    final old = (await ref.read(deviceProvider.future)).folder;
    await ref
        .read(deviceProvider.notifier)
        .change(
          (d) => d.copyWith(
            folder: () => chosen,
            backupAt: () => null,
            backupFailedAt: () => null,
          ),
        );
    await moveInto(chosen, from: old == chosen ? null : old);
    ref.invalidate(folderStatusProvider);
    if (old != null && old != chosen) await files.release(old);
    return chosen;
  }

  /// Moves files in app storage, and those in the [from] folder, into
  /// [folder]. A file that cannot be read stays as it is; it will ask to
  /// be relinked when opened.
  Future<void> moveInto(String folder, {String? from}) async {
    final files = await _files;
    final store = await ref.read(fileStoreProvider.future);
    final sources = ref.read(sourceRepositoryProvider);
    for (final f in await sources.allFiles()) {
      final source = await sources.watch(f.sourceId).first;
      final name = fileNameFor(source?.title ?? 'Source', '.pdf');
      try {
        if (f.place == FilePlace.app) {
          final local = store.resolve(f.localPath);
          if (!local.existsSync()) continue;
          final path = await files.copyIn(folder, local.path, name);
          await sources.setFile(
            f.sourceId,
            StoredFile(
              relativePath: path,
              bytes: f.bytes,
              sha256: f.sha256,
              place: FilePlace.folder,
            ),
            action: 'moveFile',
          );
          await store.remove(f.localPath);
        } else if (from != null) {
          final copy = await files.copyOut(from, f.localPath);
          if (copy == null) continue;
          try {
            final path = await files.copyIn(folder, copy, name);
            await sources.setFile(
              f.sourceId,
              StoredFile(
                relativePath: path,
                bytes: f.bytes,
                sha256: f.sha256,
                place: FilePlace.folder,
              ),
              action: 'moveFile',
            );
          } finally {
            await _deleteLocal(copy);
          }
        }
      } on Object {
        continue;
      }
    }
  }

  /// Moves files still in app storage into the study folder, if there is
  /// one: from an install before it, or a restored version 1 backup.
  Future<void> tidy() async {
    final folder = await this.folder();
    if (folder == null) return;
    final files = await ref.read(sourceRepositoryProvider).allFiles();
    if (files.any((f) => f.place == FilePlace.app)) await moveInto(folder);
  }

  /// Lets the student pick a PDF, starting in the study folder. Null if
  /// cancelled or there is no folder.
  Future<PickedFile?> pickPdf() async {
    final folder = await this.folder();
    if (folder == null) return null;
    return ref.read(pdfPickerProvider).pickPdf(folder);
  }

  /// Where a newly added PDF is kept: in place when picked inside the
  /// folder, else copied in as "<title>.pdf".
  Future<StoredFile> keep(
    PickedFile file, {
    required String title,
    required String sha256,
  }) async {
    final folder = await this.folder();
    if (folder == null) throw const FileSystemException('No study folder');
    final path =
        file.inFolder ??
        await (await _files).copyIn(
          folder,
          file.path,
          fileNameFor(title, '.pdf'),
        );
    return StoredFile(
      relativePath: path,
      bytes: file.bytes,
      sha256: sha256,
      place: FilePlace.folder,
    );
  }

  /// Undoes [keep] after a failed save: removes a copy it made.
  Future<void> discard(PickedFile file, StoredFile stored) async {
    if (file.inFolder != null) return;
    final folder = await this.folder();
    if (folder != null) await (await _files).delete(folder, stored.relativePath);
  }

  /// Opens source [sourceId]'s file, finding it again in the folder by
  /// size and SHA-256 if it moved; else its link.
  Future<OpenOutcome> open(String sourceId) async {
    final sources = ref.read(sourceRepositoryProvider);
    final opener = ref.read(sourceOpenerProvider);
    final file = await sources.fileOf(sourceId);
    if (file == null) {
      final source = await sources.watch(sourceId).first;
      return await opener.open(uri: source?.uri)
          ? OpenOutcome.opened
          : OpenOutcome.failed;
    }
    if (file.place == FilePlace.app) {
      final store = await ref.read(fileStoreProvider.future);
      final local = store.resolve(file.localPath);
      if (!local.existsSync()) return OpenOutcome.missing;
      return await opener.open(file: local)
          ? OpenOutcome.opened
          : OpenOutcome.failed;
    }
    final folder = await this.folder();
    if (folder == null) return OpenOutcome.noFolder;
    final files = await _files;
    var path = file.localPath;
    if (!await files.exists(folder, path)) {
      final found = await findAgain(sourceId);
      if (found == null) return OpenOutcome.missing;
      path = found;
    }
    return await files.open(folder, path)
        ? OpenOutcome.opened
        : OpenOutcome.failed;
  }

  /// Looks in the study folder for a PDF with the file's size and SHA-256
  /// and relinks to it if exactly one is found. Returns its path.
  Future<String?> findAgain(String sourceId) async {
    final sources = ref.read(sourceRepositoryProvider);
    final file = await sources.fileOf(sourceId);
    final folder = await this.folder();
    if (file == null || folder == null) return null;
    final files = await _files;
    final store = await ref.read(fileStoreProvider.future);
    final candidates = [
      for (final f in await files.list(folder, recursive: true))
        if (f.bytes == file.bytes &&
            p.extension(f.path).toLowerCase() == '.pdf')
          f,
    ];
    final matches = <String>[];
    for (final c in candidates.take(_maxCandidates)) {
      final copy = await files.copyOut(folder, c.path);
      if (copy == null) continue;
      try {
        if (await store.hash(File(copy)) == file.sha256) matches.add(c.path);
      } finally {
        await _deleteLocal(copy);
      }
    }
    if (matches.length != 1) return null;
    await sources.setFile(
      sourceId,
      StoredFile(
        relativePath: matches.single,
        bytes: file.bytes,
        sha256: file.sha256,
        place: FilePlace.folder,
      ),
      action: 'findFile',
    );
    return matches.single;
  }

  /// Files of the same size hashed when finding one again, at most.
  static const _maxCandidates = 5;

  /// Lets the student pick the file again. Null if cancelled.
  Future<Replacement?> pickReplacement(String sourceId) async {
    final pick = await pickPdf();
    if (pick == null) return null;
    final store = await ref.read(fileStoreProvider.future);
    final sources = ref.read(sourceRepositoryProvider);
    final sha = await store.hash(File(pick.path));
    final old = await sources.fileOf(sourceId);
    final holder = await sources.findByFileHash(sha);
    return Replacement(
      pick: pick,
      sha256: sha,
      same: old?.sha256 == sha,
      usedBy: holder != null && holder.id != sourceId ? holder.title : null,
    );
  }

  /// Links source [sourceId] to a picked file, copying it in first when
  /// it is outside the folder. Its chapters stay as they are.
  Future<void> relink(String sourceId, Replacement r) async {
    final sources = ref.read(sourceRepositoryProvider);
    final source = await sources.watch(sourceId).first;
    final stored = await keep(
      r.pick,
      title: source?.title ?? p.basenameWithoutExtension(r.pick.name),
      sha256: r.sha256,
    );
    await sources.setFile(sourceId, stored, action: 'relinkFile');
    await _deleteLocal(r.pick.path);
  }

  Future<void> _deleteLocal(String path) async {
    try {
      final f = File(path);
      if (f.existsSync()) await f.delete();
    } on FileSystemException {
      // A leftover temporary copy is harmless.
    }
  }
}
