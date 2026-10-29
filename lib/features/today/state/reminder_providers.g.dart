// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reminderScheduler)
final reminderSchedulerProvider = ReminderSchedulerProvider._();

final class ReminderSchedulerProvider
    extends
        $FunctionalProvider<
          ReminderScheduler,
          ReminderScheduler,
          ReminderScheduler
        >
    with $Provider<ReminderScheduler> {
  ReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulerHash();

  @$internal
  @override
  $ProviderElement<ReminderScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReminderScheduler create(Ref ref) {
    return reminderScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderScheduler>(value),
    );
  }
}

String _$reminderSchedulerHash() => r'e7c520f2acaf563dce28981ebe1d1186b1ae4a04';

/// The daily reminder. Permission is asked once, after the first finished
/// session (when the student has seen what it is for), never on launch.
/// Scheduling is best effort: a failure never interrupts studying.

@ProviderFor(Reminders)
final remindersProvider = RemindersProvider._();

/// The daily reminder. Permission is asked once, after the first finished
/// session (when the student has seen what it is for), never on launch.
/// Scheduling is best effort: a failure never interrupts studying.
final class RemindersProvider extends $NotifierProvider<Reminders, void> {
  /// The daily reminder. Permission is asked once, after the first finished
  /// session (when the student has seen what it is for), never on launch.
  /// Scheduling is best effort: a failure never interrupts studying.
  RemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remindersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remindersHash();

  @$internal
  @override
  Reminders create() => Reminders();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$remindersHash() => r'7361e2f6d3becccfe6ef62dc1c9672c85415e422';

/// The daily reminder. Permission is asked once, after the first finished
/// session (when the student has seen what it is for), never on launch.
/// Scheduling is best effort: a failure never interrupts studying.

abstract class _$Reminders extends $Notifier<void> {
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
