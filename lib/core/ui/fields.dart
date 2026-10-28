import 'package:flutter/material.dart';

import '../../theme/tokens/app_tokens.dart';

/// A labelled text field: 13 px label above, ground-filled box, and a
/// 12 px message in warning text when [error] is set.
class LabeledField extends StatelessWidget {
  const LabeledField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.error,
    this.hint,
    this.keyboardType,
    this.multiline = false,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? error;
  final String? hint;
  final TextInputType? keyboardType;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.chip),
          borderSide: BorderSide(color: color, width: width),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppText.subtitle.copyWith(color: c.ink)),
        const SizedBox(height: AppSpace.sm),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: multiline ? TextInputType.multiline : keyboardType,
          minLines: multiline ? 4 : 1,
          maxLines: multiline ? 10 : 1,
          style: AppText.body.copyWith(color: c.ink),
          cursorColor: c.accentText,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: c.ground,
            hintText: hint,
            hintStyle: AppText.body.copyWith(color: c.muted),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            enabledBorder: border(
              error == null ? c.chipBorder : c.warningBorder,
            ),
            focusedBorder: border(c.accentText, 1.5),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpace.xs),
          Text(error!, style: AppText.caption.copyWith(color: c.warningText)),
        ],
      ],
    );
  }
}

/// A warning message card (warning bg, border and text), with an optional
/// action, e.g. "Already added as …" with "Open it".
class WarningCard extends StatelessWidget {
  const WarningCard({required this.message, this.action, super.key});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: c.warningBg,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: c.warningBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: AppText.body.copyWith(
                    color: c.warningText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (action != null) ...[
                const SizedBox(width: AppSpace.md),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
