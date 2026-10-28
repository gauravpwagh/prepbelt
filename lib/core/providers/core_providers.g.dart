// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's clock. Tests override it with a [FakeClock].

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// The app's clock. Tests override it with a [FakeClock].

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  /// The app's clock. Tests override it with a [FakeClock].
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'55214d6539f7396a3ae1aa23b06eea79fdac0ebe';

/// The open database. Overridden at bootstrap once the file is open.

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// The open database. Overridden at bootstrap once the file is open.

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// The open database. Overridden at bootstrap once the file is open.
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'e6d1120610692c10deabd60a8e89dce9aa98c817';

/// Database, clock, ids and device id for repositories. Overridden at
/// bootstrap once the device id is known.

@ProviderFor(writeContext)
final writeContextProvider = WriteContextProvider._();

/// Database, clock, ids and device id for repositories. Overridden at
/// bootstrap once the device id is known.

final class WriteContextProvider
    extends $FunctionalProvider<WriteContext, WriteContext, WriteContext>
    with $Provider<WriteContext> {
  /// Database, clock, ids and device id for repositories. Overridden at
  /// bootstrap once the device id is known.
  WriteContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'writeContextProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$writeContextHash();

  @$internal
  @override
  $ProviderElement<WriteContext> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WriteContext create(Ref ref) {
    return writeContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WriteContext value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WriteContext>(value),
    );
  }
}

String _$writeContextHash() => r'7ae6846c8e65c3fb25bd4a087cf84c35e7e232d8';
