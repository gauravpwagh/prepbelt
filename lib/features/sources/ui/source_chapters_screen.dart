import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/config/defaults.dart';
import '../../../core/db/enums.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/reading_providers.dart';
import 'add_task_sheet.dart';
import 'source_labels.dart';

/// Source chapters (design/notes/source-chapters.md): read as you go,
/// survey if you like, and turn chapters into tasks.
class SourceChaptersScreen extends ConsumerWidget {
  const SourceChaptersScreen({required this.sourceId, super.key});

  final String sourceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final view = ref.watch(sourceChaptersProvider(sourceId));
    final actions = ref.read(readingActionsProvider.notifier);

    void snack(String message, {bool undo = false}) =>
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              action: undo
                  ? SnackBarAction(
                      label: l10n.undo,
                      onPressed: () => actions.undo(sourceId),
                    )
                  : null,
            ),
          );

    Future<void> read() async {
      final open = ref.read(openReadingProvider).value;
      if (open != null) {
        if (open.source.id != sourceId) snack(l10n.readingOpenFirst);
        await context.push(Routes.reading);
        return;
      }
      final result = await actions.start(sourceId);
      if (result == StartResult.notOpened) snack(l10n.readingNotOpened);
    }

    Future<void> createAll(SourceChaptersView v) async {
      final n = await actions.createAll(sourceId, examId: v.examId);
      if (n > 0) snack(l10n.chaptersTasksCreated(n), undo: true);
    }

    Future<void> addTask(SourceChaptersView v, int index) async {
      final request = await showAddTaskSheet(context, view: v, index: index);
      if (request == null) return;
      await actions.addTask(
        sourceId,
        chunkIds: request.chunkIds,
        title: request.title,
        importance: request.importance,
        alreadyRead: request.alreadyRead,
        examId: v.examId,
      );
      snack(l10n.addTaskAdded, undo: true);
    }

    return Scaffold(
      body: SourceChaptersBody(
        view: view,
        onBack: () => context.pop(),
        onRead: read,
        onFinish: () => context.push(Routes.reading),
        onSurvey: () => context.push(Routes.survey(sourceId)),
        onCreateAll: createAll,
        onAddTask: addTask,
        onOpenTask: (id) => context.push(Routes.task(id)),
        onRetry: () => ref.invalidate(sourceChaptersProvider(sourceId)),
      ),
    );
  }
}

/// The screen for one load state. Public so goldens can render it without
/// a database.
class SourceChaptersBody extends StatelessWidget {
  const SourceChaptersBody({
    required this.view,
    required this.onBack,
    required this.onRead,
    required this.onFinish,
    required this.onSurvey,
    required this.onCreateAll,
    required this.onAddTask,
    required this.onOpenTask,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<SourceChaptersView?> view;
  final VoidCallback onBack;
  final VoidCallback onRead;
  final VoidCallback onFinish;
  final VoidCallback onSurvey;
  final ValueChanged<SourceChaptersView> onCreateAll;
  final void Function(SourceChaptersView view, int index) onAddTask;
  final ValueChanged<String> onOpenTask;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final v = view.value;

    final children = switch (view) {
      AsyncData(value: final v?) => [
        if (v.progress.readable) ...[
          _ReadingCard(view: v, onRead: onRead, onFinish: onFinish),
          const SizedBox(height: AppSpace.md),
        ],
        _SummaryCard(
          view: v,
          onSurvey: onSurvey,
          onCreateAll: () => onCreateAll(v),
        ),
        const SizedBox(height: AppSpace.xl),
        if (v.chapters.isEmpty)
          _Muted(l10n.surveyEmpty)
        else
          for (final (i, c) in v.chapters.indexed)
            _ChapterRow(
              number: i + 1,
              chapter: c,
              unitType: v.source.unitType,
              joined: c.hasTask && c.taskOrder > 0,
              onAddTask: () => onAddTask(v, i),
              onOpenTask: () => onOpenTask(c.taskId!),
            ),
      ],
      AsyncError() => [
        WarningCard(
          message: l10n.chaptersLoadError,
          action: SmallButton(label: l10n.tryAgain, onPressed: onRetry),
        ),
      ],
      _ => [for (var i = 0; i < 4; i++) const _SkeletonRow()],
    };

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _TopBar(view: v, onBack: onBack),
          const SizedBox(height: AppSpace.xl),
          ...children,
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.view, required this.onBack});

  final SourceChaptersView? view;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final s = view?.source;
    return Row(
      children: [
        RoundIconButton.back(context, onBack),
        const SizedBox(width: AppSpace.lg),
        if (s != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    s.type.label(l10n),
                    if (s.totalUnits case final n?) s.unitType.count(l10n, n),
                  ].join(' · ').toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.overline.copyWith(color: c.muted),
                ),
                Semantics(
                  header: true,
                  child: Text(
                    s.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardTitle.copyWith(
                      color: c.ink,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _ReadingCard extends StatelessWidget {
  const _ReadingCard({
    required this.view,
    required this.onRead,
    required this.onFinish,
  });

  final SourceChaptersView view;
  final VoidCallback onRead;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final p = view.progress;
    final unit = view.source.unitType;
    final done = p.exploredUnits;
    final position = p.position;
    final explored = l10n.readingExplored(done, unit.count(l10n, p.totalUnits));
    final left = view.minutesLeft;
    final partly = [
      for (final ch in view.chapters)
        if (ch.partlyRead) ch,
    ].firstOrNull;

    final open = p.open;
    final String line;
    final Widget? button;
    if (open != null) {
      final since = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(open.startedAt),
      );
      line = l10n.readingSince(
        MaterialLocalizations.of(context).formatTimeOfDay(since),
      );
      button = PrimaryButton(label: l10n.readingFinish, onPressed: onFinish);
    } else if (position == null) {
      line = l10n.readingAllRead(formatMinutes(l10n, view.minutesRead));
      button = null;
    } else {
      line = left == null || left == 0
          ? explored
          : '$explored · ${l10n.readingTimeLeft(formatMinutes(l10n, left))}';
      button = PrimaryButton(
        label: position == 1
            ? l10n.readingStart
            : unit == UnitType.minute
            ? l10n.readingWatchFrom(unit.at(l10n, position))
            : l10n.readingFrom(unit.at(l10n, position)),
        onPressed: onRead,
      );
    }

    return _Card(
      children: [
        ProgressBar(
          value: p.totalUnits == 0 ? 0 : done / p.totalUnits,
          semanticLabel: explored,
        ),
        const SizedBox(height: AppSpace.md),
        Text(line, style: AppText.body.copyWith(color: c.ink)),
        if (button != null) ...[const SizedBox(height: AppSpace.lg), button],
        if (partly != null && open == null) ...[
          const SizedBox(height: AppSpace.sm),
          Text(
            l10n.readingPartly(
              partly.chunk.title,
              partly.readUnits,
              partly.sizeUnits,
            ),
            style: AppText.caption.copyWith(color: c.muted),
          ),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.view,
    required this.onSurvey,
    required this.onCreateAll,
  });

  final SourceChaptersView view;
  final VoidCallback onSurvey;
  final VoidCallback onCreateAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final p = view.progress;
    final missing = p.withoutTask;
    final surveyed = p.surveyedCount;
    final allSurveyed = surveyed > 0 && surveyed >= p.chapters.length;
    final primary = !p.readable;

    final survey = SecondaryButton(
      label: allSurveyed ? l10n.chaptersEditSurvey : l10n.sourceSurvey,
      onPressed: p.chapters.isEmpty ? null : onSurvey,
    );
    final create = missing == 0
        ? null
        : primary
        ? PrimaryButton(
            label: l10n.chaptersCreateTasks(missing),
            onPressed: onCreateAll,
          )
        : SecondaryButton(
            label: l10n.chaptersCreateTasks(missing),
            onPressed: onCreateAll,
          );

    return _Card(
      children: [
        Text(
          l10n.chaptersSummary(p.chapters.length, p.taskCount, surveyed),
          style: AppText.body.copyWith(color: c.ink),
        ),
        const SizedBox(height: AppSpace.lg),
        LayoutBuilder(
          builder: (context, _) {
            // Side by side when both fit; stacked at large text sizes.
            final stacked =
                create != null &&
                MediaQuery.textScalerOf(context).scale(1) > 1.15;
            if (create == null) return survey;
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  survey,
                  const SizedBox(height: AppSpace.md),
                  create,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: survey),
                const SizedBox(width: AppSpace.md),
                Expanded(child: create),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpace.md),
        Text(
          missing == 0
              ? l10n.chaptersCaptionAll
              : surveyed > 0
              ? l10n.chaptersCaptionSurvey
              : l10n.chaptersCaptionNoSurvey,
          style: AppText.caption.copyWith(color: c.muted),
        ),
      ],
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({
    required this.number,
    required this.chapter,
    required this.unitType,
    required this.joined,
    required this.onAddTask,
    required this.onOpenTask,
  });

  final int number;
  final ChapterProgress chapter;
  final UnitType unitType;

  /// Not the first chapter of its task: joined to the row above.
  final bool joined;
  final VoidCallback onAddTask;
  final VoidCallback onOpenTask;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final ch = chapter;
    final range = ch.range == null
        ? null
        : unitType.range(l10n, ch.range!.start, ch.range!.end);
    final survey = ch.survey;
    final details = [
      ?range,
      if (ch.importance case final i?) _importance(l10n, i),
      if (survey != null) ...[
        _difficulty(l10n, survey.difficulty),
        _familiarity(l10n, survey.familiarity),
      ],
      if (ch.partlyRead) l10n.chapterReadPart(ch.readUnits, ch.sizeUnits),
    ].join(' · ');

    final Widget trailing;
    if (!ch.hasTask) {
      trailing = SmallButton(label: l10n.chaptersAddTask, onPressed: onAddTask);
    } else if (joined) {
      trailing = const SizedBox(width: 44);
    } else {
      final dim = ch.taskDim;
      trailing = Semantics(
        button: true,
        label: l10n.chapterOpenTask(ch.taskTitle ?? ch.chunk.title),
        child: InkWell(
          onTap: onOpenTask,
          borderRadius: BorderRadius.circular(AppRadii.button),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: kMinTouchTarget,
              minHeight: kMinTouchTarget,
            ),
            child: Center(
              child: context.levels.badge(
                context,
                LevelBadgeData(
                  level: ch.taskLevel,
                  stripes: (2 - dim).clamp(0, 2),
                  fading: dim >= Defaults.maxDimSteps,
                  showCaption: false,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final read = ch.finished;
    return MergeSemantics(
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        decoration: BoxDecoration(
          border: Border(
            top: joined ? BorderSide.none : BorderSide(color: c.line),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Column(
                children: [
                  if (joined) Container(width: 2, height: 8, color: c.accent),
                  Semantics(
                    label: read ? l10n.chapterRead : null,
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: read ? c.accentSoft : null,
                        border: Border.all(
                          color: ch.hasTask ? c.accent : c.line,
                          width: ch.hasTask ? 2 : 1,
                        ),
                      ),
                      child: read
                          ? AppIconView(
                              AppIcon.check,
                              color: c.accentText,
                              size: 16,
                            )
                          : Text(
                              '$number',
                              style: AppText.caption.copyWith(
                                color: c.muted,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ch.chunk.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardTitle.copyWith(
                      color: c.ink,
                      fontSize: 15,
                    ),
                  ),
                  if (details.isNotEmpty) ...[
                    const SizedBox(height: AppSpace.xxs),
                    Text(
                      details,
                      style: AppText.caption.copyWith(color: c.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpace.sm),
            trailing,
          ],
        ),
      ),
    );
  }

  static String _importance(AppLocalizations l10n, Importance i) => switch (i) {
    Importance.high => l10n.importanceHigh,
    Importance.medium => l10n.importanceMedium,
    Importance.low => l10n.importanceLow,
  };

  static String _difficulty(AppLocalizations l10n, int d) => switch (d) {
    1 => l10n.difficultyEasy,
    3 => l10n.difficultyHard,
    _ => l10n.difficultyMedium,
  };

  static String _familiarity(AppLocalizations l10n, int f) => switch (f) {
    1 => l10n.familiaritySeen,
    2 => l10n.familiarityComfortable,
    _ => l10n.familiarityNew,
  };
}

class _Muted extends StatelessWidget {
  const _Muted(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpace.xl),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppText.body.copyWith(color: context.colors.muted),
    ),
  );
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget block(double w, double h, {bool round = false}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: c.line,
        borderRadius: BorderRadius.circular(round ? h : 6),
      ),
    );
    return ExcludeSemantics(
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            block(28, 28, round: true),
            const SizedBox(width: AppSpace.lg),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                block(160, 14),
                const SizedBox(height: AppSpace.sm),
                block(90, 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
