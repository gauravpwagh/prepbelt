import '../review/review_engine.dart';
import 'planner.dart';

/// The plan and, when first reads cannot all fit before the exam, how many
/// more minutes a day would fit them (docs/04-planner-spec.md, "When time
/// runs out"). Reviews are never cut (D53).
final class TriageResult {
  const TriageResult({
    required this.plan,
    this.needsStudent = false,
    this.extraForFull,
  });

  /// The plan to follow.
  final PlanResult plan;

  /// The plan does not fit; the student decides.
  final bool needsStudent;

  /// More minutes a day that would make the whole plan fit. Null when even
  /// the most a day cannot.
  final int? extraForFull;

  bool get fits => plan.fits;
}

/// Plans, and if the plan does not fit, works out the extra minutes a day
/// that would fit it, so the student can add them or drop tasks.
TriageResult triage(
  PlannerInput input,
  ReviewEngine engine, {
  int maxExtraMinutes = 8 * 60,
}) {
  final full = plan(input, engine);
  if (full.fits) return TriageResult(plan: full);

  bool fitsWith(int extra) =>
      plan(input.copyWith(extraMinutes: extra), engine).fits;
  int? extra;
  if (fitsWith(maxExtraMinutes)) {
    var lo = 0, hi = maxExtraMinutes;
    while (hi - lo > 1) {
      final mid = (lo + hi) ~/ 2;
      if (fitsWith(mid)) {
        hi = mid;
      } else {
        lo = mid;
      }
    }
    extra = hi;
  }
  return TriageResult(plan: full, needsStudent: true, extraForFull: extra);
}
