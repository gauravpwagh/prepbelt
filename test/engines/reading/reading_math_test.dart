import 'package:flutter_test/flutter_test.dart';
import 'package:prepbelt/engines/reading/reading_math.dart';

void main() {
  test('ranges merge, count and find the first gap', () {
    final u = unionOf(const [
      UnitRange(10, 20),
      UnitRange(1, 5),
      UnitRange(6, 8),
      UnitRange(15, 25),
    ]);
    expect(u, const [UnitRange(1, 8), UnitRange(10, 25)]);
    expect(coveredUnits(u, const UnitRange(1, 30)), 24);
    expect(firstUncovered(u, const UnitRange(1, 30)), 9);
    expect(
      firstUncovered(const [UnitRange(1, 30)], const UnitRange(1, 30)),
      isNull,
    );
    expect(firstUncovered(const [], const UnitRange(1, 30)), 1);
  });

  test('minutes are shared out by pages', () {
    const sittings = [
      Sitting(UnitRange(1, 20), 60),
      Sitting(UnitRange(21, 30), 20),
    ];
    expect(minutesOn(const UnitRange(11, 25), sittings), 30 + 10);
  });

  test('the guess stays within the source', () {
    expect(guessEndUnit(start: 41, minutes: 48, pace: 3, last: 480), 56);
    expect(guessEndUnit(start: 470, minutes: 90, pace: 3, last: 480), 480);
    expect(guessEndUnit(start: 41, minutes: 0, pace: 3, last: 480), 41);
  });

  test('pace stays default, then blends, then is personal', () {
    Sitting s(int minutes) => Sitting(const UnitRange(1, 10), minutes);
    expect(paceFrom([s(20), s(20)], defaultPace: 3), 3);
    expect(paceFrom([s(20), s(20), s(20)], defaultPace: 3), 2.5);
    expect(paceFrom(List.filled(10, s(20)), defaultPace: 3), 2);
  });

  group('planSave', () {
    const chapters = [
      ChapterState(range: UnitRange(1, 10)),
      ChapterState(range: UnitRange(11, 20)),
      ChapterState(range: UnitRange(21, 30), hasTask: true),
      ChapterState(range: UnitRange(31, 40)),
      ChapterState(range: UnitRange(41, 50)),
    ];

    test('whole chapters form runs; a task breaks a run', () {
      final plan = planSave(
        chapters: chapters,
        explored: const [],
        sitting: const UnitRange(1, 45),
      );
      expect(plan.newTasks, [
        [0, 1],
        [3],
      ]);
      expect(plan.firstReads, [2]);
      expect(plan.partial, [4]);
    });

    test('an earlier sitting completes a partly read chapter', () {
      final plan = planSave(
        chapters: chapters,
        explored: const [UnitRange(1, 15)],
        sitting: const UnitRange(16, 20),
      );
      expect(plan.newTasks, [
        [1],
      ]);
      expect(plan.partial, isEmpty);
    });

    test('read chapters are left alone', () {
      final plan = planSave(
        chapters: const [
          ChapterState(range: UnitRange(1, 10), hasTask: true, read: true),
        ],
        explored: const [UnitRange(1, 10)],
        sitting: const UnitRange(5, 10),
      );
      expect(plan.isEmpty, isTrue);
    });
  });
}
