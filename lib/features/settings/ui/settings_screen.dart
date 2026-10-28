import 'package:flutter/material.dart';

import '../../../core/ui/placeholder_screen.dart';
import '../../../l10n/gen/app_localizations.dart';

/// Placeholder Settings screen. Designed and built in milestone 6.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: PlaceholderScreen(
      title: AppLocalizations.of(context).screenSettings,
      showBack: true,
    ),
  );
}
