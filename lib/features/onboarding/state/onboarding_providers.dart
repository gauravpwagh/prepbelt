import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/defaults.dart';
import '../../exams/state/exam_providers.dart';
import '../../planner/state/planner_providers.dart';
import '../../settings/state/settings_providers.dart';
import '../../sources/state/source_providers.dart';
import '../../today/state/reminder_providers.dart';

part 'onboarding_providers.g.dart';

/// First launch (design/notes/first-launch.md). Kept alive: its steps run
/// across screens.
@Riverpod(keepAlive: true)
class Onboarding extends _$Onboarding {
  @override
  void build() {}

  /// True for a fresh install: not onboarded and nothing added yet. An
  /// install from before first launch existed, with data, is marked done.
  Future<bool> needed() async {
    final settings = ref.read(settingsRepositoryProvider);
    if (await settings.get(SettingKeys.onboarded) == true) return false;
    final sources = await ref.read(sourceRepositoryProvider).watchAll().first;
    final exams = await ref.read(examRepositoryProvider).watchAll().first;
    if (sources.isNotEmpty || exams.isNotEmpty) {
      await settings.set(SettingKeys.onboarded, true);
      return false;
    }
    return true;
  }

  /// Step 1: the name (optional) and the same minutes on every weekday.
  Future<void> saveProfile({required String name, required int minutes}) async {
    final settings = ref.read(settingsRepositoryProvider);
    if (name.trim().isNotEmpty) {
      await settings.set(SettingKeys.studentName, name.trim());
    }
    await ref
        .read(examRepositoryProvider)
        .setWeek('week', List.filled(7, minutes));
    await ref.read(plannerProvider.notifier).replanNow();
  }

  /// Step 2: the reminder. Asking marks first launch done.
  Future<void> setReminder({required bool on}) async {
    final settings = ref.read(settingsRepositoryProvider);
    await settings.set(SettingKeys.reminderAsked, true);
    if (on) {
      final granted = await ref
          .read(reminderSchedulerProvider)
          .requestPermission();
      await settings.set(SettingKeys.reminderEnabled, granted);
    } else {
      await settings.set(SettingKeys.reminderEnabled, false);
    }
    await settings.set(SettingKeys.onboarded, true);
  }

  /// Default minutes for the stepper.
  int get defaultMinutes => Defaults.defaultDailyMinutes;
}
