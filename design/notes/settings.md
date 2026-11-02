# Settings (`/settings`) — design note

Built on 29 Oct 2026 under D36; comments welcome. Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`. Scope from `docs/03-phase1-scope.md` (theme, reminder time, export a backup) and `05-architecture.md` (backup and restore, diagnostics).

## Entry

The Settings tab, last in the bottom navigation, in Progress's place until 1.1 (D52). This replaced a 44 px round settings button at the right of Today's date line.

## Layout (one scrolling page, ground background, 20 px side padding)

- **Top bar:** the title "Settings" (Bricolage 22 px). No back button: it is a tab.
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

## Review schedule (D53)

A row in the Study section, under Study time: "Review schedule", with the gaps as its value ("1, 3, 7, 14, 30, 60 days").

Tapping it opens a bottom sheet in the style of the study-time sheet:

- **Title and hint:** "Review schedule"; "Days before each review, counted from the one before. Every task gets at least 5 reviews before the exam: when they don't fit, the gaps are squeezed. After the last gap, reviews repeat at it."
- **One row per review:** "Review 1" … with a stepper ("3 days"). Steps move through 1–7, 10, 14, 21, 30, 45, 60, 90, 120, 180 and 365 days. A gap is never shorter than the one before or longer than the one after, so the stepper stops there.
- **Text links:** "Add a review" (up to 10), "Remove the last" (at least 1), and "Reset to 1, 3, 7, 14, 30, 60" when the gaps differ from the default.
- **Save:** closes the sheet. Every task's schedule is re-fitted from its review history with the new gaps, and the plan updates.

Stored as the `review.gapDays` setting. A malformed value falls back to the default.
