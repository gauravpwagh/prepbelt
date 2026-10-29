import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/db/app_database.dart';
import 'package:prepbelt/core/providers/core_providers.dart';
import 'package:prepbelt/features/sources/data/source_repository.dart';
import 'package:prepbelt/features/sources/state/add_source_controller.dart';
import 'package:prepbelt/features/sources/state/source_providers.dart';
import 'package:prepbelt/platform/files/file_picking.dart';
import 'package:prepbelt/platform/files/file_store.dart';
import 'package:prepbelt/platform/pdf_outline/pdf_outline.dart';
import 'package:prepbelt/platform/share_in/share_in.dart';

import '../../support/test_db.dart';

class _Picker implements PdfPicker {
  _Picker(this.file);

  final File file;

  @override
  Future<PickedFile?> pickPdf() async => PickedFile(
    path: file.path,
    name: 'HC Verma Vol 1.pdf',
    bytes: file.lengthSync(),
  );
}

class _Reader extends PdfOutlineReader {
  const _Reader(this.info);

  final PdfInfo? info;

  @override
  Future<PdfInfo> read(String path) async =>
      info ?? (throw const PdfReadError('scanned'));
}

void main() {
  late Directory tmp;
  late File pdf;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('add_source');
    pdf = File('${tmp.path}/in.pdf')..writeAsStringSync('%PDF-1.4 fake');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  ({ProviderContainer c, AppDatabase db}) open({PdfInfo? info}) {
    final t = openTestContext();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(t.db),
        writeContextProvider.overrideWithValue(t.ctx),
        fileStoreProvider.overrideWith(
          (ref) async =>
              FileStore(root: Directory('${tmp.path}/app'), ids: t.ctx.ids),
        ),
        pdfPickerProvider.overrideWithValue(_Picker(pdf)),
        pdfOutlineReaderProvider.overrideWithValue(_Reader(info)),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await t.db.close();
    });
    // Keep the auto-dispose controller alive for the test.
    c.listen(addSourceControllerProvider, (_, _) {});
    return (c: c, db: t.db);
  }

  const outline = PdfInfo(
    pageCount: 62,
    outline: [
      OutlineEntry('Ch 1 Introduction', 1),
      OutlineEntry('Ch 2 Vectors', 12, [OutlineEntry('2.1 Addition', 12)]),
      OutlineEntry('Ch 3 Rest and motion', 60),
    ],
  );

  test('a PDF with bookmarks splits by them and saves with its file', () async {
    final (:c, :db) = open(info: outline);
    final ctl = c.read(addSourceControllerProvider.notifier)
      ..setType(SourceType.pdf);
    expect(c.read(addSourceControllerProvider).canSave, isFalse);

    await ctl.pickPdf();
    final s = c.read(addSourceControllerProvider);
    expect(s.title, 'HC Verma Vol 1');
    expect(s.pdf?.pageCount, 62);
    expect(s.mode, SplitMode.bookmarks);
    expect(s.chapters.map((ch) => (ch.title, ch.depth)), [
      ('Ch 1 Introduction', 0),
      ('Ch 2 Vectors', 0),
      ('2.1 Addition', 1),
      ('Ch 3 Rest and motion', 0),
    ]);
    expect(s.chapters.last.isShort, isTrue, reason: 'pages 60–62');
    expect(s.chapters[1].sessions, greaterThan(1), reason: '48 pages');
    expect(s.canSave, isTrue);

    final id = await ctl.save();
    final files = await db.select(db.sourceFiles).get();
    expect(files.single.sourceId, id);
    expect(
      File('${tmp.path}/app/${files.single.localPath}').existsSync(),
      isTrue,
    );
    expect(await db.select(db.chunks).get(), hasLength(4));
  });

  test('the same file again is caught as a duplicate', () async {
    final (:c, db: _) = open(info: outline);
    final ctl = c.read(addSourceControllerProvider.notifier)
      ..setType(SourceType.pdf);
    await ctl.pickPdf();
    await ctl.save();

    await ctl.pickPdf();
    final s = c.read(addSourceControllerProvider);
    expect(s.duplicateTitle, 'HC Verma Vol 1');
    expect(s.canSave, isFalse);
  });

  test('an unreadable PDF falls back to pages and manual splits', () async {
    final (:c, db: _) = open();
    final ctl = c.read(addSourceControllerProvider.notifier)
      ..setType(SourceType.pdf);
    await ctl.pickPdf();
    var s = c.read(addSourceControllerProvider);
    expect(s.pdfUnreadable, isTrue);
    expect(s.issues, contains(AddSourceIssue.unitsMissing));

    ctl.setTotalUnits('45');
    s = c.read(addSourceControllerProvider);
    expect(s.mode, SplitMode.size);
    expect(s.chapters.map((ch) => (ch.startUnit, ch.endUnit)), [
      (1, 20),
      (21, 40),
      (41, 45),
    ]);
    ctl.mergeWithNext(1);
    s = c.read(addSourceControllerProvider);
    expect(s.chapters.map((ch) => (ch.startUnit, ch.endUnit)), [
      (1, 20),
      (21, 45),
    ]);
    expect(s.canSave, isTrue);
  });

  test('a book can paste a chapter list or keep one chunk', () async {
    final (:c, :db) = open();
    final ctl = c.read(addSourceControllerProvider.notifier)
      ..setType(SourceType.book)
      ..setTitle('Physics notes')
      ..setTotalUnits('0');
    expect(
      c.read(addSourceControllerProvider).issues,
      contains(AddSourceIssue.unitsMissing),
    );
    ctl
      ..setTotalUnits('80')
      ..setMode(SplitMode.paste)
      ..setPasteText('Rest and motion 1\nno page here\nForce 41');
    var s = c.read(addSourceControllerProvider);
    expect(s.pasteErrorLines, [2]);
    expect(s.chapters.map((ch) => (ch.title, ch.startUnit, ch.endUnit)), [
      ('Rest and motion', 1, 40),
      ('Force', 41, 80),
    ]);

    ctl.setMode(SplitMode.one);
    s = c.read(addSourceControllerProvider);
    expect(s.chapters.single.title, 'Physics notes');
    await ctl.save();
    final source = (await SourceRepository(
      c.read(writeContextProvider),
    ).watchAll().first).single;
    expect((source.type, source.totalUnits), (SourceType.book, 80));
    expect(await db.select(db.sourceFiles).get(), isEmpty);
  });
  test('a shared PDF or link fills the form and preselects its type', () async {
    final (:c, db: _) = open(info: outline);
    final ctl = c.read(addSourceControllerProvider.notifier);
    await ctl.useShared(
      SharedPdf(PickedFile(path: pdf.path, name: 'NCERT.pdf', bytes: 13)),
    );
    var s = c.read(addSourceControllerProvider);
    expect(
      (s.type, s.title, s.mode, s.canSave),
      (SourceType.pdf, 'NCERT', SplitMode.bookmarks, true),
    );

    final (c: c2, db: _) = open();
    await c2
        .read(addSourceControllerProvider.notifier)
        .useShared(const SharedLink('https://youtu.be/x9', title: 'One shot'));
    s = c2.read(addSourceControllerProvider);
    expect(
      (s.type, s.link, s.title, s.canSave),
      (SourceType.link, 'https://youtu.be/x9', 'One shot', true),
    );
  });
  test(
    'a file that cannot be read shows an error, not endless reading',
    () async {
      final (:c, db: _) = open(info: outline);
      await c
          .read(addSourceControllerProvider.notifier)
          .useShared(
            SharedPdf(
              PickedFile(
                path: '${tmp.path}/gone.pdf',
                name: 'gone.pdf',
                bytes: 1,
              ),
            ),
          );
      final s = c.read(addSourceControllerProvider);
      expect(
        (s.fileFailed, s.readingPdf, s.pdf, s.canSave),
        (true, false, null, false),
      );
    },
  );
}
