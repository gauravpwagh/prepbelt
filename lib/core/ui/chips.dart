import 'package:flutter/material.dart';

import '../../theme/tokens/app_tokens.dart';

/// One option in a segmented choice, e.g. High / Medium / Low in the
/// survey. Selected chips fill with ink.
class ChoiceChipButton extends StatelessWidget {
  const ChoiceChipButton({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _Chip(
      label: label,
      selected: selected,
      onPressed: onPressed,
      radius: AppRadii.chip,
      minHeight: kMinTouchTarget,
      padding: AppSpace.md,
      background: selected ? c.ink : c.surface,
      foreground: selected ? c.surface : c.ink,
      border: selected
          ? BorderSide(color: c.ink, width: 1.5)
          : BorderSide(color: c.chipBorder),
      style: AppText.button.copyWith(fontSize: 14),
    );
  }
}

/// A pill-shaped action chip, e.g. Edit / Scope / Split on Redefine.
/// Drawn 40 px tall as in the mockup, inside a 44 px touch target.
class PillChip extends StatelessWidget {
  const PillChip({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: _Chip(
        label: label,
        selected: selected,
        onPressed: onPressed,
        radius: AppRadii.pill,
        minHeight: 40,
        padding: 14,
        background: selected ? c.ink : c.surface,
        foreground: selected ? c.surface : c.ink,
        border: selected
            ? BorderSide(color: c.ink, width: 1.5)
            : BorderSide(color: c.chipBorder),
        style: AppText.chip.copyWith(
          fontSize: 13.5,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}

/// A small non-interactive tag, e.g. "from template".
class TagChip extends StatelessWidget {
  const TagChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: AppText.overline.copyWith(
            color: c.accentText,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onPressed,
    required this.radius,
    required this.minHeight,
    required this.padding,
    required this.background,
    required this.foreground,
    required this.border,
    required this.style,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;
  final double radius;
  final double minHeight;
  final double padding;
  final Color background;
  final Color foreground;
  final BorderSide border;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      enabled: onPressed != null,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: border,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: style.copyWith(color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
