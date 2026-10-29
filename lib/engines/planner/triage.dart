import 'dart:math';

import '../../core/config/defaults.dart';
import '../review/review_engine.dart';
import 'planner.dart';

/// The automatic cuts, in the order they are tried (docs/04-planner-spec.md,
/// "Triage when time runs out"). High-importance tasks are never cut.
enum TriageStep {
  /// 1. Drop the final review of Low tasks (their target falls one belt).
  dropFinalLow,

  /// 2. Lower Low targets to Yellow.
  lowToYellow,

  /// 3. Low and Easy first reads become skims: 40% of the estimate, one
  /// review.
  skimLowEasy,

  /// 4. Lower Medium targets by one level.
  lowerMedium,
}

/// One task cut by one step.
final class TriageCut {
  const TriageCut({
    required this.step,
    required this.taskId,
    required this.plannedBefore,
    required this.plannedAfter,
  });

  final TriageStep step;
  final String taskId;
  final int plannedBefore;
  final int plannedAfter;

  @override
  bool operator ==(Object other) =>
      other is TriageCut && other.step == step && other.taskId == taskId;

  @override
  int get hashCode => Object.hash(step, taskId);
}

/// The plan after triage, the cuts that made it fit, and, when cuts are
/// not enough (step 5), how many more minutes a day would help.
final class TriageResult {
  const TriageResult({
    required this.plan,
    required this.cuts,
    this.needsStudent = false,
    this.extraForReduced,
    this.extraForFull,
  });

  /// The plan to follow (with the cuts applied).
  final PlanResult plan;
  final List<TriageCut> cuts;

  /// Step 5: the cuts are not enough; the student decides.
  final bool needsStudent;

  /// More minutes a day that would make the reduced plan fit, and the
  /// full plan (no cuts). Null when even the most a day cannot.
  final int? extraForReduced;
  final int? extraForFull;

  bool get fits => plan.fits;
}

/// Plans, and if the plan does not fit, cuts the least valuable work step
/// by step until it does (docs/04-planner-spec.md, "Triage"). Each step
/// applies to every eligible task at once, and is kept only if it brings
/// the plan closer to fitting; tasks the student keeps
/// ([PlanTask.keep]) and High tasks are never cut. If all four steps are
/// not enough, the result asks the student, with the extra minutes a day
/// that would fit the reduced plan and the whole plan.
TriageResult triage(
  PlannerInput input,
  ReviewEngine engine, {
  double skimShare = Defaults.skimShare,
  int maxExtraMinutes = 8 * 60,
}) {
  final full = plan(input, engine);
  if (full.fits) return TriageResult(plan: full, cuts: const []);

  // How far a plan is from fitting: late High tasks first, then minutes.
  (int, int) shortfall(PlanResult p) => (p.late.length, p.unplacedMinutes);
  bool better((int, int) a, (int, int) b) =>
      a.$1 < b.$1 || (a.$1 == b.$1 && a.$2 < b.$2);

  var tasks = input.tasks;
  final cuts = <TriageCut>[];
  var reduced = full;
  for (final step in TriageStep.values) {
    final stepCuts = <TriageCut>[];
    final next = [
      for (final t in tasks)
        _cut(step, t, skimShare: skimShare, onCut: stepCuts.add) ?? t,
    ];
    if (stepCuts.isEmpty) continue;
    final p = plan(input.copyWith(tasks: next), engine);
    // A step that does not bring the plan closer to fitting is not worth
    // its cuts.
    if (!p.fits && !better(shortfall(p), shortfall(reduced))) continue;
    tasks = next;
    cuts.addAll(stepCuts);
    reduced = p;
    if (p.fits) return TriageResult(plan: p, cuts: cuts);
  }

  int? extraFor(List<PlanTask> tasks) {
    bool fitsWith(int extra) =>
        plan(input.copyWith(tasks: tasks, extraMinutes: extra), engine).fits;
    if (!fitsWith(maxExtraMinutes)) return null;
    var lo = 0, hi = maxExtraMinutes;
    while (hi - lo > 1) {
      final mid = (lo + hi) ~/ 2;
      if (fitsWith(mid)) {
        hi = mid;
      } else {
        lo = mid;
      }
    }
    return hi;
  }

  return TriageResult(
    plan: reduced,
    cuts: cuts,
    needsStudent: true,
    extraForReduced: extraFor(tasks),
    extraForFull: extraFor(input.tasks),
  );
}

/// [t] after [step], or null when the step does not apply to it.
PlanTask? _cut(
  TriageStep step,
  PlanTask t, {
  required double skimShare,
  required void Function(TriageCut) onCut,
}) {
  if (t.keep || t.importance == PlanImportance.high) return null;
  final done = t.state.step;
  final reviews = t.reviews;
  PlanTask? out;
  switch (step) {
    case TriageStep.dropFinalLow:
      if (t.importance == PlanImportance.low && reviews > done) {
        out = t.copyWith(reviewLimit: max(done, reviews - 1));
      }
    case TriageStep.lowToYellow:
      // Yellow is one review above White.
      if (t.importance == PlanImportance.low && reviews > max(1, done)) {
        out = t.copyWith(reviewLimit: max(1, done));
      }
    case TriageStep.skimLowEasy:
      if (t.importance == PlanImportance.low &&
          t.difficulty == 1 &&
          !t.started) {
        out = t.copyWith(
          reviewLimit: 1,
          firstReadMinutes: t.firstReadMinutes * skimShare,
        );
      }
    case TriageStep.lowerMedium:
      if (t.importance == PlanImportance.medium && reviews > max(1, done)) {
        out = t.copyWith(reviewLimit: reviews - 1);
      }
  }
  if (out == null) return null;
  onCut(
    TriageCut(
      step: step,
      taskId: t.id,
      plannedBefore: t.reviews,
      plannedAfter: out.reviews,
    ),
  );
  return out;
}
