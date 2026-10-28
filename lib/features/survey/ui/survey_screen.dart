import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/enums.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/chips.dart';
import '../../../engines/planner/estimate.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/level_theme.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/survey_providers.dart';

/// Source survey (design/mockups/3-survey.html): per chapter, importance
/// for the exam, difficulty and familiarity, with a live first-read
/// estimate and target belt.
class SurveyScreen extends ConsumerWidget {
  const SurveyScreen({required this.sourceId, this.onDone, super.key});

  final String sourceId;

  /// Called when the survey is finished; defaults to popping the route.
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final view = ref.watch(surveyViewProvider(sourceId));
    return Scaffold(
      body: SafeArea(
        child: switch (view) {
          AsyncData(:final value) => SurveyBody(
            view: value,
            onDone: onDone ?? () => Navigator.of(context).maybePop(),
          ),
          AsyncError() => _Message(
            text: l10n.loadError,
            action: l10n.tryAgain,
            onAction: () => ref.invalidate(surveyViewProvider(sourceId)),
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

/// The survey for one [SurveyView]. Public so goldens can render it
/// without a database.
class SurveyBody extends ConsumerStatefulWidget {
  const SurveyBody({required this.view, required this.onDone, super.key});

  final SurveyView view;
  final VoidCallback onDone;

  @override
  ConsumerState<SurveyBody> createState() => _SurveyBodyState();
}

class _SurveyBodyState extends ConsumerState<SurveyBody> {
  /// Seconds a chapter usually takes, for "about N min left".
  static const _secondsPerChapter = 8;

  late int _index;
  late Importance _importance;
  late int _difficulty;
  late int _familiarity;
  bool _busy = false;

  List<SurveyChapter> get _chapters => widget.view.chapters;

  @override
  void initState() {
    super.initState();
    final first = _chapters.indexWhere((c) => !c.surveyed);
    _show(first < 0 ? 0 : first);
  }

  /// Shows chapter [index] with its saved answers. An unsurveyed chapter
  /// starts from the answers just given ([carry]), else the previous
  /// chapter's saved ones, else Medium, Medium, New.
  void _show(int index, {bool carry = false}) {
    if (_chapters.isEmpty) {
      _index = index;
      return;
    }
    final c = _chapters[index];
    final prev = index > 0 ? _chapters[index - 1] : null;
    final Importance? lastImportance = carry ? _importance : prev?.importance;
    final int? lastDifficulty = carry ? _difficulty : prev?.difficulty;
    final int? lastFamiliarity = carry ? _familiarity : prev?.familiarity;
    _index = index;
    _importance = c.importance ?? lastImportance ?? Importance.medium;
    _difficulty = c.difficulty ?? lastDifficulty ?? 2;
    _familiarity = c.familiarity ?? lastFamiliarity ?? 0;
  }

  Future<void> _save() => ref
      .read(surveyActionsProvider.notifier)
      .answer(
        _chapters[_index].id,
        difficulty: _difficulty,
        familiarity: _familiarity,
        examId: widget.view.examId,
        importance: widget.view.examId == null ? null : _importance,
      );

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _next() => _run(() async {
    await _save();
    if (_index + 1 < _chapters.length) {
      setState(() => _show(_index + 1, carry: true));
    } else {
      widget.onDone();
    }
  });

  Future<void> _markRest() => _run(() async {
    await _save();
    await ref
        .read(surveyActionsProvider.notifier)
        .markRestMedium(widget.view.sourceId, examId: widget.view.examId);
    widget.onDone();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final view = widget.view;

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          RoundIconButton.back(context, () => Navigator.of(context).maybePop()),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.surveyKicker,
                  style: AppText.caption.copyWith(
                    color: c.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Semantics(
                  header: true,
                  child: Text(
                    view.sourceTitle,
                    maxLines: 1,
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
      ),
    );

    if (_chapters.isEmpty) {
      return Column(
        children: [
          header,
          Expanded(child: _Message(text: l10n.surveyEmpty)),
        ],
      );
    }

    final chapter = _chapters[_index];
    final remaining = _chapters.length - view.surveyedCount;
    final minutesLeft = remaining == 0
        ? 0
        : (remaining * _secondsPerChapter / 60).ceil();
    final isLast = _index == _chapters.length - 1;
    // "The other N": chapters after this one that are still unsurveyed.
    final others = _chapters
        .skip(_index + 1)
        .where((ch) => !ch.surveyed)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.surveyProgress(_index + 1, _chapters.length),
                        style: AppText.subtitle.copyWith(color: c.ink),
                      ),
                    ),
                    Text(
                      remaining == 0
                          ? l10n.surveyDone
                          : l10n.surveyTimeLeft(minutesLeft),
                      style: AppText.subtitle.copyWith(
                        color: c.muted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.sm),
                ProgressBar(
                  value: view.surveyedCount / _chapters.length,
                  semanticLabel: l10n.surveyProgress(
                    _index + 1,
                    _chapters.length,
                  ),
                ),
                const SizedBox(height: AppSpace.xl),
                _ChapterCard(
                  number: _index + 1,
                  chapter: chapter,
                  unitType: view.unitType,
                  examName: view.examName,
                  importance: _importance,
                  difficulty: _difficulty,
                  familiarity: _familiarity,
                  onImportance: (v) => setState(() => _importance = v),
                  onDifficulty: (v) => setState(() => _difficulty = v),
                  onFamiliarity: (v) => setState(() => _familiarity = v),
                ),
              ],
            ),
          ),
        ),
        if (others > 0)
          Center(
            child: TextLinkButton(
              label: l10n.surveyMarkRest(others),
              onPressed: _busy ? null : _markRest,
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, AppSpace.sm, 20, 24),
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: l10n.surveyPrevious,
                  onPressed: _index == 0 || _busy
                      ? null
                      : () => setState(() => _show(_index - 1)),
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: isLast ? l10n.surveyFinish : l10n.surveyNext,
                  onPressed: _busy ? null : _next,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.number,
    required this.chapter,
    required this.unitType,
    required this.examName,
    required this.importance,
    required this.difficulty,
    required this.familiarity,
    required this.onImportance,
    required this.onDifficulty,
    required this.onFamiliarity,
  });

  final int number;
  final SurveyChapter chapter;
  final UnitType unitType;
  final String? examName;
  final Importance importance;
  final int difficulty;
  final int familiarity;
  final ValueChanged<Importance> onImportance;
  final ValueChanged<int> onDifficulty;
  final ValueChanged<int> onFamiliarity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final size = chapter.sizeUnits;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadii.sheet),
        border: Border.all(color: c.line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.surveyChapterLabel(number),
              style: AppText.overline.copyWith(
                color: c.accentText,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: AppSpace.xxs),
            Semantics(
              header: true,
              child: Text(
                chapter.title,
                style: AppText.display.copyWith(
                  color: c.ink,
                  fontSize: 26,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            if (size != null) ...[
              const SizedBox(height: AppSpace.xxs),
              Text(
                unitType == UnitType.page
                    ? l10n.surveyRange(
                        chapter.startUnit!,
                        chapter.endUnit!,
                        size,
                      )
                    : '${chapter.startUnit}–${chapter.endUnit}',
                style: AppText.subtitle.copyWith(
                  color: c.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            if (examName != null) ...[
              const SizedBox(height: AppSpace.xl),
              _Question(
                label: l10n.surveyImportanceFor(examName!),
                options: [
                  l10n.importanceHigh,
                  l10n.importanceMedium,
                  l10n.importanceLow,
                ],
                selected: importance.index,
                onSelect: (i) => onImportance(Importance.values[i]),
              ),
            ],
            const SizedBox(height: AppSpace.xl),
            _Question(
              label: l10n.surveyDifficulty,
              options: [
                l10n.difficultyEasy,
                l10n.difficultyMedium,
                l10n.difficultyHard,
              ],
              selected: difficulty - 1,
              onSelect: (i) => onDifficulty(i + 1),
            ),
            const SizedBox(height: AppSpace.xl),
            _Question(
              label: l10n.surveyFamiliarity,
              options: [
                l10n.familiarityNew,
                l10n.familiaritySeen,
                l10n.familiarityComfortable,
              ],
              selected: familiarity,
              onSelect: onFamiliarity,
              fontSize: 13.5,
            ),
            const SizedBox(height: AppSpace.xl),
            _Estimate(
              minutes: size == null
                  ? null
                  : firstReadMinutes(
                      units: size,
                      unit: EffortUnit.values.byName(unitType.name),
                      difficulty: difficulty,
                      familiarity: familiarity,
                    ),
              targetLevel: examName == null
                  ? null
                  : switch (importance) {
                      Importance.high => Defaults.targetLevelHigh,
                      Importance.medium => Defaults.targetLevelMedium,
                      Importance.low => Defaults.targetLevelLow,
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _Question extends StatelessWidget {
  const _Question({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelect,
    this.fontSize = 14,
  });

  final double fontSize;

  final String label;
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppText.subtitle.copyWith(
              color: c.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpace.sm + 2),
          Row(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChipButton(
                    label: options[i],
                    selected: i == selected,
                    onPressed: () => onSelect(i),
                    fontSize: fontSize,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Estimate extends StatelessWidget {
  const _Estimate({required this.minutes, required this.targetLevel});

  final double? minutes;
  final int? targetLevel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final levels = context.levels;
    final rounded = minutes == null ? null : roundToFive(minutes!);
    final duration = rounded == null
        ? '—'
        : l10n.approximately(_duration(l10n, rounded));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.ground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.surveyFirstRead,
                    style: AppText.caption.copyWith(color: c.muted),
                  ),
                  const SizedBox(height: AppSpace.xxs),
                  Text(duration, style: AppText.section.copyWith(color: c.ink)),
                ],
              ),
            ),
            if (targetLevel != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.surveyTarget,
                    style: AppText.caption.copyWith(color: c.muted),
                  ),
                  const SizedBox(height: AppSpace.xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      levels.badge(
                        context,
                        LevelBadgeData(level: targetLevel!, showCaption: false),
                      ),
                      const SizedBox(width: AppSpace.sm),
                      Text(
                        l10n.beltName(levels.levelName(l10n, targetLevel!)),
                        style: AppText.body.copyWith(
                          color: c.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  static String _duration(AppLocalizations l10n, int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return l10n.durationMinutes(m);
    if (m == 0) return l10n.durationHours(h);
    return l10n.durationHoursMinutes(h, m);
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.action, this.onAction});

  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: c.muted),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpace.lg),
              SecondaryButton(label: action!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
