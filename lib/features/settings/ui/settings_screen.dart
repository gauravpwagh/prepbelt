import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/buttons.dart';
import '../../../core/ui/placeholder_screen.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../tasks/state/task_providers.dart';

/// Placeholder Settings screen, designed and built in milestone 6. Debug
/// builds show maintenance actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, this.showDebugActions = kDebugMode});

  final bool showDebugActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rebuild = ref.watch(masteryRebuildProvider);
    return Scaffold(
      body: PlaceholderScreen(
        title: l10n.screenSettings,
        showBack: true,
        children: [
          if (showDebugActions)
            SecondaryButton(
              label: l10n.debugRebuild,
              onPressed: rebuild.isLoading
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final count = await ref
                          .read(masteryRebuildProvider.notifier)
                          .run();
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.debugRebuildDone(count))),
                      );
                    },
            ),
        ],
      ),
    );
  }
}
