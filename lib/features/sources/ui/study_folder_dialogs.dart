import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../core/ui/buttons.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/reading_providers.dart';
import '../state/source_providers.dart';
import '../state/study_files.dart';

/// Dialogs for the study folder (D51, design/notes/study-folder.md).

Future<bool?> _ask(
  BuildContext context, {
  required String title,
  required String body,
  required String confirm,
}) {
  final l10n = AppLocalizations.of(context);
  final c = context.colors;
  return showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: c.surface,
      title: Text(title, style: AppText.section.copyWith(color: c.ink)),
      content: Text(body, style: AppText.body.copyWith(color: c.ink)),
      actions: [
        TextLinkButton(
          label: l10n.cancel,
          onPressed: () => Navigator.of(dialog).pop(false),
        ),
        TextLinkButton(
          label: confirm,
          onPressed: () => Navigator.of(dialog).pop(true),
        ),
      ],
    ),
  );
}

/// True when a study folder is available, asking the student to choose
/// one first if not.
Future<bool> ensureStudyFolder(BuildContext context, WidgetRef ref) async {
  final files = ref.read(studyFilesProvider.notifier);
  if (await files.folder() != null) return true;
  if (!context.mounted) return false;
  final l10n = AppLocalizations.of(context);
  final chosenBefore = (await ref.read(deviceProvider.future)).folder != null;
  if (!context.mounted) return false;
  final ok = await _ask(
    context,
    title: chosenBefore ? l10n.folderGoneTitle : l10n.folderAskTitle,
    body: chosenBefore ? l10n.folderGoneBody : l10n.folderAskBody,
    confirm: l10n.folderChoose,
  );
  if (!(ok ?? false)) return false;
  return await files.choose() != null;
}

/// Lets the student pick source [sourceId]'s file again, checking it is
/// the same file or asking first. True when relinked.
Future<bool> relinkSource(
  BuildContext context,
  WidgetRef ref,
  String sourceId,
) async {
  if (!await ensureStudyFolder(context, ref)) return false;
  final files = ref.read(studyFilesProvider.notifier);
  final r = await files.pickReplacement(sourceId);
  if (r == null || !context.mounted) return false;
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  if (r.usedBy case final title?) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.fileUsedBy(title))));
    return false;
  }
  if (!r.same) {
    final ok = await _ask(
      context,
      title: l10n.fileDifferentTitle,
      body: l10n.fileDifferentBody,
      confirm: l10n.fileUseAnyway,
    );
    if (!(ok ?? false)) return false;
  }
  await files.relink(sourceId, r);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(l10n.fileRelinked(r.pick.name))));
  return true;
}

/// After starting a session or a sitting: says so when nothing opened,
/// and for a missing folder or file asks to choose or relink, then opens it.
Future<void> afterStart(
  BuildContext context,
  WidgetRef ref,
  StartResult result, {
  required String sourceId,
  required String notOpened,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final files = ref.read(studyFilesProvider.notifier);
  if (result == StartResult.opened) return;
  var outcome = switch (result) {
    StartResult.noFolder => OpenOutcome.noFolder,
    StartResult.missing => OpenOutcome.missing,
    _ => OpenOutcome.failed,
  };
  if (outcome == OpenOutcome.noFolder) {
    if (!await ensureStudyFolder(context, ref)) return;
    outcome = await files.open(sourceId);
  }
  if (outcome == OpenOutcome.missing) {
    final file = await ref.read(sourceRepositoryProvider).fileOf(sourceId);
    if (!context.mounted) return;
    final ok = await _ask(
      context,
      title: l10n.fileMissingTitle(p.posix.basename(file?.localPath ?? '')),
      body: l10n.fileMissingBody,
      confirm: l10n.fileFind,
    );
    if (!(ok ?? false) || !context.mounted) return;
    if (!await relinkSource(context, ref, sourceId)) return;
    outcome = await files.open(sourceId);
  }
  if (outcome != OpenOutcome.opened) {
    messenger.showSnackBar(SnackBar(content: Text(notOpened)));
  }
}
