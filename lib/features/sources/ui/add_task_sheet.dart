import 'package:flutter/material.dart';

import '../../../core/db/enums.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/chips.dart';
import '../../../core/ui/fields.dart';
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
  });

  final List<String> chunkIds;
  final String title;
  final Importance? importance;
  final bool alreadyRead;
}

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
  late final _name = TextEditingController(text: _autoTitle);
  bool _nameEdited = false;
  Importance? _importance;
  bool _importanceSet = false;
  late bool _alreadyRead = _chapters.every((c) => c.finished);

  List<ChapterProgress> get _all => widget.view.chapters;
  List<ChapterProgress> get _chapters => _all.sublist(widget.index, _last + 1);

  String get _autoTitle =>
      taskTitleFor([for (final c in _chapters) c.chunk.title]);

  /// The highest surveyed importance of the chosen chapters, else Medium.
  Importance get _defaultImportance {
    Importance? best;
    for (final c in _chapters) {
      final i = c.importance;
      if (i != null && (best == null || i.index < best.index)) best = i;
    }
    return best ?? Importance.medium;
  }

  bool get _canAddNext => _last + 1 < _all.length && !_all[_last + 1].hasTask;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _addNext() => setState(() {
    _last++;
    if (!_nameEdited) _name.text = _autoTitle;
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
          if (first != null && last != null) ...[
            const SizedBox(height: AppSpace.xs),
            Text(
              unit.range(l10n, first.start, last.end),
              style: AppText.caption.copyWith(color: c.muted),
            ),
          ],
          const SizedBox(height: AppSpace.xl),
          LabeledField(
            label: l10n.addTaskName,
            controller: _name,
            onChanged: (_) => _nameEdited = true,
          ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
