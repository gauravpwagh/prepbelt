// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_view_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examViewRepository)
final examViewRepositoryProvider = ExamViewRepositoryProvider._();

final class ExamViewRepositoryProvider
    extends
        $FunctionalProvider<
          ExamViewRepository,
          ExamViewRepository,
          ExamViewRepository
        >
    with $Provider<ExamViewRepository> {
  ExamViewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examViewRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examViewRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExamViewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExamViewRepository create(Ref ref) {
    return examViewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExamViewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExamViewRepository>(value),
    );
  }
}

String _$examViewRepositoryHash() =>
    r'c47897b9f6af805f488f47d95191c554c9e857d5';

/// The Exam screen for [examId], or the upcoming exam when null. Null when
/// there is no such exam.

@ProviderFor(examView)
final examViewProvider = ExamViewFamily._();

/// The Exam screen for [examId], or the upcoming exam when null. Null when
/// there is no such exam.

final class ExamViewProvider
    extends
        $FunctionalProvider<AsyncValue<ExamView?>, ExamView?, Stream<ExamView?>>
    with $FutureModifier<ExamView?>, $StreamProvider<ExamView?> {
  /// The Exam screen for [examId], or the upcoming exam when null. Null when
  /// there is no such exam.
  ExamViewProvider._({
    required ExamViewFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'examViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$examViewHash();

  @override
  String toString() {
    return r'examViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ExamView?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<ExamView?> create(Ref ref) {
    final argument = this.argument as String?;
    return examView(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExamViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$examViewHash() => r'89f8282e52ed11248e333aa3add72b21e78e1e31';

/// The Exam screen for [examId], or the upcoming exam when null. Null when
/// there is no such exam.

final class ExamViewFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ExamView?>, String?> {
  ExamViewFamily._()
    : super(
        retry: null,
        name: r'examViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The Exam screen for [examId], or the upcoming exam when null. Null when
  /// there is no such exam.

  ExamViewProvider call(String? examId) =>
      ExamViewProvider._(argument: examId, from: this);

  @override
  String toString() => r'examViewProvider';
}

/// Study minutes per weekday, Monday first.

@ProviderFor(weekMinutes)
final weekMinutesProvider = WeekMinutesProvider._();

/// Study minutes per weekday, Monday first.

final class WeekMinutesProvider
    extends
        $FunctionalProvider<AsyncValue<List<int>>, List<int>, Stream<List<int>>>
    with $FutureModifier<List<int>>, $StreamProvider<List<int>> {
  /// Study minutes per weekday, Monday first.
  WeekMinutesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weekMinutesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekMinutesHash();

  @$internal
  @override
  $StreamProviderElement<List<int>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<int>> create(Ref ref) {
    return weekMinutes(ref);
  }
}

String _$weekMinutesHash() => r'65852cb94fd0e5a472e0036db0bc0864333b2556';

/// Adds an exam with its task links and daily minutes (D38).

@ProviderFor(ExamActions)
final examActionsProvider = ExamActionsProvider._();

/// Adds an exam with its task links and daily minutes (D38).
final class ExamActionsProvider extends $NotifierProvider<ExamActions, void> {
  /// Adds an exam with its task links and daily minutes (D38).
  ExamActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examActionsHash();

  @$internal
  @override
  ExamActions create() => ExamActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$examActionsHash() => r'a9b2bdfc17fbaa8f12d9796cc53401cf233bac95';

/// Adds an exam with its task links and daily minutes (D38).

abstract class _$ExamActions extends $Notifier<void> {
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
