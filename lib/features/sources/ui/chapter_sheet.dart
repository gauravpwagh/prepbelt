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
  const ChapterSave({required this.title, this.start, this.end});

  final String title;
  final int? start;
  final int? end;
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

/// Edit chapter (rename, move its pages, delete) or Add chapter. Pages
/// stay fixed and Delete is refused while a task covers the chapter.
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
  String? _error;

  List<ChapterProgress> get _all => widget.view.chapters;
  bool get _hasTasks => _chapter?.tasks.isNotEmpty ?? false;

  /// The source counts pages (or minutes) per chapter, not chapters.
  bool get _paged =>
      !widget.view.progress.byChapter &&
      (widget.view.source.totalUnits != null ||
          _all.any((c) => c.chunk.startUnit != null));

  /// Pages a new chapter starts with: right after the last chapter, up to
  /// the end of the source.
  late final (int, int) _initial = () {
    if (_chapter?.chunk case final c? when c.startUnit != null) {
      return (c.startUnit!, c.endUnit ?? c.startUnit!);
    }
    final after = _all.fold<int>(0, (m, c) {
      final e = c.chunk.endUnit ?? 0;
      return e > m ? e : m;
    });
    final total = widget.view.source.totalUnits;
    final start = after + 1;
    return (start, total != null && total >= start ? total : start);
  }();

  /// Read by chapter, deleting shifts the chapters after it; refused
  /// once any of them is read.
  bool get _laterRead =>
      widget.view.progress.byChapter &&
      _all
          .skip((widget.index ?? _all.length) + 1)
          .any((c) => c.finished || c.readUnits > 0);

  @override
  void dispose() {
    _name.dispose();
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  void _save(AppLocalizations l10n) {
    final title = _name.text.trim();
    if (title.isEmpty) {
      setState(() => _error = l10n.chapterNameNeeded);
      return;
    }
    if (!_paged || _hasTasks) {
      widget.onDone(ChapterSave(title: title));
      return;
    }
    final start = int.tryParse(_from.text.trim());
    final end = int.tryParse(_to.text.trim());
    final total = widget.view.source.totalUnits;
    if (start == null ||
        end == null ||
        start < 1 ||
        end < start ||
        (total != null && end > total)) {
      setState(() => _error = l10n.chapterPagesInvalid(total ?? 0));
      return;
    }
    for (final (i, c) in _all.indexed) {
      if (i == widget.index) continue;
      final (s, e) = (c.chunk.startUnit, c.chunk.endUnit);
      if (s != null && e != null && start <= e && s <= end) {
        setState(() => _error = l10n.chapterOverlaps(c.chunk.title));
        return;
      }
    }
    widget.onDone(ChapterSave(title: title, start: start, end: end));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final adding = widget.index == null;
    final canDelete = !adding && !_hasTasks && !_laterRead;

    Widget note(String text) => Padding(
      padding: const EdgeInsets.only(top: AppSpace.sm),
      child: Text(text, style: AppText.caption.copyWith(color: c.muted)),
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
            onChanged: (_) => setState(() => _error = null),
          ),
          if (_paged) ...[
            const SizedBox(height: AppSpace.lg),
            if (_hasTasks)
              Text(
                l10n.chapterPagesFixed(
                  widget.view.source.unitType.range(
                    l10n,
                    _initial.$1,
                    _initial.$2,
                  ),
                ),
                style: AppText.body.copyWith(color: c.ink),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: LabeledField(
                      label: l10n.addTaskFrom,
                      controller: _from,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() => _error = null),
                    ),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: LabeledField(
                      label: l10n.addTaskTo,
                      controller: _to,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() => _error = null),
                    ),
                  ),
                ],
              ),
          ],
          if (_error case final e?) ...[
            const SizedBox(height: AppSpace.sm),
            Text(e, style: AppText.caption.copyWith(color: c.warningText)),
          ],
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
