import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/bottom_sheet.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/source_providers.dart';
import 'source_labels.dart';

/// Sources list (design/notes/sources-list.md): every source with its
/// survey progress and a one-tap route into the survey.
class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summaries = ref.watch(sourceSummariesProvider);
    final actions = ref.read(sourceActionsProvider.notifier);

    Future<void> remove(SourceSummary s) async {
      final messenger = ScaffoldMessenger.of(context);
      await actions.remove(s.source.id);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.sourceRemoved(s.source.title)),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => actions.undo(s.source.id),
            ),
          ),
        );
    }

    return SourcesBody(
      summaries: summaries,
      onOpen: (s) => context.push(Routes.survey(s.source.id)),
      onAdd: () => context.push(Routes.newSource),
      onRetry: () => ref.invalidate(sourceSummariesProvider),
      onMore: (s) => showActionSheet(
        context,
        title: s.source.title,
        actions: [
          SheetAction(l10n.sourceRename, () async {
            final title = await _askTitle(context, s.source.title);
            if (title != null) await actions.rename(s.source.id, title);
          }),
          SheetAction(l10n.sourceRemove, () => remove(s), destructive: true),
        ],
      ),
    );
  }

  static Future<String?> _askTitle(BuildContext context, String current) {
    final controller = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder: (dialog) {
        final l10n = AppLocalizations.of(dialog);
        final c = dialog.colors;
        return AlertDialog(
          backgroundColor: c.surface,
          title: Text(
            l10n.sourceRename,
            style: AppText.section.copyWith(color: c.ink),
          ),
          content: LabeledField(
            label: l10n.addSourceTitle,
            controller: controller,
            onChanged: (_) {},
          ),
          actions: [
            TextLinkButton(
              label: l10n.cancel,
              onPressed: () => Navigator.of(dialog).pop(),
            ),
            TextLinkButton(
              label: l10n.save,
              onPressed: () {
                final t = controller.text.trim();
                Navigator.of(dialog).pop(t.isEmpty ? null : t);
              },
            ),
          ],
        );
      },
    ).whenComplete(controller.dispose);
  }
}

/// The list for one load state. Public so goldens can render it without a
/// database.
class SourcesBody extends StatelessWidget {
  const SourcesBody({
    required this.summaries,
    required this.onOpen,
    required this.onAdd,
    required this.onRetry,
    required this.onMore,
    super.key,
  });

  final AsyncValue<List<SourceSummary>> summaries;
  final ValueChanged<SourceSummary> onOpen;
  final VoidCallback onAdd;
  final VoidCallback onRetry;
  final ValueChanged<SourceSummary> onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final list = summaries.value;

    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          list == null || list.isEmpty
              ? ' '
              : l10n.sourcesSummary(
                  list.length,
                  list.where((s) => s.surveyed).length,
                ),
          style: AppText.subtitle.copyWith(color: c.muted),
        ),
        const SizedBox(height: AppSpace.xxs),
        Semantics(
          header: true,
          child: Text(
            l10n.screenSources,
            style: AppText.display.copyWith(color: c.ink),
          ),
        ),
        const SizedBox(height: AppSpace.xl),
      ],
    );

    final Widget content = switch (summaries) {
      AsyncData(value: final items) when items.isEmpty => _Empty(onAdd: onAdd),
      AsyncData(value: final items) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        itemCount: items.length + 1,
        separatorBuilder: (_, i) => SizedBox(height: i == 0 ? 0 : AppSpace.md),
        itemBuilder: (_, i) => i == 0
            ? header
            : _SourceCard(
                summary: items[i - 1],
                onOpen: () => onOpen(items[i - 1]),
                onMore: () => onMore(items[i - 1]),
              ),
      ),
      AsyncError() => _Padded(
        children: [
          header,
          WarningCard(
            message: l10n.sourcesLoadError,
            action: SmallButton(label: l10n.tryAgain, onPressed: onRetry),
          ),
        ],
      ),
      _ => _Padded(
        children: [
          header,
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(height: AppSpace.md),
            const _SkeletonCard(),
          ],
        ],
      ),
    };

    return SafeArea(child: content);
  }
}

class _Padded extends StatelessWidget {
  const _Padded({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
    required this.summary,
    required this.onOpen,
    required this.onMore,
  });

  final SourceSummary summary;
  final VoidCallback onOpen;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final s = summary.source;
    final type = s.type.label(l10n);
    final size = s.totalUnits == null
        ? null
        : s.unitType.count(l10n, s.totalUnits!);
    final progress = l10n.sourceSurveyedOf(
      summary.surveyedCount,
      summary.chapterCount,
    );

    return Semantics(
      button: true,
      label: l10n.sourceCardSemantics(
        s.title,
        type,
        size ?? '',
        summary.surveyedCount,
        summary.chapterCount,
      ),
      hint: summary.surveyed
          ? l10n.sourceCardHintReview
          : l10n.sourceCardHintSurvey,
      excludeSemantics: true,
      onTap: onOpen,
      onLongPress: onMore,
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: c.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onOpen,
          onLongPress: onMore,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TypeIcon(icon: s.type.icon),
                    const SizedBox(width: AppSpace.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            [type, ?size].join(' · ').toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.overline.copyWith(color: c.muted),
                          ),
                          const SizedBox(height: AppSpace.xxs),
                          Text(
                            s.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.cardTitle.copyWith(color: c.ink),
                          ),
                          const SizedBox(height: AppSpace.xxs),
                          Text(
                            l10n.sourceChapters(summary.chapterCount),
                            style: AppText.caption.copyWith(color: c.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpace.sm),
                    if (summary.surveyed)
                      SizedBox(
                        height: kMinTouchTarget,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppIconView(
                              AppIcon.check,
                              color: c.muted,
                              size: 18,
                            ),
                            const SizedBox(width: AppSpace.xs),
                            Text(
                              l10n.sourceSurveyed,
                              style: AppText.caption.copyWith(
                                color: c.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      SmallButton(label: l10n.sourceSurvey, onPressed: onOpen),
                  ],
                ),
                const SizedBox(height: AppSpace.md),
                Row(
                  children: [
                    Expanded(
                      child: ProgressBar(
                        value: summary.chapterCount == 0
                            ? 0
                            : summary.surveyedCount / summary.chapterCount,
                        semanticLabel: progress,
                      ),
                    ),
                    const SizedBox(width: AppSpace.md),
                    Text(
                      progress,
                      style: AppText.caption.copyWith(color: c.muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  const _TypeIcon({required this.icon});

  final AppIcon icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: AppIconView(icon, color: c.accentText, size: 22),
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
        height: 104,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: c.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            block(40, 40),
            const SizedBox(width: AppSpace.lg),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                block(90, 10),
                const SizedBox(height: AppSpace.sm),
                block(160, 14),
                const SizedBox(height: AppSpace.sm),
                block(70, 10),
              ],
            ),
          ],
        ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            context.levels.badge(
              context,
              const LevelBadgeData(
                level: 0,
                size: BadgeSize.large,
                showCaption: false,
              ),
            ),
            const SizedBox(height: AppSpace.xxl),
            Semantics(
              header: true,
              child: Text(
                l10n.sourcesEmptyTitle,
                style: AppText.section.copyWith(color: c.ink),
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              l10n.sourcesEmptyBody,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: c.muted),
            ),
            const SizedBox(height: AppSpace.xxl),
            PrimaryButton(label: l10n.sourcesAdd, onPressed: onAdd),
          ],
        ),
      ),
    );
  }
}
