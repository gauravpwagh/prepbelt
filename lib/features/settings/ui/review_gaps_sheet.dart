import 'package:flutter/material.dart';

import '../../../core/config/defaults.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';

/// Opens the review schedule (D53, design/notes/settings.md): the days
/// before each review, one stepper per review.
Future<void> showReviewGapsSheet(
  BuildContext context, {
  required List<int> gaps,
  required ValueChanged<List<int>> onSave,
}) => showModalBottomSheet<void>(
  context: context,
  // Over the whole screen, nav bar included.
  useRootNavigator: true,
  isScrollControlled: true,
  showDragHandle: true,
  backgroundColor: context.colors.surface,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
  ),
  builder: (sheet) => ReviewGapsSheet(
    gaps: gaps,
    onSave: (g) {
      Navigator.of(sheet).pop();
      onSave(g);
    },
  ),
);

/// "1, 3, 7, 14, 30, 60 days".
String reviewGapsLabel(AppLocalizations l10n, List<int> gaps) =>
    l10n.reviewGapsValue(gaps.join(', '));

/// One stepper per review. Public so goldens can render it.
class ReviewGapsSheet extends StatefulWidget {
  const ReviewGapsSheet({required this.gaps, required this.onSave, super.key});

  final List<int> gaps;
  final ValueChanged<List<int>> onSave;

  @override
  State<ReviewGapsSheet> createState() => _ReviewGapsSheetState();
}

class _ReviewGapsSheetState extends State<ReviewGapsSheet> {
  late final List<int> _gaps = [...widget.gaps];

  /// The values a stepper moves through.
  static const _ladder = [
    1, 2, 3, 4, 5, 6, 7, 10, 14, 21, 30, 45, 60, 90, 120, 180, 365, //
  ];

  int? _below(int v) {
    for (final l in _ladder.reversed) {
      if (l < v) return l;
    }
    return null;
  }

  int? _above(int v) {
    for (final l in _ladder) {
      if (l > v) return l;
    }
    return null;
  }

  /// A gap is never shorter than the one before or longer than the next.
  VoidCallback? _less(int i) {
    final to = _below(_gaps[i]);
    if (to == null || (i > 0 && to < _gaps[i - 1])) return null;
    return () => setState(() => _gaps[i] = to);
  }

  VoidCallback? _more(int i) {
    final to = _above(_gaps[i]);
    if (to == null || (i + 1 < _gaps.length && to > _gaps[i + 1])) return null;
    return () => setState(() => _gaps[i] = to);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final isDefault = _gaps.join(',') == Defaults.reviewGapDays.join(',');
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.reviewGapsTitle,
                style: AppText.section.copyWith(color: c.ink),
              ),
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              l10n.reviewGapsHint(Defaults.minReviewsBeforeExam),
              style: AppText.caption.copyWith(color: c.muted),
            ),
            const SizedBox(height: AppSpace.md),
            for (var i = 0; i < _gaps.length; i++) ...[
              Row(
                children: [
                  SizedBox(
                    width: 104,
                    child: Text(
                      l10n.reviewGapsReview(i + 1),
                      style: AppText.subtitle.copyWith(color: c.ink),
                    ),
                  ),
                  Expanded(
                    child: ValueStepper(
                      value: l10n.reviewGapsDays(_gaps[i]),
                      lessLabel: l10n.reviewGapsLess(i + 1),
                      moreLabel: l10n.reviewGapsMore(i + 1),
                      onLess: _less(i),
                      onMore: _more(i),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.sm),
            ],
            Wrap(
              spacing: AppSpace.md,
              children: [
                if (_gaps.length < Defaults.reviewGapsMax)
                  TextLinkButton(
                    label: l10n.reviewGapsAdd,
                    onPressed: () => setState(
                      () => _gaps.add(_above(_gaps.last) ?? _gaps.last),
                    ),
                  ),
                if (_gaps.length > 1)
                  TextLinkButton(
                    label: l10n.reviewGapsRemove,
                    onPressed: () => setState(_gaps.removeLast),
                  ),
                if (!isDefault)
                  TextLinkButton(
                    label: l10n.reviewGapsReset(
                      Defaults.reviewGapDays.join(', '),
                    ),
                    onPressed: () => setState(
                      () => _gaps
                        ..clear()
                        ..addAll(Defaults.reviewGapDays),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.md),
            PrimaryButton(
              label: l10n.reviewGapsSave,
              onPressed: () => widget.onSave(List.of(_gaps)),
            ),
          ],
        ),
      ),
    );
  }
}
