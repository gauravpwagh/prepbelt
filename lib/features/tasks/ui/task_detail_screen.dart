import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/db/enums.dart';
import '../../../core/result/result.dart';
import '../../../core/time/clock.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../redefine/state/redefine_providers.dart';
import '../../session/state/session_providers.dart';
import '../../sources/state/reading_providers.dart';
import '../../sources/ui/source_labels.dart';
import '../state/task_detail_providers.dart';

/// Task detail (design/notes/task-detail.md): belt, next review, what it
/// covers and its history, with Start or Review early.
class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({required this.taskId, super.key});

  final String taskId;

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      final result = await ref
          .read(sessionActionsProvider.notifier)
          .start(taskId);
      if (result == StartResult.notOpened) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.sessionNotOpened)));
      }
      await router.push(Routes.session(taskId));
    } on InvalidOperationError {
      messenger.showSnackBar(SnackBar(content: Text(l10n.sessionOpenFirst)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: SafeArea(
      child: TaskDetailBody(
        view: ref.watch(taskDetailViewProvider(taskId)),
        onBack: () => context.pop(),
        onStart: () => _start(context, ref),
        onOpenSource: (id) => context.push(Routes.sourceChapters(id)),
        onRetry: () => ref.invalidate(taskDetailViewProvider(taskId)),
        onRedefine: () => context.push(Routes.redefine(taskId)),
        canUndo: ref.watch(taskUndoableProvider(taskId)).value != null,
        onUndo: () async {
          final messenger = ScaffoldMessenger.of(context);
          final l10n = AppLocalizations.of(context);
          await ref.read(redefineActionsProvider.notifier).undo(taskId);
          messenger.showSnackBar(SnackBar(content: Text(l10n.taskUndone)));
        },
      ),
    ),
  );
}

/// Task detail for one view. Public so goldens can render it.
class TaskDetailBody extends StatefulWidget {
  const TaskDetailBody({
    required this.view,
    required this.onBack,
    required this.onStart,
    required this.onOpenSource,
    required this.onRetry,
    this.onRedefine,
    this.onUndo,
    this.canUndo = false,
    super.key,
  });

  final AsyncValue<TaskDetailView?> view;

  /// Opens the Redefine sheet; null hides the button.
  final VoidCallback? onRedefine;
  final VoidCallback? onUndo;
  final bool canUndo;
  final VoidCallback onBack;
  final VoidCallback onStart;
  final ValueChanged<String> onOpenSource;
  final VoidCallback onRetry;

  @override
  State<TaskDetailBody> createState() => _TaskDetailBodyState();
}

class _TaskDetailBodyState extends State<TaskDetailBody> {
  bool _allHistory = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final top = Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          RoundIconButton.back(context, widget.onBack),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Text(
              l10n.taskOverline,
              style: AppText.subtitle.copyWith(color: c.muted),
            ),
          ),
          if (widget.onRedefine != null && widget.view.value != null)
            RoundIconButton(
              icon: AppIcon.more,
              semanticLabel: l10n.taskMore,
              onPressed: widget.onRedefine,
            ),
        ],
      ),
    );
    final Widget body = switch (widget.view) {
      AsyncData(value: final TaskDetailView v) => _Filled(
        view: v,
        allHistory: _allHistory,
        onShowAll: () => setState(() => _allHistory = true),
        onStart: widget.onStart,
        onOpenSource: widget.onOpenSource,
        onUndo: widget.canUndo ? widget.onUndo : null,
      ),
      AsyncData() => _Centered(
        message: l10n.taskRemoved,
        action: SecondaryButton(label: l10n.taskBack, onPressed: widget.onBack),
      ),
      AsyncError() => Padding(
        padding: const EdgeInsets.all(20),
        child: WarningCard(
          message: l10n.taskLoadFailed,
          action: SmallButton(
            label: l10n.todayRetry,
            onPressed: widget.onRetry,
          ),
        ),
      ),
      _ => const _Skeleton(),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        top,
        Expanded(child: body),
      ],
    );
  }
}

class _Filled extends StatelessWidget {
  const _Filled({
    required this.view,
    required this.allHistory,
    required this.onShowAll,
    required this.onStart,
    required this.onOpenSource,
    this.onUndo,
  });

  final TaskDetailView view;
  final bool allHistory;
  final VoidCallback onShowAll;
  final VoidCallback onStart;
  final ValueChanged<String> onOpenSource;

  /// "Undo last change", when the latest change can be undone.
  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final d = view.detail;
    final importance = d.examLink?.importance;
    final exam = d.exam;
    final reviews = d.reviews;
    final shown = allHistory ? reviews : reviews.take(10).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text(
          view.info.task.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: AppText.display.copyWith(color: c.ink, fontSize: 28),
        ),
        if (importance != null && exam != null) ...[
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: switch (importance) {
                    Importance.high => c.importanceHigh,
                    Importance.medium => c.importanceMedium,
                    Importance.low => c.importanceLow,
                  },
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: Text(
                  l10n.taskImportanceLine(switch (importance) {
                    Importance.high => l10n.importanceHigh,
                    Importance.medium => l10n.importanceMedium,
                    Importance.low => l10n.importanceLow,
                  }, exam.name),
                  style: AppText.subtitle.copyWith(color: c.muted),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpace.xl),
        _BeltCard(view: view),
        const SizedBox(height: AppSpace.lg),
        _NextCard(view: view, onStart: onStart),
        if (onUndo != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextLinkButton(label: l10n.taskUndoLast, onPressed: onUndo),
          ),
        if (view.info.parts.isNotEmpty) ...[
          const SizedBox(height: AppSpace.xxl),
          Text(l10n.taskCovers, style: AppText.section.copyWith(color: c.ink)),
          const SizedBox(height: AppSpace.md),
          _Panel(
            children: [
              for (final p in view.info.parts)
                _CoverRow(part: p, onTap: () => onOpenSource(p.source.id)),
            ],
          ),
        ],
        const SizedBox(height: AppSpace.xxl),
        Text(l10n.taskHistory, style: AppText.section.copyWith(color: c.ink)),
        const SizedBox(height: AppSpace.md),
        if (reviews.isEmpty)
          Text(l10n.taskNoReviews, style: AppText.body.copyWith(color: c.muted))
        else
          _Panel(
            children: [
              for (final r in shown)
                _HistoryRow(review: r, kind: _kindOf(l10n, reviews, r)),
              if (shown.length < reviews.length)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextLinkButton(
                    label: l10n.taskShowAll(reviews.length),
                    onPressed: onShowAll,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  /// "First read", "Review 3" or "Retry" (a review right after one that
  /// was not Good). [log] is newest first.
  static String _kindOf(AppLocalizations l10n, List<Review> log, Review r) {
    if (r.kind == ReviewKind.firstRead) return l10n.taskKindFirstRead;
    final i = log.indexOf(r);
    final before = i + 1 < log.length ? log[i + 1] : null;
    if (before != null &&
        before.kind != ReviewKind.firstRead &&
        !Rating.fromValue(before.rating).passed) {
      return l10n.taskKindRetry;
    }
    final passed = Rating.fromValue(r.rating).passed;
    return l10n.taskKindReview(passed ? r.stepAfter : r.stepAfter + 1);
  }
}

class _BeltCard extends StatelessWidget {
  const _BeltCard({required this.view});

  final TaskDetailView view;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final d = view.display;
    final paused = view.info.paused;
    final started = d.level > 0;
    final name = started
        ? l10n.beltName(levels.levelName(l10n, d.level))
        : l10n.beltNotStarted;
    final target = view.target;
    final levelLine = !started
        ? null
        : target == null
        ? l10n.taskLevelLine(d.level)
        : l10n.taskLevelTargetLine(d.level, levels.levelName(l10n, target));
    final planned = view.detail.planned;
    final done = view.stepsDone;
    final steps = l10n.taskSteps(done, planned);
    final semantics = [
      if (started)
        d.fading
            ? l10n.beltSemanticsFading(name, d.level)
            : l10n.beltSemantics(name, d.level, d.stripes)
      else
        name,
      steps,
      ?levelLine,
    ].join(', ');

    return Semantics(
      label: semantics,
      excludeSemantics: true,
      child: Opacity(
        opacity: paused ? 0.6 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: c.hero,
            borderRadius: BorderRadius.circular(AppRadii.hero),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 14,
                runSpacing: AppSpace.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  levels.badge(
                    context,
                    LevelBadgeData(
                      level: d.level,
                      stripes: d.stripes,
                      fading: d.fading,
                      size: BadgeSize.large,
                      showCaption: false,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppText.heroTitle.copyWith(color: c.heroText),
                      ),
                      if (levelLine != null)
                        Text(
                          levelLine,
                          style: AppText.caption.copyWith(color: c.heroMuted),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.lg),
              Row(
                children: [
                  for (var i = 0; i < planned; i++) ...[
                    if (i > 0) const SizedBox(width: AppSpace.sm),
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: i < done ? c.readiness : null,
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          border: Border.all(
                            color: i < done ? c.readiness : c.heroSubtle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpace.sm),
              Text(steps, style: AppText.caption.copyWith(color: c.heroMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextCard extends StatelessWidget {
  const _NextCard({required this.view, required this.onStart});

  final TaskDetailView view;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final info = view.info;
    final state = info.state;
    final now = view.now.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    int daysTo(DateTime t) =>
        DateTime(t.year, t.month, t.day).difference(today).inDays;

    String line;
    var warn = false;
    String? button;
    String? hint;
    if (info.paused) {
      final at = state.pausedAt ?? info.task.updatedAt;
      line = l10n.taskPausedSince(
        DateFormat('d MMM', locale).format(fromUtcMs(at).toLocal()),
      );
    } else if (info.firstRead) {
      line = l10n.taskNotStartedLine(
        formatMinutes(l10n, view.firstReadMinutes.clamp(5, 9999)),
      );
      button = l10n.taskStartFirstRead;
    } else if (state.dueAt == null) {
      line = l10n.taskAllDone;
      button = l10n.taskReviewEarly;
    } else {
      final due = fromUtcMs(state.dueAt!).toLocal();
      final days = daysTo(due);
      if (days < 0) {
        line = l10n.taskOverdue(-days);
        warn = true;
        button = l10n.taskStartReview;
      } else if (days == 0) {
        line = l10n.taskDueToday;
        button = l10n.taskStartReview;
      } else {
        line = l10n.taskNextOn(
          DateFormat('EEE d MMM', locale).format(due),
          days,
        );
        button = l10n.taskReviewEarly;
        hint = l10n.taskReviewEarlyHint;
      }
    }
    return _Panel(
      children: [
        Text(
          line,
          style: AppText.body.copyWith(
            color: warn ? c.warningText : c.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (button != null) ...[
          const SizedBox(height: AppSpace.lg),
          PrimaryButton(label: button, onPressed: onStart),
        ],
        if (hint != null) ...[
          const SizedBox(height: AppSpace.sm),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: c.muted),
          ),
        ],
      ],
    );
  }
}

class _CoverRow extends StatelessWidget {
  const _CoverRow({required this.part, required this.onTap});

  final TaskPart part;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final start = part.link.startUnit ?? part.chunk.startUnit;
    final end = part.link.endUnit ?? part.chunk.endUnit;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kMinTouchTarget),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${part.source.title} · ${part.chunk.title}',
                style: AppText.cardTitle.copyWith(
                  color: c.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (start != null && end != null)
                Text(
                  part.source.unitType.range(l10n, start, end),
                  style: AppText.caption.copyWith(color: c.muted),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.review, required this.kind});

  final Review review;
  final String kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final at = fromUtcMs(review.at).toLocal();
    final rating = Rating.fromValue(review.rating);
    final ratingLabel = switch (rating) {
      Rating.forgot => l10n.rateForgot,
      Rating.hard => l10n.rateHard,
      Rating.good => l10n.rateGood,
      Rating.easy => l10n.rateEasy,
    };
    final time = formatMinutes(l10n, (review.durationSec / 60).round());
    final promoted = review.levelAfter > review.levelBefore;
    final belt = review.levelAfter == 0
        ? null
        : l10n.beltName(levels.levelName(l10n, review.levelAfter));
    final semantics = [
      l10n.taskHistorySemantics(
        DateFormat('d MMMM', locale).format(at),
        kind,
        ratingLabel,
        time,
      ),
      if (promoted && belt != null) l10n.taskPromotedSemantics(belt),
    ].join(', ');
    return Semantics(
      label: semantics,
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpace.md),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Center(
                child: levels.badge(
                  context,
                  LevelBadgeData(
                    level: review.levelAfter,
                    stripes: 2,
                    showCaption: false,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpace.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat('EEE d MMM', locale).format(at)} · $kind',
                    style: AppText.subtitle.copyWith(color: c.ink),
                  ),
                  Text(
                    [
                      time,
                      if (promoted && belt != null) l10n.taskPromotedTo(belt),
                    ].join('  '),
                    style: AppText.caption.copyWith(
                      color: promoted ? c.accentText : c.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: rating.passed ? c.accentSoft : c.warningBg,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Text(
                ratingLabel,
                style: AppText.chip.copyWith(
                  color: rating.passed ? c.accentText : c.warningText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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

class _Centered extends StatelessWidget {
  const _Centered({required this.message, required this.action});

  final String message;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.section.copyWith(color: c.ink),
            ),
            const SizedBox(height: AppSpace.lg),
            action,
          ],
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget block(double h, {double? w}) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: c.line,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
    );
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            block(28, w: 220),
            const SizedBox(height: AppSpace.xl),
            block(130),
            const SizedBox(height: AppSpace.lg),
            block(96),
            const SizedBox(height: AppSpace.lg),
            block(120),
          ],
        ),
      ),
    );
  }
}
