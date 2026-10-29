import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/time/clock.dart';
import '../../../engines/game/streak.dart';
import '../../exams/state/exam_providers.dart';
import '../../session/state/session_providers.dart';
import '../../tasks/data/review_repository.dart';
import '../../tasks/state/task_providers.dart';
import '../data/today_repository.dart';

export '../data/today_repository.dart' show TodayItem, TodayKind;

part 'today_providers.g.dart';

@Riverpod(keepAlive: true)
TodayRepository todayRepository(Ref ref) => TodayRepository(
  ref.watch(appDatabaseProvider),
  sessions: ref.watch(sessionRepositoryProvider),
);

/// A Today card: the item and its badge as it looks now.
typedef TodayCard = ({TodayItem item, LevelDisplay display});

/// Everything the Today screen shows.
final class TodayView {
  const TodayView({
    required this.today,
    required this.cards,
    required this.streak,
    required this.hasTasks,
    this.exam,
  });

  /// The local calendar day.
  final DateTime today;
  final List<TodayCard> cards;
  final int streak;

  /// False before any task exists: Today then points to adding a source.
  final bool hasTasks;
  final Exam? exam;

  int get totalMinutes => cards.fold(0, (sum, c) => sum + c.item.minutes);

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

@riverpod
Stream<List<TodayItem>> todayItems(Ref ref) {
  final now = ref.watch(clockProvider).now().toLocal();
  final start = DateTime(now.year, now.month, now.day);
  final end = DateTime(now.year, now.month, now.day + 1);
  return ref
      .watch(todayRepositoryProvider)
      .watch(
        dayStart: start.toUtc().millisecondsSinceEpoch,
        dayEnd: end.toUtc().millisecondsSinceEpoch,
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
  final items = await ref.watch(todayItemsProvider.future);
  final streak = await ref.watch(streakProvider.future);
  final exam = await ref.watch(currentExamProvider.future);
  final tasks = await ref.watch(tasksProvider.future);
  final engine = await ref.read(reviewRepositoryProvider).loadEngine();
  final now = clock.now();
  return TodayView(
    today: now.toLocal(),
    streak: streak,
    exam: exam,
    hasTasks: tasks.isNotEmpty,
    cards: [
      for (final i in items)
        (
          item: i,
          display: engine.display(
            ReviewRepository.toReviewState(i.info.state),
            now,
          ),
        ),
    ],
  );
}
