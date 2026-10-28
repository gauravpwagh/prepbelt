// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_source_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Builds a new source: type, details and chapter split, then saves it
/// with its file and chunks as one undoable operation.

@ProviderFor(AddSourceController)
final addSourceControllerProvider = AddSourceControllerProvider._();

/// Builds a new source: type, details and chapter split, then saves it
/// with its file and chunks as one undoable operation.
final class AddSourceControllerProvider
    extends $NotifierProvider<AddSourceController, AddSourceState> {
  /// Builds a new source: type, details and chapter split, then saves it
  /// with its file and chunks as one undoable operation.
  AddSourceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addSourceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addSourceControllerHash();

  @$internal
  @override
  AddSourceController create() => AddSourceController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddSourceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddSourceState>(value),
    );
  }
}

String _$addSourceControllerHash() =>
    r'ec48fbadad71ad9fa46cf5cb06492dd8b8bb0834';

/// Builds a new source: type, details and chapter split, then saves it
/// with its file and chunks as one undoable operation.

abstract class _$AddSourceController extends $Notifier<AddSourceState> {
  AddSourceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AddSourceState, AddSourceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddSourceState, AddSourceState>,
              AddSourceState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
