import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/features/sources/state/reading_providers.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/features/sources/state/study_files.dart';
import 'package:prepbelt/platform/files/file_picking.dart';
import 'package:prepbelt/platform/files/file_store.dart';
import 'package:prepbelt/platform/files/study_folder.dart';
import 'package:prepbelt/platform/open_external/source_opener.dart';

import '../../support/study_folder.dart';
import '../../support/test_db.dart';

/// Opens nothing, but records what it was asked to open.
class _Folder extends LocalStudyFolder {
  _Folder(super.root);

  final opened = <String>[];

  @override
  Future<bool> open(String folder, String path) async {
    if (!await exists(folder, path)) return false;
    opened.add(path);
    return true;
  }
}

class _Opener implements SourceOpener {
  final opened = <String>[];

  @override
  Future<bool> open({File? file, String? uri}) async {
    opened.add(file?.path ?? uri ?? '');
    return true;
  }
}

class _Picker implements PdfPicker {
  PickedFile? next;

  @override
  Future<PickedFile?> pickPdf(String folder) async => next;
}

typedef _Env = ({
  ProviderContainer c,
  AppDatabase db,
  _Folder files,
  _Opener opener,
  _Picker picker,
});

void main() {
  late Directory tmp;
  late Directory folder;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('study_files');
    folder = Directory('${tmp.path}/folder');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  _Env open({bool chosen = true}) {
    final t = openTestContext();
    final files = _Folder(folder);
    final opener = _Opener();
    final picker = _Picker();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(t.db),
        writeContextProvider.overrideWithValue(t.ctx),
        clockProvider.overrideWithValue(t.clock),
        ...overrideStudyFolder(tmp, chosen: chosen, files: files),
        sourceOpenerProvider.overrideWithValue(opener),
        pdfPickerProvider.overrideWithValue(picker),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await t.db.close();
    });
    return (c: c, db: t.db, files: files, opener: opener, picker: picker);
  }

  Future<String> addPdf(
    ProviderContainer c, {
    required String title,
    required StoredFile file,
  }) async {
    final source = await c
        .read(sourceRepositoryProvider)
        .createWithChunks(
          type: SourceType.pdf,
          title: title,
          unitType: UnitType.page,
          chapters: const [],
          totalUnits: 10,
          file: file,
        );
    return source.id;
  }

  Future<String> sha(String path) =>
      FileStore(root: tmp, ids: openTestContext().ctx.ids).hash(File(path));

  File write(String path, String text) => File(path)
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(text);

  test('choosing a folder moves files from app storage into it, named by '
      'title', () async {
    final env = open(chosen: false);
    final c = env.c;
    final legacy = write('${tmp.path}/app/sources/abc.pdf', '%PDF one');
    final id = await addPdf(
      c,
      title: 'HC Verma: Vol 1',
      file: StoredFile(
        relativePath: 'sources/abc.pdf',
        bytes: legacy.lengthSync(),
        sha256: await sha(legacy.path),
      ),
    );
    // Auto-dispose: keep it alive while the test reads it.
    c.listen(needsFolderProvider, (_, _) {});
    expect(await c.read(needsFolderProvider.future), isTrue);

    await c.read(studyFilesProvider.notifier).choose();

    final row = await c.read(sourceRepositoryProvider).fileOf(id);
    expect((row!.localPath, row.place), (
      'HC Verma Vol 1.pdf',
      FilePlace.folder,
    ));
    expect(File('${folder.path}/HC Verma Vol 1.pdf').existsSync(), isTrue);
    expect(legacy.existsSync(), isFalse, reason: 'app storage is cleared');
    expect(await c.read(needsFolderProvider.future), isFalse);
  });

  test('a PDF picked inside the folder is used in place; one from '
      'elsewhere is copied in, with a free name', () async {
    final c = open().c;
    final notifier = c.read(studyFilesProvider.notifier);
    write('${folder.path}/Physics/Optics.pdf', 'x');
    final inPlace = await notifier.keep(
      const PickedFile(
        path: 'unused',
        name: 'Optics.pdf',
        bytes: 1,
        inFolder: 'Physics/Optics.pdf',
      ),
      title: 'Optics',
      sha256: 's1',
    );
    expect(inPlace.relativePath, 'Physics/Optics.pdf');

    write('${folder.path}/Notes.pdf', 'taken');
    final outside = write('${tmp.path}/elsewhere/n.pdf', 'new');
    final copied = await notifier.keep(
      PickedFile(path: outside.path, name: 'n.pdf', bytes: 3),
      title: 'Notes',
      sha256: 's2',
    );
    expect(copied.relativePath, 'Notes (2).pdf');
    expect(File('${folder.path}/Notes (2).pdf').readAsStringSync(), 'new');
  });

  test('a moved file is found again by size and hash; a missing one asks '
      'to relink', () async {
    final env = open();
    final c = env.c;
    final pdf = write('${folder.path}/Book.pdf', '%PDF book');
    final id = await addPdf(
      c,
      title: 'Book',
      file: StoredFile(
        relativePath: 'Book.pdf',
        bytes: pdf.lengthSync(),
        sha256: await sha(pdf.path),
        place: FilePlace.folder,
      ),
    );
    final notifier = c.read(studyFilesProvider.notifier);
    expect(await notifier.open(id), OpenOutcome.opened);

    // Moved into a subfolder, next to a same-size different file.
    write('${folder.path}/Old/Other.pdf', '%PDF xxxx');
    pdf.renameSync('${folder.path}/Old/Book.pdf');
    expect(await notifier.open(id), OpenOutcome.opened);
    expect(env.files.opened.last, 'Old/Book.pdf');
    final row = await c.read(sourceRepositoryProvider).fileOf(id);
    expect(row!.localPath, 'Old/Book.pdf');

    File('${folder.path}/Old/Book.pdf').deleteSync();
    expect(await notifier.open(id), OpenOutcome.missing);
  });

  test('relinking to a different file from elsewhere copies it in and '
      'says it differs', () async {
    final env = open();
    final c = env.c;
    final id = await addPdf(
      c,
      title: 'Book',
      file: const StoredFile(
        relativePath: 'Gone.pdf',
        bytes: 3,
        sha256: 'old',
        place: FilePlace.folder,
      ),
    );
    final other = write('${tmp.path}/dl/new.pdf', '%PDF new edition');
    env.picker.next = PickedFile(
      path: other.path,
      name: 'new.pdf',
      bytes: other.lengthSync(),
    );
    final notifier = c.read(studyFilesProvider.notifier);
    final r = await notifier.pickReplacement(id);
    expect((r!.same, r.usedBy), (false, null));
    await notifier.relink(id, r);
    final row = await c.read(sourceRepositoryProvider).fileOf(id);
    expect((row!.localPath, row.sha256), ('Book.pdf', r.sha256));
    expect(await notifier.open(id), OpenOutcome.opened);
  });

  test('without a folder a folder file cannot open; a link still opens', () async {
    final env = open(chosen: false);
    final c = env.c;
    final id = await addPdf(
      c,
      title: 'Book',
      file: const StoredFile(
        relativePath: 'Book.pdf',
        bytes: 3,
        sha256: 'x',
        place: FilePlace.folder,
      ),
    );
    final notifier = c.read(studyFilesProvider.notifier);
    expect(await notifier.open(id), OpenOutcome.noFolder);

    final link = await c
        .read(sourceRepositoryProvider)
        .create(
          type: SourceType.link,
          title: 'Notes',
          unitType: UnitType.item,
          uri: 'https://example.com',
        );
    expect(await notifier.open(link.id), OpenOutcome.opened);
    expect(env.opener.opened, ['https://example.com']);
  });

  test('fileNameFor drops characters a file name cannot hold', () {
    expect(fileNameFor('A/B: C?', '.pdf'), 'A B C.pdf');
    expect(fileNameFor('   ', '.pdf'), 'Source.pdf');
  });
}
