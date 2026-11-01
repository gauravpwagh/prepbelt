// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Automatic backups into the study folder (D51): the database only,
/// every `backup.everyDays` local days if something changed, the newest
/// [Defaults.backupKeep] kept. Kept alive: it runs as the app goes to the
/// background.

@ProviderFor(AutoBackup)
final autoBackupProvider = AutoBackupProvider._();

/// Automatic backups into the study folder (D51): the database only,
/// every `backup.everyDays` local days if something changed, the newest
/// [Defaults.backupKeep] kept. Kept alive: it runs as the app goes to the
/// background.
final class AutoBackupProvider extends $NotifierProvider<AutoBackup, void> {
  /// Automatic backups into the study folder (D51): the database only,
  /// every `backup.everyDays` local days if something changed, the newest
  /// [Defaults.backupKeep] kept. Kept alive: it runs as the app goes to the
  /// background.
  AutoBackupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoBackupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoBackupHash();

  @$internal
  @override
  AutoBackup create() => AutoBackup();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$autoBackupHash() => r'c9115a9181e6f835af3a683e8401c84cd082f9dd';

/// Automatic backups into the study folder (D51): the database only,
/// every `backup.everyDays` local days if something changed, the newest
/// [Defaults.backupKeep] kept. Kept alive: it runs as the app goes to the
/// background.

abstract class _$AutoBackup extends $Notifier<void> {
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
