import 'package:flutter/painting.dart';

/// Grid palette "Night to sun" (viridis), levels 1→7. Separate from the
/// level theme: it colours the activity grid and mastery timeline.
abstract final class NightToSun {
  static const levels = [
    Color(0xFF440154),
    Color(0xFF443983),
    Color(0xFF31688E),
    Color(0xFF21918C),
    Color(0xFF35B779),
    Color(0xFF90D743),
    Color(0xFFFDE725),
  ];

  /// Planned (future) cells are drawn at this opacity.
  static const plannedOpacity = 0.38;
}
