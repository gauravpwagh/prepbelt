# Settings (`/settings`) — design note

Built on 29 Oct 2026 under D36; comments welcome. Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`. Scope from `docs/03-phase1-scope.md` (theme, reminder time, export a backup) and `05-architecture.md` (backup and restore, diagnostics).

## Entry

A 44 px round settings button at the right of Today's date line, next to the streak pill.

## Layout (one scrolling page, ground background, 20 px side padding)

- **Top bar:** back button and the title "Settings" (Bricolage 22 px).
- **Sections:** each has a 12 px overline title, then a surface card of rows. Rows are at least 52 px tall, with the title in 15 px semibold, the value or explanation in 12 px muted, and a trailing control or chevron.

| Section | Rows |
| --- | --- |
| **STUDY** | **Study time:** "Mon–Sat 1 h 30 min · Sun 4 h", opens the weekday sheet. |
| **REMINDER** | **Daily reminder:** a switch. **Time:** "19:00", opens the platform time picker; greyed out while the reminder is off. |
| **LOOK** | **Belt theme:** "Dojo", with a check and the caption "Gems arrives in a later version." |
| **YOUR DATA** | **Export a backup:** "One file with everything, sources included". **Restore from a backup:** "Replaces what is on this phone". **Export diagnostics:** "For testers: app version, recent changes, plan summary. No file contents". |
| **ABOUT** | "PrepBelt 0.1.0 · Works offline. Nothing leaves your phone unless you export it." |
| **DEBUG** (debug builds only) | **Rebuild mastery from the review log.** |

## Backup and restore

- **The file:** a `.zip` holding
  - `manifest.json` (format, backup version, schema version, time, counts);
  - `prepbelt.sqlite` (a consistent copy made with `VACUUM INTO`);
  - the `sources/` folder.
- **Export:** saves through the platform's save dialog as `prepbelt-backup-2026-10-29.zip`. A snackbar confirms it.
- **Restore:**
  - Pick a file, then a confirmation dialog: "Replace everything on this phone with the backup from 29 Oct 2026? This can't be undone."
  - The backup is checked first: right format, and a schema no newer than the app's. It is then staged next to the database.
  - On the next start, before the database opens, it replaces the database and sources folder; the backup's schema is migrated as usual.
  - Android offers "Restart now". iOS asks the student to close and reopen PrepBelt.
- **Errors:** "This isn't a PrepBelt backup." / "This backup is from a newer PrepBelt. Update the app first." / "Couldn't save the backup."
- **First launch:** a text link "Restore a backup" under step 1, so a new phone can start from a backup.

## States

| State | What shows |
| --- | --- |
| Loading | The rows with empty values (settings load in under 100 ms). |
| Working | While exporting or restoring, that row shows a small progress ring and the others are disabled. |
| Error | A snackbar with the message above. |
