import 'package:flutter/material.dart';

import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/reading_providers.dart';
import 'source_labels.dart';

/// What the chapter sheet asks to do (D56).
sealed class ChapterChange {
  const ChapterChange();
}

/// Save the name and, for chapters with pages, the range.
final class ChapterSave extends ChapterChange {
  const ChapterSave({
    required this.title,
    this.start,
    this.end,
    this.endsSource = false,
  });

  final String title;
  final int? start;
  final int? end;

  /// The source ends at [end] (D58).
  final bool endsSource;
}

final class ChapterDelete extends ChapterChange {
  const ChapterDelete();
}

/// Opens the sheet for chapter [index] of [view], or for a new chapter
/// when [index] is null. Returns null when closed.
Future<ChapterChange?> showChapterSheet(
  BuildContext context, {
  required SourceChaptersView view,
  int? index,
}) => showModalBottomSheet<ChapterChange>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  backgroundColor: context.colors.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
  ),
  builder: (sheet) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(sheet).bottom),
    // Above the system navigation bar; useSafeArea covers only the top.
    child: SafeArea(
      top: false,
      child: ChapterSheet(
        view: view,
        index: index,
        onDone: (change) => Navigator.of(sheet).pop(change),
      ),
    ),
  ),
);

/// Edit chapter (rename, move its pages, delete) or Add chapter (D56,
/// D58). Pages move even under tasks, which keep their own pages; units
/// taken from a neighbour are named before saving. Delete is refused
/// while a task covers the chapter.
class ChapterSheet extends StatefulWidget {
  const ChapterSheet({
    required this.view,
    required this.onDone,
    this.index,
    super.key,
  });

  final SourceChaptersView view;

  /// The chapter edited; null adds one.
  final int? index;
  final ValueChanged<ChapterChange> onDone;

  @override
  State<ChapterSheet> createState() => _ChapterSheetState();
}

class _ChapterSheetState extends State<ChapterSheet> {
  late final ChapterProgress? _chapter = switch (widget.index) {
    final i? => widget.view.chapters[i],
    null => null,
  };
  late final _name = TextEditingController(text: _chapter?.chunk.title ?? '');
  late final _from = TextEditingController(text: '${_initial.$1}');
  late final _to = TextEditingController(text: '${_initial.$2}');
  late bool _endsSource = _isLast && _initial.$2 == _total;
  bool _nameEdited = false;
  String? _error;

  List<ChapterProgress> get _all => widget.view.chapters;
  int? get _total => widget.view.source.totalUnits;
  bool get _hasTasks => _chapter?.tasks.isNotEmpty ?? false;

  /// The source counts pages (or minutes) per chapter, not chapters.
  bool get _paged =>
      !widget.view.progress.byChapter &&
      (_total != null || _all.any((c) => c.chunk.startUnit != null));

  /// Pages a new chapter starts with: right after the last chapter, up to
  /// the end of the source.
  late final (int, int) _initial = () {
    if (_chapter?.chunk case final c? when c.startUnit != null) {
      return (c.startUnit!, c.endUnit ?? c.startUnit!);
    }
    final start = _lastEnd + 1;
    final total = _total;
    return (start, total != null && total >= start ? total : start);
  }();

  int get _lastEnd => _all.fold<int>(0, (m, c) {
    final e = c.chunk.endUnit ?? 0;
    return e > m ? e : m;
  });

  /// A new chapter, or the one that ends furthest along.
  bool get _isLast =>
      _chapter == null || (_chapter.chunk.endUnit ?? 0) >= _lastEnd;

  /// Read by chapter, deleting shifts the chapters after it; refused
  /// once any of them is read.
  bool get _laterRead =>
      widget.view.progress.byChapter &&
      _all
          .skip((widget.index ?? _all.length) + 1)
          .any((c) => c.finished || c.readUnits > 0);

  /// The typed range, when the numbers make one.
  UnitRange? get _range => switch ((
    int.tryParse(_from.text.trim()),
    int.tryParse(_to.text.trim()),
  )) {
    (final a?, final b?) when a >= 1 && b >= a => UnitRange(a, b),
    _ => null,
  };

  ChapterFit? get _fit => switch (_range) {
    final r? => fitChapter(r, {
      for (final c in _all)
        if (c.chunk.id != _chapter?.chunk.id && c.chunk.startUnit != null)
          c.chunk.id: UnitRange(c.chunk.startUnit!, c.chunk.endUnit!),
    }),
    null => null,
  };

  String _auto(int start, int end) => widget.view.source.unitType.chunkTitle(
    AppLocalizations.of(context),
    start,
    end,
  );

  /// The name to save: the typed one, or the range when the name was the
  /// old range (or empty) and the student did not change it.
  String _title(UnitRange? r) {
    final typed = _name.text.trim();
    if (r == null || _nameEdited && typed.isNotEmpty) return typed;
    final wasAuto =
        typed.isEmpty ||
        (_chapter != null && typed == _auto(_initial.$1, _initial.$2));
    return wasAuto ? _auto(r.start, r.end) : typed;
  }

  @override
  void dispose() {
    _name.dispose();
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  void _changed() => setState(() => _error = null);

  void _save(AppLocalizations l10n) {
    if (!_paged) {
      final title = _name.text.trim();
      if (title.isEmpty) {
        setState(() => _error = l10n.chapterNameNeeded);
        return;
      }
      widget.onDone(ChapterSave(title: title));
      return;
    }
    final r = _range;
    final total = _total;
    if (r == null || (!_endsSource && total != null && r.end > total)) {
      setState(() => _error = l10n.chapterPagesInvalid(total ?? 0));
      return;
    }
    if (_fit?.blocker case final id?) {
      final other = _all.firstWhere((c) => c.chunk.id == id).chunk.title;
      setState(() => _error = l10n.chapterSwallows(other));
      return;
    }
    widget.onDone(
      ChapterSave(
        title: _title(r),
        start: r.start,
        end: r.end,
        endsSource: _endsSource && r.end != total,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final unit = widget.view.source.unitType;
    final adding = widget.index == null;
    final canDelete = !adding && !_hasTasks && !_laterRead;
    final trims = _fit?.trims ?? const <String, UnitRange>{};

    Widget note(String text, {Color? color}) => Padding(
      padding: const EdgeInsets.only(top: AppSpace.sm),
      child: Text(
        text,
        style: AppText.caption.copyWith(color: color ?? c.muted),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: Text(
              adding ? l10n.chapterAddTitle : l10n.chapterEditTitle,
              style: AppText.section.copyWith(color: c.ink),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          LabeledField(
            label: l10n.chapterName,
            controller: _name,
            hint: _paged ? l10n.chapterNameHint : null,
            onChanged: (_) {
              _nameEdited = true;
              _changed();
            },
          ),
          if (_paged) ...[
            const SizedBox(height: AppSpace.lg),
            Row(
              children: [
                Expanded(
                  child: LabeledField(
                    label: l10n.addTaskFrom,
                    controller: _from,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _changed(),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: LabeledField(
                    label: l10n.addTaskTo,
                    controller: _to,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _changed(),
                  ),
                ),
              ],
            ),
            for (final MapEntry(key: id, value: left) in trims.entries)
              if (_all.firstWhere((ch) => ch.chunk.id == id).chunk
                  case final other)
                note(
                  l10n.chapterTakes(
                    // What the neighbour gives up: the end of the one
                    // before, or the start of the one after.
                    left.start == other.startUnit
                        ? unit.range(l10n, left.end + 1, other.endUnit!)
                        : unit.range(l10n, other.startUnit!, left.start - 1),
                    other.title,
                  ),
                  color: c.warningText,
                ),
            if (_hasTasks) note(l10n.chapterTasksKeepPages),
            if (_isLast) ...[
              const SizedBox(height: AppSpace.sm),
              CheckboxListTile(
                value: _endsSource,
                onChanged: (v) => setState(() {
                  _endsSource = v ?? false;
                  _error = null;
                }),
                title: Text(
                  l10n.chapterEndsSource,
                  style: AppText.body.copyWith(color: c.ink),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: c.accent,
                checkColor: c.onAccent,
                side: BorderSide(color: c.chipBorder, width: 1.5),
              ),
            ],
          ],
          if (_error case final e?) note(e, color: c.warningText),
          const SizedBox(height: AppSpace.xxl),
          PrimaryButton(
            label: adding ? l10n.chapterAdd : l10n.save,
            onPressed: () => _save(l10n),
          ),
          if (!adding) ...[
            const SizedBox(height: AppSpace.md),
            Center(
              child: TextLinkButton(
                label: l10n.chapterDelete,
                onPressed: canDelete
                    ? () => widget.onDone(const ChapterDelete())
                    : null,
              ),
            ),
            if (_hasTasks)
              note(l10n.chapterDeleteHasTasks(_chapter!.tasks.length))
            else if (_laterRead)
              note(l10n.chapterDeleteLaterRead),
          ],
        ],
      ),
    );
  }
}
