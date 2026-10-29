import 'package:flutter/material.dart';

import '../../theme/tokens/app_tokens.dart';
import 'app_icons.dart';
import 'buttons.dart';

/// A value between − and + buttons, each a 44 px target.
class ValueStepper extends StatelessWidget {
  const ValueStepper({
    required this.value,
    required this.lessLabel,
    required this.moreLabel,
    this.onLess,
    this.onMore,
    super.key,
  });

  final String value;

  /// Semantics labels of the − and + buttons.
  final String lessLabel;
  final String moreLabel;
  final VoidCallback? onLess;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.ground,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(color: c.chipBorder),
      ),
      child: Row(
        children: [
          RoundIconButton(
            icon: AppIcon.minus,
            semanticLabel: lessLabel,
            onPressed: onLess,
          ),
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: AppText.cardTitle.copyWith(color: c.ink, fontSize: 17),
              ),
            ),
          ),
          RoundIconButton(
            icon: AppIcon.add,
            semanticLabel: moreLabel,
            onPressed: onMore,
          ),
        ],
      ),
    );
  }
}
