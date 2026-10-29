import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The mockups' 2 px stroke icons, drawn from their SVG path data on a
/// 24 × 24 grid.
enum AppIcon {
  today(['M4 11l8-7 8 7v9H4z', 'M10 20v-5h4v5']),
  exams([
    'M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z',
    'M4 10h16M9 3v4M15 3v4',
  ]),
  sources(['M5 4h10a4 4 0 0 1 4 4v12H9a4 4 0 0 1-4-4z', 'M9 9h6M9 13h6']),
  progress([
    'M5 4h3a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z',
    'M11 4h3a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-3a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z',
    'M16.5 4h2.5a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-2.5a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1z',
    'M5 10h3a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1z',
    'M11 10h3a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-3a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1z',
    'M5 16h3a1 1 0 0 1 1 1v2a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-2a1 1 0 0 1 1-1z',
  ]),
  add(['M12 5v14M5 12h14'], strokeWidth: 2.4),
  flame([
    'M12 3c2 3 5 5 5 9a5 5 0 0 1-10 0c0-2 1-3 2-4 0 2 1 3 2 3 0-3-1-5 1-8z',
  ]),
  play(['M8 5v14l11-7z'], filled: true),
  back(['M15 5l-7 7 7 7']),
  close(['M6 6l12 12M18 6L6 18']),
  clock(['M12 5a8 8 0 1 0 0 16a8 8 0 1 0 0-16z', 'M12 9v4l3 2M9 2h6']),
  more(['M12 6h.01M12 12h.01M12 18h.01'], strokeWidth: 3),
  minus(['M5 12h14'], strokeWidth: 2.4),
  check(['M5 12.5l4.5 4.5L19 7.5']),
  pdf(['M6 3h8l4 4v14H6z', 'M14 3v4h4', 'M9 13h6M9 17h4']),
  book(['M5 4h12a2 2 0 0 1 2 2v14H7a2 2 0 0 1-2-2z', 'M5 18a2 2 0 0 1 2-2h12']),
  video([
    'M4 6h11a1 1 0 0 1 1 1v10a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1z',
    'M16 10l5-3v10l-5-3',
  ]),
  link([
    'M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1',
    'M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1',
  ]),
  notes(['M6 3h12v18H6z', 'M9 8h6M9 12h6M9 16h4']),
  qbank([
    'M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18z',
    'M9.5 9a2.5 2.5 0 1 1 3.5 2.3c-.7.3-1 .9-1 1.7',
    'M12 17h.01',
  ]),
  settings([
    'M12 9a3 3 0 1 0 0 6a3 3 0 1 0 0-6z',
    'M12 2v3M12 19v3M4.2 4.2l2.1 2.1M17.7 17.7l2.1 2.1M2 12h3M19 12h3M4.2 19.8l2.1-2.1M17.7 6.3l2.1-2.1',
  ]);

  const AppIcon(this.paths, {this.strokeWidth = 2, this.filled = false});

  final List<String> paths;
  final double strokeWidth;
  final bool filled;
}

/// Draws an [AppIcon]. Decorative by default; give a [semanticLabel] when
/// the icon carries meaning on its own.
class AppIconView extends StatelessWidget {
  const AppIconView(
    this.icon, {
    required this.color,
    this.size = 22,
    this.semanticLabel,
    super.key,
  });

  final AppIcon icon;
  final Color color;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final paint = CustomPaint(
      size: Size.square(size),
      painter: _IconPainter(icon, color),
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: paint)
        : Semantics(label: semanticLabel, image: true, child: paint);
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.icon, this.color);

  final AppIcon icon;
  final Color color;

  static final _cache = <String, Path>{};

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 24, size.height / 24);
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = icon.filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = icon.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final d in icon.paths) {
      canvas.drawPath(_cache.putIfAbsent(d, () => parseSvgPath(d)), paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.icon != icon || old.color != color;
}

/// Parses the subset of SVG path syntax the icons use: M L H V C A Z, in
/// absolute and relative forms.
Path parseSvgPath(String d) {
  final tokens = RegExp(
    r'[MLHVCAZmlhvcaz]|-?\d*\.?\d+(?:e-?\d+)?',
  ).allMatches(d).map((m) => m[0]!).toList();
  final path = Path();
  var i = 0;
  var cmd = '';
  var cx = 0.0, cy = 0.0, sx = 0.0, sy = 0.0;
  double n() => double.parse(tokens[i++]);
  bool isCmd(String t) => RegExp('[A-Za-z]').hasMatch(t);

  while (i < tokens.length) {
    if (isCmd(tokens[i])) cmd = tokens[i++];
    final rel = cmd == cmd.toLowerCase();
    final ox = rel ? cx : 0.0, oy = rel ? cy : 0.0;
    switch (cmd.toUpperCase()) {
      case 'M':
        cx = ox + n();
        cy = oy + n();
        path.moveTo(cx, cy);
        sx = cx;
        sy = cy;
        cmd = rel ? 'l' : 'L';
      case 'L':
        cx = ox + n();
        cy = oy + n();
        path.lineTo(cx, cy);
      case 'H':
        cx = ox + n();
        path.lineTo(cx, cy);
      case 'V':
        cy = (rel ? cy : 0.0) + n();
        path.lineTo(cx, cy);
      case 'C':
        final x1 = ox + n(), y1 = oy + n(), x2 = ox + n(), y2 = oy + n();
        cx = ox + n();
        cy = oy + n();
        path.cubicTo(x1, y1, x2, y2, cx, cy);
      case 'A':
        final rx = n(), ry = n(), rot = n(), large = n(), sweep = n();
        cx = ox + n();
        cy = oy + n();
        path.arcToPoint(
          Offset(cx, cy),
          radius: Radius.elliptical(rx, ry),
          rotation: rot * math.pi / 180,
          largeArc: large != 0,
          clockwise: sweep != 0,
        );
      case 'Z':
        path.close();
        cx = sx;
        cy = sy;
      default:
        throw FormatException('Unsupported path command $cmd in $d');
    }
  }
  return path;
}
