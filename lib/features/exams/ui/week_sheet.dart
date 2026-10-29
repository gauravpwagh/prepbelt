import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/ui/buttons.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../sources/ui/source_labels.dart';

/// Weekday names, Monday first, in the current locale.
List<String> weekdayNames(String locale, {bool short = false}) => [
  // 5 Jan 2026 is a Monday.
  for (var i = 0; i < 7; i++)
    DateFormat(short ? 'EEE' : 'EEEE', locale).format(DateTime(2026, 1, 5 + i)),
];

/// "Every day · 1 h 30 min", or runs of equal days: "Mon–Sat 1 h 45 min ·
/// Sun 4 h".
String weekSummary(AppLocalizations l10n, String locale, List<int> week) {
  String time(int m) => m == 0 ? l10n.weekOff : formatMinutes(l10n, m);
  if (week.toSet().length == 1) return l10n.weekEveryDay(time(week.first));
  final names = weekdayNames(locale, short: true);
  final parts = <String>[];
  var start = 0;
  for (var i = 1; i <= 7; i++) {
    if (i == 7 || week[i] != week[start]) {
      final days = i - 1 == start
          ? names[start]
          : '${names[start]}–${names[i - 1]}';
      parts.add('$days ${time(week[start])}');
      start = i;
    }
  }
  return parts.join(' · ');
}

/// Opens the weekday editor; [onSave] gets the new minutes, Monday first.
Future<void> showWeekSheet(
  BuildContext context, {
  required List<int> week,
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
  builder: (sheet) => WeekSheet(
    week: week,
    onSave: (w) {
      Navigator.of(sheet).pop();
      onSave(w);
    },
  ),
);

/// Seven steppers, one per weekday. Public so goldens can render it.
class WeekSheet extends StatefulWidget {
  const WeekSheet({required this.week, required this.onSave, super.key});

  final List<int> week;
  final ValueChanged<List<int>> onSave;

  @override
  State<WeekSheet> createState() => _WeekSheetState();
}

class _WeekSheetState extends State<WeekSheet> {
  late final List<int> _week = [...widget.week];

  static const _step = 15;
  static const _max = 8 * 60;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final names = weekdayNames(locale);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.weekSheetTitle,
                style: AppText.section.copyWith(color: c.ink),
              ),
            ),
            const SizedBox(height: AppSpace.xs),
            Text(
              l10n.weekSheetHint,
              style: AppText.caption.copyWith(color: c.muted),
            ),
            const SizedBox(height: AppSpace.md),
            for (var d = 0; d < 7; d++) ...[
              Row(
                children: [
                  SizedBox(
                    width: 104,
                    child: Text(
                      names[d],
                      style: AppText.subtitle.copyWith(color: c.ink),
                    ),
                  ),
                  Expanded(
                    child: ValueStepper(
                      value: _week[d] == 0
                          ? l10n.weekOff
                          : formatMinutes(l10n, _week[d]),
                      lessLabel: l10n.weekLess(names[d]),
                      moreLabel: l10n.weekMore(names[d]),
                      onLess: _week[d] > 0
                          ? () => setState(() => _week[d] -= _step)
                          : null,
                      onMore: _week[d] < _max
                          ? () => setState(() => _week[d] += _step)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.sm),
            ],
            const SizedBox(height: AppSpace.md),
            PrimaryButton(
              label: l10n.weekSave,
              onPressed: () => widget.onSave(List.of(_week)),
            ),
          ],
        ),
      ),
    );
  }
}
