import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/engines/planner/estimate.dart';
import 'package:prepbelt/engines/planner/planner.dart';
import 'package:prepbelt/engines/planner/triage.dart';
import 'package:prepbelt/engines/review/review_engine.dart';
import 'package:prepbelt/engines/review/review_types.dart';

final _engine = ReviewEngine(const ReviewConfig());
final _today = DateTime.utc(2026, 10, 28);
final _exam = DateTime.utc(2027, 1, 10);

PlanTask _task(
  String id,
  PlanImportance importance, {
  double read = 60,
  int difficulty = 2,
  bool keep = false,
}) => PlanTask(
  id: id,
  state: const ReviewState(),
  importance: importance,
  planned: switch (importance) {
    PlanImportance.high => 5,
    PlanImportance.medium => 4,
    PlanImportance.low => 3,
  },
  firstReadMinutes: read,
  reviewMinutes: (step) => reviewMinutes(read, firstReview: step == 0),
  difficulty: difficulty,
  keep: keep,
);

/// The spec's mix: 12 High, 16 Medium, 10 Low (4 of them Easy).
List<PlanTask> _syllabus({Set<String> keep = const {}}) => [
  for (var i = 0; i < 12; i++)
    _task('h$i', PlanImportance.high, read: 120, keep: keep.contains('h$i')),
  for (var i = 0; i < 16; i++)
    _task('m$i', PlanImportance.medium, read: 90, keep: keep.contains('m$i')),
  for (var i = 0; i < 10; i++)
    _task(
      'l$i',
      PlanImportance.low,
      difficulty: i < 4 ? 1 : 2,
      keep: keep.contains('l$i'),
    ),
];

PlannerInput _input(int minutes, {Set<String> keep = const {}}) => PlannerInput(
  today: _today,
  examDay: _exam,
  weekdayMinutes: List.filled(7, minutes),
  tasks: _syllabus(keep: keep),
);

void main() {
  test('enough time: no cuts', () {
    final r = triage(_input(240), _engine);
    expect(r.fits, isTrue);
    expect(r.cuts, isEmpty);
    expect(r.needsStudent, isFalse);
  });

  test('a little short: cuts make it fit, in step order, never High', () {
    final full = plan(_input(90), _engine);
    expect(full.fits, isFalse);
    final r = triage(_input(90), _engine);
    expect(r.fits, isTrue);
    expect(r.needsStudent, isFalse);
    final steps = [for (final c in r.cuts) c.step];
    for (var i = 1; i < steps.length; i++) {
      expect(steps[i].index, greaterThanOrEqualTo(steps[i - 1].index));
    }
    expect(r.cuts.where((c) => c.taskId.startsWith('h')), isEmpty);
    // Step 1 dropped one review of every Low task.
    final first = r.cuts.where((c) => c.step == TriageStep.dropFinalLow);
    expect(first.map((c) => c.taskId).toSet(), {
      for (var i = 0; i < 10; i++) 'l$i',
    });
    expect(first.every((c) => c.plannedAfter == c.plannedBefore - 1), isTrue);
  });

  test('a step that does not help is not taken', () {
    // At 100 minutes only the last days are short; Low cuts do not free
    // them, so only Medium targets drop.
    final r = triage(_input(100), _engine);
    expect(r.fits, isTrue);
    expect({for (final c in r.cuts) c.step}, {TriageStep.lowerMedium});
  });

  test('30 minutes a day: the cuts are not enough, so the student is '
      'asked, with the extra minutes for the reduced and the full plan', () {
    final r = triage(_input(30), _engine);
    expect(r.needsStudent, isTrue);
    expect(r.cuts, isNotEmpty);
    expect(r.cuts.where((c) => c.taskId.startsWith('h')), isEmpty);
    expect(r.extraForReduced, isNotNull);
    expect(r.extraForFull, greaterThanOrEqualTo(r.extraForReduced!));
    // The suggested extra for everything really is enough.
    expect(triage(_input(30 + r.extraForFull!), _engine).cuts, isEmpty);
  });

  test('a kept task is never cut', () {
    final r = triage(_input(30, keep: {'l0', 'm0'}), _engine);
    expect(r.cuts.where((c) => c.taskId == 'l0' || c.taskId == 'm0'), isEmpty);
  });
}
