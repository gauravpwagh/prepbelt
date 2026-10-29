import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/config/defaults.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/fields.dart';
import '../../../core/ui/value_stepper.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../sources/ui/source_labels.dart';
import '../state/onboarding_providers.dart';

/// First launch (design/notes/first-launch.md): name and daily minutes,
/// the reminder, then the exam or skip.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _name = TextEditingController();
  int _step = 0;
  int _minutes = Defaults.defaultDailyMinutes;
  bool _busy = false;
  bool _failed = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Onboarding get _actions => ref.read(onboardingProvider.notifier);

  Future<void> _run(Future<void> Function() op) async {
    setState(() {
      _busy = true;
      _failed = false;
    });
    try {
      await op();
    } on Object {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: OnboardingBody(
        step: _step,
        name: _name,
        minutes: _minutes,
        busy: _busy,
        failed: _failed,
        onMinutes: (m) => setState(() => _minutes = m),
        onContinue: () => _run(() async {
          await _actions.saveProfile(name: _name.text, minutes: _minutes);
          setState(() => _step = 1);
        }),
        onReminder: (on) => _run(() async {
          await _actions.setReminder(on: on);
          setState(() => _step = 2);
        }),
        onAddExam: () => context.go(Routes.newExam),
        onSkip: () => context.go(Routes.today),
      ),
    ),
  );
}

/// The three steps. Public so goldens can render each one.
class OnboardingBody extends StatelessWidget {
  const OnboardingBody({
    required this.step,
    required this.name,
    required this.minutes,
    required this.onMinutes,
    required this.onContinue,
    required this.onReminder,
    required this.onAddExam,
    required this.onSkip,
    this.busy = false,
    this.failed = false,
    super.key,
  });

  /// 0 welcome, 1 reminder, 2 exam.
  final int step;
  final TextEditingController name;
  final int minutes;
  final bool busy;
  final bool failed;
  final ValueChanged<int> onMinutes;
  final VoidCallback onContinue;
  final ValueChanged<bool> onReminder;
  final VoidCallback onAddExam;
  final VoidCallback onSkip;

  static const _step = 15;
  static const _max = 8 * 60;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;

    final dots = Semantics(
      label: l10n.onboardStep(step + 1),
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(width: AppSpace.sm),
            Container(
              width: i == step ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == step ? c.accent : c.line,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
          ],
        ],
      ),
    );

    final List<Widget> content;
    final List<Widget> actions;
    switch (step) {
      case 0:
        content = [
          Center(
            child: ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/brand/icon.png',
                  width: 72,
                  height: 72,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          Text(
            'PrepBelt',
            textAlign: TextAlign.center,
            style: AppText.display.copyWith(color: c.ink),
          ),
          Text(
            l10n.onboardTagline,
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: c.muted),
          ),
          const SizedBox(height: 32),
          LabeledField(
            label: l10n.onboardName,
            controller: name,
            hint: l10n.onboardNameHint,
            onChanged: (_) {},
          ),
          const SizedBox(height: AppSpace.xl),
          Text(
            l10n.onboardMinutes,
            style: AppText.subtitle.copyWith(color: c.ink),
          ),
          const SizedBox(height: AppSpace.sm),
          ValueStepper(
            value: formatMinutes(l10n, minutes),
            lessLabel: l10n.addExamLess,
            moreLabel: l10n.addExamMore,
            onLess: minutes > _step ? () => onMinutes(minutes - _step) : null,
            onMore: minutes < _max ? () => onMinutes(minutes + _step) : null,
          ),
          const SizedBox(height: AppSpace.sm),
          Text(
            l10n.onboardMinutesHint,
            style: AppText.caption.copyWith(color: c.muted),
          ),
        ];
        actions = [
          PrimaryButton(
            label: l10n.onboardContinue,
            onPressed: busy ? null : onContinue,
          ),
        ];
      case 1:
        content = [
          const SizedBox(height: 48),
          Center(child: AppIconView(AppIcon.flame, color: c.flame, size: 48)),
          const SizedBox(height: AppSpace.xl),
          Text(
            l10n.onboardReminderTitle,
            textAlign: TextAlign.center,
            style: AppText.display.copyWith(color: c.ink, fontSize: 26),
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            l10n.onboardReminderBody,
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: c.muted),
          ),
        ];
        actions = [
          PrimaryButton(
            label: l10n.onboardReminderOn,
            onPressed: busy ? null : () => onReminder(true),
          ),
          Align(
            child: TextLinkButton(
              label: l10n.onboardReminderOff,
              onPressed: busy ? null : () => onReminder(false),
            ),
          ),
        ];
      default:
        content = [
          const SizedBox(height: 48),
          Center(
            child: AppIconView(AppIcon.exams, color: c.accentText, size: 48),
          ),
          const SizedBox(height: AppSpace.xl),
          Text(
            l10n.onboardExamTitle,
            textAlign: TextAlign.center,
            style: AppText.display.copyWith(color: c.ink, fontSize: 26),
          ),
          const SizedBox(height: AppSpace.md),
          Text(
            l10n.onboardExamBody,
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: c.muted),
          ),
        ];
        actions = [
          PrimaryButton(label: l10n.onboardAddExam, onPressed: onAddExam),
          const SizedBox(height: AppSpace.sm),
          SecondaryButton(label: l10n.onboardSkip, onPressed: onSkip),
        ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), child: dots),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            children: content,
          ),
        ),
        if (failed)
          Text(
            l10n.onboardFailed,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: c.warningText),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, AppSpace.md, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions,
          ),
        ),
      ],
    );
  }
}
