import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/buttons.dart';
import '../../../core/ui/chips.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/reading_providers.dart';
import 'source_labels.dart';

/// "How far did you get?" (design/notes/source-chapters.md), shown as a
/// bottom sheet over any screen when a reading sitting is open.
class ReadingSheet extends ConsumerWidget {
  const ReadingSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reading = ref.watch(openReadingProvider);
    final actions = ref.read(readingActionsProvider.notifier);

    // Saving also empties the provider, which closes the sheet too; close
    // only once.
    void close() {
      if (context.mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
        context.pop();
      }
    }

    return switch (reading) {
      AsyncData(value: final r?) => ReadingSheetBody(
        reading: r,
        onDiscard: () async {
          await actions.discard(r);
          close();
        },
        onSave: (choice) async {
          final messenger = ScaffoldMessenger.of(context);
          final unit = r.source.unitType;
          final out = await actions.save(
            r,
            endUnit: choice.endUnit,
            minutes: choice.minutes,
            taskNow: choice.taskNow,
            partTitle: (s, e) => unit.chunkTitle(l10n, s, e),
            pagesTitle: (ch, s, e) =>
                l10n.taskPagesTitle(ch, unit.range(l10n, s, e)),
            inChapter: choice.inChapter,
            partsDone: choice.partsDone,
            partNow: choice.partNow,
            finish: choice.finish,
            readOn: choice.readOn,
          );
          close();
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(switch (out.held) {
                  final h? => l10n.readingSavedHeld(
                    unit.range(l10n, h.start, h.end),
                  ),
                  null => l10n.readingSaved(out.tasksCreated.length),
                }),
                action: SnackBarAction(
                  label: l10n.undo,
                  onPressed: () => actions.undo(r.source.id),
                ),
              ),
            );
        },
      ),
      AsyncData() => _CloseWhenEmpty(onClose: close),
      _ => const SizedBox(height: 200),
    };
  }
}

/// Nothing is open (saved elsewhere, or undone): close the sheet.
class _CloseWhenEmpty extends StatefulWidget {
  const _CloseWhenEmpty({required this.onClose});

  final VoidCallback onClose;

  @override
  State<_CloseWhenEmpty> createState() => _CloseWhenEmptyState();
}

class _CloseWhenEmptyState extends State<_CloseWhenEmpty> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox(height: 200);
}

/// What the student chose in the sheet.
final class ReadingChoice {
  const ReadingChoice({
    required this.endUnit,
    required this.minutes,
    this.taskNow = const {},
    this.partNow = false,
    this.finish = false,
    this.readOn = false,
    this.inChapter = false,
    this.partsDone = 0,
  });

  final int endUnit;

  /// Read by chapter (D49): still in chapter [endUnit], with [partsDone]
  /// of its parts finished.
  final bool inChapter;
  final int partsDone;
  final int minutes;

  /// Partly read chapters to make tasks now (D29).
  final Set<String> taskNow;

  /// A short progressive sitting becomes a part anyway (D47).
  final bool partNow;

  /// "Done with this source" after this sitting.
  final bool finish;

  /// Start the next sitting right away.
  final bool readOn;
}

/// The sheet's content. Public so goldens can render it without a database.
class ReadingSheetBody extends StatefulWidget {
  const ReadingSheetBody({
    required this.reading,
    required this.onSave,
    required this.onDiscard,
    super.key,
  });

  final OpenReading reading;
  final Future<void> Function(ReadingChoice choice) onSave;
  final VoidCallback onDiscard;

  @override
  State<ReadingSheetBody> createState() => _ReadingSheetBodyState();
}

class _ReadingSheetBodyState extends State<ReadingSheetBody> {
  late int _minutes = widget.reading.awayMinutes;
  late int _endUnit = widget.reading.guessFor(_minutes);
  bool _endTouched = false;
  final _taskNow = <String>{};
  bool _partNow = false;
  bool _finish = false;
  bool _inChapter = false;
  int _partsDone = 0;
  bool _saving = false;

  OpenReading get _r => widget.reading;
  int get _step => _r.config.awayStepMinutes;

  void _setMinutes(int m) => setState(() {
    _minutes = m.clamp(_step, 24 * 60);
    if (!_endTouched) _endUnit = _r.guessFor(_minutes);
  });

  void _setEnd(int unit) => setState(() {
    _endUnit = unit.clamp(_r.startUnit, _r.lastUnit);
    _endTouched = true;
    _partsDone = 0;
  });

  Future<void> _save({bool readOn = false}) async {
    setState(() => _saving = true);
    try {
      await widget.onSave(
        ReadingChoice(
          endUnit: _endUnit,
          minutes: _minutes,
          taskNow: _taskNow,
          partNow: _partNow,
          finish: _finish,
          readOn: readOn,
          inChapter: _r.progress.byChapter && _inChapter,
          partsDone: _inChapter ? _partsDone : 0,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final unit = _r.source.unitType;
    final p = _r.progress;
    // Read by chapter, a chapter the student is still in is not finished.
    final byChapter = p.byChapter;
    final stillIn = byChapter && _inChapter;
    final sitting = stillIn
        ? UnitRange(_r.startUnit, _endUnit - 1)
        : UnitRange(_r.startUnit, _endUnit);
    final plan = p.planFor(sitting);
    String at(int n) =>
        byChapter ? p.chapters[n - 1].chunk.title : unit.at(l10n, n);
    final inChapter = stillIn ? p.chapters[_endUnit - 1] : null;
    final splitParts = inChapter == null
        ? 0
        : inChapter.tasks
                  .firstWhere(
                    (t) => t.parts != null,
                    orElse: () => const ChapterTask(taskId: '', title: ''),
                  )
                  .parts ??
              0;

    String rangeOf(List<int> run) {
      final first = p.chapters[run.first].range!;
      final last = p.chapters[run.last].range!;
      return unit.range(l10n, first.start, last.end);
    }

    String taskOf(List<int> run) {
      final title = taskTitleFor([
        for (final i in run) p.chapters[i].chunk.title,
      ]);
      return byChapter
          ? l10n.readingPreviewTaskOnly(title)
          : l10n.readingPreviewTask(title, rangeOf(run));
    }

    // A source split as it is read (D47): the sitting, with held ones,
    // becomes the next part unless it is short.
    final part = p.progressive ? p.nextPart(sitting) : null;
    final holds =
        p.holds(sitting, _minutes, minPartMinutes: _r.config.minPartMinutes) &&
        !_partNow &&
        !_finish;
    final atEnd = _endUnit >= _r.lastUnit && !stillIn;
    final preview = [
      if (part != null && part.size > 0)
        holds
            ? l10n.readingPreviewHeld(
                _r.config.minPartMinutes,
                unit.range(l10n, part.start, part.end),
              )
            : l10n.readingPreviewTask(
                unit.chunkTitle(l10n, part.start, part.end),
                unit.range(l10n, part.start, part.end),
              ),
      for (final run in plan.newTasks) taskOf(run),
      for (final i in plan.firstReads)
        l10n.readingPreviewFirstRead(p.chapters[i].chunk.title),
      for (final i in plan.partial)
        l10n.readingPreviewPartial(
          p.chapters[i].chunk.title,
          p.readUnitsAfter(i, sitting),
          p.chapters[i].sizeUnits,
        ),
      if (inChapter != null)
        l10n.readingPreviewInChapter(inChapter.chunk.title),
      if (_finish) l10n.readingPreviewFinish(_r.source.title),
    ];
    // Partly read chapters with pages read and no task on them (D49).
    final partialWithoutTask = [
      for (final i in plan.partial)
        if (p.readWithoutTask(i, sitting) case final r?) (p.chapters[i], r),
    ];

    Widget check(String text, bool value, void Function(bool) onChanged) =>
        Padding(
          padding: const EdgeInsets.only(top: AppSpace.sm),
          child: CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: c.accent,
            value: value,
            onChanged: (v) => setState(() => onChanged(v ?? false)),
            title: Text(text, style: AppText.body.copyWith(color: c.ink)),
          ),
        );

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
          Text(
            l10n
                .readingOverline(_r.source.title, at(_r.startUnit))
                .toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.overline.copyWith(color: c.muted),
          ),
          const SizedBox(height: AppSpace.xxs),
          Semantics(
            header: true,
            child: Text(
              l10n.readingSheetTitle,
              style: AppText.section.copyWith(color: c.ink),
            ),
          ),
          const SizedBox(height: AppSpace.xs),
          Text(
            l10n.readingAway(formatMinutes(l10n, _r.awayMinutes)),
            style: AppText.caption.copyWith(color: c.muted),
          ),
          const SizedBox(height: AppSpace.xl),
          label(l10n.readingTimeLabel),
          ValueStepper(
            value: formatMinutes(l10n, _minutes),
            lessLabel: l10n.readingLess,
            moreLabel: l10n.readingMore,
            onLess: _minutes > _step
                ? () => _setMinutes(_minutes - _step)
                : null,
            onMore: () => _setMinutes(_minutes + _step),
          ),
          const SizedBox(height: AppSpace.xl),
          label(l10n.readingUpTo),
          ValueStepper(
            value: at(_endUnit),
            lessLabel: l10n.readingLess,
            moreLabel: l10n.readingMore,
            onLess: _endUnit > _r.startUnit
                ? () => _setEnd(_endUnit - 1)
                : null,
            onMore: _endUnit < _r.lastUnit ? () => _setEnd(_endUnit + 1) : null,
          ),
          if (byChapter) ...[
            const SizedBox(height: AppSpace.md),
            Row(
              children: [
                Expanded(
                  child: ChoiceChipButton(
                    label: l10n.readingFinishedIt,
                    selected: !_inChapter,
                    onPressed: () => setState(() => _inChapter = false),
                  ),
                ),
                const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: ChoiceChipButton(
                    label: l10n.readingStillInIt,
                    selected: _inChapter,
                    onPressed: () => setState(() => _inChapter = true),
                  ),
                ),
              ],
            ),
            if (splitParts > 1) ...[
              const SizedBox(height: AppSpace.md),
              Wrap(
                spacing: AppSpace.sm,
                runSpacing: AppSpace.sm,
                children: [
                  for (var k = 1; k < splitParts; k++)
                    ChoiceChipButton(
                      label: l10n.readingPartsDone(k, splitParts),
                      fontSize: 13,
                      selected: _partsDone == k,
                      onPressed: () =>
                          setState(() => _partsDone = _partsDone == k ? 0 : k),
                    ),
                ],
              ),
            ],
          ],
          if (_r.chapterEndsNear(_endUnit) case final ends
              when ends.isNotEmpty) ...[
            const SizedBox(height: AppSpace.md),
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [
                for (final ch in ends)
                  ChoiceChipButton(
                    label: l10n.readingChapterEnd(
                      ch.chunk.title,
                      unit.at(l10n, ch.chunk.endUnit!),
                    ),
                    fontSize: 13,
                    selected: _endUnit == ch.chunk.endUnit,
                    onPressed: () => _setEnd(ch.chunk.endUnit!),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpace.xl),
          Container(
            padding: const EdgeInsets.all(AppSpace.lg),
            decoration: BoxDecoration(
              color: c.ground,
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
            child: Semantics(
              liveRegion: true,
              child: Text(
                preview.isEmpty
                    ? l10n.readingPreviewNothing
                    : preview.join(' '),
                style: AppText.body.copyWith(color: c.ink),
              ),
            ),
          ),
          for (final (ch, read) in partialWithoutTask)
            check(
              l10n.readingMakeTaskNow(
                l10n.taskPagesTitle(
                  ch.chunk.title,
                  unit.range(l10n, read.start, read.end),
                ),
              ),
              _taskNow.contains(ch.chunk.id),
              (v) =>
                  v ? _taskNow.add(ch.chunk.id) : _taskNow.remove(ch.chunk.id),
            ),
          if (holds || _partNow)
            check(l10n.readingPartNow, _partNow, (v) => _partNow = v),
          if (!atEnd)
            check(l10n.readingFinishSource, _finish, (v) => _finish = v),
          const SizedBox(height: AppSpace.xxl),
          PrimaryButton(label: l10n.save, onPressed: _saving ? null : _save),
          if (!_finish && !atEnd) ...[
            const SizedBox(height: AppSpace.sm),
            SecondaryButton(
              label: l10n.readingSaveReadOn,
              onPressed: _saving ? null : () => _save(readOn: true),
            ),
          ],
          const SizedBox(height: AppSpace.sm),
          Center(
            child: TextLinkButton(
              label: l10n.readingDidntRead,
              onPressed: _saving ? null : widget.onDiscard,
            ),
          ),
        ],
      ),
    );
  }
}
