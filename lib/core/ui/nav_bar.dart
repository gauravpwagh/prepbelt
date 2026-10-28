import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';
import '../../theme/tokens/app_tokens.dart';
import 'app_icons.dart';

/// Bottom navigation from the Today mockup: Today, Exams, a raised add
/// button, Sources, Progress.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.currentIndex,
    required this.onSelect,
    required this.onAdd,
    super.key,
  });

  /// 0 Today, 1 Exams, 2 Sources, 3 Progress.
  final int currentIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    Widget item(int index, AppIcon icon, String label) => _NavItem(
      icon: icon,
      label: label,
      selected: currentIndex == index,
      onTap: () => onSelect(index),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              item(0, AppIcon.today, l10n.navToday),
              item(1, AppIcon.exams, l10n.navExams),
              _AddButton(label: l10n.navQuickAdd, onTap: onAdd),
              item(2, AppIcon.sources, l10n.navSources),
              item(3, AppIcon.progress, l10n.navProgress),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppIcon icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.accentText : c.muted;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        child: SizedBox(
          width: 64,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIconView(icon, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: AppText.navLabel.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Transform.translate(
      offset: const Offset(0, -14),
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.navAdd),
            boxShadow: [
              BoxShadow(
                color: c.accentShadow,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: c.accent,
            borderRadius: BorderRadius.circular(AppRadii.navAdd),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.navAdd),
              onTap: onTap,
              child: SizedBox.square(
                dimension: 56,
                child: Center(
                  child: AppIconView(AppIcon.add, color: c.onAccent, size: 24),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
