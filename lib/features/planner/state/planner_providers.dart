import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../engines/planner/triage.dart';
import '../../session/state/session_providers.dart';
import '../../sources/state/reading_providers.dart';
import '../../tasks/state/task_providers.dart';
import '../data/planner_repository.dart';

export '../../../engines/planner/planner.dart' show PlanResult, dayKey;
export '../../../engines/planner/triage.dart'
    show TriageCut, TriageResult, TriageStep;

part 'planner_providers.g.dart';

@Riverpod(keepAlive: true)
PlannerRepository plannerRepository(Ref ref) => PlannerRepository(
  ref.watch(writeContextProvider),
  sessions: ref.watch(sessionRepositoryProvider),
  reviews: ref.watch(reviewRepositoryProvider),
  reading: ref.watch(readingRepositoryProvider),
);

/// Keeps the plan current: replans [Defaults.plannerDebounceMs] after any
/// planner input changes (a review, a survey answer, a task, the exam,
/// availability), and on [replanNow] (app resume, a new day). State is the
/// latest result, null without an upcoming exam.
@Riverpod(keepAlive: true)
class Planner extends _$Planner {
  Timer? _debounce;
  bool _running = false;
  bool _again = false;

  @override
  Future<TriageResult?> build() async {
    final repo = ref.watch(plannerRepositoryProvider);
    final sub = repo.watchInputs().skip(1).listen((_) => _schedule());
    ref.onDispose(() {
      _debounce?.cancel();
      unawaited(sub.cancel());
    });
    return repo.replan();
  }

  void _schedule() {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: Defaults.plannerDebounceMs),
      () => unawaited(replanNow()),
    );
  }

  /// Replans now. Runs one at a time; a request during a run runs once
  /// more after it.
  Future<void> replanNow() async {
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    try {
      do {
        _again = false;
        final result = await AsyncValue.guard(
          () => ref.read(plannerRepositoryProvider).replan(),
        );
        state = result;
      } while (_again);
    } finally {
      _running = false;
    }
  }
}

/// The plan items of [day] in order.
@riverpod
Stream<List<PlanItem>> planDay(Ref ref, DateTime day) =>
    ref.watch(plannerRepositoryProvider).watchDay(day);
