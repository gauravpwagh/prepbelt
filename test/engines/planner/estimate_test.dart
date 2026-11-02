import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/engines/planner/estimate.dart';

void main() {
  test('worked example: 32 New pages = 96 minutes in 3 sessions (D53: no '
      'difficulty factor)', () {
    final m = firstReadMinutes(units: 32, unit: EffortUnit.page);
    expect(m, 96);
    expect(readingSessions(m), 3);
  });

  test('29 pages seen before ≈ 1 h', () {
    final m = firstReadMinutes(
      units: 29,
      unit: EffortUnit.page,
      familiarity: 1,
    );
    expect(roundToFive(m), 60);
  });

  test('unsurveyed chunks count as New', () {
    expect(firstReadMinutes(units: 10, unit: EffortUnit.page), 30);
    expect(firstReadMinutes(units: 10, unit: EffortUnit.minute), 15);
  });
}
