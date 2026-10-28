import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../theme/level_theme.dart';
import '../../theme/tokens/app_tokens.dart';
import 'buttons.dart';

/// One session on the Today screen: belt, kind and minutes, title, source
/// and range, and a Start button. New material (level 0) gets a dashed
/// border and an outlined Start button.
class SessionCard extends StatelessWidget {
  const SessionCard({
    required this.badge,
    required this.kindLabel,
    required this.title,
    required this.subtitle,
    required this.startLabel,
    required this.onStart,
    this.kindColor,
    super.key,
  });

  final LevelBadgeData badge;

  /// Already upper-cased, e.g. "REVIEW · 20 MIN".
  final String kindLabel;

  /// Defaults to the level's label colour, or the accent for new material.
  final Color? kindColor;
  final String title;
  final String subtitle;

  /// Accessible name of the Start button.
  final String startLabel;
  final VoidCallback? onStart;

  bool get isNew => badge.level == 0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final levels = context.levels;
    final labelColor =
        kindColor ?? (isNew ? c.accentText : levels.labelFor(badge.level));

    final content = Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Center(child: levels.badge(context, badge)),
          ),
          const SizedBox(width: AppSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kindLabel,
                  style: AppText.overline.copyWith(color: labelColor),
                ),
                const SizedBox(height: AppSpace.xxs),
                Text(
                  title,
                  style: AppText.cardTitle.copyWith(color: c.ink),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpace.xxs),
                Text(
                  subtitle,
                  style: AppText.caption.copyWith(color: c.muted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpace.lg),
          StartButton(
            semanticLabel: startLabel,
            onPressed: onStart,
            outlined: isNew,
          ),
        ],
      ),
    );

    final radius = BorderRadius.circular(AppRadii.card);
    if (!isNew) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: radius,
          border: Border.all(color: c.line),
        ),
        child: content,
      );
    }
    return CustomPaint(
      painter: _DashedBorderPainter(color: c.lineDashed, radius: AppRadii.card),
      child: DecoratedBox(
        decoration: BoxDecoration(color: c.surface, borderRadius: radius),
        child: content,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double width = 1.5;
  static const double dash = 5;
  static const double gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final rect = (Offset.zero & size).deflate(width / 2);
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    for (final PathMetric metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
