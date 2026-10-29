import 'dart:math';

import '../../core/config/defaults.dart';
import '../planner/planner.dart' show PlanImportance;

/// One exam task as the exam metrics see it.
final class ExamTaskLevel {
  const ExamTaskLevel({
    required this.id,
    required this.importance,
    required this.target,
    required this.level,
    required this.projected,
    this.size = 1,
  });

  final String id;
  final PlanImportance importance;

  /// The exam's belt target (1–7).
  final int target;

  /// Belt now (0 not started).
  final int level;

  /// Belt by exam day if the plan is followed.
  final int projected;

  /// Weight by size (units); at least 1.
  final int size;
}

/// The exam's numbers (docs/02-data-model.md, "Exam tier", "Readiness").
final class ExamMetrics {
  const ExamMetrics({
    required this.tier,
    required this.projectedTier,
    required this.readiness,
    required this.atTarget,
    required this.total,
    required this.weakLinks,
  });

  /// The exam belt today: 0 below White.
  final int tier;
  final int projectedTier;

  /// Weighted share of tasks at their effective target, 0..1.
  final double readiness;
  final int atTarget;
  final int total;

  /// High-importance tasks below Yellow, weakest first.
  final List<String> weakLinks;
}

/// Brown: Black always takes one extra review by choice, so the planner's
/// target never goes past it (docs/04-planner-spec.md).
const _maxEffective = 6;

int effectiveTarget(int target) => min(target, _maxEffective);

ExamMetrics examMetrics(
  List<ExamTaskLevel> tasks, {
  double coverage = Defaults.examTierCoverage,
  List<int> importanceWeights = Defaults.importanceWeights,
}) {
  double weight(ExamTaskLevel t) =>
      importanceWeights[t.importance.index] * max(1, t.size).toDouble();

  int tierOf(int Function(ExamTaskLevel) levelOf) {
    final total = tasks.fold(0.0, (s, t) => s + weight(t));
    if (total == 0) return 0;
    var best = 0;
    for (var l = 1; l <= 7; l++) {
      var reached = 0.0;
      for (final t in tasks) {
        final attainment = min(levelOf(t) / effectiveTarget(t.target), 1.0);
        if (attainment >= l / 7 - 1e-9) reached += weight(t);
      }
      if (reached / total >= coverage - 1e-9) best = l;
    }
    return best;
  }

  final total = tasks.fold(0.0, (s, t) => s + weight(t));
  var ready = 0.0;
  var atTarget = 0;
  for (final t in tasks) {
    if (t.level >= effectiveTarget(t.target)) {
      ready += weight(t);
      atTarget++;
    }
  }
  final weak =
      [
        for (final t in tasks)
          if (t.importance == PlanImportance.high && t.level < 2) t,
      ]..sort((a, b) {
        final byLevel = a.level.compareTo(b.level);
        return byLevel != 0 ? byLevel : a.id.compareTo(b.id);
      });

  return ExamMetrics(
    tier: tierOf((t) => t.level),
    projectedTier: tierOf((t) => t.projected),
    readiness: total == 0 ? 0 : ready / total,
    atTarget: atTarget,
    total: tasks.length,
    weakLinks: [for (final t in weak) t.id],
  );
}

/// Study minutes per day bucketed into intensities 0..[buckets] for the
/// activity grid (docs/02-data-model.md): 0 for no study, then equal
/// steps up to [full] minutes, anything above in the top bucket.
int activityBucket(
  int minutes, {
  required int full,
  int buckets = Defaults.activityGridBuckets,
}) {
  if (minutes <= 0) return 0;
  return min(buckets, 1 + (minutes * (buckets - 1) / max(1, full)).floor());
}
