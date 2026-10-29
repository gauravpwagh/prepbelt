import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/core_providers.dart';
import '../../session/state/session_providers.dart';
import '../data/review_repository.dart';
import '../data/task_detail_repository.dart';
import 'task_providers.dart';

export '../../../core/db/app_database.dart' show Review;
export '../data/task_detail_repository.dart' show TaskDetail;

part 'task_detail_providers.g.dart';

@Riverpod(keepAlive: true)
TaskDetailRepository taskDetailRepository(Ref ref) => TaskDetailRepository(
  ref.watch(appDatabaseProvider),
  sessions: ref.watch(sessionRepositoryProvider),
  reviews: ref.watch(reviewRepositoryProvider),
);

/// Task detail as the screen shows it.
final class TaskDetailView {
  const TaskDetailView({
    required this.detail,
    required this.display,
    required this.firstReadMinutes,
    required this.now,
  });

  final TaskDetail detail;

  /// The badge as it looks now.
  final LevelDisplay display;

  /// Estimate for "Not started · first read about 45 min".
  final int firstReadMinutes;

  /// When this view was built (UTC).
  final DateTime now;

  SessionTask get info => detail.info;

  /// Scheduled reviews done: passed steps, at most [TaskDetail.planned].
  int get stepsDone => info.state.step.clamp(0, detail.planned);

  /// The belt target for the upcoming exam, if any.
  int? get target => detail.examLink?.targetLevel;
}

/// Null when the task was removed.
@riverpod
Stream<TaskDetailView?> taskDetailView(Ref ref, String taskId) {
  final clock = ref.watch(clockProvider);
  final repo = ref.watch(taskDetailRepositoryProvider);
  final sessions = ref.watch(sessionRepositoryProvider);
  final reviews = ref.watch(reviewRepositoryProvider);
  return repo.watch(taskId).asyncMap((detail) async {
    if (detail == null) return null;
    final engine = await reviews.loadEngine();
    final now = clock.now();
    return TaskDetailView(
      detail: detail,
      display: engine.display(
        ReviewRepository.toReviewState(detail.info.state),
        now,
      ),
      firstReadMinutes: (await sessions.firstReadEstimate(detail.info)).round(),
      now: now,
    );
  });
}
