// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redefine_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(redefineRepository)
final redefineRepositoryProvider = RedefineRepositoryProvider._();

final class RedefineRepositoryProvider
    extends
        $FunctionalProvider<
          RedefineRepository,
          RedefineRepository,
          RedefineRepository
        >
    with $Provider<RedefineRepository> {
  RedefineRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'redefineRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$redefineRepositoryHash();

  @$internal
  @override
  $ProviderElement<RedefineRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RedefineRepository create(Ref ref) {
    return redefineRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RedefineRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RedefineRepository>(value),
    );
  }
}

String _$redefineRepositoryHash() =>
    r'4b39075772dd6d5d70dc1a7447f2b7fb9582bbf6';

@ProviderFor(redefineView)
final redefineViewProvider = RedefineViewFamily._();

final class RedefineViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<RedefineView>,
          RedefineView,
          FutureOr<RedefineView>
        >
    with $FutureModifier<RedefineView>, $FutureProvider<RedefineView> {
  RedefineViewProvider._({
    required RedefineViewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'redefineViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$redefineViewHash();

  @override
  String toString() {
    return r'redefineViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RedefineView> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RedefineView> create(Ref ref) {
    final argument = this.argument as String;
    return redefineView(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RedefineViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$redefineViewHash() => r'733a5e97c829d61762735defd744b913e2027c1a';

final class RedefineViewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RedefineView>, String> {
  RedefineViewFamily._()
    : super(
        retry: null,
        name: r'redefineViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RedefineViewProvider call(String taskId) =>
      RedefineViewProvider._(argument: taskId, from: this);

  @override
  String toString() => r'redefineViewProvider';
}

/// The latest change to [taskId] that "Undo last change" can reverse
/// (an action name), or null. Re-read whenever the task changes.

@ProviderFor(taskUndoable)
final taskUndoableProvider = TaskUndoableFamily._();

/// The latest change to [taskId] that "Undo last change" can reverse
/// (an action name), or null. Re-read whenever the task changes.

final class TaskUndoableProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The latest change to [taskId] that "Undo last change" can reverse
  /// (an action name), or null. Re-read whenever the task changes.
  TaskUndoableProvider._({
    required TaskUndoableFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskUndoableProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskUndoableHash();

  @override
  String toString() {
    return r'taskUndoableProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return taskUndoable(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskUndoableProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskUndoableHash() => r'3070120d6c7f46f780e39569bceea044dcda9e78';

/// The latest change to [taskId] that "Undo last change" can reverse
/// (an action name), or null. Re-read whenever the task changes.

final class TaskUndoableFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  TaskUndoableFamily._()
    : super(
        retry: null,
        name: r'taskUndoableProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The latest change to [taskId] that "Undo last change" can reverse
  /// (an action name), or null. Re-read whenever the task changes.

  TaskUndoableProvider call(String taskId) =>
      TaskUndoableProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskUndoableProvider';
}

/// The redefinitions, each followed by a replan. Kept alive: they run
/// past the sheet that started them.

@ProviderFor(RedefineActions)
final redefineActionsProvider = RedefineActionsProvider._();

/// The redefinitions, each followed by a replan. Kept alive: they run
/// past the sheet that started them.
final class RedefineActionsProvider
    extends $NotifierProvider<RedefineActions, void> {
  /// The redefinitions, each followed by a replan. Kept alive: they run
  /// past the sheet that started them.
  RedefineActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'redefineActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$redefineActionsHash();

  @$internal
  @override
  RedefineActions create() => RedefineActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$redefineActionsHash() => r'7dea20341a6c39ae5c6bb5cd351e3a7828f1b9e1';

/// The redefinitions, each followed by a replan. Kept alive: they run
/// past the sheet that started them.

abstract class _$RedefineActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
