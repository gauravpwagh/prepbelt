import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/config/defaults.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../core/ui/motion.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../sources/ui/source_labels.dart';
import '../../today/state/reminder_providers.dart';
import '../../today/ui/reminder_text.dart';
import '../state/session_providers.dart';

/// Back from source (docs/06-screens.md §2): where the student stopped,
/// how well they recalled it, and the result. Done records the review.
class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({required this.taskId, super.key});

  final String taskId;

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  Rating? _rating;
  int? _stop;
  bool _saving = false;
  bool _failed = false;
  Timer? _tick;

  /// The view while saving, so the screen does not flash "closed" when the
  /// session row goes away.
  SessionView? _held;

  @override
  void initState() {
    super.initState();
    // Keep "22 min" current while the screen is open.
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  int _nowMs() => ref.read(clockProvider).nowMs();

  Future<void> _done(SessionView view) async {
    final rating = _rating;
    if (rating == null) return;
    setState(() {
      _saving = true;
      _failed = false;
      _held = view;
    });
    try {
      await ref
          .read(sessionActionsProvider.notifier)
          .finish(
            rating: rating,
            minutes: view.minutesAt(_nowMs()),
            stopUnit: view.info.range == null
                ? null
                : _stop ?? view.info.range!.end,
          );
      if (!mounted) return;
      unawaited(
        ref
            .read(remindersProvider.notifier)
            .afterSession(reminderText(AppLocalizations.of(context))),
      );
      context.go(Routes.today);
    } on Object {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _failed = true;
        _held = null;
      });
    }
  }

  Future<void> _leave() async {
    await ref.read(sessionActionsProvider.notifier).discard();
    if (mounted) context.go(Routes.today);
  }

  void _rate(SessionView view, Rating r) {
    if (view.promotes(r) || view.info.firstRead) {
      unawaited(HapticFeedback.mediumImpact());
    } else {
      unawaited(HapticFeedback.selectionClick());
    }
    setState(() => _rating = r);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(sessionViewProvider(widget.taskId));
    final view = _held ?? async.value;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: switch ((view, async)) {
          (final SessionView v, _) => SessionBody(
            view: v,
            minutes: v.minutesAt(_nowMs()),
            nowMs: _nowMs(),
            rating: _rating,
            stop: _stop,
            saving: _saving,
            failed: _failed,
            onRate: (r) => _rate(v, r),
            onStop: (u) => setState(() => _stop = u),
            onDone: () => _done(v),
            onClose: _leave,
            onOpenAgain: () => ref
                .read(sessionActionsProvider.notifier)
                .openAgain(widget.taskId),
            onBackToToday: () => context.go(Routes.today),
          ),
          (_, AsyncError()) => Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: WarningCard(
                message: l10n.sessionLoadFailed,
                action: SmallButton(
                  label: l10n.sessionBackToToday,
                  onPressed: () => context.go(Routes.today),
                ),
              ),
            ),
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

/// The screen for one [SessionView]. Public so goldens can render it.
class SessionBody extends StatelessWidget {
  const SessionBody({
    required this.view,
    required this.minutes,
    required this.nowMs,
    required this.onRate,
    required this.onStop,
    required this.onDone,
    required this.onClose,
    required this.onOpenAgain,
    required this.onBackToToday,
    this.rating,
    this.stop,
    this.saving = false,
    this.failed = false,
    super.key,
  });

  final SessionView view;
  final int minutes;
  final int nowMs;
  final Rating? rating;

  /// The unit the student stopped at; null means the range end.
  final int? stop;
  final bool saving;
  final bool failed;
  final ValueChanged<Rating> onRate;
  final ValueChanged<int> onStop;
  final VoidCallback onDone;
  final VoidCallback onClose;
  final VoidCallback onOpenAgain;
  final VoidCallback onBackToToday;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final info = view.info;
    if (view.session == null && !saving) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.sessionClosed,
                textAlign: TextAlign.center,
                style: AppText.section.copyWith(color: c.ink),
              ),
              const SizedBox(height: AppSpace.lg),
              SecondaryButton(
                label: l10n.sessionBackToToday,
                onPressed: onBackToToday,
              ),
            ],
          ),
        ),
      );
    }
    final chosen = rating;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              RoundIconButton(
                icon: AppIcon.close,
                semanticLabel: l10n.sessionLeave,
                onPressed: saving ? null : onClose,
              ),
              Expanded(
                child: Text(
                  info.firstRead
                      ? l10n.sessionFirstReadTitle
                      : l10n.sessionReviewTitle,
                  textAlign: TextAlign.center,
                  style: AppText.subtitle.copyWith(color: c.muted),
                ),
              ),
              const SizedBox(width: kMinTouchTarget),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            children: [
              Text(
                l10n.sessionWelcomeBack,
                style: AppText.display.copyWith(color: c.ink, fontSize: 28),
              ),
              const SizedBox(height: AppSpace.sm),
              Row(
                children: [
                  context.levels.badge(
                    context,
                    LevelBadgeData(
                      level: view.display.level,
                      stripes: view.display.stripes,
                      fading: view.display.fading,
                      showCaption: false,
                    ),
                  ),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: Text(
                      info.task.title,
                      style: AppText.cardTitle.copyWith(
                        color: c.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _WhereCard(
                view: view,
                minutes: minutes,
                stop: stop,
                onStop: saving ? null : onStop,
                onOpenAgain: onOpenAgain,
              ),
              const SizedBox(height: 18),
              Text(
                info.firstRead ? l10n.sessionHowFirstRead : l10n.sessionHowWell,
                style: AppText.section.copyWith(color: c.ink, fontSize: 16),
              ),
              if (info.firstRead) ...[
                const SizedBox(height: AppSpace.xs),
                Text(
                  l10n.sessionFirstReadHint,
                  style: AppText.caption.copyWith(color: c.muted),
                ),
              ],
              const SizedBox(height: AppSpace.md),
              _RatingGrid(
                view: view,
                nowMs: nowMs,
                selected: chosen,
                onRate: saving ? null : onRate,
              ),
              if (chosen != null) ...[
                const SizedBox(height: 18),
                _ResultCard(
                  key: ValueKey(chosen),
                  view: view,
                  rating: chosen,
                  nowMs: nowMs,
                ),
              ],
            ],
          ),
        ),
        if (failed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              l10n.sessionSaveFailed,
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: c.warningText),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, AppSpace.md, 20, 24),
          child: PrimaryButton(
            label: chosen == null ? l10n.sessionPickRating : l10n.sessionDone,
            onPressed: chosen == null || saving ? null : onDone,
          ),
        ),
      ],
    );
  }
}

class _WhereCard extends StatelessWidget {
  const _WhereCard({
    required this.view,
    required this.minutes,
    required this.stop,
    required this.onStop,
    required this.onOpenAgain,
  });

  final SessionView view;
  final int minutes;
  final int? stop;
  final ValueChanged<int>? onStop;
  final VoidCallback onOpenAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final info = view.info;
    final source = info.source;
    final range = info.range;
    final unit = source?.unitType;
    final time = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconView(AppIcon.clock, color: c.muted, size: 15),
        const SizedBox(width: AppSpace.sm),
        Text(
          formatMinutes(l10n, minutes),
          style: AppText.subtitle.copyWith(color: c.ink),
        ),
      ],
    );
    final children = <Widget>[];
    if (range != null && unit != null) {
      final from = info.startUnit ?? range.start;
      final at = (stop ?? range.end).clamp(from, range.end);
      final span = range.end - from;
      final left = range.end - at;
      children.addAll([
        Text(
          l10n.sessionWhereStop,
          style: AppText.subtitle.copyWith(color: c.ink),
        ),
        Text(
          '${source!.title} · ${unit.range(l10n, range.start, range.end)}',
          style: AppText.caption.copyWith(color: c.muted),
        ),
        const SizedBox(height: AppSpace.md),
        ValueStepper(
          value: unit.at(l10n, at),
          lessLabel: l10n.readingLess,
          moreLabel: l10n.readingMore,
          onLess: onStop == null || at <= from ? null : () => onStop!(at - 1),
          onMore: onStop == null || at >= range.end
              ? null
              : () => onStop!(at + 1),
        ),
        const SizedBox(height: AppSpace.lg),
        ProgressBar(
          value: span == 0 ? 1 : (at - from) / span,
          semanticLabel: left == 0
              ? l10n.sessionFinishedRange
              : l10n.sessionLeftForNext(unit.count(l10n, left)),
        ),
        const SizedBox(height: AppSpace.md),
        Row(
          children: [
            Expanded(
              child: Text(
                left == 0
                    ? l10n.sessionFinishedRange
                    : l10n.sessionLeftForNext(unit.count(l10n, left)),
                style: AppText.caption.copyWith(color: c.muted),
              ),
            ),
            time,
          ],
        ),
      ]);
    } else {
      children.add(
        Row(
          children: [
            Expanded(
              child: Text(
                source?.title ?? info.task.title,
                style: AppText.subtitle.copyWith(color: c.ink),
              ),
            ),
            time,
          ],
        ),
      );
    }
    if (source != null) {
      children.add(
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextLinkButton(
            label: l10n.sessionOpenAgain,
            onPressed: onOpenAgain,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Days from [nowMs] to [due] in local calendar days.
int _daysUntil(int nowMs, DateTime due) {
  DateTime day(DateTime t) => DateTime(t.year, t.month, t.day);
  final now = DateTime.fromMillisecondsSinceEpoch(nowMs, isUtc: true);
  return day(due.toLocal()).difference(day(now.toLocal())).inDays;
}

String _nextText(AppLocalizations l10n, ReviewOutcome o, int nowMs) {
  final due = o.dueAfter;
  if (due == null) return l10n.sessionNoMoreReviews;
  final days = _daysUntil(nowMs, due);
  return days <= 1 ? l10n.sessionBackTomorrow : l10n.sessionNextInDays(days);
}

String _ratingLabel(AppLocalizations l10n, Rating r) => switch (r) {
  Rating.forgot => l10n.rateForgot,
  Rating.hard => l10n.rateHard,
  Rating.good => l10n.rateGood,
  Rating.easy => l10n.rateEasy,
};

class _RatingGrid extends StatelessWidget {
  const _RatingGrid({
    required this.view,
    required this.nowMs,
    required this.selected,
    required this.onRate,
  });

  final SessionView view;
  final int nowMs;
  final Rating? selected;
  final ValueChanged<Rating>? onRate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    Widget button(Rating r) {
      final on = r == selected;
      final label = _ratingLabel(l10n, r);
      final next = _nextText(l10n, view.outcomes[r]!, nowMs);
      return Semantics(
        button: true,
        selected: on,
        label: l10n.sessionRatingSemantics(label, next),
        excludeSemantics: true,
        child: Material(
          color: on ? c.accent : c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.card),
            side: BorderSide(color: on ? c.accent : c.line, width: on ? 2 : 1),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadii.card),
            onTap: onRate == null ? null : () => onRate!(r),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 72),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: AppText.section.copyWith(
                        color: on ? c.onAccent : c.ink,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: AppSpace.xxs),
                    Text(
                      next,
                      style: AppText.caption.copyWith(
                        color: on ? c.onAccent : c.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget row(Rating a, Rating b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: button(a)),
          const SizedBox(width: AppSpace.md),
          Expanded(child: button(b)),
        ],
      ),
    );
    return Column(
      children: [
        row(Rating.forgot, Rating.hard),
        const SizedBox(height: AppSpace.md),
        row(Rating.good, Rating.easy),
      ],
    );
  }
}

/// The dark card that shows what the chosen rating does: a promotion
/// grows the new belt with a shine; a lost stripe gives the belt a small
/// shake (CLAUDE.md, "Reward moments"; timings in [RewardMotion]).
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.view,
    required this.rating,
    required this.nowMs,
    super.key,
  });

  final SessionView view;
  final Rating rating;
  final int nowMs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final o = view.outcomes[rating]!;
    final level = o.levelAfter;
    final belt = l10n.beltName(levels.levelName(l10n, level));
    final dim = o.state.dim;
    final promoted = view.promotes(rating);
    final xp = view.xpFor(rating);
    final due = o.dueAfter;

    final String title;
    final String sub;
    if (view.info.firstRead) {
      title = l10n.sessionEarned(belt);
    } else if (promoted) {
      title = l10n.sessionPromoted(belt);
    } else if (dim >= Defaults.maxDimSteps) {
      title = l10n.sessionFading(belt);
    } else {
      title = l10n.sessionStripeLost(belt);
    }
    if (due == null) {
      sub = l10n.sessionXpDone(xp);
    } else if (!rating.passed && !view.info.firstRead) {
      sub = l10n.sessionXpAgainTomorrow(xp);
    } else {
      sub = l10n.sessionXpNext(xp, _daysUntil(nowMs, due).clamp(1, 9999));
    }

    Widget badge = levels.badge(
      context,
      LevelBadgeData(
        level: level,
        stripes: (2 - dim).clamp(0, 2),
        fading: dim >= Defaults.maxDimSteps,
        size: BadgeSize.large,
        showCaption: false,
      ),
    );
    badge = promoted || view.info.firstRead
        ? badge
              .animate()
              .scale(
                begin: const Offset(0.6, 0.6),
                duration: RewardMotion.promote,
                curve: RewardMotion.promoteCurve,
              )
              .shimmer(
                delay: RewardMotion.shineDelay,
                duration: RewardMotion.shine,
                color: c.heroText.withValues(alpha: 0.6),
              )
        : badge.animate().shakeX(
            duration: RewardMotion.stripeLost,
            hz: 5,
            amount: 3,
          );

    return Semantics(
          liveRegion: true,
          label: '$title. $sub',
          excludeSemantics: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: c.hero,
              borderRadius: BorderRadius.circular(AppRadii.hero),
            ),
            child: Row(
              children: [
                badge,
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.heroTitle.copyWith(
                          color: c.heroText,
                          fontSize: 19,
                        ),
                      ),
                      const SizedBox(height: AppSpace.xxs),
                      Text(
                        sub,
                        style: AppText.subtitle.copyWith(
                          color: c.heroMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: RewardMotion.cardIn)
        .slideY(
          begin: 0.15,
          duration: RewardMotion.cardIn,
          curve: Curves.easeOutCubic,
        );
  }
}
