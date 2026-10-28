/// Ways to split a source into chapters (docs/01-product.md, "Splitting a
/// PDF"): PDF bookmarks first, then a pasted chapter list, then a split by
/// size. Pure functions over plain values, so they test without a PDF.
library;

import 'dart:math';

import '../../../core/config/defaults.dart';

/// A chapter about to be saved as a Chunk. Ranges are inclusive and
/// 1-based; [children] become chunks with this one as parent.
final class ChunkDraft {
  const ChunkDraft({
    required this.title,
    this.startUnit,
    this.endUnit,
    this.children = const [],
  });

  final String title;
  final int? startUnit;
  final int? endUnit;
  final List<ChunkDraft> children;

  /// Units covered, when the range is known.
  int? get sizeUnits =>
      startUnit == null || endUnit == null ? null : endUnit! - startUnit! + 1;

  /// Under [Defaults.mergeSuggestionPages]: suggest merging with the next.
  bool get isShort =>
      (sizeUnits ?? Defaults.mergeSuggestionPages) <
      Defaults.mergeSuggestionPages;

  @override
  String toString() =>
      'ChunkDraft($title, $startUnit–$endUnit'
      '${children.isEmpty ? '' : ', $children'})';

  @override
  bool operator ==(Object other) =>
      other is ChunkDraft &&
      other.title == title &&
      other.startUnit == startUnit &&
      other.endUnit == endUnit &&
      _listEquals(other.children, children);

  @override
  int get hashCode => Object.hash(title, startUnit, endUnit, children.length);
}

/// A PDF bookmark: its title, the 1-based page it points to (null if it
/// has no destination) and nested bookmarks.
final class OutlineEntry {
  const OutlineEntry(this.title, this.page, [this.children = const []]);

  final String title;
  final int? page;
  final List<OutlineEntry> children;
}

/// Chapters from PDF bookmarks. Each runs to the page before the next
/// bookmark at its level; the last runs to its parent's end (or the last
/// page). Bookmarks without a page are dropped, keeping their children.
List<ChunkDraft> chaptersFromOutline(List<OutlineEntry> roots, int pageCount) =>
    _level(roots, 1, pageCount);

List<ChunkDraft> _level(List<OutlineEntry> entries, int from, int to) {
  final flat = <OutlineEntry>[];
  for (final e in entries) {
    if (e.page == null) {
      flat.addAll(e.children.where((c) => c.page != null));
    } else {
      flat.add(e);
    }
  }
  final pages = [
    for (final e in flat) e.page!.clamp(from, max(from, to)).toInt(),
  ];
  final order = List<int>.generate(flat.length, (i) => i)
    ..sort((a, b) => pages[a] != pages[b] ? pages[a] - pages[b] : a - b);

  final out = <ChunkDraft>[];
  for (var k = 0; k < order.length; k++) {
    final i = order[k];
    final start = pages[i];
    final nextStart = k + 1 < order.length ? pages[order[k + 1]] : to + 1;
    final end = max(start, nextStart - 1);
    out.add(
      ChunkDraft(
        title: flat[i].title.trim(),
        startUnit: start,
        endUnit: end,
        children: _level(flat[i].children, start, end),
      ),
    );
  }
  return out;
}

/// A line of a pasted chapter list could not be read.
final class ChapterListError {
  const ChapterListError(this.line, this.text);

  /// 1-based line number.
  final int line;
  final String text;
}

/// Chapters from a pasted list, one per line ending in its first page,
/// e.g. "Rest and motion 40" or "3. Rest and motion ..... 40". Blank lines
/// are skipped. The last chapter runs to [totalUnits] when known.
({List<ChunkDraft> chapters, List<ChapterListError> errors})
chaptersFromPastedList(String text, {int? totalUnits}) {
  final pattern = RegExp(r'^(.*?)[\s.,:\-–—]*(\d+)\s*$');
  final starts = <(String, int)>[];
  final errors = <ChapterListError>[];
  final lines = text.split(RegExp(r'\r?\n'));
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    final m = pattern.firstMatch(line);
    final title = m?.group(1)?.trim() ?? '';
    if (m == null || title.isEmpty) {
      errors.add(ChapterListError(i + 1, line));
      continue;
    }
    starts.add((title, int.parse(m.group(2)!)));
  }
  starts.sort((a, b) => a.$2 - b.$2);
  final chapters = <ChunkDraft>[];
  for (var k = 0; k < starts.length; k++) {
    final (title, start) = starts[k];
    final next = k + 1 < starts.length ? starts[k + 1].$2 : null;
    final end = next != null
        ? max(start, next - 1)
        : totalUnits != null
        ? max(start, totalUnits)
        : null;
    chapters.add(ChunkDraft(title: title, startUnit: start, endUnit: end));
  }
  return (chapters: chapters, errors: errors);
}

/// Splits [totalUnits] into chapters of [size] units, the last one
/// shorter. Titles come from [label], e.g. `(s, e) => 'Pages $s–$e'`.
List<ChunkDraft> chaptersBySize(
  int totalUnits,
  int size, {
  required String Function(int start, int end) label,
}) {
  if (totalUnits < 1 || size < 1) return const [];
  return [
    for (var start = 1; start <= totalUnits; start += size)
      ChunkDraft(
        title: label(start, min(totalUnits, start + size - 1)),
        startUnit: start,
        endUnit: min(totalUnits, start + size - 1),
      ),
  ];
}

bool _listEquals(List<ChunkDraft> a, List<ChunkDraft> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
