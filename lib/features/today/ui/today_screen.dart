import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/ui/placeholder_screen.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';

/// Placeholder Today screen: the header from the mockup. Sessions arrive
/// in milestone 4.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final today = ref.watch(clockProvider).now().toLocal();
    return PlaceholderScreen(
      title: l10n.screenToday,
      children: [
        Text(
          DateFormat('EEEE, d MMM', locale).format(today),
          style: AppText.subtitle.copyWith(color: c.muted),
        ),
      ],
    );
  }
}
