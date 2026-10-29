import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/defaults.dart';
import 'package:prepbelt/engines/game/streak.dart';
import 'package:prepbelt/engines/planner/estimate.dart';
import 'package:prepbelt/engines/review/review_types.dart';
import 'package:prepbelt/engines/review/xp.dart';

void main() {
  test('the streak counts back from today, or from yesterday until today '
      'has a review', () {
    final today = DateTime(2026, 10, 28, 20);
    DateTime d(int day) => DateTime(2026, 10, day, 9);
    expect(streakDays([d(26), d(27), d(28)], today), 3);
    expect(streakDays([d(26), d(27)], today), 2, reason: 'today not over');
    expect(streakDays([d(25), d(27), d(27)], today), 1);
    expect(streakDays([d(25)], today), 0);
    expect(streakDays([], today), 0);
  });

  test('XP: weight times 10, plus 10 for a promotion', () {
    int xp(Rating r, {bool promoted = false}) => xpForReview(
      r,
      promoted: promoted,
      perWeight: Defaults.xpPerRatingWeight,
      ratingWeights: Defaults.xpRatingWeights,
      promotionBonus: Defaults.xpPromotionBonus,
    );
    expect(
      [
        xp(Rating.forgot),
        xp(Rating.hard),
        xp(Rating.good, promoted: true),
        xp(Rating.easy, promoted: true),
      ],
      [10, 20, 40, 50],
      reason: 'the Back-from-source mockup',
    );
  });

  test('review length: 35% then 20% of the first read, within 5–30 min', () {
    expect(reviewMinutes(60, firstReview: true), 21);
    expect(reviewMinutes(60, firstReview: false), 12);
    expect(reviewMinutes(5, firstReview: true), 5);
    expect(reviewMinutes(300, firstReview: true), 30);
  });
}
