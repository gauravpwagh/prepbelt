// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskDetailRepository)
final taskDetailRepositoryProvider = TaskDetailRepositoryProvider._();

final class TaskDetailRepositoryProvider
    extends
        $FunctionalProvider<
          TaskDetailRepository,
          TaskDetailRepository,
          TaskDetailRepository
        >
    with $Provider<TaskDetailRepository> {
  TaskDetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskDetailRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskDetailRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskDetailRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TaskDetailRepository create(Ref ref) {
    return taskDetailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskDetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskDetailRepository>(value),
    );
  }
}

String _$taskDetailRepositoryHash() =>
    r'05e87cefd9a07e9224a61016202e3f6c9941dd92';

/// Null when the task was removed.

@ProviderFor(taskDetailView)
final taskDetailViewProvider = TaskDetailViewFamily._();

/// Null when the task was removed.

final class TaskDetailViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<TaskDetailView?>,
          TaskDetailView?,
          Stream<TaskDetailView?>
        >
    with $FutureModifier<TaskDetailView?>, $StreamProvider<TaskDetailView?> {
  /// Null when the task was removed.
  TaskDetailViewProvider._({
    required TaskDetailViewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskDetailViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskDetailViewHash();

  @override
  String toString() {
    return r'taskDetailViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<TaskDetailView?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<TaskDetailView?> create(Ref ref) {
    final argument = this.argument as String;
    return taskDetailView(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskDetailViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskDetailViewHash() => r'582b8e94efc8ce129e29e03eeab16b1a406c313e';

/// Null when the task was removed.

final class TaskDetailViewFamily extends $Family
    with $FunctionalFamilyOverride<Stream<TaskDetailView?>, String> {
  TaskDetailViewFamily._()
    : super(
        retry: null,
        name: r'taskDetailViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Null when the task was removed.

  TaskDetailViewProvider call(String taskId) =>
      TaskDetailViewProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskDetailViewProvider';
}
