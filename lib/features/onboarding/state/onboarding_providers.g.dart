// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// First launch (design/notes/first-launch.md). Kept alive: its steps run
/// across screens.

@ProviderFor(Onboarding)
final onboardingProvider = OnboardingProvider._();

/// First launch (design/notes/first-launch.md). Kept alive: its steps run
/// across screens.
final class OnboardingProvider extends $NotifierProvider<Onboarding, void> {
  /// First launch (design/notes/first-launch.md). Kept alive: its steps run
  /// across screens.
  OnboardingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingHash();

  @$internal
  @override
  Onboarding create() => Onboarding();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$onboardingHash() => r'cfd162e841aa3f15a06749ae309b9a50c0529df8';

/// First launch (design/notes/first-launch.md). Kept alive: its steps run
/// across screens.

abstract class _$Onboarding extends $Notifier<void> {
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
