import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../engines/review/review_types.dart';
import '../../../engines/review/xp.dart';
import '../../settings/state/settings_providers.dart';
import '../../sources/state/reading_providers.dart';
import '../../tasks/data/review_repository.dart';
import '../../tasks/state/task_providers.dart';
import '../data/session_repository.dart';

export '../../../engines/review/review_types.dart'
    show LevelDisplay, Rating, ReviewOutcome;
export '../data/session_repository.dart' show SessionTask, TaskPart;

part 'session_providers.g.dart';

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) => SessionRepository(
  ref.watch(writeContextProvider),
  reviews: ref.watch(reviewRepositoryProvider),
);

@riverpod
Stream<ActiveSession?> activeSession(Ref ref) =>
    ref.watch(sessionRepositoryProvider).watchActive();

/// Everything "Back from source" shows for one task.
final class SessionView {
  const SessionView({
    required this.info,
    required this.display,
    required this.outcomes,
    required this.maxMinutes,
    this.session,
  });

  final SessionTask info;

  /// The badge as it looks now, before rating.
  final LevelDisplay display;

  /// What each rating would do (dry run of the review engine).
  final Map<Rating, ReviewOutcome> outcomes;

  /// The open session on this task; null once it was finished or left.
  final ActiveSession? session;

  /// Longest time a session logs.
  final int maxMinutes;

  /// Minutes the session has been open at [nowMs].
  int minutesAt(int nowMs) => session == null
      ? 0
      : SessionRepository.minutesSince(
          session!.startedAt,
          nowMs,
          maxMinutes: maxMinutes,
        );

  bool promotes(Rating r) => outcomes[r]!.levelAfter > outcomes[r]!.levelBefore;

  int xpFor(Rating r) => xpForReview(
    r,
    promoted: promotes(r),
    perWeight: Defaults.xpPerRatingWeight,
    ratingWeights: Defaults.xpRatingWeights,
    promotionBonus: Defaults.xpPromotionBonus,
  );
}

@riverpod
Future<SessionView> sessionView(Ref ref, String taskId) async {
  final repo = ref.watch(sessionRepositoryProvider);
  final session = await ref.watch(activeSessionProvider.future);
  final info = await repo.load(taskId);
  final engine = await ref.read(reviewRepositoryProvider).loadEngine();
  final config = ReadingConfig.fromSettings(
    await ref.read(settingsRepositoryProvider).getAll(),
  );
  return SessionView(
    info: info,
    display: engine.display(
      ReviewRepository.toReviewState(info.state),
      ref.read(clockProvider).now(),
    ),
    outcomes: await repo.preview(taskId),
    session: session?.taskId == taskId ? session : null,
    maxMinutes: config.maxAwayMinutes,
  );
}

/// Starting, finishing and leaving a session. Kept alive: these run past
/// the screen that called them.
@Riverpod(keepAlive: true)
class SessionActions extends _$SessionActions {
  @override
  void build() {}

  SessionRepository get _repo => ref.read(sessionRepositoryProvider);

  /// Opens the session, then the source in its own app. The session is
  /// saved first, so it survives the OS closing PrepBelt.
  Future<StartResult> start(String taskId) async {
    await _repo.start(taskId);
    return openAgain(taskId);
  }

  /// Opens the task's source again from the session screen.
  Future<StartResult> openAgain(String taskId) async {
    final source = (await _repo.load(taskId)).source;
    if (source == null) return StartResult.notOpened;
    return await openSource(ref, source.id)
        ? StartResult.opened
        : StartResult.notOpened;
  }

  Future<Review> finish({
    required Rating rating,
    required int minutes,
    int? stopUnit,
  }) => _repo.finish(rating: rating, minutes: minutes, stopUnit: stopUnit);

  Future<void> discard() => _repo.discard();
}
