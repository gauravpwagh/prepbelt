// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(readingRepository)
final readingRepositoryProvider = ReadingRepositoryProvider._();

final class ReadingRepositoryProvider
    extends
        $FunctionalProvider<
          ReadingRepository,
          ReadingRepository,
          ReadingRepository
        >
    with $Provider<ReadingRepository> {
  ReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReadingRepository create(Ref ref) {
    return readingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadingRepository>(value),
    );
  }
}

String _$readingRepositoryHash() => r'c75db6b485acdc083df3568795c5d1ad197324a3';

@ProviderFor(sourceOpener)
final sourceOpenerProvider = SourceOpenerProvider._();

final class SourceOpenerProvider
    extends $FunctionalProvider<SourceOpener, SourceOpener, SourceOpener>
    with $Provider<SourceOpener> {
  SourceOpenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceOpenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceOpenerHash();

  @$internal
  @override
  $ProviderElement<SourceOpener> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SourceOpener create(Ref ref) {
    return sourceOpener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SourceOpener value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SourceOpener>(value),
    );
  }
}

String _$sourceOpenerHash() => r'1c993dfe47632c08ca1bd32f2dd3792a44fc0a5d';

@ProviderFor(readingConfig)
final readingConfigProvider = ReadingConfigProvider._();

final class ReadingConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReadingConfig>,
          ReadingConfig,
          FutureOr<ReadingConfig>
        >
    with $FutureModifier<ReadingConfig>, $FutureProvider<ReadingConfig> {
  ReadingConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingConfigHash();

  @$internal
  @override
  $FutureProviderElement<ReadingConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReadingConfig> create(Ref ref) {
    return readingConfig(ref);
  }
}

String _$readingConfigHash() => r'1d8a3ab18a3141314ffc77e018af87ce4a8af5b5';

@ProviderFor(sourceChapters)
final sourceChaptersProvider = SourceChaptersFamily._();

final class SourceChaptersProvider
    extends
        $FunctionalProvider<
          AsyncValue<SourceChaptersView?>,
          SourceChaptersView?,
          Stream<SourceChaptersView?>
        >
    with
        $FutureModifier<SourceChaptersView?>,
        $StreamProvider<SourceChaptersView?> {
  SourceChaptersProvider._({
    required SourceChaptersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sourceChaptersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sourceChaptersHash();

  @override
  String toString() {
    return r'sourceChaptersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<SourceChaptersView?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SourceChaptersView?> create(Ref ref) {
    final argument = this.argument as String;
    return sourceChapters(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SourceChaptersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sourceChaptersHash() => r'170eadca940cdef3a3606bbc4a10806aba508485';

final class SourceChaptersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<SourceChaptersView?>, String> {
  SourceChaptersFamily._()
    : super(
        retry: null,
        name: r'sourceChaptersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SourceChaptersProvider call(String sourceId) =>
      SourceChaptersProvider._(argument: sourceId, from: this);

  @override
  String toString() => r'sourceChaptersProvider';
}

/// The open sitting of any source, or null.

@ProviderFor(openReading)
final openReadingProvider = OpenReadingProvider._();

/// The open sitting of any source, or null.

final class OpenReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<OpenReading?>,
          OpenReading?,
          Stream<OpenReading?>
        >
    with $FutureModifier<OpenReading?>, $StreamProvider<OpenReading?> {
  /// The open sitting of any source, or null.
  OpenReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openReadingHash();

  @$internal
  @override
  $StreamProviderElement<OpenReading?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<OpenReading?> create(Ref ref) {
    return openReading(ref);
  }
}

String _$openReadingHash() => r'eb3129a55b4f60bc90298c69eb6a2c7d31f1cb2d';

/// Reading and task actions for the Source chapters screen and sheets.
/// Kept alive: its methods read providers after awaiting, and an unwatched
/// auto-dispose notifier would be gone by then.

@ProviderFor(ReadingActions)
final readingActionsProvider = ReadingActionsProvider._();

/// Reading and task actions for the Source chapters screen and sheets.
/// Kept alive: its methods read providers after awaiting, and an unwatched
/// auto-dispose notifier would be gone by then.
final class ReadingActionsProvider
    extends $NotifierProvider<ReadingActions, void> {
  /// Reading and task actions for the Source chapters screen and sheets.
  /// Kept alive: its methods read providers after awaiting, and an unwatched
  /// auto-dispose notifier would be gone by then.
  ReadingActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingActionsHash();

  @$internal
  @override
  ReadingActions create() => ReadingActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$readingActionsHash() => r'46b67fd2d67a88c4c9d9f37e556bb39efe4f7354';

/// Reading and task actions for the Source chapters screen and sheets.
/// Kept alive: its methods read providers after awaiting, and an unwatched
/// auto-dispose notifier would be gone by then.

abstract class _$ReadingActions extends $Notifier<void> {
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
