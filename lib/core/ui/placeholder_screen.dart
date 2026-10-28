import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../../theme/tokens/app_tokens.dart';
import 'app_icons.dart';

/// Stand-in for screens built in later milestones.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    this.showBack = false,
    this.children = const [],
    super.key,
  });

  final String title;
  final bool showBack;

  /// Extra content, e.g. debug actions.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showBack) ...[
              _BackButton(color: c.ink),
              const SizedBox(height: AppSpace.lg),
            ],
            Semantics(
              header: true,
              child: Text(title, style: AppText.display.copyWith(color: c.ink)),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              l10n.placeholderComingSoon(title),
              style: AppText.subtitle.copyWith(color: c.muted),
            ),
            const SizedBox(height: AppSpace.xl),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: MaterialLocalizations.of(context).backButtonTooltip,
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        shape: CircleBorder(side: BorderSide(color: c.line)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.of(context).maybePop(),
          child: SizedBox.square(
            dimension: kMinTouchTarget,
            child: Center(child: AppIconView(AppIcon.back, color: color)),
          ),
        ),
      ),
    );
  }
}
