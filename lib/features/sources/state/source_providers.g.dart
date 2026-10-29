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

/// Sources with survey progress, in Sources-list order.

@ProviderFor(sourceSummaries)
final sourceSummariesProvider = SourceSummariesProvider._();

/// Sources with survey progress, in Sources-list order.

final class SourceSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SourceSummary>>,
          List<SourceSummary>,
          Stream<List<SourceSummary>>
        >
    with
        $FutureModifier<List<SourceSummary>>,
        $StreamProvider<List<SourceSummary>> {
  /// Sources with survey progress, in Sources-list order.
  SourceSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceSummariesHash();

  @$internal
  @override
  $StreamProviderElement<List<SourceSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SourceSummary>> create(Ref ref) {
    return sourceSummaries(ref);
  }
}

String _$sourceSummariesHash() => r'a69e79c49c47912e28483fe9208d9d70ca1a327e';

/// Where imported files are copied. Tests override it with a temp folder.

@ProviderFor(fileStore)
final fileStoreProvider = FileStoreProvider._();

/// Where imported files are copied. Tests override it with a temp folder.

final class FileStoreProvider
    extends
        $FunctionalProvider<
          AsyncValue<FileStore>,
          FileStore,
          FutureOr<FileStore>
        >
    with $FutureModifier<FileStore>, $FutureProvider<FileStore> {
  /// Where imported files are copied. Tests override it with a temp folder.
  FileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileStoreHash();

  @$internal
  @override
  $FutureProviderElement<FileStore> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<FileStore> create(Ref ref) {
    return fileStore(ref);
  }
}

String _$fileStoreHash() => r'b8fb743f97aa6fc84c494e9436ac1e921fbb8557';

@ProviderFor(pdfPicker)
final pdfPickerProvider = PdfPickerProvider._();

final class PdfPickerProvider
    extends $FunctionalProvider<PdfPicker, PdfPicker, PdfPicker>
    with $Provider<PdfPicker> {
  PdfPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pdfPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pdfPickerHash();

  @$internal
  @override
  $ProviderElement<PdfPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PdfPicker create(Ref ref) {
    return pdfPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PdfPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PdfPicker>(value),
    );
  }
}

String _$pdfPickerHash() => r'cf6c1042a4de958e703782a793651db1a15ffba5';

@ProviderFor(pdfOutlineReader)
final pdfOutlineReaderProvider = PdfOutlineReaderProvider._();

final class PdfOutlineReaderProvider
    extends
        $FunctionalProvider<
          PdfOutlineReader,
          PdfOutlineReader,
          PdfOutlineReader
        >
    with $Provider<PdfOutlineReader> {
  PdfOutlineReaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pdfOutlineReaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pdfOutlineReaderHash();

  @$internal
  @override
  $ProviderElement<PdfOutlineReader> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PdfOutlineReader create(Ref ref) {
    return pdfOutlineReader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PdfOutlineReader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PdfOutlineReader>(value),
    );
  }
}

String _$pdfOutlineReaderHash() => r'ee6eb56ffa0cc28f6408642f8fa81a44da4775f6';

/// PDFs and links shared from other apps. Tests override it.

@ProviderFor(shareInbox)
final shareInboxProvider = ShareInboxProvider._();

/// PDFs and links shared from other apps. Tests override it.

final class ShareInboxProvider
    extends $FunctionalProvider<ShareInbox, ShareInbox, ShareInbox>
    with $Provider<ShareInbox> {
  /// PDFs and links shared from other apps. Tests override it.
  ShareInboxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareInboxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareInboxHash();

  @$internal
  @override
  $ProviderElement<ShareInbox> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareInbox create(Ref ref) {
    return shareInbox(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareInbox value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareInbox>(value),
    );
  }
}

String _$shareInboxHash() => r'712fd639543e05289cb9a973c1d7624798dde941';

/// Rename, remove and undo from the Sources list. Kept alive: removing
/// awaits, then replans.

@ProviderFor(SourceActions)
final sourceActionsProvider = SourceActionsProvider._();

/// Rename, remove and undo from the Sources list. Kept alive: removing
/// awaits, then replans.
final class SourceActionsProvider
    extends $NotifierProvider<SourceActions, void> {
  /// Rename, remove and undo from the Sources list. Kept alive: removing
  /// awaits, then replans.
  SourceActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceActionsHash();

  @$internal
  @override
  SourceActions create() => SourceActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$sourceActionsHash() => r'8510a7ba4984dfc30f9b58be5bb2dd78eaf883a2';

/// Rename, remove and undo from the Sources list. Kept alive: removing
/// awaits, then replans.

abstract class _$SourceActions extends $Notifier<void> {
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
