// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_files.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The platform's study folder: the system folder picker on Android, a
/// PrepBelt folder in app storage elsewhere until iOS gets a picker (D51).
/// Tests override it.

@ProviderFor(studyFolder)
final studyFolderProvider = StudyFolderProvider._();

/// The platform's study folder: the system folder picker on Android, a
/// PrepBelt folder in app storage elsewhere until iOS gets a picker (D51).
/// Tests override it.

final class StudyFolderProvider
    extends
        $FunctionalProvider<
          AsyncValue<StudyFolder>,
          StudyFolder,
          FutureOr<StudyFolder>
        >
    with $FutureModifier<StudyFolder>, $FutureProvider<StudyFolder> {
  /// The platform's study folder: the system folder picker on Android, a
  /// PrepBelt folder in app storage elsewhere until iOS gets a picker (D51).
  /// Tests override it.
  StudyFolderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyFolderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyFolderHash();

  @$internal
  @override
  $FutureProviderElement<StudyFolder> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StudyFolder> create(Ref ref) {
    return studyFolder(ref);
  }
}

String _$studyFolderHash() => r'b22535a070121db358aaa9653ccb195f598fdebc';

/// Picks PDFs in the study folder. Tests override it.

@ProviderFor(pdfPicker)
final pdfPickerProvider = PdfPickerProvider._();

/// Picks PDFs in the study folder. Tests override it.

final class PdfPickerProvider
    extends $FunctionalProvider<PdfPicker, PdfPicker, PdfPicker>
    with $Provider<PdfPicker> {
  /// Picks PDFs in the study folder. Tests override it.
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

String _$pdfPickerHash() => r'c577bc1ace805a0c79157bc3d361713f4853f42c';

/// `device.json`, next to the database. Tests override it.

@ProviderFor(deviceStateFile)
final deviceStateFileProvider = DeviceStateFileProvider._();

/// `device.json`, next to the database. Tests override it.

final class DeviceStateFileProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceStateFile>,
          DeviceStateFile,
          FutureOr<DeviceStateFile>
        >
    with $FutureModifier<DeviceStateFile>, $FutureProvider<DeviceStateFile> {
  /// `device.json`, next to the database. Tests override it.
  DeviceStateFileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceStateFileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceStateFileHash();

  @$internal
  @override
  $FutureProviderElement<DeviceStateFile> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DeviceStateFile> create(Ref ref) {
    return deviceStateFile(ref);
  }
}

String _$deviceStateFileHash() => r'0eb1010d4afa4fdcc563fb96b2b040c549a9387b';

/// This phone's folder and backup times.

@ProviderFor(Device)
final deviceProvider = DeviceProvider._();

/// This phone's folder and backup times.
final class DeviceProvider extends $AsyncNotifierProvider<Device, DeviceState> {
  /// This phone's folder and backup times.
  DeviceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceHash();

  @$internal
  @override
  Device create() => Device();
}

String _$deviceHash() => r'3df91325898c526e52f8c70ed9831f92c12a3574';

/// This phone's folder and backup times.

abstract class _$Device extends $AsyncNotifier<DeviceState> {
  FutureOr<DeviceState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DeviceState>, DeviceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DeviceState>, DeviceState>,
              AsyncValue<DeviceState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(folderStatus)
final folderStatusProvider = FolderStatusProvider._();

final class FolderStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<FolderStatus>,
          FolderStatus,
          FutureOr<FolderStatus>
        >
    with $FutureModifier<FolderStatus>, $FutureProvider<FolderStatus> {
  FolderStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderStatusHash();

  @$internal
  @override
  $FutureProviderElement<FolderStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FolderStatus> create(Ref ref) {
    return folderStatus(ref);
  }
}

String _$folderStatusHash() => r'beec8b066c672be1785cee916f7d69a4fcea4e73';

/// True when source files exist but no study folder is available: an
/// install from before it, or a folder that went away. Today asks then.

@ProviderFor(needsFolder)
final needsFolderProvider = NeedsFolderProvider._();

/// True when source files exist but no study folder is available: an
/// install from before it, or a folder that went away. Today asks then.

final class NeedsFolderProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// True when source files exist but no study folder is available: an
  /// install from before it, or a folder that went away. Today asks then.
  NeedsFolderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'needsFolderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$needsFolderHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return needsFolder(ref);
  }
}

String _$needsFolderHash() => r'8f96d5842434902380f141cd8e78106bd13f63e4';

@ProviderFor(sourceDetails)
final sourceDetailsProvider = SourceDetailsFamily._();

final class SourceDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SourceDetails?>,
          SourceDetails?,
          FutureOr<SourceDetails?>
        >
    with $FutureModifier<SourceDetails?>, $FutureProvider<SourceDetails?> {
  SourceDetailsProvider._({
    required SourceDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sourceDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sourceDetailsHash();

  @override
  String toString() {
    return r'sourceDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SourceDetails?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SourceDetails?> create(Ref ref) {
    final argument = this.argument as String;
    return sourceDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SourceDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sourceDetailsHash() => r'878d7a4759418b22db0c80d442db59a8041015fe';

final class SourceDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SourceDetails?>, String> {
  SourceDetailsFamily._()
    : super(
        retry: null,
        name: r'sourceDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SourceDetailsProvider call(String id) =>
      SourceDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'sourceDetailsProvider';
}

/// Source files in the study folder (D51, design/notes/study-folder.md):
/// choosing the folder, keeping a picked PDF, opening, finding a moved
/// file again and relinking. Kept alive: it awaits platform pickers.

@ProviderFor(StudyFiles)
final studyFilesProvider = StudyFilesProvider._();

/// Source files in the study folder (D51, design/notes/study-folder.md):
/// choosing the folder, keeping a picked PDF, opening, finding a moved
/// file again and relinking. Kept alive: it awaits platform pickers.
final class StudyFilesProvider extends $NotifierProvider<StudyFiles, void> {
  /// Source files in the study folder (D51, design/notes/study-folder.md):
  /// choosing the folder, keeping a picked PDF, opening, finding a moved
  /// file again and relinking. Kept alive: it awaits platform pickers.
  StudyFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'studyFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$studyFilesHash();

  @$internal
  @override
  StudyFiles create() => StudyFiles();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$studyFilesHash() => r'0e2b4345713258e8bcf9a38645bfe3159e363649';

/// Source files in the study folder (D51, design/notes/study-folder.md):
/// choosing the folder, keeping a picked PDF, opening, finding a moved
/// file again and relinking. Kept alive: it awaits platform pickers.

abstract class _$StudyFiles extends $Notifier<void> {
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
