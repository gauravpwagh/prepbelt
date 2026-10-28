import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/review_config.dart';
import '../../../core/providers/core_providers.dart';
import '../data/settings_repository.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepository(ref.watch(writeContextProvider));

/// All settings, decoded from JSON.
@Riverpod(keepAlive: true)
Stream<Map<String, Object?>> settings(Ref ref) =>
    ref.watch(settingsRepositoryProvider).watchAll();

/// Review engine configuration: [ReviewConfig] defaults merged with any
/// Setting overrides.
@Riverpod(keepAlive: true)
Future<ReviewConfig> reviewConfig(Ref ref) async =>
    ReviewConfig.fromSettings(await ref.watch(settingsProvider.future));
