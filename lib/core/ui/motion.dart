import 'package:flutter/animation.dart';

/// Timings of the reward moments (CLAUDE.md, "Reward moments"), in one
/// place so they can be tuned. Every moment stays under about 1.5 s and
/// never blocks the next tap.
abstract final class RewardMotion {
  /// The result card sliding in after a rating.
  static const cardIn = Duration(milliseconds: 280);

  /// The new belt growing into place on a promotion.
  static const promote = Duration(milliseconds: 650);
  static const promoteCurve = Curves.elasticOut;

  /// The shine passing over a promoted belt, after it lands.
  static const shine = Duration(milliseconds: 700);
  static const shineDelay = Duration(milliseconds: 350);

  /// The small shake of a belt that lost a stripe.
  static const stripeLost = Duration(milliseconds: 420);

  /// The streak flame's pulse when today's first review lands.
  static const streak = Duration(milliseconds: 600);
}
