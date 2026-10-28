import 'package:flutter/material.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../../level_theme.dart';
import '../../tokens/app_tokens.dart';

/// A martial-arts belt (cloth band and knot, never a buckle) for one level.
///
/// Colour is never the only signal: the knot carries the level number,
/// stripes at the right end show shine, a faded belt is captioned
/// "fading", and the whole badge has a Semantics label.
class BeltBadge extends StatelessWidget {
  const BeltBadge({required this.data, super.key});

  final LevelBadgeData data;

  /// Opacity of a faded belt (docs/06-screens.md: about 45%).
  static const double fadedOpacity = 0.45;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final levels = context.levels;
    final colors = context.colors;
    final geometry = _BeltGeometry.of(data.size);
    final started = data.level > 0;

    final belt = CustomPaint(
      size: geometry.size,
      painter: started
          ? _BeltPainter(
              geometry: geometry,
              cloth: levels.colorFor(data.level),
              knot: levels.accentFor(data.level),
              stripe: levels.stripeFor(data.level),
              number: levels.numberFor(data.level),
              outline: levels.outlineFor(data.level),
              level: data.level,
              stripes: data.fading ? 0 : data.stripes,
              textDirection: Directionality.of(context),
            )
          : _PlaceholderPainter(
              geometry: geometry,
              stroke: colors.placeholderStroke,
            ),
    );

    final caption = !data.showCaption
        ? null
        : !started
        ? (l10n.beltNew, colors.muted)
        : data.fading
        ? (l10n.beltFading, levels.labelFor(data.level))
        : null;

    return Semantics(
      label: semanticsLabel(l10n, levels, data),
      image: true,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data.fading)
            Opacity(opacity: fadedOpacity, child: belt)
          else
            belt,
          if (caption != null) ...[
            const SizedBox(height: AppSpace.xs),
            Text(
              caption.$1,
              style: AppText.badgeCaption.copyWith(color: caption.$2),
            ),
          ],
        ],
      ),
    );
  }

  /// "Green belt, level 4, 2 stripes", "Yellow belt, level 2, fading",
  /// "Not started".
  static String semanticsLabel(
    AppLocalizations l10n,
    LevelTheme levels,
    LevelBadgeData data,
  ) {
    if (data.level == 0) return l10n.beltNotStarted;
    final belt = l10n.beltName(levels.levelName(l10n, data.level));
    return data.fading
        ? l10n.beltSemanticsFading(belt, data.level)
        : l10n.beltSemantics(belt, data.level, data.stripes);
  }
}

/// Belt drawing in its own coordinates, matching the mockup SVGs.
final class _BeltGeometry {
  const _BeltGeometry({
    required this.size,
    required this.scale,
    required this.band,
    required this.knot,
    required this.stripeXs,
  });

  factory _BeltGeometry.of(BadgeSize size) => switch (size) {
    // viewBox 0 0 36 16 (Today session cards).
    BadgeSize.small => const _BeltGeometry(
      size: Size(36, 16),
      scale: 1,
      band: Rect.fromLTWH(1, 4, 34, 8),
      knot: Rect.fromLTWH(13, 1.5, 10, 13),
      stripeXs: [28, 31.5],
    ),
    // viewBox 0 0 44 18 (Today exam card).
    BadgeSize.medium => const _BeltGeometry(
      size: Size(44, 18),
      scale: 1,
      band: Rect.fromLTWH(1, 5, 42, 8),
      knot: Rect.fromLTWH(17, 2, 10, 14),
      stripeXs: [35, 38.5],
    ),
    BadgeSize.large => const _BeltGeometry(
      size: Size(88, 36),
      scale: 2,
      band: Rect.fromLTWH(1, 5, 42, 8),
      knot: Rect.fromLTWH(17, 2, 10, 14),
      stripeXs: [35, 38.5],
    ),
  };

  final Size size;
  final double scale;
  final Rect band;
  final Rect knot;

  /// Left edges of stripe 2 and stripe 1; one stripe uses the last.
  final List<double> stripeXs;
}

class _BeltPainter extends CustomPainter {
  _BeltPainter({
    required this.geometry,
    required this.cloth,
    required this.knot,
    required this.stripe,
    required this.number,
    required this.outline,
    required this.level,
    required this.stripes,
    required this.textDirection,
  });

  final _BeltGeometry geometry;
  final Color cloth;
  final Color knot;
  final Color stripe;
  final Color number;

  /// Border for the white belt, which would vanish on a white card.
  final Color? outline;
  final int level;
  final int stripes;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(geometry.scale);
    final band = RRect.fromRectAndRadius(
      geometry.band,
      const Radius.circular(2),
    );
    canvas.drawRRect(band, Paint()..color = cloth);
    if (outline != null) {
      canvas.drawRRect(
        band.deflate(0.5),
        Paint()
          ..color = outline!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    final shown = stripes.clamp(0, geometry.stripeXs.length);
    final stripePaint = Paint()..color = stripe;
    for (final x in geometry.stripeXs.skip(geometry.stripeXs.length - shown)) {
      canvas.drawRect(
        Rect.fromLTWH(x, geometry.band.top, 2, geometry.band.height),
        stripePaint,
      );
    }

    final knotRect = RRect.fromRectAndRadius(
      geometry.knot,
      const Radius.circular(2.5),
    );
    canvas.drawRRect(knotRect, Paint()..color = knot);

    final digit = TextPainter(
      text: TextSpan(
        text: '$level',
        style: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: geometry.knot.height * 0.68,
          fontWeight: FontWeight.w700,
          color: number,
          height: 1,
        ),
      ),
      textDirection: textDirection,
    )..layout();
    digit.paint(
      canvas,
      geometry.knot.center - Offset(digit.width / 2, digit.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BeltPainter old) =>
      old.cloth != cloth ||
      old.knot != knot ||
      old.stripe != stripe ||
      old.number != number ||
      old.outline != outline ||
      old.level != level ||
      old.stripes != stripes;
}

/// Dashed outline for material not yet started.
class _PlaceholderPainter extends CustomPainter {
  _PlaceholderPainter({required this.geometry, required this.stroke});

  final _BeltGeometry geometry;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(geometry.scale);
    final paint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(geometry.band, const Radius.circular(2)),
      );
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 3), paint);
        d += 5;
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PlaceholderPainter old) => old.stroke != stroke;
}
