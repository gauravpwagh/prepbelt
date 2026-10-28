import 'package:pdfrx/pdfrx.dart';

/// A PDF bookmark: its title, the 1-based page it points to (null if it
/// has no destination) and nested bookmarks.
final class OutlineEntry {
  const OutlineEntry(this.title, this.page, [this.children = const []]);

  final String title;
  final int? page;
  final List<OutlineEntry> children;
}

/// What an imported PDF tells us before the student splits it.
final class PdfInfo {
  const PdfInfo({required this.pageCount, required this.outline});

  final int pageCount;

  /// Empty when the PDF has no bookmarks (often a scan).
  final List<OutlineEntry> outline;
}

/// The PDF could not be opened (damaged, or password-protected).
final class PdfReadError implements Exception {
  const PdfReadError(this.cause);

  final Object cause;

  @override
  String toString() => 'PdfReadError: $cause';
}

/// Reads page count and bookmarks offline with pdfrx (verified at the start
/// of milestone 3; docs/05-architecture.md, "PDF outline").
final class PdfOutlineReader {
  const PdfOutlineReader();

  Future<PdfInfo> read(String path) async {
    await pdfrxFlutterInitialize();
    final PdfDocument doc;
    try {
      doc = await PdfDocument.openFile(path);
    } on Object catch (e) {
      throw PdfReadError(e);
    }
    try {
      return PdfInfo(
        pageCount: doc.pages.length,
        outline: _convert(await doc.loadOutline()),
      );
    } finally {
      await doc.dispose();
    }
  }

  static List<OutlineEntry> _convert(List<PdfOutlineNode> nodes) => [
    for (final n in nodes)
      OutlineEntry(n.title, n.dest?.pageNumber, _convert(n.children)),
  ];
}
