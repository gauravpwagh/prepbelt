// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'36b460136828fa342c8dbaf20a9134bebf3e7784';

@ProviderFor(reviewRepository)
final reviewRepositoryProvider = ReviewRepositoryProvider._();

final class ReviewRepositoryProvider
    extends
        $FunctionalProvider<
          ReviewRepository,
          ReviewRepository,
          ReviewRepository
        >
    with $Provider<ReviewRepository> {
  ReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReviewRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReviewRepository create(Ref ref) {
    return reviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewRepository>(value),
    );
  }
}

String _$reviewRepositoryHash() => r'be2ca335c6de1e1fd7a532919d9480a9ff35694f';

@ProviderFor(tasks)
final tasksProvider = TasksProvider._();

final class TasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  TasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return tasks(ref);
  }
}

String _$tasksHash() => r'3c3aa0652f5472483100266354826932ace5e082';

@ProviderFor(task)
final taskProvider = TaskFamily._();

final class TaskProvider
    extends $FunctionalProvider<AsyncValue<Task?>, Task?, Stream<Task?>>
    with $FutureModifier<Task?>, $StreamProvider<Task?> {
  TaskProvider._({
    required TaskFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskHash();

  @override
  String toString() {
    return r'taskProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Task?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Task?> create(Ref ref) {
    final argument = this.argument as String;
    return task(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskHash() => r'38c285bae04dbe53f57995c0291d238e292e5ea3';

final class TaskFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Task?>, String> {
  TaskFamily._()
    : super(
        retry: null,
        name: r'taskProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskProvider call(String id) => TaskProvider._(argument: id, from: this);

  @override
  String toString() => r'taskProvider';
}

@ProviderFor(taskState)
final taskStateProvider = TaskStateFamily._();

final class TaskStateProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskState?>,
          TaskState?,
          Stream<TaskState?>
        >
    with $FutureModifier<TaskState?>, $StreamProvider<TaskState?> {
  TaskStateProvider._({
    required TaskStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskStateHash();

  @override
  String toString() {
    return r'taskStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<TaskState?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<TaskState?> create(Ref ref) {
    final argument = this.argument as String;
    return taskState(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskStateHash() => r'ded16335eefcc823980b475be663fbd913a91f65';

final class TaskStateFamily extends $Family
    with $FunctionalFamilyOverride<Stream<TaskState?>, String> {
  TaskStateFamily._()
    : super(
        retry: null,
        name: r'taskStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskStateProvider call(String taskId) =>
      TaskStateProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskStateProvider';
}

/// The rebuild command, as an action for the debug menu. State is the
/// number of tasks checked by the last run. Kept alive so a run started
/// from a button finishes even if nothing is listening.

@ProviderFor(MasteryRebuild)
final masteryRebuildProvider = MasteryRebuildProvider._();

/// The rebuild command, as an action for the debug menu. State is the
/// number of tasks checked by the last run. Kept alive so a run started
/// from a button finishes even if nothing is listening.
final class MasteryRebuildProvider
    extends $AsyncNotifierProvider<MasteryRebuild, int?> {
  /// The rebuild command, as an action for the debug menu. State is the
  /// number of tasks checked by the last run. Kept alive so a run started
  /// from a button finishes even if nothing is listening.
  MasteryRebuildProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masteryRebuildProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masteryRebuildHash();

  @$internal
  @override
  MasteryRebuild create() => MasteryRebuild();
}

String _$masteryRebuildHash() => r'6664010370e8bf1aa40572d2abde7b9fc6963dd8';

/// The rebuild command, as an action for the debug menu. State is the
/// number of tasks checked by the last run. Kept alive so a run started
/// from a button finishes even if nothing is listening.

abstract class _$MasteryRebuild extends $AsyncNotifier<int?> {
  FutureOr<int?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int?>, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int?>, int?>,
              AsyncValue<int?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
