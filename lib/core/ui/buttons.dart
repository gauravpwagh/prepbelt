import 'package:flutter/material.dart';

import '../../theme/tokens/app_tokens.dart';
import 'app_icons.dart';

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
                // One line; shrinks rather than breaking a word.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppText.button.copyWith(color: foreground),
                  ),
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
      // Its own node, so a tappable card around it keeps both actions.
      container: true,
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

/// A round 44 px icon button on a surface, e.g. Back in the screen header.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  });

  /// Back, using the platform's localized label.
  factory RoundIconButton.back(BuildContext context, VoidCallback onPressed) =>
      RoundIconButton(
        icon: AppIcon.back,
        semanticLabel: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onPressed,
      );

  final AppIcon icon;
  final String semanticLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      // Its own node, so a header around it keeps the button reachable.
      container: true,
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        shape: CircleBorder(side: BorderSide(color: c.line)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: kMinTouchTarget,
            child: Center(child: AppIconView(icon, color: c.ink, size: 18)),
          ),
        ),
      ),
    );
  }
}

/// A text-only action in the accent colour, e.g. "Mark the other 14 as
/// Medium". Keeps a 44 px touch target.
class TextLinkButton extends StatelessWidget {
  const TextLinkButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadii.button),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kMinTouchTarget),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
            child: Center(
              widthFactor: 1,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(
                  color: c.accentText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A compact secondary action inside a card, e.g. "Survey" on a source.
/// Drawn 36 px tall inside a 44 px touch target.
class SmallButton extends StatelessWidget {
  const SmallButton({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: kMinTouchTarget),
        child: Center(
          widthFactor: 1,
          child: Material(
            color: c.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.button),
              side: BorderSide(color: c.chipBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 36),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: AppText.chip.copyWith(color: c.ink),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A 6 px rounded progress bar (track in line colour, fill in accent).
class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.value, this.semanticLabel, super.key});

  /// 0..1.
  final double value;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: semanticLabel,
      value: '${(value.clamp(0, 1) * 100).round()}%',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: SizedBox(
          height: 6,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: c.line),
              FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: value.clamp(0, 1).toDouble(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
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
