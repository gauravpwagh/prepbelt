import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../../engines/game/streak.dart';
import '../../exams/state/exam_providers.dart';
import '../../exams/state/exam_view_providers.dart';
import '../../planner/data/planner_repository.dart' show dateText;
import '../../planner/state/planner_providers.dart';
import '../../session/state/session_providers.dart';
import '../../sources/state/reading_providers.dart';
import '../../tasks/data/review_repository.dart';
import '../../tasks/state/task_providers.dart';
import '../data/today_repository.dart';

export '../data/today_repository.dart' show TodayBoxes, TodayItem, TodayKind;

part 'today_providers.g.dart';

@Riverpod(keepAlive: true)
TodayRepository todayRepository(Ref ref) => TodayRepository(
  ref.watch(appDatabaseProvider),
  sessions: ref.watch(sessionRepositoryProvider),
  reading: ref.watch(readingRepositoryProvider),
);

const _notStarted = LevelDisplay(
  level: 0,
  dim: 0,
  stripes: 0,
  fading: false,
  overdue: false,
);

/// A Today card: the item and its badge as it looks now.
typedef TodayCard = ({TodayItem item, LevelDisplay display});

/// Everything the Today screen shows.
final class TodayView {
  const TodayView({
    required this.today,
    required this.streak,
    required this.hasTasks,
    this.due = const [],
    this.fresh = const [],
    this.ahead = const [],
    this.plannedMinutes = 0,
    this.plannedFirstReads = 0,
    this.hasPlan = false,
    this.exam,
    this.metrics,
  });

  /// The local calendar day.
  final DateTime today;

  /// The three boxes (D50): reviews due, not started, reviews ahead.
  final List<TodayCard> due;
  final List<TodayCard> fresh;
  final List<TodayCard> ahead;

  /// Today's plan, for the summary line.
  final int plannedMinutes;
  final int plannedFirstReads;
  final bool hasPlan;
  final int streak;

  /// False before any task exists: Today then points to adding a source.
  final bool hasTasks;
  final Exam? exam;

  /// The exam belt, readiness and projection, with an exam.
  final ExamMetrics? metrics;

  /// Days from today to the exam, or null without one.
  int? get daysToGo {
    final e = exam;
    if (e == null) return null;
    final date = DateTime.parse(e.date);
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
  }
}

/// Today's three boxes (D50).
@riverpod
Stream<TodayBoxes> todayBoxes(Ref ref) {
  final now = ref.watch(clockProvider).now().toLocal();
  final start = DateTime(now.year, now.month, now.day);
  final end = DateTime(now.year, now.month, now.day + 1);
  // The stored plan shows at once; the planner keeps it current behind.
  ref.watch(plannerProvider);
  return ref
      .watch(todayRepositoryProvider)
      .watchBoxes(
        dayStart: start.toUtc().millisecondsSinceEpoch,
        dayEnd: end.toUtc().millisecondsSinceEpoch,
        today: dateText(start),
      );
}

@riverpod
Stream<int> streak(Ref ref) {
  final clock = ref.watch(clockProvider);
  return ref
      .watch(todayRepositoryProvider)
      .watchReviewTimes()
      .map(
        (times) => streakDays([
          for (final t in times) fromUtcMs(t).toLocal(),
        ], clock.now().toLocal()),
      );
}

@riverpod
Future<TodayView> todayView(Ref ref) async {
  final clock = ref.watch(clockProvider);
  final boxes = await ref.watch(todayBoxesProvider.future);
  final streak = await ref.watch(streakProvider.future);
  final exam = await ref.watch(currentExamProvider.future);
  final examView = exam == null
      ? null
      : await ref.watch(examViewProvider(null).future);
  final tasks = await ref.watch(tasksProvider.future);
  final engine = await ref.read(reviewRepositoryProvider).loadEngine();
  final now = clock.now();
  TodayCard card(TodayItem i) => (
    item: i,
    display: i.info == null
        ? _notStarted
        : engine.display(ReviewRepository.toReviewState(i.info!.state), now),
  );
  return TodayView(
    today: now.toLocal(),
    streak: streak,
    exam: exam,
    metrics: examView?.metrics,
    hasTasks: tasks.isNotEmpty || boxes.fresh.isNotEmpty,
    due: [for (final i in boxes.due) card(i)],
    fresh: [for (final i in boxes.fresh) card(i)],
    ahead: [for (final i in boxes.ahead) card(i)],
    plannedMinutes: boxes.plannedMinutes,
    plannedFirstReads: boxes.plannedFirstReads,
    hasPlan: boxes.hasPlan,
  );
}
