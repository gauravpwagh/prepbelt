import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/enums.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/source_providers.dart';
import '../state/study_files.dart';
import 'study_folder_dialogs.dart';

/// Edit details (D51, design/notes/study-folder.md): title, link, total
/// pages or minutes, and the file. Type and chapters are not edited here.
class EditSourceScreen extends ConsumerStatefulWidget {
  const EditSourceScreen({required this.sourceId, super.key});

  final String sourceId;

  @override
  ConsumerState<EditSourceScreen> createState() => _EditSourceScreenState();
}

class _EditSourceScreenState extends ConsumerState<EditSourceScreen> {
  final _title = TextEditingController();
  final _link = TextEditingController();
  final _total = TextEditingController();
  bool _filled = false;
  bool _saving = false;
  bool _failed = false;

  @override
  void dispose() {
    _title.dispose();
    _link.dispose();
    _total.dispose();
    super.dispose();
  }

  Future<void> _save(SourceDetails d) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final actions = ref.read(sourceActionsProvider.notifier);
    final s = d.source;
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      final link = _link.text.trim();
      await actions.saveDetails(
        s.id,
        title: _title.text,
        uri: hasLink(s.type) ? (link.isEmpty ? null : link) : s.uri,
        totalUnits: hasTotal(s.type)
            ? int.tryParse(_total.text.trim())
            : s.totalUnits,
      );
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.sourceEdited(_title.text.trim())),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () => actions.undo(s.id),
            ),
          ),
        );
      router.pop();
    } on Object {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(sourceDetailsProvider(widget.sourceId)).value;
    if (details != null && !_filled) {
      _filled = true;
      _title.text = details.source.title;
      _link.text = details.source.uri ?? '';
      _total.text = details.source.totalUnits?.toString() ?? '';
    }
    return Scaffold(
      body: SafeArea(
        child: details == null
            ? const SizedBox.shrink()
            : EditSourceBody(
                details: details,
                title: _title,
                link: _link,
                total: _total,
                saving: _saving,
                failed: _failed,
                onChanged: () => setState(() {}),
                onBack: () => context.pop(),
                onChangeFile: () async {
                  await relinkSource(context, ref, widget.sourceId);
                  ref.invalidate(sourceDetailsProvider(widget.sourceId));
                },
                onSave: () => _save(details),
              ),
      ),
    );
  }
}

/// A link field: videos and links.
bool hasLink(SourceType t) => t == SourceType.video || t == SourceType.link;

/// A total to edit: a PDF's comes from its file, a link has none.
bool hasTotal(SourceType t) => t != SourceType.pdf && t != SourceType.link;

/// The form. Public so goldens can render it.
class EditSourceBody extends StatelessWidget {
  const EditSourceBody({
    required this.details,
    required this.title,
    required this.link,
    required this.total,
    required this.onChanged,
    required this.onBack,
    required this.onChangeFile,
    required this.onSave,
    this.saving = false,
    this.failed = false,
    super.key,
  });

  final SourceDetails details;
  final TextEditingController title;
  final TextEditingController link;
  final TextEditingController total;
  final bool saving;
  final bool failed;
  final VoidCallback onChanged;
  final VoidCallback onBack;
  final VoidCallback onChangeFile;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final s = details.source;
    final titleOk = title.text.trim().isNotEmpty;
    final linkOk = s.type != SourceType.link || link.text.trim().isNotEmpty;
    final n = int.tryParse(total.text.trim());
    final totalOk =
        !hasTotal(s.type) ||
        (total.text.trim().isEmpty && details.minTotal == 0) ||
        (n != null && n > 0 && n >= details.minTotal);
    final valid = titleOk && linkOk && totalOk;

    final fields = <Widget>[
      LabeledField(
        label: l10n.addSourceTitle,
        controller: title,
        onChanged: (_) => onChanged(),
        error: titleOk ? null : l10n.addSourceTitleMissing,
      ),
      if (hasLink(s.type)) ...[
        const SizedBox(height: AppSpace.lg),
        LabeledField(
          label: s.type == SourceType.link
              ? l10n.addSourceLink
              : l10n.addSourceLinkOptional,
          controller: link,
          keyboardType: TextInputType.url,
          onChanged: (_) => onChanged(),
          error: linkOk ? null : l10n.addSourceLinkMissing,
        ),
      ],
      if (hasTotal(s.type)) ...[
        const SizedBox(height: AppSpace.lg),
        LabeledField(
          label: s.unitType == UnitType.minute
              ? l10n.sourceEditTotalMinutes
              : l10n.addSourcePages,
          controller: total,
          keyboardType: TextInputType.number,
          onChanged: (_) => onChanged(),
          error: totalOk ? null : l10n.sourceEditTotalTooSmall(details.minTotal),
        ),
      ],
    ];

    final file = details.fileName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              RoundIconButton.back(context, onBack),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Text(
                  l10n.sourceEditTitle,
                  style: AppText.heroTitle.copyWith(color: c.ink),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            children: [
              _Card(children: fields),
              if (s.type == SourceType.pdf) ...[
                const SizedBox(height: AppSpace.lg),
                _Card(
                  children: [
                    Text(
                      l10n.sourceEditFile,
                      style: AppText.subtitle.copyWith(color: c.ink),
                    ),
                    const SizedBox(height: AppSpace.xs),
                    Text(
                      file ?? '',
                      style: AppText.body.copyWith(color: c.ink),
                    ),
                    if (!details.fileFound)
                      Text(
                        l10n.sourceEditFileMissing,
                        style: AppText.caption.copyWith(color: c.warningText),
                      ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextLinkButton(
                        label: l10n.sourceEditChangeFile,
                        onPressed: saving ? null : onChangeFile,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (failed)
          Text(
            l10n.addSourceSaveFailed,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: c.warningText),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, AppSpace.md, 20, 24),
          child: PrimaryButton(
            label: l10n.save,
            onPressed: valid && !saving ? onSave : null,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
