import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/enums.dart';
import '../../../engines/planner/estimate.dart';
import '../../../platform/files/file_picking.dart';
import '../../../platform/files/file_store.dart';
import '../../../platform/pdf_outline/pdf_outline.dart';
import '../../../platform/share_in/share_in.dart';
import '../data/chapter_split.dart';
import 'source_providers.dart';

part 'add_source_controller.g.dart';

/// How the chapters card splits the source (design/notes/add-source.md).
enum SplitMode { bookmarks, paste, size, one }

/// A field that stops the source from being saved.
enum AddSourceIssue { pdfMissing, titleMissing, unitsMissing, linkMissing }

/// One chapter as the chapters card lists it.
final class ChapterPreview {
  const ChapterPreview({
    required this.title,
    required this.depth,
    this.startUnit,
    this.endUnit,
    this.isShort = false,
    this.sessions = 1,
  });

  final String title;

  /// 0 for a chapter, 1 for a part nested under it.
  final int depth;
  final int? startUnit;
  final int? endUnit;

  /// Under 5 pages: offer "Short — merge with next?".
  final bool isShort;

  /// Reading sessions its first read takes; over 1 shows "Long — …".
  final int sessions;
}

/// The chosen PDF, as the details card shows it.
final class PdfSummary {
  const PdfSummary({required this.name, required this.bytes, this.pageCount});

  final String name;
  final int bytes;

  /// Null until read, or when the PDF could not be opened.
  final int? pageCount;
}

/// Everything the Add source screen shows.
final class AddSourceState {
  const AddSourceState({
    this.type,
    this.title = '',
    this.totalUnits,
    this.link = '',
    this.pdf,
    this.readingPdf = false,
    this.duplicateId,
    this.duplicateTitle,
    this.bookmarksFound = false,
    this.pdfUnreadable = false,
    this.fileFailed = false,
    this.mode = SplitMode.one,
    this.pasteText = '',
    this.splitSize = Defaults.splitSizePages,
    this.chapters = const [],
    this.pasteErrorLines = const [],
    this.issues = const {},
    this.saving = false,
    this.saveFailed = false,
  });

  final SourceType? type;
  final String title;
  final int? totalUnits;
  final String link;
  final PdfSummary? pdf;
  final bool readingPdf;

  /// Set when the chosen PDF was already added.
  final String? duplicateId;
  final String? duplicateTitle;

  /// The PDF had bookmarks to split by.
  final bool bookmarksFound;

  /// The PDF could not be opened, or has no bookmarks we can read.
  final bool pdfUnreadable;

  /// The chosen or shared file could not be read at all.
  final bool fileFailed;

  final SplitMode mode;
  final String pasteText;
  final int splitSize;
  final List<ChapterPreview> chapters;

  /// Lines of the pasted list that could not be read (1-based).
  final List<int> pasteErrorLines;
  final Set<AddSourceIssue> issues;
  final bool saving;
  final bool saveFailed;

  UnitType get unitType => unitTypeFor(type ?? SourceType.book);

  /// Chapters other than one chunk need a known size to split by.
  bool get canSplit => type != SourceType.link;

  bool get canSave =>
      type != null &&
      issues.isEmpty &&
      duplicateId == null &&
      !readingPdf &&
      !saving &&
      chapters.isNotEmpty;

  static UnitType unitTypeFor(SourceType type) => switch (type) {
    SourceType.pdf || SourceType.book || SourceType.notes => UnitType.page,
    SourceType.video => UnitType.minute,
    SourceType.qbank => UnitType.question,
    SourceType.link => UnitType.item,
  };
}

/// Builds a new source: type, details and chapter split, then saves it
/// with its file and chunks as one undoable operation.
@riverpod
class AddSourceController extends _$AddSourceController {
  /// Titles for chapters split by size, e.g. "Pages 1–20". The screen sets
  /// a localised one.
  String Function(UnitType unit, int start, int end) rangeTitle = (_, s, e) =>
      '$s–$e';

  SourceType? _type;
  String _title = '';
  int? _totalUnits;
  String _link = '';
  PdfSummary? _pdf;
  String? _pdfPath;
  String? _sha;
  bool _reading = false;
  String? _duplicateId;
  String? _duplicateTitle;
  bool _unreadable = false;
  bool _fileFailed = false;
  List<ChunkDraft> _bookmarks = const [];
  SplitMode _mode = SplitMode.one;
  String _paste = '';
  int _size = Defaults.splitSizePages;
  List<int> _pasteErrors = const [];
  bool _saving = false;
  bool _saveFailed = false;

  /// Chapters after "merge with next"; reset when the split changes.
  List<ChunkDraft>? _edited;
  List<ChunkDraft> _drafts = const [];

  @override
  AddSourceState build() => const AddSourceState();

  void setType(SourceType type) {
    if (type == _type) return;
    _type = type;
    _edited = null;
    if (type != SourceType.pdf) _clearPdf();
    _mode = _defaultMode();
    _emit();
  }

  void setTitle(String value) {
    _title = value;
    _emit();
  }

  void setTotalUnits(String value) {
    _totalUnits = int.tryParse(value.trim());
    _edited = null;
    if (_mode == SplitMode.one || _mode == SplitMode.size) {
      _mode = _defaultMode();
    }
    _emit();
  }

  void setLink(String value) {
    _link = value;
    _emit();
  }

  void setMode(SplitMode mode) {
    _mode = mode;
    _edited = null;
    _emit();
  }

  void setPasteText(String value) {
    _paste = value;
    _edited = null;
    _emit();
  }

  void changeSplitSize(int delta) {
    _size = (_size + delta).clamp(1, 999);
    _edited = null;
    _emit();
  }

  /// Joins chapter [index] with the one after it.
  void mergeWithNext(int index) {
    final list = [..._drafts];
    if (index < 0 || index + 1 >= list.length) return;
    final a = list[index], b = list[index + 1];
    list
      ..removeAt(index + 1)
      ..[index] = ChunkDraft(
        title: a.title,
        startUnit: a.startUnit,
        endUnit: b.endUnit ?? a.endUnit,
        children: [...a.children, ...b.children],
      );
    _edited = list;
    _emit();
  }

  /// Lets the student choose a PDF, rejects one already added, and reads
  /// its page count and bookmarks.
  Future<void> pickPdf() async {
    final picked = await ref.read(pdfPickerProvider).pickPdf();
    if (picked == null) return;
    await _usePdf(picked);
  }

  /// Fills the form from something shared into the app: a PDF or a link
  /// preselects its type (design/notes/add-source.md).
  Future<void> useShared(SharedItem item) async {
    switch (item) {
      case SharedPdf(:final file):
        setType(SourceType.pdf);
        await _usePdf(file);
      case SharedLink(:final url, :final title):
        setType(SourceType.link);
        _link = url;
        if (title != null && _title.trim().isEmpty) _title = title;
        _emit();
      case SharedOther():
    }
  }

  Future<void> _usePdf(PickedFile picked) async {
    _clearPdf();
    _pdf = PdfSummary(name: picked.name, bytes: picked.bytes);
    _pdfPath = picked.path;
    _reading = true;
    _emit();

    final store = await ref.read(fileStoreProvider.future);
    final String sha;
    try {
      sha = await store.hash(File(picked.path));
    } on FileSystemException {
      _clearPdf();
      _reading = false;
      _fileFailed = true;
      _emit();
      return;
    }
    final duplicate = await ref
        .read(sourceRepositoryProvider)
        .findByFileHash(sha);
    if (duplicate != null) {
      _reading = false;
      _duplicateId = duplicate.id;
      _duplicateTitle = duplicate.title;
      _emit();
      return;
    }
    _sha = sha;

    int? pages;
    var outline = const <OutlineEntry>[];
    try {
      final info = await ref.read(pdfOutlineReaderProvider).read(picked.path);
      pages = info.pageCount;
      outline = info.outline;
    } on PdfReadError {
      pages = null;
    }
    _bookmarks = pages == null ? const [] : chaptersFromOutline(outline, pages);
    _unreadable = _bookmarks.isEmpty;
    _totalUnits = pages;
    _pdf = PdfSummary(name: picked.name, bytes: picked.bytes, pageCount: pages);
    if (_title.trim().isEmpty) _title = p.basenameWithoutExtension(picked.name);
    _reading = false;
    _edited = null;
    _mode = _defaultMode();
    _emit();
  }

  /// Saves the source, its file and chapters. Returns the new source's id,
  /// or null when nothing was saved.
  Future<String?> save() async {
    if (!state.canSave) return null;
    _saving = true;
    _saveFailed = false;
    _emit();
    StoredFile? stored;
    final store = _type == SourceType.pdf
        ? await ref.read(fileStoreProvider.future)
        : null;
    try {
      if (store != null) {
        stored = await store.copyIn(File(_pdfPath!), sha: _sha);
      }
      final source = await ref
          .read(sourceRepositoryProvider)
          .createWithChunks(
            type: _type!,
            title: _title.trim(),
            unitType: state.unitType,
            uri: _type == SourceType.video || _type == SourceType.link
                ? _nonEmpty(_link)
                : null,
            totalUnits: _type == SourceType.link ? null : _totalUnits,
            chapters: _drafts,
            file: stored,
          );
      _saving = false;
      _emit();
      return source.id;
    } on Object {
      if (stored != null) await store!.remove(stored.relativePath);
      _saving = false;
      _saveFailed = true;
      _emit();
      return null;
    }
  }

  void _clearPdf() {
    _fileFailed = false;
    _pdf = null;
    _pdfPath = null;
    _sha = null;
    _duplicateId = null;
    _duplicateTitle = null;
    _unreadable = false;
    _bookmarks = const [];
    if (_type == SourceType.pdf) _totalUnits = null;
  }

  /// Bookmarks when there are any, else a split by size for anything long
  /// enough, else one chunk.
  SplitMode _defaultMode() {
    if (_type == SourceType.pdf && _bookmarks.isNotEmpty) {
      return SplitMode.bookmarks;
    }
    final total = _totalUnits;
    if (_type != SourceType.link && total != null && total > _size) {
      return SplitMode.size;
    }
    return SplitMode.one;
  }

  List<ChunkDraft> _split() {
    final total = _totalUnits;
    final unit = state.unitType;
    _pasteErrors = const [];
    switch (_mode) {
      case SplitMode.bookmarks:
        return _bookmarks;
      case SplitMode.paste:
        final parsed = chaptersFromPastedList(_paste, totalUnits: total);
        _pasteErrors = [for (final e in parsed.errors) e.line];
        return parsed.chapters;
      case SplitMode.size:
        return total == null || total < 1
            ? const []
            : chaptersBySize(
                total,
                _size,
                label: (s, e) => rangeTitle(unit, s, e),
              );
      case SplitMode.one:
        final title = _title.trim();
        return [
          ChunkDraft(
            title: title.isEmpty ? '—' : title,
            startUnit: _type == SourceType.link || total == null ? null : 1,
            endUnit: _type == SourceType.link ? null : total,
          ),
        ];
    }
  }

  Set<AddSourceIssue> _issues() => {
    if (_type == SourceType.pdf && _pdf == null) AddSourceIssue.pdfMissing,
    if (_title.trim().isEmpty) AddSourceIssue.titleMissing,
    if (_type == SourceType.link && _link.trim().isEmpty)
      AddSourceIssue.linkMissing,
    if (_type != null &&
        _type != SourceType.link &&
        (_type != SourceType.pdf ||
            (_pdf != null && _pdf!.pageCount == null)) &&
        (_totalUnits == null || _totalUnits! < 1))
      AddSourceIssue.unitsMissing,
  };

  void _emit() {
    final type = _type;
    _drafts = type == null ? const [] : _edited ?? _split();
    final unit = AddSourceState.unitTypeFor(type ?? SourceType.book);
    state = AddSourceState(
      type: type,
      title: _title,
      totalUnits: _totalUnits,
      link: _link,
      pdf: _pdf,
      readingPdf: _reading,
      duplicateId: _duplicateId,
      duplicateTitle: _duplicateTitle,
      bookmarksFound: _bookmarks.isNotEmpty,
      pdfUnreadable: _unreadable,
      fileFailed: _fileFailed,
      mode: _mode,
      pasteText: _paste,
      splitSize: _size,
      chapters: [
        for (final d in _drafts) ...[
          _preview(d, 0, unit),
          for (final c in d.children) _preview(c, 1, unit),
        ],
      ],
      pasteErrorLines: _pasteErrors,
      issues: type == null ? const {} : _issues(),
      saving: _saving,
      saveFailed: _saveFailed,
    );
  }

  static ChapterPreview _preview(ChunkDraft d, int depth, UnitType unit) {
    final size = d.sizeUnits;
    final minutes = size == null
        ? null
        : firstReadMinutes(
            units: size,
            unit: EffortUnit.values.byName(unit.name),
          );
    return ChapterPreview(
      title: d.title,
      depth: depth,
      startUnit: d.startUnit,
      endUnit: d.endUnit,
      isShort: depth == 0 && unit == UnitType.page && d.isShort,
      sessions: depth == 0 && minutes != null ? readingSessions(minutes) : 1,
    );
  }

  static String? _nonEmpty(String s) => s.trim().isEmpty ? null : s.trim();
}
