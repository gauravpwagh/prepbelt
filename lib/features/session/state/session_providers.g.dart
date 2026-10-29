// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionRepository)
final sessionRepositoryProvider = SessionRepositoryProvider._();

final class SessionRepositoryProvider
    extends
        $FunctionalProvider<
          SessionRepository,
          SessionRepository,
          SessionRepository
        >
    with $Provider<SessionRepository> {
  SessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<SessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionRepository create(Ref ref) {
    return sessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionRepository>(value),
    );
  }
}

String _$sessionRepositoryHash() => r'585cb9fbf69216ed0f49b23a4d0e325be9761337';

@ProviderFor(activeSession)
final activeSessionProvider = ActiveSessionProvider._();

final class ActiveSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActiveSession?>,
          ActiveSession?,
          Stream<ActiveSession?>
        >
    with $FutureModifier<ActiveSession?>, $StreamProvider<ActiveSession?> {
  ActiveSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSessionHash();

  @$internal
  @override
  $StreamProviderElement<ActiveSession?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ActiveSession?> create(Ref ref) {
    return activeSession(ref);
  }
}

String _$activeSessionHash() => r'942a410188c993259f79b6e679d9ee13ff367486';

@ProviderFor(sessionView)
final sessionViewProvider = SessionViewFamily._();

final class SessionViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<SessionView>,
          SessionView,
          FutureOr<SessionView>
        >
    with $FutureModifier<SessionView>, $FutureProvider<SessionView> {
  SessionViewProvider._({
    required SessionViewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionViewHash();

  @override
  String toString() {
    return r'sessionViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SessionView> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SessionView> create(Ref ref) {
    final argument = this.argument as String;
    return sessionView(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionViewHash() => r'43f5c916c0db158f2861652084ae0c06aab43945';

final class SessionViewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SessionView>, String> {
  SessionViewFamily._()
    : super(
        retry: null,
        name: r'sessionViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionViewProvider call(String taskId) =>
      SessionViewProvider._(argument: taskId, from: this);

  @override
  String toString() => r'sessionViewProvider';
}

/// Starting, finishing and leaving a session. Kept alive: these run past
/// the screen that called them.

@ProviderFor(SessionActions)
final sessionActionsProvider = SessionActionsProvider._();

/// Starting, finishing and leaving a session. Kept alive: these run past
/// the screen that called them.
final class SessionActionsProvider
    extends $NotifierProvider<SessionActions, void> {
  /// Starting, finishing and leaving a session. Kept alive: these run past
  /// the screen that called them.
  SessionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionActionsHash();

  @$internal
  @override
  SessionActions create() => SessionActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$sessionActionsHash() => r'60051b6c9a61d9f3293c6ed2b61e785da3425390';

/// Starting, finishing and leaving a session. Kept alive: these run past
/// the screen that called them.

abstract class _$SessionActions extends $Notifier<void> {
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
