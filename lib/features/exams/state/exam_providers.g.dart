// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examRepository)
final examRepositoryProvider = ExamRepositoryProvider._();

final class ExamRepositoryProvider
    extends $FunctionalProvider<ExamRepository, ExamRepository, ExamRepository>
    with $Provider<ExamRepository> {
  ExamRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExamRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExamRepository create(Ref ref) {
    return examRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExamRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExamRepository>(value),
    );
  }
}

String _$examRepositoryHash() => r'08b15abb8800e4a9b2014c0a8335949da324c8c8';

/// The one upcoming exam of 1.0.

@ProviderFor(currentExam)
final currentExamProvider = CurrentExamProvider._();

/// The one upcoming exam of 1.0.

final class CurrentExamProvider
    extends $FunctionalProvider<AsyncValue<Exam?>, Exam?, Stream<Exam?>>
    with $FutureModifier<Exam?>, $StreamProvider<Exam?> {
  /// The one upcoming exam of 1.0.
  CurrentExamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentExamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentExamHash();

  @$internal
  @override
  $StreamProviderElement<Exam?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Exam?> create(Ref ref) {
    return currentExam(ref);
  }
}

String _$currentExamHash() => r'259983bbc0eef120e646e8dcd4fc626c53d4ea7d';
