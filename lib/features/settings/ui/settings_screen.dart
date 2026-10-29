import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/config/app_info.dart';
import '../../../core/config/defaults.dart';
import '../../../core/ui/app_icons.dart';
import '../../../core/ui/buttons.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../theme/tokens/app_tokens.dart';
import '../../exams/state/exam_view_providers.dart';
import '../../exams/ui/week_sheet.dart';
import '../../tasks/state/task_providers.dart';
import '../../today/ui/reminder_text.dart';
import '../state/settings_actions.dart';
import '../state/settings_providers.dart';

/// Picks a backup, checks it, asks to confirm, and stages it for the next
/// start (design/notes/settings.md). Used by Settings and first launch.
Future<void> restoreBackup(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final locale = Localizations.localeOf(context).toLanguageTag();
  final actions = ref.read(settingsActionsProvider.notifier);
  final DateTime? made;
  try {
    made = await actions.stageRestore();
  } on BackupError catch (e) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          e.problem == BackupProblem.tooNew
              ? l10n.backupTooNew
              : l10n.backupNotABackup,
        ),
      ),
    );
    return;
  }
  if (made == null || !context.mounted) return;
  final c = context.colors;
  final ok = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      backgroundColor: c.surface,
      title: Text(
        l10n.restoreConfirmTitle,
        style: AppText.section.copyWith(color: c.ink),
      ),
      content: Text(
        l10n.restoreConfirmBody(
          DateFormat('d MMM y', locale).format(made!.toLocal()),
        ),
        style: AppText.body.copyWith(color: c.ink),
      ),
      actions: [
        TextLinkButton(
          label: l10n.redefineCancel,
          onPressed: () => Navigator.of(dialog).pop(false),
        ),
        TextLinkButton(
          label: l10n.restoreConfirm,
          onPressed: () => Navigator.of(dialog).pop(true),
        ),
      ],
    ),
  );
  if (!(ok ?? false)) {
    await actions.cancelRestore();
    return;
  }
  if (!context.mounted) return;
  final android = !kIsWeb && Platform.isAndroid;
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialog) => AlertDialog(
      backgroundColor: c.surface,
      title: Text(
        l10n.restoreReadyTitle,
        style: AppText.section.copyWith(color: c.ink),
      ),
      content: Text(
        android ? l10n.restoreReadyAndroid : l10n.restoreReadyIos,
        style: AppText.body.copyWith(color: c.ink),
      ),
      actions: [
        if (android) ...[
          TextLinkButton(
            label: l10n.restoreLater,
            onPressed: () => Navigator.of(dialog).pop(),
          ),
          TextLinkButton(
            label: l10n.restoreRestart,
            onPressed: SystemNavigator.pop,
          ),
        ] else
          TextLinkButton(
            label: l10n.restoreLater,
            onPressed: () => Navigator.of(dialog).pop(),
          ),
      ],
    ),
  );
}

/// Settings (design/notes/settings.md).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.showDebugActions = kDebugMode});

  final bool showDebugActions;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// The row doing slow work (export, restore, diagnostics), if any.
  String? _busy;

  SettingsActions get _actions => ref.read(settingsActionsProvider.notifier);

  Future<void> _work(String row, Future<void> Function() op) async {
    setState(() => _busy = row);
    try {
      await op();
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final settings = ref.watch(settingsProvider).value ?? const {};
    final week = ref.watch(weekMinutesProvider).value;
    final rebuild = ref.watch(masteryRebuildProvider);
    final text = reminderText(l10n);
    return Scaffold(
      body: SafeArea(
        child: SettingsBody(
          settings: settings,
          week: week,
          busy: _busy,
          showDebug: widget.showDebugActions,
          onBack: () => context.pop(),
          onEditWeek: week == null
              ? null
              : () => showWeekSheet(
                  context,
                  week: week,
                  onSave: _actions.setWeek,
                ),
          onReminder: (on) => _actions.setReminder(on: on, text: text),
          onReminderTime: () async {
            final current = _time(settings[SettingKeys.reminderTime]);
            final picked = await showTimePicker(
              context: context,
              initialTime: current,
            );
            if (picked == null) return;
            final hh = picked.hour.toString().padLeft(2, '0');
            final mm = picked.minute.toString().padLeft(2, '0');
            await _actions.setReminderTime('$hh:$mm', text);
          },
          onExport: () => _work('export', () async {
            try {
              if (await _actions.exportBackup()) {
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.backupSaved)),
                );
              }
            } on Object {
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.backupFailed)),
              );
            }
          }),
          onRestore: () => _work('restore', () => restoreBackup(context, ref)),
          onDiagnostics: () => _work('diagnostics', () async {
            if (await _actions.exportDiagnostics()) {
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.diagnosticsSaved)),
              );
            }
          }),
          onRebuild: rebuild.isLoading
              ? null
              : () async {
                  final count = await ref
                      .read(masteryRebuildProvider.notifier)
                      .run();
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.debugRebuildDone(count))),
                  );
                },
        ),
      ),
    );
  }
}

TimeOfDay _time(Object? value) {
  final parts = (value is String ? value : Defaults.reminderTime).split(':');
  return TimeOfDay(
    hour: int.tryParse(parts.first) ?? 19,
    minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
  );
}

/// The settings page for given values. Public so goldens can render it.
class SettingsBody extends StatelessWidget {
  const SettingsBody({
    required this.settings,
    required this.onBack,
    required this.onReminder,
    required this.onReminderTime,
    required this.onExport,
    required this.onRestore,
    required this.onDiagnostics,
    this.week,
    this.onEditWeek,
    this.onRebuild,
    this.busy,
    this.showDebug = false,
    super.key,
  });

  final Map<String, Object?> settings;
  final List<int>? week;
  final String? busy;
  final bool showDebug;
  final VoidCallback onBack;
  final VoidCallback? onEditWeek;
  final ValueChanged<bool> onReminder;
  final VoidCallback onReminderTime;
  final VoidCallback onExport;
  final VoidCallback onRestore;
  final VoidCallback onDiagnostics;
  final VoidCallback? onRebuild;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = context.colors;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final reminderOn =
        settings[SettingKeys.reminderEnabled] != false &&
        settings[SettingKeys.reminderAsked] == true;
    final time = _time(settings[SettingKeys.reminderTime]);
    final timeText =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
    final idle = busy == null;

    Widget section(String title, List<Widget> rows) => Padding(
      padding: const EdgeInsets.only(top: AppSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: AppText.overline.copyWith(color: c.muted),
            ),
          ),
          const SizedBox(height: AppSpace.sm),
          Container(
            decoration: BoxDecoration(
              color: c.surface,
              border: Border.all(color: c.line),
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (var i = 0; i < rows.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: c.line),
                  rows[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Row(
          children: [
            RoundIconButton.back(context, onBack),
            const SizedBox(width: AppSpace.lg),
            Text(
              l10n.screenSettings,
              style: AppText.heroTitle.copyWith(color: c.ink),
            ),
          ],
        ),
        section(l10n.settingsStudy, [
          _Row(
            title: l10n.examStudyTime,
            subtitle: week == null ? '' : weekSummary(l10n, locale, week!),
            onTap: idle ? onEditWeek : null,
          ),
        ]),
        section(l10n.settingsReminder, [
          _Row(
            title: l10n.settingsReminderOn,
            subtitle: l10n.settingsReminderOnHint,
            trailing: Switch(
              value: reminderOn,
              activeThumbColor: c.onAccent,
              activeTrackColor: c.accent,
              onChanged: idle ? onReminder : null,
            ),
            onTap: idle ? () => onReminder(!reminderOn) : null,
            toggled: reminderOn,
          ),
          _Row(
            title: l10n.settingsReminderTime,
            subtitle: timeText,
            onTap: reminderOn && idle ? onReminderTime : null,
          ),
        ]),
        section(l10n.settingsLook, [
          _Row(
            title: l10n.settingsTheme,
            subtitle: '${l10n.settingsThemeDojo} · ${l10n.settingsThemeHint}',
            trailing: AppIconView(AppIcon.check, color: c.accentText, size: 20),
          ),
        ]),
        section(l10n.settingsData, [
          _Row(
            title: l10n.settingsExport,
            subtitle: l10n.settingsExportHint,
            working: busy == 'export',
            onTap: idle ? onExport : null,
          ),
          _Row(
            title: l10n.settingsRestore,
            subtitle: l10n.settingsRestoreHint,
            working: busy == 'restore',
            onTap: idle ? onRestore : null,
          ),
          _Row(
            title: l10n.settingsDiagnostics,
            subtitle: l10n.settingsDiagnosticsHint,
            working: busy == 'diagnostics',
            onTap: idle ? onDiagnostics : null,
          ),
        ]),
        if (showDebug)
          section(l10n.settingsDebug, [
            _Row(title: l10n.debugRebuild, onTap: onRebuild),
          ]),
        section(l10n.settingsAbout, [
          _Row(title: l10n.settingsAboutText(appVersion)),
        ]),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.working = false,
    this.toggled,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool working;

  /// For a switch row: its state, read out by screen readers.
  final bool? toggled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasText = subtitle != null && subtitle!.isNotEmpty;
    return Semantics(
      button: onTap != null && toggled == null,
      toggled: toggled,
      enabled: onTap != null || trailing == null,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.cardTitle.copyWith(
                          color: c.ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (hasText)
                        Text(
                          subtitle!,
                          style: AppText.caption.copyWith(color: c.muted),
                        ),
                    ],
                  ),
                ),
                if (working)
                  SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: c.muted,
                    ),
                  )
                else if (trailing != null)
                  ExcludeSemantics(child: trailing)
                else if (onTap != null)
                  AppIconView(AppIcon.more, color: c.muted, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
