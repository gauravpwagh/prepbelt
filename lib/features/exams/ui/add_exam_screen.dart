import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/config/defaults.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../sources/ui/source_labels.dart';
import '../state/exam_providers.dart';
import '../state/exam_view_providers.dart';

/// Add exam (design/notes/add-exam.md): name, date and daily minutes.
/// With [examId] it edits that exam's name and date instead.
class AddExamScreen extends ConsumerStatefulWidget {
  const AddExamScreen({this.examId, super.key});

  final String? examId;

  @override
  ConsumerState<AddExamScreen> createState() => _AddExamScreenState();
}

class _AddExamScreenState extends ConsumerState<AddExamScreen> {
  final _name = TextEditingController();
  DateTime? _date;
  int _minutes = Defaults.defaultDailyMinutes;
  bool _saving = false;
  bool _failed = false;
  bool _touched = false;
  int? _tasks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = widget.examId;
      if (id != null) {
        final exam = await ref.read(examRepositoryProvider).watch(id).first;
        if (exam != null && mounted) {
          setState(() {
            _name.text = exam.name;
            _date = DateTime.parse(exam.date);
          });
        }
        return;
      }
      final n = await ref.read(examActionsProvider.notifier).taskCount();
      // Start from the minutes chosen at first launch, if any.
      final week = await ref.read(weekMinutesProvider.future);
      if (mounted) {
        setState(() {
          _tasks = n;
          _minutes = week.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  DateTime get _today {
    final now = ref.read(clockProvider).now().toLocal();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate() async {
    final tomorrow = _today.add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? tomorrow.add(const Duration(days: 60)),
      firstDate: tomorrow,
      lastDate: _today.add(const Duration(days: 3 * 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      final id = widget.examId;
      final actions = ref.read(examActionsProvider.notifier);
      if (id != null) {
        final messenger = ScaffoldMessenger.of(context);
        final l10n = AppLocalizations.of(context);
        await actions.edit(id, name: _name.text, date: _date!);
        if (!mounted) return;
        context.pop();
        messenger.showSnackBar(SnackBar(content: Text(l10n.examSavedSnack)));
        return;
      }
      await actions.add(name: _name.text, date: _date!, dailyMinutes: _minutes);
      if (mounted) context.go(Routes.today);
    } on Object {
      if (mounted) {
        setState(() {
          _saving = false;
          _failed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: AddExamBody(
        name: _name,
        date: _date,
        today: _today,
        minutes: _minutes,
        taskCount: _tasks,
        saving: _saving,
        failed: _failed,
        showErrors: _touched,
        onBack: () => context.pop(),
        onName: (_) => setState(() => _touched = true),
        onPickDate: _pickDate,
        onMinutes: (m) => setState(() => _minutes = m),
        onSave: _save,
        editing: widget.examId != null,
      ),
    ),
  );
}

/// The form for one state. Public so goldens can render it.
class AddExamBody extends StatelessWidget {
  const AddExamBody({
    required this.name,
    required this.date,
    required this.today,
    required this.minutes,
    required this.onBack,
    required this.onName,
    required this.onPickDate,
    required this.onMinutes,
    required this.onSave,
    this.taskCount,
    this.saving = false,
    this.failed = false,
    this.showErrors = false,
    this.editing = false,
    super.key,
  });

  /// Editing an exam: name and date only (study time has its own row).
  final bool editing;

  final TextEditingController name;
  final DateTime? date;
  final DateTime today;
  final int minutes;
  final int? taskCount;
  final bool saving;
  final bool failed;

  /// Shows "Give the exam a name" once the field was touched.
  final bool showErrors;
  final VoidCallback onBack;
  final ValueChanged<String> onName;
  final VoidCallback onPickDate;
  final ValueChanged<int> onMinutes;
  final VoidCallback onSave;

  static const _step = 15;
  static const _max = 8 * 60;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final d = date;
    final valid = name.text.trim().isNotEmpty && d != null;
    Widget card(List<Widget> children) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            children: [
              RoundIconButton.back(context, onBack),
              const SizedBox(width: AppSpace.lg),
              Text(
                editing ? l10n.editExamTitle : l10n.addExamTitle,
                style: AppText.heroTitle.copyWith(color: c.ink),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            children: [
              card([
                LabeledField(
                  label: l10n.addExamName,
                  controller: name,
                  onChanged: onName,
                  error: showErrors && name.text.trim().isEmpty
                      ? l10n.addExamNameMissing
                      : null,
                ),
                const SizedBox(height: AppSpace.xl),
                Text(
                  l10n.addExamDate,
                  style: AppText.subtitle.copyWith(color: c.ink),
                ),
                const SizedBox(height: AppSpace.sm),
                Semantics(
                  button: true,
                  label: l10n.addExamDate,
                  value: d == null
                      ? l10n.addExamChooseDate
                      : DateFormat('EEEE d MMMM y', locale).format(d),
                  excludeSemantics: true,
                  child: Material(
                    color: c.ground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                      side: BorderSide(color: c.chipBorder),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                      onTap: onPickDate,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              d == null
                                  ? l10n.addExamChooseDate
                                  : DateFormat('EEE d MMM y', locale).format(d),
                              style: AppText.body.copyWith(
                                color: d == null ? c.muted : c.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (d != null) ...[
                  const SizedBox(height: AppSpace.xs),
                  Text(
                    l10n.addExamDaysFrom(d.difference(today).inDays),
                    style: AppText.caption.copyWith(color: c.muted),
                  ),
                ],
              ]),
              const SizedBox(height: AppSpace.lg),
              if (!editing)
                card([
                  Text(
                    l10n.addExamTime,
                    style: AppText.subtitle.copyWith(color: c.ink),
                  ),
                  const SizedBox(height: AppSpace.sm),
                  ValueStepper(
                    value: formatMinutes(l10n, minutes),
                    lessLabel: l10n.addExamLess,
                    moreLabel: l10n.addExamMore,
                    onLess: minutes > _step
                        ? () => onMinutes(minutes - _step)
                        : null,
                    onMore: minutes < _max
                        ? () => onMinutes(minutes + _step)
                        : null,
                  ),
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    l10n.addExamTimeHint,
                    style: AppText.caption.copyWith(color: c.muted),
                  ),
                ]),
              if (taskCount != null && !editing) ...[
                const SizedBox(height: AppSpace.lg),
                Text(
                  l10n.addExamTasks(taskCount!),
                  style: AppText.caption.copyWith(color: c.muted),
                ),
              ],
            ],
          ),
        ),
        if (failed)
          Text(
            l10n.addExamFailed,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: c.warningText),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, AppSpace.md, 20, 24),
          child: PrimaryButton(
            label: editing ? l10n.editExamSave : l10n.addExamSave,
            onPressed: valid && !saving ? onSave : null,
          ),
        ),
      ],
    );
  }
}
