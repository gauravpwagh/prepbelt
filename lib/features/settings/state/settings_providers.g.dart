// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'eaeca8c7bcc6aed1e611cc8764d27d8fea6183dd';

/// All settings, decoded from JSON.

@ProviderFor(settings)
final settingsProvider = SettingsProvider._();

/// All settings, decoded from JSON.

final class SettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Object?>>,
          Map<String, Object?>,
          Stream<Map<String, Object?>>
        >
    with
        $FutureModifier<Map<String, Object?>>,
        $StreamProvider<Map<String, Object?>> {
  /// All settings, decoded from JSON.
  SettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, Object?>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Object?>> create(Ref ref) {
    return settings(ref);
  }
}

String _$settingsHash() => r'b907f7b016dab6393e8b148f7e0fc09c269d9554';

/// Review engine configuration: [ReviewConfig] defaults merged with any
/// Setting overrides.

@ProviderFor(reviewConfig)
final reviewConfigProvider = ReviewConfigProvider._();

/// Review engine configuration: [ReviewConfig] defaults merged with any
/// Setting overrides.

final class ReviewConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReviewConfig>,
          ReviewConfig,
          FutureOr<ReviewConfig>
        >
    with $FutureModifier<ReviewConfig>, $FutureProvider<ReviewConfig> {
  /// Review engine configuration: [ReviewConfig] defaults merged with any
  /// Setting overrides.
  ReviewConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewConfigHash();

  @$internal
  @override
  $FutureProviderElement<ReviewConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReviewConfig> create(Ref ref) {
    return reviewConfig(ref);
  }
}

String _$reviewConfigHash() => r'f39cbaf41732e3aabddb2511f887c883a41cff74';
