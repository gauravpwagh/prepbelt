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

/// Today's items: the plan's when there is an upcoming exam, otherwise
/// what is due (D33).

@ProviderFor(todayItems)
final todayItemsProvider = TodayItemsProvider._();

/// Today's items: the plan's when there is an upcoming exam, otherwise
/// what is due (D33).

final class TodayItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TodayItem>>,
          List<TodayItem>,
          Stream<List<TodayItem>>
        >
    with $FutureModifier<List<TodayItem>>, $StreamProvider<List<TodayItem>> {
  /// Today's items: the plan's when there is an upcoming exam, otherwise
  /// what is due (D33).
  TodayItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<TodayItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TodayItem>> create(Ref ref) {
    return todayItems(ref);
  }
}

String _$todayItemsHash() => r'95f14f7e10be4b62ada02db10b6698c60a6fc81b';

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

String _$todayViewHash() => r'166fdb87f1b9de732f504f7164312a581db587d8';
