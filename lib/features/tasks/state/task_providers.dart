import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/review_config.dart';
import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../settings/state/settings_providers.dart';
import '../data/review_repository.dart';
import '../data/task_repository.dart';

part 'task_providers.g.dart';

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) =>
    TaskRepository(ref.watch(writeContextProvider));

@Riverpod(keepAlive: true)
ReviewRepository reviewRepository(Ref ref) => ReviewRepository(
  ref.watch(writeContextProvider),
  // Reads settings directly: a provider nobody listens to is paused in
  // Riverpod 3, so awaiting reviewConfigProvider here could never finish.
  config: () async => ReviewConfig.fromSettings(
    await ref.read(settingsRepositoryProvider).getAll(),
  ),
);

@riverpod
Stream<Task?> task(Ref ref, String id) =>
    ref.watch(taskRepositoryProvider).watch(id);

@riverpod
Stream<TaskState?> taskState(Ref ref, String taskId) =>
    ref.watch(taskRepositoryProvider).watchState(taskId);

/// The rebuild command, as an action for the debug menu. State is the
/// number of tasks checked by the last run. Kept alive so a run started
/// from a button finishes even if nothing is listening.
@Riverpod(keepAlive: true)
class MasteryRebuild extends _$MasteryRebuild {
  @override
  FutureOr<int?> build() => null;

  Future<int> run() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(reviewRepositoryProvider).rebuildAll(),
    );
    state = result;
    return result.requireValue;
  }
}
