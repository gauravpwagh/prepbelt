// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sourceRepository)
final sourceRepositoryProvider = SourceRepositoryProvider._();

final class SourceRepositoryProvider
    extends
        $FunctionalProvider<
          SourceRepository,
          SourceRepository,
          SourceRepository
        >
    with $Provider<SourceRepository> {
  SourceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceRepositoryHash();

  @$internal
  @override
  $ProviderElement<SourceRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SourceRepository create(Ref ref) {
    return sourceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SourceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SourceRepository>(value),
    );
  }
}

String _$sourceRepositoryHash() => r'efc32c241bb0414d04d0f0187618aa3f6e8d15e6';

@ProviderFor(sources)
final sourcesProvider = SourcesProvider._();

final class SourcesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Source>>,
          List<Source>,
          Stream<List<Source>>
        >
    with $FutureModifier<List<Source>>, $StreamProvider<List<Source>> {
  SourcesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourcesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourcesHash();

  @$internal
  @override
  $StreamProviderElement<List<Source>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Source>> create(Ref ref) {
    return sources(ref);
  }
}

String _$sourcesHash() => r'843873ae1c0f0edd3f6ab8ff273ad6df49d1d0e6';

@ProviderFor(source)
final sourceProvider = SourceFamily._();

final class SourceProvider
    extends $FunctionalProvider<AsyncValue<Source?>, Source?, Stream<Source?>>
    with $FutureModifier<Source?>, $StreamProvider<Source?> {
  SourceProvider._({
    required SourceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sourceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sourceHash();

  @override
  String toString() {
    return r'sourceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Source?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Source?> create(Ref ref) {
    final argument = this.argument as String;
    return source(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SourceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sourceHash() => r'ddfdc52b062c7a259d07e09eef34defa45cddc86';

final class SourceFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Source?>, String> {
  SourceFamily._()
    : super(
        retry: null,
        name: r'sourceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SourceProvider call(String id) => SourceProvider._(argument: id, from: this);

  @override
  String toString() => r'sourceProvider';
}
