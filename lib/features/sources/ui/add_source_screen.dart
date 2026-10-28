import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/db/enums.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/chips.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/add_source_controller.dart';
import 'source_labels.dart';

/// Add source (design/notes/add-source.md): type, details, then a chapter
/// split, saved as one undoable operation.
class AddSourceScreen extends ConsumerStatefulWidget {
  const AddSourceScreen({super.key});

  @override
  ConsumerState<AddSourceScreen> createState() => _AddSourceScreenState();
}

class _AddSourceScreenState extends ConsumerState<AddSourceScreen> {
  final _title = TextEditingController();
  final _units = TextEditingController();
  final _link = TextEditingController();
  final _paste = TextEditingController();

  AddSourceController get _ctl =>
      ref.read(addSourceControllerProvider.notifier);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    _ctl.rangeTitle = (unit, s, e) => unit.chunkTitle(l10n, s, e);
  }

  @override
  void dispose() {
    _title.dispose();
    _units.dispose();
    _link.dispose();
    _paste.dispose();
    super.dispose();
  }

  Future<void> _save({required bool survey}) async {
    final id = await _ctl.save();
    if (id == null || !mounted) return;
    context.pushReplacement(
      survey ? Routes.survey(id) : Routes.sourceChapters(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addSourceControllerProvider);
    // Keep fields in step with values the controller fills in (a PDF's
    // name and page count).
    _sync(_title, state.title);
    if (state.type == SourceType.pdf) {
      _sync(_units, state.totalUnits?.toString() ?? _units.text);
    }
    return Scaffold(
      body: SafeArea(
        child: AddSourceBody(
          state: state,
          title: _title,
          units: _units,
          link: _link,
          paste: _paste,
          controller: _ctl,
          onSave: () => _save(survey: false),
          onSaveAndSurvey: () => _save(survey: true),
          onOpenDuplicate: (id) =>
              context.pushReplacement(Routes.sourceChapters(id)),
        ),
      ),
    );
  }

  static void _sync(TextEditingController c, String value) {
    if (c.text != value) c.text = value;
  }
}

/// The form for one [AddSourceState]. Public so goldens can render it
/// with a fixed state.
class AddSourceBody extends StatelessWidget {
  const AddSourceBody({
    required this.state,
    required this.title,
    required this.units,
    required this.link,
    required this.paste,
    required this.controller,
    required this.onSave,
    required this.onSaveAndSurvey,
    required this.onOpenDuplicate,
    super.key,
  });

  final AddSourceState state;
  final TextEditingController title;
  final TextEditingController units;
  final TextEditingController link;
  final TextEditingController paste;
  final AddSourceController controller;
  final VoidCallback onSave;
  final VoidCallback onSaveAndSurvey;
  final ValueChanged<String> onOpenDuplicate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final type = state.type;
    final canSave = state.canSave;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              RoundIconButton.back(
                context,
                () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.screenAddSource,
                    style: AppText.heroTitle.copyWith(color: c.ink),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Label(l10n.addSourceWhat),
                const SizedBox(height: AppSpace.md),
                _TypeGrid(selected: type, onSelect: controller.setType),
                if (type != null) ...[
                  const SizedBox(height: AppSpace.xxl),
                  _Card(
                    title: l10n.addSourceDetails,
                    children: _details(context),
                  ),
                  if (state.duplicateTitle != null) ...[
                    const SizedBox(height: AppSpace.lg),
                    WarningCard(
                      message: l10n.addSourceDuplicate(state.duplicateTitle!),
                      action: SmallButton(
                        label: l10n.addSourceOpenIt,
                        onPressed: () => onOpenDuplicate(state.duplicateId!),
                      ),
                    ),
                  ],
                  if (_showChapters) ...[
                    const SizedBox(height: AppSpace.lg),
                    _Card(
                      title: l10n.addSourceChapters,
                      children: _chapters(context),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
        if (state.saveFailed)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, AppSpace.sm, 20, 0),
            child: Text(
              l10n.addSourceSaveFailed,
              textAlign: TextAlign.center,
              style: AppText.caption.copyWith(color: c.warningText),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, AppSpace.md, 20, 24),
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: l10n.addSourceSaveSurvey,
                  onPressed: canSave ? onSaveAndSurvey : null,
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: PrimaryButton(
                  label: l10n.save,
                  onPressed: canSave ? onSave : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get _showChapters =>
      state.canSplit &&
      state.duplicateId == null &&
      !state.readingPdf &&
      (state.type != SourceType.pdf ||
          state.pdf?.pageCount != null ||
          state.pdfUnreadable);

  List<Widget> _details(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final type = state.type!;
    final unitsError =
        units.text.trim().isNotEmpty &&
            state.issues.contains(AddSourceIssue.unitsMissing)
        ? l10n.addSourceUnitsMissing
        : null;

    Widget titleField() => LabeledField(
      label: l10n.addSourceTitle,
      controller: title,
      onChanged: controller.setTitle,
    );
    Widget unitsField(String label) => LabeledField(
      label: label,
      controller: units,
      onChanged: controller.setTotalUnits,
      keyboardType: TextInputType.number,
      error: unitsError,
    );
    Widget linkField(String label) => LabeledField(
      label: label,
      controller: link,
      onChanged: controller.setLink,
      keyboardType: TextInputType.url,
    );
    const gap = SizedBox(height: AppSpace.lg);

    switch (type) {
      case SourceType.pdf:
        final pdf = state.pdf;
        return [
          if (pdf != null) ...[
            Row(
              children: [
                AppIconView(AppIcon.pdf, color: c.accentText),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pdf.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body.copyWith(
                          color: c.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        pdf.pageCount == null
                            ? _fileSize(l10n, pdf.bytes)
                            : l10n.addSourceFileInfo(
                                _fileSize(l10n, pdf.bytes),
                                UnitType.page.count(l10n, pdf.pageCount!),
                              ),
                        style: AppText.caption.copyWith(color: c.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (state.readingPdf) ...[
              const SizedBox(height: AppSpace.lg),
              Text(
                l10n.addSourceReading,
                style: AppText.caption.copyWith(color: c.muted),
              ),
              const SizedBox(height: AppSpace.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.pill),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  color: c.accent,
                  backgroundColor: c.line,
                ),
              ),
            ],
            gap,
          ],
          if (pdf == null)
            SecondaryButton(
              label: l10n.addSourceChoosePdf,
              onPressed: controller.pickPdf,
            )
          else ...[
            if (!state.readingPdf && state.duplicateId == null) ...[
              titleField(),
              if (pdf.pageCount == null) ...[
                gap,
                unitsField(l10n.addSourcePages),
              ],
            ],
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextLinkButton(
                label: l10n.addSourceChooseOther,
                onPressed: state.readingPdf ? null : controller.pickPdf,
              ),
            ),
          ],
        ];
      case SourceType.book || SourceType.notes:
        return [titleField(), gap, unitsField(l10n.addSourcePages)];
      case SourceType.video:
        return [
          titleField(),
          gap,
          linkField(l10n.addSourceLinkOptional),
          gap,
          unitsField(l10n.addSourceMinutes),
        ];
      case SourceType.link:
        return [linkField(l10n.addSourceLink), gap, titleField()];
      case SourceType.qbank:
        return [titleField(), gap, unitsField(l10n.addSourceQuestions)];
    }
  }

  List<Widget> _chapters(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final unit = state.unitType;
    final hasTotal = (state.totalUnits ?? 0) > 0;

    Widget option(SplitMode mode, String label) => _ModeOption(
      label: label,
      selected: state.mode == mode,
      onTap: () => controller.setMode(mode),
    );

    return [
      if (state.bookmarksFound) ...[
        Text(
          l10n.addSourceFoundBookmarks(
            state.chapters.where((ch) => ch.depth == 0).length,
          ),
          style: AppText.body.copyWith(
            color: c.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpace.sm),
        option(SplitMode.bookmarks, l10n.addSourceUseBookmarks),
      ] else if (state.type == SourceType.pdf && state.pdfUnreadable) ...[
        WarningCard(message: l10n.addSourceNoBookmarks),
        const SizedBox(height: AppSpace.sm),
      ],
      option(SplitMode.paste, l10n.addSourcePaste),
      if (state.mode == SplitMode.paste) ...[
        LabeledField(
          label: l10n.addSourcePasteHelp,
          controller: paste,
          onChanged: controller.setPasteText,
          hint: l10n.addSourcePasteHint,
          multiline: true,
          error: state.pasteErrorLines.isEmpty
              ? null
              : l10n.addSourcePasteErrors(
                  state.pasteErrorLines.length,
                  state.pasteErrorLines.join(', '),
                ),
        ),
        const SizedBox(height: AppSpace.sm),
      ],
      if (hasTotal) ...[
        option(
          SplitMode.size,
          l10n.addSourceSplitEvery(unit.count(l10n, state.splitSize)),
        ),
        if (state.mode == SplitMode.size)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 32, bottom: 6),
            child: Row(
              children: [
                RoundIconButton(
                  icon: AppIcon.minus,
                  semanticLabel: l10n.addSourceFewer,
                  onPressed: state.splitSize > 1
                      ? () => controller.changeSplitSize(-5)
                      : null,
                ),
                const SizedBox(width: AppSpace.md),
                Text(
                  unit.count(l10n, state.splitSize),
                  style: AppText.body.copyWith(
                    color: c.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                RoundIconButton(
                  icon: AppIcon.add,
                  semanticLabel: l10n.addSourceMore,
                  onPressed: () => controller.changeSplitSize(5),
                ),
              ],
            ),
          ),
      ],
      option(SplitMode.one, l10n.addSourceKeepOne),
      if (state.chapters.isNotEmpty) ...[
        const SizedBox(height: AppSpace.md),
        Divider(height: 1, color: c.line),
        const SizedBox(height: AppSpace.sm),
        for (var i = 0; i < state.chapters.length; i++)
          _ChapterRow(
            chapter: state.chapters[i],
            unit: unit,
            onMerge: _mergeTarget(i) == null
                ? null
                : () => controller.mergeWithNext(_mergeTarget(i)!),
          ),
      ],
    ];
  }

  /// The top-level index of preview row [i] when it can merge with the
  /// next chapter, else null.
  int? _mergeTarget(int i) {
    final rows = state.chapters;
    if (rows[i].depth != 0 || !rows[i].isShort) return null;
    final top = rows.take(i + 1).where((r) => r.depth == 0).length - 1;
    final tops = rows.where((r) => r.depth == 0).length;
    return top + 1 < tops ? top : null;
  }

  static String _fileSize(AppLocalizations l10n, int bytes) => bytes >= 1 << 20
      ? l10n.addSourceMegabytes((bytes / (1 << 20)).toStringAsFixed(1))
      : l10n.addSourceKilobytes((bytes / 1024).ceil().toString());
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: AppText.subtitle.copyWith(
        color: context.colors.ink,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _TypeGrid extends StatelessWidget {
  const _TypeGrid({required this.selected, required this.onSelect});

  final SourceType? selected;
  final ValueChanged<SourceType> onSelect;

  /// The design's 3 × 2 order.
  static const _order = [
    [SourceType.pdf, SourceType.book, SourceType.video],
    [SourceType.link, SourceType.notes, SourceType.qbank],
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        for (final row in _order) ...[
          if (row != _order.first) const SizedBox(height: 8),
          Row(
            children: [
              for (final t in row) ...[
                if (t != row.first) const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChipButton(
                    label: t.label(l10n),
                    selected: t == selected,
                    onPressed: () => onSelect(t),
                    fontSize: 13.5,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: c.line),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                title.toUpperCase(),
                style: AppText.overline.copyWith(color: c.accentText),
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// One split option, drawn as a radio row with a 44 px target.
class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.button),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kMinTouchTarget),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? c.ink : c.chipBorder,
                    width: selected ? 6 : 1.5,
                  ),
                ),
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Text(
                  label,
                  style: AppText.body.copyWith(
                    color: c.ink,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({
    required this.chapter,
    required this.unit,
    required this.onMerge,
  });

  final ChapterPreview chapter;
  final UnitType unit;
  final VoidCallback? onMerge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final nested = chapter.depth > 0;
    final range = chapter.startUnit == null || chapter.endUnit == null
        ? null
        : unit.range(l10n, chapter.startUnit!, chapter.endUnit!);
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: nested ? 16 : 0,
        top: AppSpace.sm,
        bottom: AppSpace.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  chapter.title,
                  style: (nested ? AppText.caption : AppText.body).copyWith(
                    color: nested ? c.muted : c.ink,
                    fontWeight: nested ? FontWeight.w500 : FontWeight.w600,
                  ),
                ),
              ),
              if (range != null) ...[
                const SizedBox(width: AppSpace.md),
                Text(range, style: AppText.caption.copyWith(color: c.muted)),
              ],
            ],
          ),
          if (chapter.sessions > 1)
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.xxs),
              child: Text(
                l10n.addSourceLong(chapter.sessions),
                style: AppText.caption.copyWith(color: c.muted),
              ),
            ),
          if (onMerge != null)
            Transform.translate(
              offset: const Offset(-AppSpace.lg, 0),
              child: TextLinkButton(
                label: l10n.addSourceShort,
                onPressed: onMerge,
              ),
            ),
        ],
      ),
    );
  }
}
