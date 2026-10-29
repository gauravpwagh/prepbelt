import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/palettes/night_to_sun.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../sources/ui/source_labels.dart';
import '../state/exam_view_providers.dart';

/// The Exams tab: the upcoming exam, or a way to add one.
class ExamsTab extends ConsumerWidget {
  const ExamsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: SafeArea(
      child: ExamBody(
        view: ref.watch(examViewProvider(null)),
        onAdd: () => context.push(Routes.newExam),
        onOpenTask: (id) => context.push(Routes.task(id)),
        onRetry: () => ref.invalidate(examViewProvider(null)),
      ),
    ),
  );
}

/// The Exam screen (`/exams/:id`, mockup 4).
class ExamScreen extends ConsumerWidget {
  const ExamScreen({required this.examId, super.key});

  final String examId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: SafeArea(
      child: ExamBody(
        view: ref.watch(examViewProvider(examId)),
        onBack: () => context.pop(),
        onAdd: () => context.push(Routes.newExam),
        onOpenTask: (id) => context.push(Routes.task(id)),
        onRetry: () => ref.invalidate(examViewProvider(examId)),
      ),
    ),
  );
}

/// The exam for one view. Public so goldens can render it.
class ExamBody extends StatelessWidget {
  const ExamBody({
    required this.view,
    required this.onAdd,
    required this.onOpenTask,
    required this.onRetry,
    this.onBack,
    super.key,
  });

  final AsyncValue<ExamView?> view;
  final VoidCallback? onBack;
  final VoidCallback onAdd;
  final ValueChanged<String> onOpenTask;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    return switch (view) {
      AsyncData(value: final ExamView v) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          _Header(view: v, onBack: onBack),
          const SizedBox(height: AppSpace.lg),
          _Hero(view: v),
          if (!v.planFits) ...[
            const SizedBox(height: AppSpace.lg),
            WarningCard(message: l10n.examPlanTight),
          ],
          if (v.weakLinks.isNotEmpty) ...[
            const SizedBox(height: AppSpace.lg),
            _WeakLinks(view: v, onOpenTask: onOpenTask),
          ],
          const SizedBox(height: AppSpace.lg),
          _Activity(view: v),
        ],
      ),
      AsyncData() => _Empty(onAdd: onAdd),
      AsyncError() => Padding(
        padding: const EdgeInsets.all(20),
        child: WarningCard(
          message: l10n.examLoadFailed,
          action: SmallButton(label: l10n.todayRetry, onPressed: onRetry),
        ),
      ),
      _ => Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: c.muted),
        ),
      ),
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.view, required this.onBack});

  final ExamView view;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat(
      'd MMM y',
      locale,
    ).format(DateTime.parse(view.exam.date));
    return Row(
      children: [
        if (onBack != null) ...[
          RoundIconButton.back(context, onBack!),
          const SizedBox(width: AppSpace.lg),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                view.exam.name,
                style: AppText.display.copyWith(color: c.ink, fontSize: 24),
              ),
              Text(
                l10n.examDateLine(date, view.daysLeft.clamp(0, 99999)),
                style: AppText.subtitle.copyWith(
                  color: c.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.view});

  final ExamView view;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final m = view.metrics;
    String name(int level) =>
        level == 0 ? l10n.beltNotStarted : levels.levelName(l10n, level);
    Widget tile(String value, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: c.heroTrack,
          borderRadius: BorderRadius.circular(AppRadii.chip),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                value,
                maxLines: 1,
                style: AppText.section.copyWith(
                  color: c.heroText,
                  fontSize: 18,
                ),
              ),
            ),
            Text(label, style: AppText.caption.copyWith(color: c.heroMuted)),
          ],
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.hero,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: l10n.examBeltSemantics(name(m.tier), name(m.projectedTier)),
            excludeSemantics: true,
            child: Wrap(
              spacing: 16,
              runSpacing: AppSpace.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                levels.badge(
                  context,
                  LevelBadgeData(
                    level: m.tier,
                    stripes: 2,
                    size: BadgeSize.large,
                    showCaption: false,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.examBeltToday,
                      style: AppText.caption.copyWith(
                        color: c.heroSubtle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      name(m.tier),
                      style: AppText.heroTitle.copyWith(
                        color: c.heroText,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      l10n.examProjected(name(m.projectedTier)),
                      style: AppText.subtitle.copyWith(
                        color: c.heroMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              tile('${(m.readiness * 100).round()}%', l10n.examReady),
              const SizedBox(width: 8),
              tile('${m.atTarget} / ${m.total}', l10n.examAtTarget),
              const SizedBox(width: 8),
              tile(formatMinutes(l10n, view.todayMinutes), l10n.examToday),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeakLinks extends StatelessWidget {
  const _WeakLinks({required this.view, required this.onOpenTask});

  final ExamView view;
  final ValueChanged<String> onOpenTask;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final locale = Localizations.localeOf(context).toLanguageTag();
    String when(String date) {
      final d = DateTime.parse(date);
      final days = DateTime(d.year, d.month, d.day)
          .difference(
            DateTime(view.today.year, view.today.month, view.today.day),
          )
          .inDays;
      if (days <= 0) return l10n.examWhenToday;
      if (days == 1) return l10n.examWhenTomorrow;
      return DateFormat('EEE', locale).format(d);
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      decoration: BoxDecoration(
        color: c.warningBg,
        border: Border.all(color: c.warningBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.examWeakLinks(view.weakLinks.length),
                style: AppText.body.copyWith(
                  color: c.warningText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                l10n.examWeakHint,
                style: AppText.caption.copyWith(color: c.warningText),
              ),
            ],
          ),
          for (final w in view.weakLinks)
            InkWell(
              onTap: () => onOpenTask(w.taskId),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: kMinTouchTarget),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        w.title,
                        style: AppText.body.copyWith(
                          color: c.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Flexible(
                      child: Text(
                        w.level == 0
                            ? w.next == null
                                  ? l10n.examWeakNotPlanned
                                  : l10n.examWeakNotStarted(when(w.next!.date))
                            : l10n.examWeakNext(
                                l10n.beltName(levels.levelName(l10n, w.level)),
                                w.next == null ? '—' : when(w.next!.date),
                              ),
                        textAlign: TextAlign.end,
                        style: AppText.caption.copyWith(color: c.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The activity grid (1.0's stand-in for the mastery timeline): one cell
/// per day, weeks as columns, brighter for more study.
class _Activity extends StatelessWidget {
  const _Activity({required this.view});

  final ExamView view;

  static const _shades = [0, 2, 3, 5, 6];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final days = view.activity;
    final weeks = (days.length / 7).ceil();
    Color colorOf(int bucket) =>
        bucket == 0 ? c.gridEmpty : NightToSun.levels[_shades[bucket - 1]];
    Widget cell(Color color) => Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
    final studied = days.where((d) => d.minutes > 0).length;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(
                l10n.examActivity,
                style: AppText.cardTitle.copyWith(color: c.ink),
              ),
              Text(
                l10n.examActivityHint,
                style: AppText.caption.copyWith(color: c.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          Semantics(
            label: l10n.examActivitySemantics(studied, weeks),
            excludeSemantics: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var w = 0; w < weeks; w++) ...[
                    if (w > 0) const SizedBox(width: 3),
                    Column(
                      children: [
                        for (var d = 0; d < 7; d++) ...[
                          if (d > 0) const SizedBox(height: 3),
                          if (w * 7 + d < days.length)
                            cell(colorOf(days[w * 7 + d].bucket))
                          else
                            const SizedBox(width: 14, height: 14),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          ExcludeSemantics(
            child: Row(
              children: [
                Text(
                  l10n.examActivityLess,
                  style: AppText.caption.copyWith(color: c.muted),
                ),
                const SizedBox(width: AppSpace.xs),
                for (var b = 0; b <= 5; b++) ...[
                  cell(colorOf(b)),
                  const SizedBox(width: 3),
                ],
                const SizedBox(width: AppSpace.xxs),
                Text(
                  l10n.examActivityMore,
                  style: AppText.caption.copyWith(color: c.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: context.levels.badge(
                context,
                const LevelBadgeData(
                  level: 0,
                  size: BadgeSize.large,
                  showCaption: false,
                ),
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            Text(
              l10n.examsEmptyTitle,
              style: AppText.section.copyWith(color: c.ink),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              l10n.examsEmptyBody,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: c.muted),
            ),
            const SizedBox(height: AppSpace.xl),
            PrimaryButton(label: l10n.examsAdd, onPressed: onAdd),
          ],
        ),
      ),
    );
  }
}
