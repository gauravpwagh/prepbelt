// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(surveyRepository)
final surveyRepositoryProvider = SurveyRepositoryProvider._();

final class SurveyRepositoryProvider
    extends
        $FunctionalProvider<
          SurveyRepository,
          SurveyRepository,
          SurveyRepository
        >
    with $Provider<SurveyRepository> {
  SurveyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'surveyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$surveyRepositoryHash();

  @$internal
  @override
  $ProviderElement<SurveyRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SurveyRepository create(Ref ref) {
    return surveyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SurveyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SurveyRepository>(value),
    );
  }
}

String _$surveyRepositoryHash() => r'70b3caa43fcad1e91dfc21fe393d1a898574f215';

/// The survey of one source against the current exam.

@ProviderFor(surveyView)
final surveyViewProvider = SurveyViewFamily._();

/// The survey of one source against the current exam.

final class SurveyViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<SurveyView>,
          SurveyView,
          Stream<SurveyView>
        >
    with $FutureModifier<SurveyView>, $StreamProvider<SurveyView> {
  /// The survey of one source against the current exam.
  SurveyViewProvider._({
    required SurveyViewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'surveyViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$surveyViewHash();

  @override
  String toString() {
    return r'surveyViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SurveyView> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<SurveyView> create(Ref ref) {
    final argument = this.argument as String;
    return surveyView(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SurveyViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$surveyViewHash() => r'9e657817f3ed12374052e214aa09b1007309fa9e';

/// The survey of one source against the current exam.

final class SurveyViewFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SurveyView>, String> {
  SurveyViewFamily._()
    : super(
        retry: null,
        name: r'surveyViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The survey of one source against the current exam.

  SurveyViewProvider call(String sourceId) =>
      SurveyViewProvider._(argument: sourceId, from: this);

  @override
  String toString() => r'surveyViewProvider';
}

/// Survey actions for the screen.

@ProviderFor(SurveyActions)
final surveyActionsProvider = SurveyActionsProvider._();

/// Survey actions for the screen.
final class SurveyActionsProvider
    extends $NotifierProvider<SurveyActions, void> {
  /// Survey actions for the screen.
  SurveyActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'surveyActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$surveyActionsHash();

  @$internal
  @override
  SurveyActions create() => SurveyActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$surveyActionsHash() => r'35d666fa4fcaafc627ff84e25667ed9bd1be6e84';

/// Survey actions for the screen.

abstract class _$SurveyActions extends $Notifier<void> {
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
