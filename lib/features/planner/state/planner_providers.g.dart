// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(plannerRepository)
final plannerRepositoryProvider = PlannerRepositoryProvider._();

final class PlannerRepositoryProvider
    extends
        $FunctionalProvider<
          PlannerRepository,
          PlannerRepository,
          PlannerRepository
        >
    with $Provider<PlannerRepository> {
  PlannerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlannerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlannerRepository create(Ref ref) {
    return plannerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlannerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlannerRepository>(value),
    );
  }
}

String _$plannerRepositoryHash() => r'bd056ef759ea3996fac404d28f84896dd8f32ca6';

/// Keeps the plan current: replans [Defaults.plannerDebounceMs] after any
/// planner input changes (a review, a survey answer, a task, the exam,
/// availability), and on [replanNow] (app resume, a new day). State is the
/// latest result, null without an upcoming exam.

@ProviderFor(Planner)
final plannerProvider = PlannerProvider._();

/// Keeps the plan current: replans [Defaults.plannerDebounceMs] after any
/// planner input changes (a review, a survey answer, a task, the exam,
/// availability), and on [replanNow] (app resume, a new day). State is the
/// latest result, null without an upcoming exam.
final class PlannerProvider
    extends $AsyncNotifierProvider<Planner, TriageResult?> {
  /// Keeps the plan current: replans [Defaults.plannerDebounceMs] after any
  /// planner input changes (a review, a survey answer, a task, the exam,
  /// availability), and on [replanNow] (app resume, a new day). State is the
  /// latest result, null without an upcoming exam.
  PlannerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plannerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plannerHash();

  @$internal
  @override
  Planner create() => Planner();
}

String _$plannerHash() => r'94ce57114a48af485be4d90856dc28379766d04e';

/// Keeps the plan current: replans [Defaults.plannerDebounceMs] after any
/// planner input changes (a review, a survey answer, a task, the exam,
/// availability), and on [replanNow] (app resume, a new day). State is the
/// latest result, null without an upcoming exam.

abstract class _$Planner extends $AsyncNotifier<TriageResult?> {
  FutureOr<TriageResult?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TriageResult?>, TriageResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TriageResult?>, TriageResult?>,
              AsyncValue<TriageResult?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The plan items of [day] in order.

@ProviderFor(planDay)
final planDayProvider = PlanDayFamily._();

/// The plan items of [day] in order.

final class PlanDayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlanItem>>,
          List<PlanItem>,
          Stream<List<PlanItem>>
        >
    with $FutureModifier<List<PlanItem>>, $StreamProvider<List<PlanItem>> {
  /// The plan items of [day] in order.
  PlanDayProvider._({
    required PlanDayFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'planDayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$planDayHash();

  @override
  String toString() {
    return r'planDayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PlanItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PlanItem>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return planDay(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlanDayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$planDayHash() => r'49c6e820249125ee12b46d08510256da596aab67';

/// The plan items of [day] in order.

final class PlanDayFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PlanItem>>, DateTime> {
  PlanDayFamily._()
    : super(
        retry: null,
        name: r'planDayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The plan items of [day] in order.

  PlanDayProvider call(DateTime day) =>
      PlanDayProvider._(argument: day, from: this);

  @override
  String toString() => r'planDayProvider';
}
