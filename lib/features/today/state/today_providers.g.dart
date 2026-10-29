// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todayRepository)
final todayRepositoryProvider = TodayRepositoryProvider._();

final class TodayRepositoryProvider
    extends
        $FunctionalProvider<TodayRepository, TodayRepository, TodayRepository>
    with $Provider<TodayRepository> {
  TodayRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayRepositoryHash();

  @$internal
  @override
  $ProviderElement<TodayRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodayRepository create(Ref ref) {
    return todayRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodayRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodayRepository>(value),
    );
  }
}

String _$todayRepositoryHash() => r'4f8d72d3fa7825b6086015809027c240d57cb8f9';

/// Today's three boxes (D50).

@ProviderFor(todayBoxes)
final todayBoxesProvider = TodayBoxesProvider._();

/// Today's three boxes (D50).

final class TodayBoxesProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodayBoxes>,
          TodayBoxes,
          Stream<TodayBoxes>
        >
    with $FutureModifier<TodayBoxes>, $StreamProvider<TodayBoxes> {
  /// Today's three boxes (D50).
  TodayBoxesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayBoxesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayBoxesHash();

  @$internal
  @override
  $StreamProviderElement<TodayBoxes> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<TodayBoxes> create(Ref ref) {
    return todayBoxes(ref);
  }
}

String _$todayBoxesHash() => r'87d23a5a6e5a7ead3252433b1484360afae610b5';

@ProviderFor(streak)
final streakProvider = StreakProvider._();

final class StreakProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  StreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return streak(ref);
  }
}

String _$streakHash() => r'97be42ca733779f803d857856ec03d60de4a1626';

@ProviderFor(todayView)
final todayViewProvider = TodayViewProvider._();

final class TodayViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<TodayView>,
          TodayView,
          FutureOr<TodayView>
        >
    with $FutureModifier<TodayView>, $FutureProvider<TodayView> {
  TodayViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayViewHash();

  @$internal
  @override
  $FutureProviderElement<TodayView> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TodayView> create(Ref ref) {
    return todayView(ref);
  }
}

String _$todayViewHash() => r'498e3d9b8dbf42a417310a66fb03288ba52bd001';
