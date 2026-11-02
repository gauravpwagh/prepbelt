import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/core/config/review_config.dart';
import 'package:prepbelt/engines/planner/estimate.dart';
import 'package:prepbelt/engines/planner/planner.dart';
import 'package:prepbelt/engines/review/review_engine.dart';
import 'package:prepbelt/engines/review/review_types.dart';

final _engine = ReviewEngine(const ReviewConfig());
final _today = DateTime.utc(2026, 10, 28);
final _exam = DateTime.utc(2027, 1, 10);
const _week = [105, 105, 105, 105, 105, 105, 240];

int _day(DateTime d) => d.difference(_today).inDays;

PlanTask _task(
  String id, {
  PlanImportance importance = PlanImportance.medium,
  double read = 60,
  String source = '',
  int order = 0,
  String subject = '',
  ReviewState state = const ReviewState(),
}) {
  return PlanTask(
    id: id,
    state: state,
    importance: importance,
    firstReadMinutes: read,
    reviewMinutes: (step) => reviewMinutes(read, firstReview: step == 0),
    sourceKey: source,
    sourceOrder: order,
    subject: subject,
  );
}

/// A task read [daysAgo] days ago and reviewed [step] times since, due on
/// [due] (relative to today).
PlanTask _started(
  String id, {
  required int level,
  required int step,
  required int due,
  PlanImportance importance = PlanImportance.medium,
  int dim = 0,
}) => _task(
  id,
  importance: importance,
  read: 90,
  subject: 'Chemistry',
  state: ReviewState(
    level: level,
    step: step,
    dim: dim,
    reps: step + 1,
    lastReviewAt: _today.subtract(const Duration(days: 10)),
    dueAt: _today.add(Duration(days: due)),
  ),
);

void main() {
  // docs/04-planner-spec.md, "Worked example".
  test('worked example: Rotational motion reads over 3 days, then reviews '
      'at the default gaps and a final one before the exam, reaching Black '
      '(D53)', () {
    final rotational = _task(
      'rotational',
      importance: PlanImportance.high,
      read: firstReadMinutes(units: 32, unit: EffortUnit.page),
      subject: 'Physics',
    );
    final result = plan(
      PlannerInput(
        today: _today,
        examDay: _exam,
        weekdayMinutes: _week,
        tasks: [rotational],
      ),
      _engine,
    );
    final mine = [
      for (final e in result.entries)
        if (e.taskId == 'rotational') e,
    ];
    final reads = [
      for (final e in mine)
        if (e.kind == PlanKind.firstRead) (_day(e.day), e.minutes),
    ];
    expect(reads, [(0, 45), (1, 45), (2, 6)]);

    final reviews = [
      for (final e in mine)
        if (e.kind != PlanKind.firstRead) e,
    ];
    final days = [for (final r in reviews) _day(r.day)];
    expect(days.take(5), [3, 6, 13, 27, 57]);
    expect(days, hasLength(6));
    // High's final window: 1 to 3 days before the exam (day 74).
    expect(days.last, inInclusiveRange(71, 73));
    expect(reviews.last.kind, PlanKind.finalReview);
    expect(reviews.first.minutes, 30, reason: '35% of 96, capped');
    expect(result.projectedLevel['rotational'], 7, reason: 'Black');
    expect(result.fits, isTrue);
  });

  group('a full plan', () {
    late PlannerInput input;
    late PlanResult result;

    setUp(() {
      input = PlannerInput(
        today: _today,
        examDay: _exam,
        weekdayMinutes: _week,
        overrides: {DateTime.utc(2026, 11, 14): 0},
        tasks: [
          for (var i = 0; i < 9; i++)
            _task(
              'new$i',
              importance: PlanImportance.values[i % 3],
              read: 40 + i * 15,
              source: i < 5 ? 'hcv' : 'ncert',
              order: i,
              subject: i.isEven ? 'Physics' : 'Maths',
            ),
          for (var i = 0; i < 20; i++)
            _started(
              'old$i',
              level: 2 + i % 3,
              step: 1 + i % 3,
              due: i - 4,
              importance: PlanImportance.values[i % 3],
              dim: i % 5 == 0 ? 1 : 0,
            ),
        ],
        explores: const [
          PlanExplore(sourceId: 'hcv', minutes: 300, subject: 'Physics'),
        ],
      );
      result = plan(input, _engine);
    });

    test('first reads never take a day over its minutes by more than one '
        'overrun; reviews are planned whatever the minutes (D53)', () {
      final reviews = <DateTime, int>{};
      final reads = <DateTime, int>{};
      for (final e in result.entries) {
        final into = e.kind == PlanKind.review || e.kind == PlanKind.finalReview
            ? reviews
            : reads;
        into[e.day] = (into[e.day] ?? 0) + e.minutes;
      }
      for (final MapEntry(key: day, value: minutes) in reads.entries) {
        final cap = input.overrides[day] ?? _week[day.weekday - 1];
        expect(
          minutes + (reviews[day] ?? 0),
          lessThanOrEqualTo(cap + 10),
          reason: '$day',
        );
      }
      // Day 0 holds every overdue review, more than its minutes.
      final due = input.tasks.where(
        (t) => t.state.dueAt != null && !t.state.dueAt!.isAfter(_today),
      );
      expect(
        result
            .on(_today)
            .where(
              (e) => e.kind != PlanKind.firstRead && e.kind != PlanKind.explore,
            )
            .length,
        due.length,
      );
      expect(
        result.on(DateTime.utc(2026, 11, 14)),
        isEmpty,
        reason: 'a 0-minute break day',
      );
    });

    test('overdue reviews lead day 0; first reads come after reviews', () {
      final day0 = result.on(_today);
      expect(day0.first.kind, PlanKind.review);
      final firstRead = day0.indexWhere((e) => e.kind == PlanKind.firstRead);
      final lastReview = day0.lastIndexWhere(
        (e) => e.kind == PlanKind.review || e.kind == PlanKind.finalReview,
      );
      if (firstRead >= 0) expect(firstRead, greaterThan(lastReview));
      // The most overdue (due 4 days ago) comes first.
      expect(day0.first.taskId, 'old0');
    });

    test('the taper holds reviews only and the exam day is empty', () {
      for (final e in result.entries) {
        if (_exam.difference(e.day).inDays <= 2) {
          expect(e.kind, isNot(PlanKind.firstRead));
          expect(e.kind, isNot(PlanKind.explore));
        }
        expect(e.day.isBefore(_exam), isTrue);
      }
    });

    test('source order: a chapter is never read before an earlier one', () {
      DateTime firstDay(String id) =>
          result.entries.firstWhere((e) => e.taskId == id).day;
      for (var i = 1; i < 5; i++) {
        expect(
          firstDay('new$i').isBefore(firstDay('new${i - 1}')),
          isFalse,
          reason: 'new$i before new${i - 1}',
        );
      }
      final explore = result.entries.firstWhere(
        (e) => e.kind == PlanKind.explore,
      );
      final lastHcv = result.entries.lastWhere(
        (e) =>
            e.kind == PlanKind.firstRead &&
            ['new0', 'new1', 'new2', 'new3', 'new4'].contains(e.taskId),
      );
      expect(explore.day.isBefore(lastHcv.day), isFalse);
    });

    test('one reading session a day per task, at most 45 minutes', () {
      final seen = <(DateTime, String)>{};
      for (final e in result.entries) {
        if (e.kind != PlanKind.firstRead) continue;
        expect(seen.add((e.day, e.taskId!)), isTrue);
        expect(e.minutes, lessThanOrEqualTo(45));
      }
    });

    test('when it fits, every planned task gets a final review before '
        'the exam (docs/03, "Done means")', () {
      final roomy = PlannerInput(
        today: _today,
        examDay: _exam,
        weekdayMinutes: const [180, 180, 180, 180, 180, 180, 300],
        tasks: input.tasks,
      );
      final r = plan(roomy, _engine);
      expect(r.fits, isTrue);
      final planned = {
        for (final e in r.entries)
          if (e.taskId != null) e.taskId!,
      };
      final finals = {
        for (final e in r.entries)
          if (e.kind == PlanKind.finalReview) e.taskId!,
      };
      expect(planned.difference(finals), isEmpty);
      for (final e in r.entries) {
        if (e.kind == PlanKind.finalReview) {
          expect(e.day.isBefore(_exam), isTrue);
        }
      }
    });

    test('the same input gives the same plan', () {
      final again = plan(input, _engine);
      expect(
        again.entries.map((e) => e.toString()).toList(),
        result.entries.map((e) => e.toString()).toList(),
      );
    });
  });

  test('too little time flags High tasks that cannot finish their first '
      'read in time', () {
    final result = plan(
      PlannerInput(
        today: _today,
        examDay: DateTime.utc(2026, 11, 20),
        weekdayMinutes: List.filled(7, 20),
        tasks: [
          for (var i = 0; i < 6; i++)
            _task('h$i', importance: PlanImportance.high, read: 120),
        ],
      ),
      _engine,
    );
    expect(result.fits, isFalse);
    expect(result.late, isNotEmpty);
  });

  test('paused tasks are left out', () {
    final result = plan(
      PlannerInput(
        today: _today,
        examDay: _exam,
        weekdayMinutes: _week,
        tasks: [_task('p', state: ReviewState(pausedAt: _today))],
      ),
      _engine,
    );
    expect(result.entries, isEmpty);
  });
}
