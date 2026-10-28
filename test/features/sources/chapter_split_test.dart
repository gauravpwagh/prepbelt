import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/features/sources/data/chapter_split.dart';

void main() {
  group('chaptersFromOutline', () {
    test('each chapter runs to the page before the next', () {
      final chapters = chaptersFromOutline(const [
        OutlineEntry('Ch 1 Introduction', 1),
        OutlineEntry('Ch 2 Physics and mathematics', 12),
        OutlineEntry('Ch 3 Rest and motion', 40),
      ], 62);
      expect(chapters, const [
        ChunkDraft(title: 'Ch 1 Introduction', startUnit: 1, endUnit: 11),
        ChunkDraft(
          title: 'Ch 2 Physics and mathematics',
          startUnit: 12,
          endUnit: 39,
        ),
        ChunkDraft(title: 'Ch 3 Rest and motion', startUnit: 40, endUnit: 62),
      ]);
    });

    test('nested bookmarks become parts within their chapter', () {
      final chapters = chaptersFromOutline(const [
        OutlineEntry('Ch 1', 1, [
          OutlineEntry('1.1', 1),
          OutlineEntry('1.2', 5),
        ]),
        OutlineEntry('Ch 2', 10),
      ], 20);
      expect(chapters.first.children, const [
        ChunkDraft(title: '1.1', startUnit: 1, endUnit: 4),
        ChunkDraft(title: '1.2', startUnit: 5, endUnit: 9),
      ]);
      expect(chapters.last.endUnit, 20);
    });

    test('bookmarks out of order, on the same page, or without a page', () {
      final chapters = chaptersFromOutline(const [
        OutlineEntry('B', 10),
        OutlineEntry('A', 1),
        OutlineEntry('A2', 1),
        OutlineEntry('Part', null, [OutlineEntry('C', 15)]),
        OutlineEntry('Beyond', 99),
      ], 20);
      expect(chapters.map((c) => (c.title, c.startUnit, c.endUnit)), [
        ('A', 1, 1),
        ('A2', 1, 9),
        ('B', 10, 14),
        ('C', 15, 19),
        ('Beyond', 20, 20),
      ]);
    });
  });

  group('chaptersFromPastedList', () {
    test('reads titles ending in a page number', () {
      final r = chaptersFromPastedList(
        'Introduction 1\n'
        '2. Physics and mathematics ..... 12\n'
        '\n'
        'Rest and motion: 40\n',
        totalUnits: 62,
      );
      expect(r.errors, isEmpty);
      expect(r.chapters.map((c) => (c.title, c.startUnit, c.endUnit)), [
        ('Introduction', 1, 11),
        ('2. Physics and mathematics', 12, 39),
        ('Rest and motion', 40, 62),
      ]);
    });

    test('reports lines it cannot read and leaves the end open if unknown', () {
      final r = chaptersFromPastedList('No page here\nOptics 10\n42');
      expect(r.errors.map((e) => e.line), [1, 3]);
      expect(r.chapters.single.endUnit, isNull);
    });
  });

  test('chaptersBySize splits evenly with a shorter last part', () {
    final parts = chaptersBySize(45, 20, label: (s, e) => 'Pages $s–$e');
    expect(parts.map((c) => c.title), [
      'Pages 1–20',
      'Pages 21–40',
      'Pages 41–45',
    ]);
    expect(parts.last.isShort, isFalse);
    expect(chaptersBySize(44, 20, label: (s, e) => '').last.isShort, isTrue);
  });
}
