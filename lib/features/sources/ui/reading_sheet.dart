import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/chips.dart';
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
        onSave: (endUnit, minutes, taskNow) async {
          final messenger = ScaffoldMessenger.of(context);
          final out = await actions.save(
            r,
            endUnit: endUnit,
            minutes: minutes,
            taskNow: taskNow,
          );
          close();
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(l10n.readingSaved(out.tasksCreated.length)),
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

/// The sheet's content. Public so goldens can render it without a database.
class ReadingSheetBody extends StatefulWidget {
  const ReadingSheetBody({
    required this.reading,
    required this.onSave,
    required this.onDiscard,
    super.key,
  });

  final OpenReading reading;
  final Future<void> Function(int endUnit, int minutes, Set<String> taskNow)
  onSave;
  final VoidCallback onDiscard;

  @override
  State<ReadingSheetBody> createState() => _ReadingSheetBodyState();
}

class _ReadingSheetBodyState extends State<ReadingSheetBody> {
  late int _minutes = widget.reading.awayMinutes;
  late int _endUnit = widget.reading.guessFor(_minutes);
  bool _endTouched = false;
  final _taskNow = <String>{};
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
  });

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSave(_endUnit, _minutes, _taskNow);
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
    final sitting = UnitRange(_r.startUnit, _endUnit);
    final plan = p.planFor(sitting);

    String rangeOf(List<int> run) {
      final first = p.chapters[run.first].range!;
      final last = p.chapters[run.last].range!;
      return unit.range(l10n, first.start, last.end);
    }

    final preview = [
      for (final run in plan.newTasks)
        l10n.readingPreviewTask(
          taskTitleFor([for (final i in run) p.chapters[i].chunk.title]),
          rangeOf(run),
        ),
      for (final i in plan.firstReads)
        l10n.readingPreviewFirstRead(p.chapters[i].chunk.title),
      for (final i in plan.partial)
        l10n.readingPreviewPartial(
          p.chapters[i].chunk.title,
          p.readUnitsAfter(i, sitting),
          p.chapters[i].sizeUnits,
        ),
    ];
    final partialWithoutTask = [
      for (final i in plan.partial)
        if (!p.chapters[i].hasTask) p.chapters[i],
    ];

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
                .readingOverline(_r.source.title, unit.at(l10n, _r.startUnit))
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
          _Stepper(
            value: formatMinutes(l10n, _minutes),
            onLess: _minutes > _step
                ? () => _setMinutes(_minutes - _step)
                : null,
            onMore: () => _setMinutes(_minutes + _step),
          ),
          const SizedBox(height: AppSpace.xl),
          label(l10n.readingUpTo),
          _Stepper(
            value: unit.at(l10n, _endUnit),
            onLess: _endUnit > _r.startUnit
                ? () => _setEnd(_endUnit - 1)
                : null,
            onMore: _endUnit < _r.lastUnit ? () => _setEnd(_endUnit + 1) : null,
          ),
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
          for (final ch in partialWithoutTask)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.sm),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: c.accent,
                value: _taskNow.contains(ch.chunk.id),
                onChanged: (v) => setState(
                  () => v == true
                      ? _taskNow.add(ch.chunk.id)
                      : _taskNow.remove(ch.chunk.id),
                ),
                title: Text(
                  l10n.readingMakeTaskNow(ch.chunk.title),
                  style: AppText.body.copyWith(color: c.ink),
                ),
              ),
            ),
          const SizedBox(height: AppSpace.xxl),
          PrimaryButton(label: l10n.save, onPressed: _saving ? null : _save),
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

/// A value between − and + buttons, each a 44 px target.
class _Stepper extends StatelessWidget {
  const _Stepper({required this.value, this.onLess, this.onMore});

  final String value;
  final VoidCallback? onLess;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.ground,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(color: c.chipBorder),
      ),
      child: Row(
        children: [
          RoundIconButton(
            icon: AppIcon.minus,
            semanticLabel: l10n.readingLess,
            onPressed: onLess,
          ),
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: AppText.cardTitle.copyWith(color: c.ink, fontSize: 17),
              ),
            ),
          ),
          RoundIconButton(
            icon: AppIcon.add,
            semanticLabel: l10n.readingMore,
            onPressed: onMore,
          ),
        ],
      ),
    );
  }
}
