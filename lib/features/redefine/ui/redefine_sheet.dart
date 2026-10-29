import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/chips.dart';
import '../../../core/ui/fields.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../sources/ui/source_labels.dart';
import '../state/redefine_providers.dart';

/// What the Redefine sheet is showing. Merge, swap source and move to exam
/// arrive after 1.0 (docs/03-phase1-scope.md).
enum RedefineMode { edit, scope, split, pause }

/// What the sheet asks the app to do. A class so goldens can pass no-ops.
final class RedefineCallbacks {
  const RedefineCallbacks({
    required this.save,
    required this.setScope,
    required this.split,
    required this.togglePause,
    required this.cancel,
  });

  /// Name and importance (either may be unchanged).
  final Future<void> Function(String title, Importance? importance) save;
  final Future<void> Function(int start, int end, bool splitAdded) setScope;
  final Future<void> Function(int after, String a, String b) split;
  final Future<void> Function() togglePause;
  final VoidCallback cancel;
}

/// Redefine (`/tasks/:id/redefine`, mockup 5): edit, scope, split or pause
/// a task with an impact preview. Every change can be undone.
class RedefineSheet extends ConsumerWidget {
  const RedefineSheet({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(redefineViewProvider(taskId));
    final actions = ref.read(redefineActionsProvider.notifier);
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    void close() {
      if (ModalRoute.of(context)?.isCurrent ?? false) router.pop();
    }

    void saved(String message, {String? undoTask}) {
      unawaited(HapticFeedback.lightImpact());
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          action: undoTask == null
              ? null
              : SnackBarAction(
                  label: l10n.redefineUndo,
                  onPressed: () => actions.undo(undoTask),
                ),
        ),
      );
    }

    Future<void> guard(Future<void> Function() op) async {
      try {
        await op();
      } on Object {
        messenger.showSnackBar(SnackBar(content: Text(l10n.redefineFailed)));
      }
    }

    return switch (async) {
      AsyncData(value: final v) => RedefineSheetBody(
        view: v,
        nowMs: ref.read(clockProvider).nowMs(),
        callbacks: RedefineCallbacks(
          cancel: close,
          save: (title, importance) => guard(() async {
            if (title.trim().isNotEmpty && title.trim() != v.info.task.title) {
              await actions.rename(taskId, title);
            }
            if (importance != null &&
                importance != v.importance &&
                v.examId != null) {
              await actions.setImportance(v.examId!, taskId, importance);
            }
            close();
            saved(l10n.redefineSaved, undoTask: taskId);
          }),
          setScope: (start, end, splitAdded) => guard(() async {
            await actions.setScope(
              taskId,
              start: start,
              end: end,
              splitAdded: splitAdded,
            );
            close();
            saved(l10n.redefineSaved, undoTask: taskId);
          }),
          split: (after, a, b) => guard(() async {
            final (first, _) = await actions.split(
              taskId,
              after: after,
              titleA: a,
              titleB: b,
            );
            close();
            unawaited(router.pushReplacement(Routes.task(first)));
            saved(l10n.redefineSplitDone, undoTask: first);
          }),
          togglePause: () => guard(() async {
            await (v.paused ? actions.resume(taskId) : actions.pause(taskId));
            close();
            saved(l10n.redefineSaved, undoTask: taskId);
          }),
        ),
      ),
      AsyncError() => Padding(
        padding: const EdgeInsets.all(20),
        child: WarningCard(message: l10n.redefineFailed),
      ),
      _ => const SizedBox(height: 200),
    };
  }
}

/// The sheet for one task. Public so goldens can render it.
class RedefineSheetBody extends StatefulWidget {
  const RedefineSheetBody({
    required this.view,
    required this.nowMs,
    required this.callbacks,
    this.initialMode,
    super.key,
  });

  final RedefineView view;
  final int nowMs;
  final RedefineCallbacks callbacks;
  final RedefineMode? initialMode;

  @override
  State<RedefineSheetBody> createState() => _RedefineSheetBodyState();
}

class _RedefineSheetBodyState extends State<RedefineSheetBody> {
  late RedefineMode _mode =
      widget.initialMode ??
      (widget.view.canSplit ? RedefineMode.split : RedefineMode.edit);
  bool _busy = false;

  Future<void> _run(Future<void> Function() op) async {
    setState(() => _busy = true);
    try {
      await op();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final v = widget.view;
    final cb = widget.callbacks;
    final labels = {
      RedefineMode.edit: l10n.redefineEdit,
      RedefineMode.scope: l10n.redefineScope,
      RedefineMode.split: l10n.redefineSplit,
      RedefineMode.pause: v.paused ? l10n.redefineResume : l10n.redefinePause,
    };
    final Widget body = switch (_mode) {
      RedefineMode.edit => _Edit(
        view: v,
        busy: _busy,
        onSave: (t, i) => _run(() => cb.save(t, i)),
        onCancel: cb.cancel,
      ),
      RedefineMode.scope => _Scope(
        view: v,
        busy: _busy,
        onSave: (s, e, split) => _run(() => cb.setScope(s, e, split)),
        onCancel: cb.cancel,
      ),
      RedefineMode.split => _Split(
        view: v,
        nowMs: widget.nowMs,
        busy: _busy,
        onSplit: (at, a, b) => _run(() => cb.split(at, a, b)),
        onCancel: cb.cancel,
      ),
      RedefineMode.pause => _Pause(
        view: v,
        busy: _busy,
        onApply: () => _run(cb.togglePause),
        onCancel: cb.cancel,
      ),
    };
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              l10n.redefineTitle,
              style: AppText.heroTitle.copyWith(color: c.ink),
            ),
          ),
          Text(
            l10n.redefineSubtitle,
            style: AppText.subtitle.copyWith(
              color: c.muted,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final m in RedefineMode.values)
                PillChip(
                  label: labels[m]!,
                  selected: m == _mode,
                  onPressed: () => setState(() => _mode = m),
                ),
            ],
          ),
          const SizedBox(height: AppSpace.xl),
          body,
        ],
      ),
    );
  }
}

/// "WHAT HAPPENS" with icon rows (mockup 5).
class _WhatHappens extends StatelessWidget {
  const _WhatHappens({required this.rows});

  final List<(Widget, String)> rows;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.ground,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.redefineWhatHappens,
            style: AppText.overline.copyWith(color: c.muted),
          ),
          for (final (icon, text) in rows) ...[
            const SizedBox(height: AppSpace.sm),
            Row(
              children: [
                SizedBox(width: 36, child: Center(child: icon)),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Text(text, style: AppText.body.copyWith(color: c.ink)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Widget _icon(BuildContext context, AppIcon icon) =>
    AppIconView(icon, color: context.colors.muted, size: 18);

/// Cancel and the primary action, side by side as in the mockup.
class _Buttons extends StatelessWidget {
  const _Buttons({
    required this.label,
    required this.onPressed,
    required this.onCancel,
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.xl),
      child: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: l10n.redefineCancel,
              onPressed: onCancel,
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Expanded(
            flex: 2,
            child: PrimaryButton(label: label, onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}

class _Edit extends StatefulWidget {
  const _Edit({
    required this.view,
    required this.busy,
    required this.onSave,
    required this.onCancel,
  });

  final RedefineView view;
  final bool busy;
  final void Function(String title, Importance? importance) onSave;
  final VoidCallback onCancel;

  @override
  State<_Edit> createState() => _EditState();
}

class _EditState extends State<_Edit> {
  late final _name = TextEditingController(text: widget.view.info.task.title);
  late Importance? _importance = widget.view.importance;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final v = widget.view;
    final changedImportance = _importance != v.importance;
    final changed =
        changedImportance ||
        (_name.text.trim().isNotEmpty &&
            _name.text.trim() != v.info.task.title);
    String label(Importance i) => switch (i) {
      Importance.high => l10n.importanceHigh,
      Importance.medium => l10n.importanceMedium,
      Importance.low => l10n.importanceLow,
    };
    final target = switch (_importance) {
      Importance.high => 7,
      Importance.medium => 5,
      Importance.low => 4,
      null => null,
    };
    final planned = switch (_importance) {
      Importance.high => 5,
      Importance.medium => 4,
      Importance.low => 3,
      null => v.planned,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.editName,
          controller: _name,
          onChanged: (_) => setState(() {}),
        ),
        if (v.examName != null) ...[
          const SizedBox(height: AppSpace.xl),
          Text(
            l10n.editImportance(v.examName!),
            style: AppText.subtitle.copyWith(color: c.ink),
          ),
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              for (final i in Importance.values) ...[
                if (i != Importance.values.first)
                  const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: ChoiceChipButton(
                    label: label(i),
                    selected: i == _importance,
                    onPressed: () => setState(() => _importance = i),
                  ),
                ),
              ],
            ],
          ),
        ],
        const SizedBox(height: AppSpace.xl),
        _WhatHappens(
          rows: [
            if (changedImportance && target != null)
              (
                _icon(context, AppIcon.exams),
                l10n.editImpact(
                  l10n.beltName(levels.levelName(l10n, target)),
                  planned,
                ),
              )
            else
              (_icon(context, AppIcon.check), l10n.editNoChange),
            (_icon(context, AppIcon.undo), l10n.splitUndoHint),
          ],
        ),
        _Buttons(
          label: l10n.editSave,
          onPressed: changed && !widget.busy
              ? () => widget.onSave(_name.text, _importance)
              : null,
          onCancel: widget.onCancel,
        ),
      ],
    );
  }
}

class _Scope extends StatefulWidget {
  const _Scope({
    required this.view,
    required this.busy,
    required this.onSave,
    required this.onCancel,
  });

  final RedefineView view;
  final bool busy;
  final void Function(int start, int end, bool splitAdded) onSave;
  final VoidCallback onCancel;

  @override
  State<_Scope> createState() => _ScopeState();
}

class _ScopeState extends State<_Scope> {
  late int _start = widget.view.info.range?.start ?? 1;
  late int _end = widget.view.info.range?.end ?? 1;
  bool _splitAdded = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final v = widget.view;
    if (!v.canScope) {
      return Text(
        l10n.scopeUnavailable,
        style: AppText.body.copyWith(color: c.muted),
      );
    }
    final range = v.info.range!;
    final unit = v.info.source!.unitType;
    final total = v.info.source!.totalUnits ?? (range.end + 200);
    final grows = _start < range.start || _end > range.end;
    final same = _start == range.start && _end == range.end;
    final added = [
      if (_start < range.start) unit.range(l10n, _start, range.start - 1),
      if (_end > range.end) unit.range(l10n, range.end + 1, _end),
    ].join(', ');
    Widget stepper(
      String label,
      int value,
      int min,
      int max,
      void Function(int) set,
    ) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.subtitle.copyWith(color: c.ink)),
        const SizedBox(height: AppSpace.sm),
        ValueStepper(
          value: unit.at(l10n, value),
          lessLabel: l10n.readingLess,
          moreLabel: l10n.readingMore,
          onLess: value > min ? () => setState(() => set(value - 1)) : null,
          onMore: value < max ? () => setState(() => set(value + 1)) : null,
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        stepper(l10n.scopeFrom, _start, 1, _end, (x) => _start = x),
        const SizedBox(height: AppSpace.lg),
        stepper(l10n.scopeTo, _end, _start, total, (x) => _end = x),
        if (grows) ...[
          const SizedBox(height: AppSpace.xl),
          Text(
            l10n.scopeAdded(added),
            style: AppText.subtitle.copyWith(color: c.ink),
          ),
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              Expanded(
                child: ChoiceChipButton(
                  label: l10n.scopeGrowSplit,
                  selected: _splitAdded,
                  onPressed: () => setState(() => _splitAdded = true),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: ChoiceChipButton(
                  label: l10n.scopeGrowKeep,
                  selected: !_splitAdded,
                  onPressed: () => setState(() => _splitAdded = false),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpace.xl),
        _WhatHappens(
          rows: [
            (
              _icon(context, AppIcon.check),
              same
                  ? l10n.scopeSame
                  : !grows
                  ? l10n.scopeShrink
                  : _splitAdded
                  ? l10n.scopeGrowSplitImpact
                  : l10n.scopeGrowKeepImpact,
            ),
            (_icon(context, AppIcon.undo), l10n.splitUndoHint),
          ],
        ),
        _Buttons(
          label: l10n.scopeSave,
          onPressed: same || widget.busy
              ? null
              : () => widget.onSave(_start, _end, _splitAdded),
          onCancel: widget.onCancel,
        ),
      ],
    );
  }
}

class _Split extends StatefulWidget {
  const _Split({
    required this.view,
    required this.nowMs,
    required this.busy,
    required this.onSplit,
    required this.onCancel,
  });

  final RedefineView view;
  final int nowMs;
  final bool busy;
  final void Function(int after, String a, String b) onSplit;
  final VoidCallback onCancel;

  @override
  State<_Split> createState() => _SplitState();
}

class _SplitState extends State<_Split> {
  late int _after = () {
    final r = widget.view.info.range;
    return r == null ? 0 : (r.start + r.end) ~/ 2;
  }();
  TextEditingController? _a;
  TextEditingController? _b;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    final title = widget.view.info.task.title;
    _a ??= TextEditingController(text: l10n.splitPartName(title, 1));
    _b ??= TextEditingController(text: l10n.splitPartName(title, 2));
  }

  @override
  void dispose() {
    _a?.dispose();
    _b?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final v = widget.view;
    if (!v.canSplit) {
      return Text(
        l10n.splitUnavailable,
        style: AppText.body.copyWith(color: c.muted),
      );
    }
    final range = v.info.range!;
    final unit = v.info.source!.unitType;
    final d = v.display;
    final due = v.info.state.dueAt;
    String day(int ms) =>
        DateFormat('EEE d MMM', locale).format(fromUtcMs(ms).toLocal());
    final name = d.level == 0
        ? null
        : l10n.beltName(levels.levelName(l10n, d.level));
    final belt = name == null
        ? null
        : d.fading
        ? l10n.beltWithFading(name)
        : l10n.beltWithStripes(name, d.stripes);

    Widget part(
      String letter,
      TextEditingController name,
      int from,
      int to,
      Color border,
      Color fill,
      Color text,
    ) => Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.splitPart(
              letter,
              unit.count(l10n, to - from + 1).toUpperCase(),
            ),
            style: AppText.overline.copyWith(color: text),
          ),
          TextField(
            controller: name,
            onChanged: (_) => setState(() {}),
            style: AppText.body.copyWith(
              color: c.ink,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 6),
            ),
          ),
          Text(
            unit.range(l10n, from, to),
            style: AppText.caption.copyWith(color: c.muted),
          ),
        ],
      ),
    );

    final valid =
        _a!.text.trim().isNotEmpty &&
        _b!.text.trim().isNotEmpty &&
        !widget.busy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.splitDrag, style: AppText.subtitle.copyWith(color: c.ink)),
        const SizedBox(height: AppSpace.md),
        _SplitBar(
          start: range.start,
          end: range.end,
          after: _after,
          label: (u) => l10n.splitHandle(unit.at(l10n, u)),
          onChanged: (x) => setState(() => _after = x),
        ),
        const SizedBox(height: AppSpace.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              unit.at(l10n, range.start),
              style: AppText.caption.copyWith(color: c.muted),
            ),
            Text(
              l10n.splitAfter(unit.at(l10n, _after)),
              style: AppText.caption.copyWith(
                color: c.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              unit.at(l10n, range.end),
              style: AppText.caption.copyWith(color: c.muted),
            ),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: part(
                  'A',
                  _a!,
                  range.start,
                  _after,
                  c.partA,
                  c.partABg,
                  c.partAText,
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: part(
                  'B',
                  _b!,
                  _after + 1,
                  range.end,
                  c.partB,
                  c.partBBg,
                  c.partBText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.lg),
        _WhatHappens(
          rows: [
            (
              levels.badge(
                context,
                LevelBadgeData(
                  level: d.level,
                  stripes: d.stripes,
                  fading: d.fading,
                  showCaption: false,
                ),
              ),
              belt == null ? l10n.splitStartFresh : l10n.splitKeep(belt),
            ),
            if (due != null)
              (
                _icon(context, AppIcon.exams),
                l10n.splitNext(
                  day(due),
                  day(due + Duration.millisecondsPerDay),
                ),
              ),
            (_icon(context, AppIcon.undo), l10n.splitUndoHint),
          ],
        ),
        _Buttons(
          label: l10n.splitApply,
          onPressed: valid
              ? () => widget.onSplit(_after, _a!.text, _b!.text)
              : null,
          onCancel: widget.onCancel,
        ),
      ],
    );
  }
}

/// The two-coloured range bar with a draggable handle (mockup 5). Also a
/// slider for screen readers: swipe up or down to move the split.
class _SplitBar extends StatelessWidget {
  const _SplitBar({
    required this.start,
    required this.end,
    required this.after,
    required this.label,
    required this.onChanged,
  });

  final int start;
  final int end;

  /// The last unit of part A (start ≤ after < end).
  final int after;
  final String Function(int unit) label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final span = end - start + 1;
    return LayoutBuilder(
      builder: (context, box) {
        final width = box.maxWidth;
        // The handle sits on the boundary after unit [after].
        final x = width * (after - start + 1) / span;
        void drag(double dx) {
          final unit = start - 1 + (dx / width * span).round();
          onChanged(unit.clamp(start, end - 1));
        }

        return Semantics(
          slider: true,
          label: label(after),
          value: label(after),
          increasedValue: after < end - 1 ? label(after + 1) : null,
          decreasedValue: after > start ? label(after - 1) : null,
          onIncrease: after < end - 1 ? () => onChanged(after + 1) : null,
          onDecrease: after > start ? () => onChanged(after - 1) : null,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (d) => drag(d.localPosition.dx),
            onTapDown: (d) => drag(d.localPosition.dx),
            child: SizedBox(
              height: 44,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: after - start + 1,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: c.partA,
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        flex: end - after,
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: c.partB,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: (x - 14).clamp(0, width - 28),
                    top: 0,
                    child: Container(
                      width: 28,
                      height: 44,
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: c.ink, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: AppIconView(AppIcon.grip, color: c.ink, size: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Pause extends StatelessWidget {
  const _Pause({
    required this.view,
    required this.busy,
    required this.onApply,
    required this.onCancel,
  });

  final RedefineView view;
  final bool busy;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final paused = view.paused;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WhatHappens(
          rows: [
            (
              _icon(context, AppIcon.clock),
              paused ? l10n.resumeBody : l10n.pauseBody,
            ),
            (_icon(context, AppIcon.undo), l10n.splitUndoHint),
          ],
        ),
        _Buttons(
          label: paused ? l10n.resumeApply : l10n.pauseApply,
          onPressed: busy ? null : onApply,
          onCancel: onCancel,
        ),
      ],
    );
  }
}
