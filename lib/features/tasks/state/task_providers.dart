import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../data/task_repository.dart';

part 'task_providers.g.dart';

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) =>
    TaskRepository(ref.watch(writeContextProvider));

@riverpod
Stream<Task?> task(Ref ref, String id) =>
    ref.watch(taskRepositoryProvider).watch(id);

@riverpod
Stream<TaskState?> taskState(Ref ref, String taskId) =>
    ref.watch(taskRepositoryProvider).watchState(taskId);
