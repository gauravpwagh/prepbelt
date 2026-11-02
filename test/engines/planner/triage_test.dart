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

PlanTask _task(String id, PlanImportance importance, {double read = 60}) =>
    PlanTask(
      id: id,
      state: const ReviewState(),
      importance: importance,
      firstReadMinutes: read,
      reviewMinutes: (step) => reviewMinutes(read, firstReview: step == 0),
    );

/// The spec's mix: 12 High, 16 Medium, 10 Low.
List<PlanTask> _syllabus() => [
  for (var i = 0; i < 12; i++) _task('h$i', PlanImportance.high, read: 120),
  for (var i = 0; i < 16; i++) _task('m$i', PlanImportance.medium, read: 90),
  for (var i = 0; i < 10; i++) _task('l$i', PlanImportance.low),
];

PlannerInput _input(int minutes) => PlannerInput(
  today: _today,
  examDay: _exam,
  weekdayMinutes: List.filled(7, minutes),
  tasks: _syllabus(),
);

void main() {
  test('enough time: nothing to ask', () {
    final r = triage(_input(240), _engine);
    expect(r.fits, isTrue);
    expect(r.needsStudent, isFalse);
  });

  test('30 minutes a day: the student is asked, with the extra minutes '
      'that fit every first read, and every review stays planned (D53)', () {
    final r = triage(_input(30), _engine);
    expect(r.needsStudent, isTrue);
    expect(r.extraForFull, isNotNull);
    expect(triage(_input(30 + r.extraForFull!), _engine).fits, isTrue);
    final reviewed = {
      for (final e in r.plan.entries)
        if (e.kind != PlanKind.firstRead) e.taskId,
    };
    final read = {
      for (final e in r.plan.entries)
        if (e.kind == PlanKind.firstRead) e.taskId,
    };
    // Every task whose first read finishes gets its reviews.
    expect(reviewed, isNotEmpty);
    expect(reviewed.difference(read), isEmpty);
  });
}
