import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/engines/planner/estimate.dart';

void main() {
  test('worked example: 32 Hard New pages ≈ 128 minutes in 3 sessions', () {
    final m = firstReadMinutes(units: 32, unit: EffortUnit.page, difficulty: 3);
    expect(m, closeTo(127.7, 0.1));
    expect(readingSessions(m), 3);
  });

  test('matches the survey mockup: 29 Hard pages seen before ≈ 1 h 20', () {
    final m = firstReadMinutes(
      units: 29,
      unit: EffortUnit.page,
      difficulty: 3,
      familiarity: 1,
    );
    expect(roundToFive(m), 80);
  });

  test('unsurveyed chunks count as Medium and New', () {
    expect(firstReadMinutes(units: 10, unit: EffortUnit.page), 30);
    expect(firstReadMinutes(units: 10, unit: EffortUnit.minute), 15);
  });
}
