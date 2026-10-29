import '../../../l10n/gen/app_localizations.dart';
import '../state/reminder_providers.dart';

/// The daily reminder's localised text.
ReminderText reminderText(AppLocalizations l10n) => (
  title: l10n.reminderTitle,
  body: l10n.reminderBody,
  channel: l10n.reminderChannel,
);
