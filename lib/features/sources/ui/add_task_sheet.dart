import 'package:flutter/material.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/enums.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/chips.dart';
import '../../../core/ui/fields.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/reading_providers.dart';
import 'source_labels.dart';

/// What the Add task sheet asks to create.
final class AddTaskRequest {
  const AddTaskRequest({
    required this.chunkIds,
    required this.title,
    required this.alreadyRead,
    this.importance,
    this.pages,
    this.parts,
  });

  final List<String> chunkIds;
  final String title;
  final Importance? importance;
  final bool alreadyRead;

  /// Only these pages of the one chapter (D49).
  final UnitRange? pages;

  /// Split the one chapter (without page numbers) into this many parts.
  final int? parts;
}

/// What a task on one chapter covers (D49).
enum _Covers { whole, pages, parts }

/// Opens the Add task sheet for chapter [index]. Returns null when closed.
Future<AddTaskRequest?> showAddTaskSheet(
  BuildContext context, {
  required SourceChaptersView view,
  required int index,
}) => showModalBottomSheet<AddTaskRequest>(
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
    child: AddTaskSheet(
      view: view,
      index: index,
      onCreate: (r) => Navigator.of(sheet).pop(r),
    ),
  ),
);

/// The sheet's content. Pre-filled so that one tap on Create is enough.
class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({
    required this.view,
    required this.index,
    required this.onCreate,
    super.key,
  });

  final SourceChaptersView view;
  final int index;
  final ValueChanged<AddTaskRequest> onCreate;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  late int _last = widget.index;
  late final _name = TextEditingController();
  bool _nameEdited = false;
  Importance? _importance;
  bool _importanceSet = false;
  late bool _alreadyRead = _chapters.every((c) => c.finished);

  /// A chapter with page numbers, and pages of it without a task.
  late final ChapterProgress _first = _all[widget.index];
  late final bool _paged = _first.range != null && _first.slot == null;
  late final UnitRange? _gap = _first.uncovered.firstOrNull;
  late _Covers _covers = _first.tasks.isNotEmpty
      ? _Covers.pages
      : _Covers.whole;
  late int _from = _gap?.start ?? 1;
  late int _to = _gap?.end ?? 1;
  int _parts = 2;

  List<ChapterProgress> get _all => widget.view.chapters;
  List<ChapterProgress> get _chapters => _all.sublist(widget.index, _last + 1);

  String _autoTitle(AppLocalizations l10n) => switch (_covers) {
    _Covers.pages => l10n.taskPagesTitle(
      _first.chunk.title,
      widget.view.source.unitType.range(l10n, _from, _to),
    ),
    _ => taskTitleFor([for (final c in _chapters) c.chunk.title]),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_nameEdited) _name.text = _autoTitle(AppLocalizations.of(context));
  }

  void _retitle() {
    if (!_nameEdited) _name.text = _autoTitle(AppLocalizations.of(context));
  }

  /// The pages chosen are all read already.
  bool get _pagesRead =>
      coveredUnits(widget.view.progress.explored, UnitRange(_from, _to)) >=
      _to - _from + 1;

  /// The highest surveyed importance of the chosen chapters, else Medium.
  Importance get _defaultImportance {
    Importance? best;
    for (final c in _chapters) {
      final i = c.importance;
      if (i != null && (best == null || i.index < best.index)) best = i;
    }
    return best ?? Importance.medium;
  }

  bool get _canAddNext =>
      _covers == _Covers.whole &&
      _last + 1 < _all.length &&
      _all[_last + 1].tasks.isEmpty;

  /// A part under the reading config's minimum gets a warning (D49).
  bool get _short {
    final minutes = switch (_covers) {
      _Covers.pages => (_to - _from + 1) * widget.view.pace,
      _Covers.parts when !_paged => widget.view.pace / _parts,
      _ => double.infinity,
    };
    return minutes < Defaults.readingMinPartMinutes;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _addNext() => setState(() {
    _last++;
    _retitle();
  });

  void _setCovers(_Covers covers) => setState(() {
    _covers = covers;
    _alreadyRead = switch (covers) {
      _Covers.pages => _pagesRead,
      _ => _first.finished,
    };
    _retitle();
  });

  void _setPages({int? from, int? to}) => setState(() {
    final gap = _gap!;
    _from = (from ?? _from).clamp(gap.start, _to);
    _to = (to ?? _to).clamp(_from, gap.end);
    _alreadyRead = _pagesRead;
    _retitle();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final view = widget.view;
    final unit = view.source.unitType;
    final importance = _importanceSet ? _importance : _defaultImportance;
    final first = _chapters.first.range;
    final last = _chapters.last.range;

    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.sm),
      child: Text(text, style: AppText.subtitle.copyWith(color: c.ink)),
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
              l10n.addTaskTitle,
              style: AppText.section.copyWith(color: c.ink),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          label(l10n.addTaskChapters),
          Wrap(
            spacing: AppSpace.sm,
            runSpacing: AppSpace.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final ch in _chapters)
                Container(
                  constraints: const BoxConstraints(minHeight: 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpace.lg,
                    vertical: AppSpace.sm,
                  ),
                  decoration: BoxDecoration(
                    color: c.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  child: Text(
                    ch.chunk.title,
                    style: AppText.caption.copyWith(
                      color: c.accentText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (_canAddNext)
                SmallButton(
                  label: l10n.addTaskNextChapter,
                  onPressed: _addNext,
                ),
            ],
          ),
          if (first != null &&
              last != null &&
              _first.slot == null &&
              _covers == _Covers.whole) ...[
            const SizedBox(height: AppSpace.xs),
            Text(
              unit.range(l10n, first.start, last.end),
              style: AppText.caption.copyWith(color: c.muted),
            ),
          ],
          if (_last == widget.index &&
              (_paged ? _gap != null : _first.tasks.isEmpty)) ...[
            const SizedBox(height: AppSpace.xl),
            label(l10n.addTaskCovers),
            Row(
              children: [
                if (_first.tasks.isEmpty) ...[
                  Expanded(
                    child: ChoiceChipButton(
                      label: l10n.addTaskWhole,
                      selected: _covers == _Covers.whole,
                      onPressed: () => _setCovers(_Covers.whole),
                    ),
                  ),
                  const SizedBox(width: AppSpace.sm),
                ],
                Expanded(
                  child: ChoiceChipButton(
                    label: _paged ? l10n.addTaskSomePages : l10n.addTaskParts,
                    selected: _covers != _Covers.whole,
                    onPressed: () =>
                        _setCovers(_paged ? _Covers.pages : _Covers.parts),
                  ),
                ),
              ],
            ),
            if (_covers == _Covers.pages) ...[
              const SizedBox(height: AppSpace.lg),
              label(l10n.addTaskFrom),
              ValueStepper(
                value: unit.at(l10n, _from),
                lessLabel: l10n.readingLess,
                moreLabel: l10n.readingMore,
                onLess: _from > _gap!.start
                    ? () => _setPages(from: _from - 1)
                    : null,
                onMore: _from < _to ? () => _setPages(from: _from + 1) : null,
              ),
              const SizedBox(height: AppSpace.md),
              label(l10n.addTaskTo),
              ValueStepper(
                value: unit.at(l10n, _to),
                lessLabel: l10n.readingLess,
                moreLabel: l10n.readingMore,
                onLess: _to > _from ? () => _setPages(to: _to - 1) : null,
                onMore: _to < _gap.end ? () => _setPages(to: _to + 1) : null,
              ),
            ],
            if (_covers == _Covers.parts) ...[
              const SizedBox(height: AppSpace.lg),
              ValueStepper(
                value: l10n.addTaskPartsCount(_parts),
                lessLabel: l10n.readingLess,
                moreLabel: l10n.readingMore,
                onLess: _parts > 2 ? () => setState(() => _parts--) : null,
                onMore: _parts < Defaults.chapterPartsMax
                    ? () => setState(() => _parts++)
                    : null,
              ),
              const SizedBox(height: AppSpace.xs),
              Text(
                l10n.addTaskPartsHint(
                  l10n.taskPartTitle(_first.chunk.title, 1, _parts),
                ),
                style: AppText.caption.copyWith(color: c.muted),
              ),
            ],
            if (_short) ...[
              const SizedBox(height: AppSpace.xs),
              Text(
                l10n.addTaskShort,
                style: AppText.caption.copyWith(color: c.warningText),
              ),
            ],
          ],
          if (_covers != _Covers.parts) ...[
            const SizedBox(height: AppSpace.xl),
            LabeledField(
              label: l10n.addTaskName,
              controller: _name,
              onChanged: (_) => _nameEdited = true,
            ),
          ],
          if (view.examName case final exam?) ...[
            const SizedBox(height: AppSpace.xl),
            label(l10n.surveyImportanceFor(exam)),
            Row(
              children: [
                for (final (i, option) in Importance.values.indexed) ...[
                  if (i > 0) const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: ChoiceChipButton(
                      label: switch (option) {
                        Importance.high => l10n.importanceHigh,
                        Importance.medium => l10n.importanceMedium,
                        Importance.low => l10n.importanceLow,
                      },
                      selected: importance == option,
                      onPressed: () => setState(() {
                        _importance = option;
                        _importanceSet = true;
                      }),
                    ),
                  ),
                ],
              ],
            ),
          ],
          const SizedBox(height: AppSpace.xl),
          label(l10n.addTaskAlreadyRead),
          Row(
            children: [
              Expanded(
                child: ChoiceChipButton(
                  label: l10n.addTaskNotYet,
                  selected: !_alreadyRead,
                  onPressed: () => setState(() => _alreadyRead = false),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: ChoiceChipButton(
                  label: l10n.addTaskYes,
                  selected: _alreadyRead,
                  onPressed: () => setState(() => _alreadyRead = true),
                ),
              ),
            ],
          ),
          if (_alreadyRead) ...[
            const SizedBox(height: AppSpace.xs),
            Text(
              l10n.addTaskYesHint,
              style: AppText.caption.copyWith(color: c.muted),
            ),
          ],
          const SizedBox(height: AppSpace.xxl),
          PrimaryButton(
            label: l10n.addTaskCreate,
            onPressed: () => widget.onCreate(
              AddTaskRequest(
                chunkIds: [for (final ch in _chapters) ch.chunk.id],
                title: _name.text.trim(),
                importance: view.examId == null ? null : importance,
                alreadyRead: _alreadyRead,
                pages: _covers == _Covers.pages ? UnitRange(_from, _to) : null,
                parts: _covers == _Covers.parts ? _parts : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
