import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/engines/exam/exam_metrics.dart';
import 'package:prepbelt/engines/planner/planner.dart';

ExamTaskLevel _t(
  String id,
  PlanImportance i,
  int level, {
  int target = 5,
  int? projected,
}) => ExamTaskLevel(
  id: id,
  importance: i,
  target: target,
  level: level,
  projected: projected ?? level,
);

void main() {
  test('the exam tier is the level reached by 80% of the weighted '
      'syllabus', () {
    // Targets Blue (5). Attainment level/5 must reach L/7.
    final m = examMetrics([
      _t('a', PlanImportance.high, 5), // 1.0
      _t('b', PlanImportance.high, 4), // 0.8
      _t('c', PlanImportance.medium, 3), // 0.6
      _t('d', PlanImportance.low, 0), // 0
    ]);
    // Weights 3, 3, 2, 1 = 9; 80% = 7.2. L=4 (0.571): a, b, c = 8 → yes.
    // L=5 (0.714): a, b = 6 → no.
    expect(m.tier, 4);
    expect((m.atTarget, m.total), (1, 4));
    expect(m.readiness, closeTo(3 / 9, 1e-9));
    expect(m.weakLinks, isEmpty);
  });

  test('the projected tier uses the plan; Black targets count as Brown', () {
    final m = examMetrics([
      _t('a', PlanImportance.high, 1, target: 7, projected: 6),
      _t('b', PlanImportance.medium, 0, projected: 5),
    ]);
    expect(m.projectedTier, 7, reason: 'everyone reaches the effective target');
    expect(m.tier, 0);
  });

  test('weak links: High tasks below Yellow, weakest first', () {
    final m = examMetrics([
      _t('w1', PlanImportance.high, 1),
      _t('w0', PlanImportance.high, 0),
      _t('ok', PlanImportance.high, 2),
      _t('low', PlanImportance.low, 0),
    ]);
    expect(m.weakLinks, ['w0', 'w1']);
  });

  test('no tasks: everything zero', () {
    final m = examMetrics(const []);
    expect((m.tier, m.projectedTier, m.readiness, m.total), (0, 0, 0.0, 0));
  });

  test('activity buckets: none, then 4 steps up to a full day', () {
    expect(
      [
        for (final m in [0, 1, 22, 45, 68, 90, 200])
          activityBucket(m, full: 90),
      ],
      [0, 1, 1, 3, 4, 5, 5],
    );
  });
}
