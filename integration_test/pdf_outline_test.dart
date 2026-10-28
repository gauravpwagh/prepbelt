import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';
import 'package:prepbelt/platform/pdf_outline/pdf_outline.dart';

/// A hand-built 5-page PDF whose bookmarks are:
/// "Ch 1 Basics" (p. 1) with child "1.1 Units" (p. 2), "Ch 2 Motion" (p. 4).
const _pdf =
    'JVBERi0xLjQKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgL091dGxpbmVzIDIwIDAgUiAvUGFnZU1vZGUgL1VzZU91dGxpbmVzID4+CmVuZG9iagoyIDAgb2JqCjw8IC9UeXBlIC9QYWdlcyAvS2lkcyBbMTAgMCBSIDExIDAgUiAxMiAwIFIgMTMgMCBSIDE0IDAgUl0gL0NvdW50IDUgPj4KZW5kb2JqCjEwIDAgb2JqCjw8IC9UeXBlIC9QYWdlIC9QYXJlbnQgMiAwIFIgL01lZGlhQm94IFswIDAgMjAwIDIwMF0gPj4KZW5kb2JqCjExIDAgb2JqCjw8IC9UeXBlIC9QYWdlIC9QYXJlbnQgMiAwIFIgL01lZGlhQm94IFswIDAgMjAwIDIwMF0gPj4KZW5kb2JqCjEyIDAgb2JqCjw8IC9UeXBlIC9QYWdlIC9QYXJlbnQgMiAwIFIgL01lZGlhQm94IFswIDAgMjAwIDIwMF0gPj4KZW5kb2JqCjEzIDAgb2JqCjw8IC9UeXBlIC9QYWdlIC9QYXJlbnQgMiAwIFIgL01lZGlhQm94IFswIDAgMjAwIDIwMF0gPj4KZW5kb2JqCjE0IDAgb2JqCjw8IC9UeXBlIC9QYWdlIC9QYXJlbnQgMiAwIFIgL01lZGlhQm94IFswIDAgMjAwIDIwMF0gPj4KZW5kb2JqCjIwIDAgb2JqCjw8IC9UeXBlIC9PdXRsaW5lcyAvRmlyc3QgMjEgMCBSIC9MYXN0IDIzIDAgUiAvQ291bnQgMyA+PgplbmRvYmoKMjEgMCBvYmoKPDwgL1RpdGxlIChDaCAxIEJhc2ljcykgL1BhcmVudCAyMCAwIFIgL05leHQgMjMgMCBSIC9GaXJzdCAyMiAwIFIgL0xhc3QgMjIgMCBSIC9Db3VudCAxIC9EZXN0IFsxMCAwIFIgL0ZpdF0gPj4KZW5kb2JqCjIyIDAgb2JqCjw8IC9UaXRsZSAoMS4xIFVuaXRzKSAvUGFyZW50IDIxIDAgUiAvRGVzdCBbMTEgMCBSIC9GaXRdID4+CmVuZG9iagoyMyAwIG9iago8PCAvVGl0bGUgKENoIDIgTW90aW9uKSAvUGFyZW50IDIwIDAgUiAvUHJldiAyMSAwIFIgL0Rlc3QgWzEzIDAgUiAvRml0XSA+PgplbmRvYmoKeHJlZgowIDI0CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwOSAwMDAwMCBuIAowMDAwMDAwMDk4IDAwMDAwIG4gCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDE4NCAwMDAwMCBuIAowMDAwMDAwMjU2IDAwMDAwIG4gCjAwMDAwMDAzMjggMDAwMDAgbiAKMDAwMDAwMDQwMCAwMDAwMCBuIAowMDAwMDAwNDcyIDAwMDAwIG4gCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDAwIDY1NTM1IGYgCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwNTQ0IDAwMDAwIG4gCjAwMDAwMDA2MTggMDAwMDAgbiAKMDAwMDAwMDc0NSAwMDAwMCBuIAowMDAwMDAwODIxIDAwMDAwIG4gCnRyYWlsZXIKPDwgL1NpemUgMjQgL1Jvb3QgMSAwIFIgPj4Kc3RhcnR4cmVmCjkxMgolJUVPRgo=';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pdfrx reads page count and nested bookmarks on device', (
    tester,
  ) async {
    final file = File('${Directory.systemTemp.path}/outline.pdf')
      ..writeAsBytesSync(base64Decode(_pdf));
    final info = await const PdfOutlineReader().read(file.path);
    expect(info.pageCount, 5);

    final chapters = chaptersFromOutline(info.outline, info.pageCount);
    expect(chapters.map((c) => (c.title, c.startUnit, c.endUnit)), [
      ('Ch 1 Basics', 1, 3),
      ('Ch 2 Motion', 4, 5),
    ]);
    expect(chapters.first.children.single.title, '1.1 Units');
    expect(chapters.first.children.single.startUnit, 2);
  });
}
