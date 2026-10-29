// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(backupFiles)
final backupFilesProvider = BackupFilesProvider._();

final class BackupFilesProvider
    extends $FunctionalProvider<BackupFiles, BackupFiles, BackupFiles>
    with $Provider<BackupFiles> {
  BackupFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupFilesHash();

  @$internal
  @override
  $ProviderElement<BackupFiles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BackupFiles create(Ref ref) {
    return backupFiles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupFiles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupFiles>(value),
    );
  }
}

String _$backupFilesHash() => r'41887dc2dbff7cadd4504baf0a595863ad50b4d9';

@ProviderFor(backupRepository)
final backupRepositoryProvider = BackupRepositoryProvider._();

final class BackupRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<BackupRepository>,
          BackupRepository,
          FutureOr<BackupRepository>
        >
    with $FutureModifier<BackupRepository>, $FutureProvider<BackupRepository> {
  BackupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<BackupRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BackupRepository> create(Ref ref) {
    return backupRepository(ref);
  }
}

String _$backupRepositoryHash() => r'970fc891a3c1cde615d7504fa9d868da25da14bf';

/// What the Settings screen changes (design/notes/settings.md).

@ProviderFor(SettingsActions)
final settingsActionsProvider = SettingsActionsProvider._();

/// What the Settings screen changes (design/notes/settings.md).
final class SettingsActionsProvider
    extends $NotifierProvider<SettingsActions, void> {
  /// What the Settings screen changes (design/notes/settings.md).
  SettingsActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsActionsHash();

  @$internal
  @override
  SettingsActions create() => SettingsActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$settingsActionsHash() => r'b27eaf5b635247e4ff189ce1bca1c63989ca7a4f';

/// What the Settings screen changes (design/notes/settings.md).

abstract class _$SettingsActions extends $Notifier<void> {
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
