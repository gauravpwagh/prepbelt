import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/config/defaults.dart';
import '../../../core/result/result.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../core/ui/session_card.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../session/state/session_providers.dart';
import '../../sources/state/reading_providers.dart';
import '../../sources/state/study_files.dart';
import '../../sources/ui/source_labels.dart';
import '../../sources/ui/study_folder_dialogs.dart';
import '../state/today_providers.dart';

/// Today (docs/06-screens.md §1): the streak, the exam, and the sessions
/// to do, overdue first. Start opens the source and the session.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  Future<void> _start(
    BuildContext context,
    WidgetRef ref,
    String taskId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      final actions = ref.read(sessionActionsProvider.notifier);
      final result = await actions.start(taskId);
      final sourceId = await actions.sourceOf(taskId);
      if (sourceId == null) {
        if (result != StartResult.opened) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.sessionNotOpened)),
          );
        }
      } else if (context.mounted) {
        await afterStart(
          context,
          ref,
          result,
          sourceId: sourceId,
          notOpened: l10n.sessionNotOpened,
        );
      }
      await router.push(Routes.session(taskId));
    } on InvalidOperationError {
      messenger.showSnackBar(SnackBar(content: Text(l10n.sessionOpenFirst)));
    }
  }

  Future<void> _read(
    BuildContext context,
    WidgetRef ref,
    String sourceId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      final result = await ref
          .read(readingActionsProvider.notifier)
          .start(sourceId);
      if (result != StartResult.opened && context.mounted) {
        await afterStart(
          context,
          ref,
          result,
          sourceId: sourceId,
          notOpened: l10n.readingNotOpened,
        );
        await router.push(Routes.sourceChapters(sourceId));
      }
    } on InvalidOperationError {
      messenger.showSnackBar(SnackBar(content: Text(l10n.sessionOpenFirst)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: SafeArea(
      child: TodayBody(
        view: ref.watch(todayViewProvider),
        onStart: (id) => _start(context, ref, id),
        onStartReading: (id) => _read(context, ref, id),
        onOpenTask: (id) => context.push(Routes.task(id)),
        onChooseFolder: ref.watch(needsFolderProvider).value ?? false
            ? () => ensureStudyFolder(context, ref)
            : null,
        onOpenSource: (id) => context.push(Routes.sourceChapters(id)),
        onOpenExam: (id) => context.push(Routes.exam(id)),
        onAddSource: () => context.push(Routes.newSource),
        onRetry: () => ref.invalidate(todayViewProvider),
      ),
    ),
  );
}

/// Today for one [TodayView]. Public so goldens can render it.
class TodayBody extends StatelessWidget {
  const TodayBody({
    required this.view,
    required this.onStart,
    required this.onStartReading,
    required this.onOpenTask,
    required this.onOpenSource,
    required this.onOpenExam,
    required this.onAddSource,
    required this.onRetry,
    this.onChooseFolder,
    super.key,
  });

  /// Shows "Choose a folder for your PDFs and backups" (D51) when set.
  final VoidCallback? onChooseFolder;

  final AsyncValue<TodayView> view;
  final ValueChanged<String> onStart;

  /// Starts a reading sitting on a source (a "continue reading" item).
  final ValueChanged<String> onStartReading;
  final ValueChanged<String> onOpenTask;
  final ValueChanged<String> onOpenSource;
  final ValueChanged<String> onOpenExam;
  final VoidCallback onAddSource;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final v = view.value;
    final children = <Widget>[
      _Header(view: v),
      const SizedBox(height: AppSpace.xl),
      if (onChooseFolder case final choose?) ...[
        WarningCard(
          message: l10n.todayFolderCard,
          action: SmallButton(label: l10n.todayFolderChoose, onPressed: choose),
        ),
        const SizedBox(height: AppSpace.xl),
      ],
    ];
    switch (view) {
      case AsyncData(value: final v):
        if (v.exam != null) {
          children
            ..add(_ExamCard(view: v, onTap: () => onOpenExam(v.exam!.id)))
            ..add(const SizedBox(height: AppSpace.xl));
        }
        if (!v.hasTasks) {
          children.add(
            _Message(
              title: l10n.todayEmptyTitle,
              body: l10n.todayEmptyBody,
              action: PrimaryButton(
                label: l10n.todayAddSource,
                onPressed: onAddSource,
              ),
            ),
          );
        } else {
          Widget row(TodayCard card) => _Card(
            card: card,
            today: v.today,
            onStart: switch (card.item.kind) {
              TodayKind.ahead || TodayKind.untasked => null,
              TodayKind.explore => () => onStartReading(card.item.id),
              _ => () => onStart(card.item.id),
            },
            onTap: card.item.info == null
                ? () => onOpenSource(card.item.id)
                : () => onOpenTask(card.item.id),
          );
          children
            ..add(
              Text(
                [
                  l10n.todayDueCount(v.due.length),
                  if (!v.hasPlan) l10n.todayFreshCount(v.fresh.length),
                  if (v.plannedFirstReads > 0)
                    l10n.todayPlannedReads(v.plannedFirstReads),
                  if (v.plannedMinutes > 0)
                    l10n.todayAbout(formatMinutes(l10n, v.plannedMinutes)),
                ].join(' · '),
                style: AppText.subtitle.copyWith(color: c.ink),
              ),
            )
            ..add(const SizedBox(height: AppSpace.lg))
            ..add(
              _Box(
                title: l10n.todayBoxDue,
                empty: l10n.todayBoxDueEmpty,
                tone: _BoxTone.due,
                // Every review due shows: they are today's work (D53).
                collapsed: false,
                rows: [for (final card in v.due) row(card)],
              ),
            )
            ..add(const SizedBox(height: AppSpace.md))
            ..add(
              _Box(
                title: l10n.todayBoxFresh,
                empty: l10n.todayBoxFreshEmpty,
                tone: _BoxTone.fresh,
                rows: [for (final card in v.fresh) row(card)],
              ),
            )
            ..add(const SizedBox(height: AppSpace.md))
            ..add(
              _Box(
                title: l10n.todayBoxAhead,
                empty: l10n.todayBoxAheadEmpty,
                tone: _BoxTone.ahead,
                rows: [for (final card in v.ahead) row(card)],
              ),
            );
        }
      case AsyncError():
        children.add(
          WarningCard(
            message: l10n.todayLoadFailed,
            action: SmallButton(label: l10n.todayRetry, onPressed: onRetry),
          ),
        );
      default:
        for (var i = 0; i < 3; i++) {
          children
            ..add(const _SkeletonCard())
            ..add(const SizedBox(height: AppSpace.md));
        }
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      children: children,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.view});

  final TodayView? view;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final v = view;
    // The streak pill sits on the date line, so the title keeps the full
    // width (beside the pill it would wrap at 390 px).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: v == null
                  ? const SizedBox.shrink()
                  : Text(
                      DateFormat('EEEE, d MMM', locale).format(v.today),
                      style: AppText.subtitle.copyWith(color: c.muted),
                    ),
            ),
            if (v != null && v.streak > 0)
              Semantics(
                label: l10n.todayStreakSemantics(v.streak),
                excludeSemantics: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    border: Border.all(color: c.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppIconView(AppIcon.flame, color: c.flame, size: 16),
                      const SizedBox(width: AppSpace.sm),
                      Text(
                        '${v.streak}',
                        style: AppText.body.copyWith(
                          color: c.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: AppSpace.xs),
                      Text(
                        l10n.todayStreak(v.streak),
                        style: AppText.caption.copyWith(color: c.muted),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpace.xxs),
        Text(l10n.screenToday, style: AppText.display.copyWith(color: c.ink)),
      ],
    );
  }
}

/// The dark exam card. Exam belt and readiness join it with the planner
/// (milestone 5).
class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.view, required this.onTap});

  final TodayView view;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final exam = view.exam!;
    final date = DateFormat(
      'd MMM y',
      locale,
    ).format(DateTime.parse(exam.date));
    final days = view.daysToGo!.clamp(0, 99999);
    final m = view.metrics;
    final levels = context.levels;
    String beltName(int level) => level == 0
        ? l10n.beltNotStarted
        : l10n.beltName(levels.levelName(l10n, level));
    return Material(
      color: c.hero,
      borderRadius: BorderRadius.circular(AppRadii.hero),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.hero),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.todayExamLine(exam.name, date),
                          style: AppText.caption.copyWith(
                            color: c.heroSubtle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpace.xxs),
                        Text(
                          l10n.todayDaysToGo(days),
                          style: AppText.heroTitle.copyWith(color: c.heroText),
                        ),
                      ],
                    ),
                  ),
                  if (m != null) ...[
                    const SizedBox(width: AppSpace.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        levels.badge(
                          context,
                          LevelBadgeData(
                            level: m.tier,
                            stripes: 2,
                            size: BadgeSize.medium,
                            showCaption: false,
                          ),
                        ),
                        const SizedBox(height: AppSpace.xs),
                        Text(
                          beltName(m.tier),
                          style: AppText.caption.copyWith(
                            color: c.heroText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              if (m != null) ...[
                const SizedBox(height: AppSpace.lg),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                  child: LinearProgressIndicator(
                    value: m.readiness,
                    minHeight: 8,
                    color: c.readiness,
                    backgroundColor: c.heroTrack,
                    semanticsLabel: l10n.todayReady(
                      (m.readiness * 100).round(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.sm),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: AppSpace.md,
                    children: [
                      Text(
                        l10n.todayReady((m.readiness * 100).round()),
                        style: AppText.caption.copyWith(color: c.heroMuted),
                      ),
                      if (m.projectedTier > 0)
                        Text(
                          l10n.todayOnTrack(
                            levels.levelName(l10n, m.projectedTier),
                          ),
                          style: AppText.caption.copyWith(color: c.heroMuted),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Each box's colours (D54): amber for what is due, indigo for new
/// learning, teal for what comes later.
enum _BoxTone { due, fresh, ahead }

/// One of Today's three boxes (D50, D54): a tinted card with a title and a
/// count, then its rows. A [collapsed] box shows the first
/// [Defaults.todayBoxVisible] rows and "Show all" for the rest.
class _Box extends StatefulWidget {
  const _Box({
    required this.title,
    required this.empty,
    required this.tone,
    required this.rows,
    this.collapsed = true,
  });

  final String title;
  final String empty;
  final _BoxTone tone;
  final List<Widget> rows;
  final bool collapsed;

  @override
  State<_Box> createState() => _BoxState();
}

class _BoxState extends State<_Box> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final rows = widget.rows;
    final folds = widget.collapsed && rows.length > Defaults.todayBoxVisible;
    final shown = folds && !_all
        ? rows.take(Defaults.todayBoxVisible).toList()
        : rows;
    final (bg, border, pill, pillText) = switch (widget.tone) {
      _BoxTone.due => (c.dueBg, c.dueBorder, c.duePill, c.dueText),
      _BoxTone.fresh => (c.freshBg, c.freshBorder, c.freshPill, c.freshText),
      _BoxTone.ahead => (c.aheadBg, c.aheadBorder, c.aheadPill, c.aheadText),
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppText.cardTitle.copyWith(color: c.ink),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: pill,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Text(
                    '${rows.length}',
                    style: AppText.caption.copyWith(
                      color: pillText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.md),
          if (rows.isEmpty)
            Text(widget.empty, style: AppText.body.copyWith(color: c.muted))
          else
            for (final (i, r) in shown.indexed) ...[
              if (i > 0) const SizedBox(height: AppSpace.sm),
              r,
            ],
          if (folds)
            Center(
              child: TextLinkButton(
                label: _all
                    ? l10n.todayShowFewer
                    : l10n.todayShowAll(rows.length),
                onPressed: () => setState(() => _all = !_all),
              ),
            ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.card,
    required this.today,
    required this.onStart,
    required this.onTap,
  });

  final TodayCard card;
  final DateTime today;

  /// Null for reviews ahead and sources without tasks: no Start (D50).
  final VoidCallback? onStart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final item = card.item;
    final info = item.info;
    final time = formatMinutes(l10n, item.minutes);
    final locale = Localizations.localeOf(context).toLanguageTag();
    String ahead() {
      final due = DateTime.fromMillisecondsSinceEpoch(item.dueAt!);
      final days = DateTime(
        due.year,
        due.month,
        due.day,
      ).difference(DateTime(today.year, today.month, today.day)).inDays;
      return days <= 1
          ? l10n.todayAheadTomorrow(time)
          : days > Defaults.todayAheadDateAfterDays
          ? l10n.todayAheadDate(days, DateFormat('d MMM', locale).format(due))
          : l10n.todayAheadDays(days, time);
    }

    final kind = switch (item.kind) {
      TodayKind.overdue => l10n.todayKindOverdue(item.overdueDays, time),
      TodayKind.review => l10n.todayKindReview(time),
      TodayKind.finalReview => l10n.todayKindFinalReview(time),
      TodayKind.firstRead =>
        item.plannedToday
            ? l10n.todayPlanned(l10n.todayKindFirstRead(time))
            : l10n.todayKindFirstRead(time),
      TodayKind.explore =>
        item.plannedToday
            ? l10n.todayPlanned(l10n.todayKindExplore(time))
            : l10n.todayKindExplore(time),
      TodayKind.ahead => ahead(),
      TodayKind.untasked => l10n.todayUntasked(item.withoutTask),
    }.toUpperCase();

    final String title;
    final String where;
    if (info == null) {
      final source = item.source!;
      title = source.title;
      final at = item.position;
      where = switch ((item.kind, item.chapter, at)) {
        (TodayKind.untasked, _, _) => l10n.todayUntaskedHint,
        (_, final chapter?, _) => l10n.readingContinue(chapter),
        (_, _, final at?) => l10n.readingFrom(source.unitType.at(l10n, at)),
        _ => '',
      };
    } else {
      title = info.task.title;
      final source = info.source;
      final range = info.range;
      where = source == null
          ? ''
          : range != null
          ? '${source.title} · ${source.unitType.range(l10n, range.start, range.end)}'
          : '${source.title} · ${info.parts.first.chunk.title}';
    }
    final d = card.display;
    return SessionCard(
      badge: LevelBadgeData(
        level: d.level,
        stripes: d.stripes,
        fading: d.fading,
      ),
      kindLabel: kind,
      kindColor: switch (item.kind) {
        TodayKind.overdue => c.warningText,
        TodayKind.ahead => c.aheadText,
        _ => null,
      },
      title: title,
      subtitle: where,
      startLabel: onStart == null
          ? null
          : l10n.sessionStart(title, switch (item.kind) {
              TodayKind.firstRead => l10n.todayKindFirstReadWord,
              TodayKind.explore => l10n.todayKindExploreWord,
              _ => l10n.todayKindReviewWord,
            }),
      onStart: onStart,
      onTap: onTap,
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.body, this.action});

  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
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
            title,
            textAlign: TextAlign.center,
            style: AppText.section.copyWith(color: c.ink),
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: c.muted),
          ),
          if (action != null) ...[const SizedBox(height: AppSpace.xl), action!],
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget block(double w, double h) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: c.line,
        borderRadius: BorderRadius.circular(6),
      ),
    );
    return ExcludeSemantics(
      child: Container(
        height: 76,
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: c.line),
        ),
        child: Row(
          children: [
            block(36, 16),
            const SizedBox(width: AppSpace.lg),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  block(90, 10),
                  const SizedBox(height: AppSpace.sm),
                  block(160, 14),
                ],
              ),
            ),
            block(44, 44),
          ],
        ),
      ),
    );
  }
}
