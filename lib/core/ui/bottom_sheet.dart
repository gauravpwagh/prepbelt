import 'package:flutter/material.dart';

import '../../theme/tokens/app_tokens.dart';

/// One row of an action sheet.
final class SheetAction {
  const SheetAction(this.label, this.onSelected, {this.destructive = false});

  final String label;
  final VoidCallback onSelected;
  final bool destructive;
}

/// A bottom sheet of actions under a title, e.g. Rename / Remove on a
/// source. Choosing a row closes the sheet first.
Future<void> showActionSheet(
  BuildContext context, {
  required String title,
  required List<SheetAction> actions,
}) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: context.colors.surface,
  showDragHandle: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
  ),
  builder: (sheet) {
    final c = sheet.colors;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.section.copyWith(color: c.ink),
              ),
            ),
            const SizedBox(height: AppSpace.md),
            for (final a in actions)
              InkWell(
                borderRadius: BorderRadius.circular(AppRadii.button),
                onTap: () {
                  Navigator.of(sheet).pop();
                  a.onSelected();
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 52),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      a.label,
                      style: AppText.body.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: a.destructive ? c.warningText : c.ink,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  },
);
