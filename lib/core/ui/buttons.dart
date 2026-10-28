import 'package:flutter/material.dart';

import '../../theme/tokens/app_tokens.dart';

/// Full-width call to action, e.g. "Next chapter", "Done · back to Today".
/// Disabled until [onPressed] is set (mockup: grey fill).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _AppButton(
      label: label,
      onPressed: onPressed,
      background: onPressed == null ? c.placeholderStroke : c.accent,
      foreground: c.onAccent,
      border: null,
    );
  }
}

/// The quieter button beside a primary one, e.g. "Previous", "Cancel".
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _AppButton(
      label: label,
      onPressed: onPressed,
      background: c.surface,
      foreground: onPressed == null ? c.muted : c.ink,
      border: BorderSide(color: c.line),
    );
  }
}

class _AppButton extends StatelessWidget {
  const _AppButton({
    required this.label,
    required this.onPressed,
    required this.background,
    required this.foreground,
    required this.border,
  });

  /// Mockup button height.
  static const double height = 52;

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.card),
      side: border ?? BorderSide.none,
    );
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: Material(
        color: background,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: height),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.xl),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppText.button.copyWith(color: foreground),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Round 44 px Start button on a session card. Filled for reviews,
/// outlined for new material.
class StartButton extends StatelessWidget {
  const StartButton({
    required this.semanticLabel,
    required this.onPressed,
    this.outlined = false,
    super.key,
  });

  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: outlined ? c.surface : c.accent,
        shape: CircleBorder(
          side: outlined
              ? BorderSide(color: c.accentText, width: 1.5)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: kMinTouchTarget,
            child: Center(
              child: CustomPaint(
                size: const Size.square(18),
                painter: _PlayPainter(outlined ? c.accentText : c.onAccent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayPainter extends CustomPainter {
  _PlayPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    canvas.drawPath(
      Path()
        ..moveTo(8 * s, 5 * s)
        ..lineTo(8 * s, 19 * s)
        ..lineTo(19 * s, 12 * s)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_PlayPainter old) => old.color != color;
}
