import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../planner/state/planner_providers.dart';
import '../../session/state/session_providers.dart';
import '../../sources/data/task_writer.dart';
import '../../tasks/state/task_detail_providers.dart';
import '../../tasks/state/task_providers.dart';
import '../data/redefine_repository.dart';

export '../../../core/db/app_database.dart' show Importance;

part 'redefine_providers.g.dart';

@Riverpod(keepAlive: true)
RedefineRepository redefineRepository(Ref ref) => RedefineRepository(
  ref.watch(writeContextProvider),
  sessions: ref.watch(sessionRepositoryProvider),
);

/// What the Redefine sheet needs about one task.
final class RedefineView {
  const RedefineView({
    required this.info,
    required this.display,
    required this.planned,
    this.examId,
    this.examName,
    this.importance,
  });

  final SessionTask info;
  final LevelDisplay display;

  /// Reviews planned for its current target.
  final int planned;
  final String? examId;
  final String? examName;
  final Importance? importance;

  bool get paused => info.paused;

  /// Scope and split need one contiguous range in one source.
  bool get canScope => info.parts.length == 1 && info.range != null;
  bool get canSplit =>
      info.range != null && info.range!.end > info.range!.start;
}

@riverpod
Future<RedefineView> redefineView(Ref ref, String taskId) async {
  final detail = await ref.watch(taskDetailViewProvider(taskId).future);
  if (detail == null) throw StateError('task $taskId was removed');
  return RedefineView(
    info: detail.info,
    display: detail.display,
    planned: detail.detail.planned,
    examId: detail.detail.exam?.id,
    examName: detail.detail.exam?.name,
    importance: detail.detail.examLink?.importance,
  );
}

/// The latest change to [taskId] that "Undo last change" can reverse
/// (an action name), or null. Re-read whenever the task changes.
@riverpod
Future<String?> taskUndoable(Ref ref, String taskId) async {
  await ref.watch(taskDetailViewProvider(taskId).future);
  return (await ref.read(redefineRepositoryProvider).undoable(taskId))?.action;
}

/// The redefinitions, each followed by a replan. Kept alive: they run
/// past the sheet that started them.
@Riverpod(keepAlive: true)
class RedefineActions extends _$RedefineActions {
  @override
  void build() {}

  RedefineRepository get _repo => ref.read(redefineRepositoryProvider);

  Future<T> _then<T>(Future<T> Function() op) async {
    final out = await op();
    await ref.read(plannerProvider.notifier).replanNow();
    return out;
  }

  Future<void> rename(String taskId, String title) =>
      _then(() => _repo.rename(taskId, title.trim()));

  Future<void> setImportance(
    String examId,
    String taskId,
    Importance importance,
  ) => _then(
    () => _repo.setImportance(
      examId,
      taskId,
      importance,
      targetLevel: TaskWriter.targetLevelFor(importance),
    ),
  );

  Future<List<String>> setScope(
    String taskId, {
    required int start,
    required int end,
    required bool splitAdded,
  }) => _then(
    () =>
        _repo.setScope(taskId, start: start, end: end, splitAdded: splitAdded),
  );

  Future<(String, String)> split(
    String taskId, {
    required int after,
    required String titleA,
    required String titleB,
  }) => _then(
    () => _repo.split(
      taskId,
      after: after,
      titleA: titleA.trim(),
      titleB: titleB.trim(),
    ),
  );

  Future<void> pause(String taskId) =>
      _then(() => ref.read(reviewRepositoryProvider).pause(taskId));

  Future<void> resume(String taskId) =>
      _then(() => ref.read(reviewRepositoryProvider).resume(taskId));

  /// The latest change that can be undone, for "Undo last change".
  Future<String?> undoable(String taskId) async =>
      (await _repo.undoable(taskId))?.action;

  Future<void> undo(String taskId) => _then(() => _repo.undo(taskId));

  /// Planned reviews for [importance], for Edit's impact line.
  Future<int> plannedFor(Importance importance) async {
    final engine = await ref.read(reviewRepositoryProvider).loadEngine();
    return engine.plannedReviewsFor(TaskWriter.targetLevelFor(importance));
  }
}
