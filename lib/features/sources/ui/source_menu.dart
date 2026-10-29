import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import '../../../core/ui/bottom_sheet.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../state/source_providers.dart';

/// A source's options (D48): Rename and Remove. Used by the Sources list
/// and the source's own screen, which passes [onRemoved] to leave it.
Future<void> showSourceMenu(
  BuildContext context,
  WidgetRef ref, {
  required String id,
  required String title,
  VoidCallback? onRemoved,
}) {
  final l10n = AppLocalizations.of(context);
  final actions = ref.read(sourceActionsProvider.notifier);
  return showActionSheet(
    context,
    title: title,
    actions: [
      SheetAction(l10n.sourceRename, () async {
        final name = await _askTitle(context, title);
        if (name != null) await actions.rename(id, name);
      }),
      SheetAction(
        l10n.sourceRemove,
        () => removeSource(
          context,
          ref,
          id: id,
          title: title,
          onRemoved: onRemoved,
        ),
        destructive: true,
      ),
    ],
  );
}

/// Asks first, naming how many tasks go with it, then removes the source
/// with Undo in a snackbar.
Future<void> removeSource(
  BuildContext context,
  WidgetRef ref, {
  required String id,
  required String title,
  VoidCallback? onRemoved,
}) async {
  final l10n = AppLocalizations.of(context);
  final actions = ref.read(sourceActionsProvider.notifier);
  final messenger = ScaffoldMessenger.of(context);
  final tasks = await actions.taskCount(id);
  if (!context.mounted) return;
  final c = context.colors;
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: c.surface,
      title: Text(
        l10n.sourceRemoveTitle(title),
        style: AppText.section.copyWith(color: c.ink),
      ),
      content: Text(
        l10n.sourceRemoveBody(tasks),
        style: AppText.body.copyWith(color: c.ink),
      ),
      actions: [
        TextLinkButton(
          label: l10n.redefineCancel,
          onPressed: () => Navigator.of(dialog).pop(false),
        ),
        TextLinkButton(
          label: l10n.sourceRemove,
          onPressed: () => Navigator.of(dialog).pop(true),
        ),
      ],
    ),
  );
  if (!(ok ?? false)) return;
  try {
    await actions.remove(id);
  } on InvalidOperationError {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.sourceRemoveBusy)));
    return;
  }
  onRemoved?.call();
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(l10n.sourceRemoved(title)),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => actions.undo(id),
        ),
      ),
    );
}

Future<String?> _askTitle(BuildContext context, String current) {
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
