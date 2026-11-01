# Study folder, automatic backup and editing a source — design note (D51)

The owner decided, on 1 Nov 2026, that a folder the student chooses is the only place source files live. A backup of everything else is written into it on a schedule. Clearing the app's data, or reinstalling it, then loses nothing: the student picks the folder again and restores.

## The folder

```
PrepBelt/                          ← the folder the student picks (any name, any place)
  HC Verma Vol 1.pdf               ← PDFs added from elsewhere are copied here, named by title
  Physics/Optics notes.pdf         ← PDFs already in the folder stay where they are
  Backups/
    prepbelt-backup-2026-11-01.zip ← database only, no PDFs
    prepbelt-backup-2026-10-31.zip
    …                              ← the newest 7 (`backup.keep`)
```

- **Choosing it:** the system folder picker (Android: Storage Access Framework, permission kept across restarts). The student may create a new folder in the picker. PrepBelt keeps the folder in a device file (see Data effects).
- **iOS for now:** a `PrepBelt` folder inside the app's own storage, with no picker. It is not shown in the Files app, because sharing the Documents folder would also show the database. It goes with the app on uninstall, so Export a backup stays the way to keep a copy. A picker with a saved bookmark (iCloud Drive or On My iPhone) needs a Mac to build and test. The code goes through one `StudyFolder` interface, so it can be swapped later.
- **Adding a PDF:** the picker opens in the study folder.
  - A PDF picked from inside the folder is used in place (its path inside the folder is stored).
  - A PDF picked from elsewhere, or shared into the app, is copied into the folder's top level as "<title>.pdf" (" (2)" added if the name is taken).
  - The duplicate check by SHA-256 stays.
- **Opening a source:** the PDF in the folder opens in the student's PDF app, as before.
- **Removing a source** never deletes its PDF from the folder. The folder is the student's.

## When the file is not found (relink)

The source screen's "Open" first checks the file. If it is missing:

1. PrepBelt searches the folder for a PDF with the same size and SHA-256. If exactly one is found, it relinks to it silently.
2. Otherwise a sheet: **"Can't find HC Verma Vol 1.pdf"**, body "It may have been moved, renamed or deleted from your PrepBelt folder." Primary **"Find the file"** opens the picker in the folder; secondary "Cancel".
   - A file picked inside the folder is linked in place; one from elsewhere is copied in first.
   - A different file (other SHA-256): "This isn't the same file as before. Use it anyway?" Its pages may differ, so chapters are kept as they are.
3. With no folder available (the permission was lost, or the folder was deleted): **"Your PrepBelt folder isn't available"** with "Choose folder".

The source card and source screen show nothing until the file is needed. Studying, reviews and the plan never depend on the file.

## Automatic backup

- **What:** the database only (`VACUUM INTO` copy) with `manifest.json`, backup version 2. It is small, a few MB.
- **When:** when the app opens or goes to the background, if the last backup is older than `backup.everyDays` (1 by default; Settings offers Every day, Every 3 days, Every week) and something changed since.
- **How:**
  - Written as a temporary file, then renamed, so a broken write never replaces a good backup.
  - Today's file is replaced if it already exists.
  - Backups beyond the newest 7 are deleted.
  - A failure is silent at the time; Settings shows it.
- **Back up now** in Settings writes one at once.

## First launch

Step 1 gets a new step after it. Restore moves into this step too.

**Step 2, "Where should PrepBelt keep your files?"**
- Body: "Pick or create a folder, for example Documents/PrepBelt. Your PDFs live there, and a backup is saved there every day. If you reinstall PrepBelt, pick the same folder to get everything back."
- Primary **"Choose folder"**.
- Text button "Not now". Without a folder, nothing is backed up, and adding a PDF asks for a folder first.
- If the chosen folder holds backups, the newest is offered with Restore's usual confirmation ("Replace everything on this phone with the backup from 31 Oct 2026?"), Cancel / **Restore**. Restore swaps it in at the next start (D43); Cancel starts fresh.

The steps become: Welcome, Folder, Reminder, Exam (4 pills). The "Restore a backup" link on step 1 stays, for a backup file kept somewhere else.

## Settings: "YOUR DATA"

| Row | Shows |
| --- | --- |
| **PrepBelt folder** | Its name ("Documents/PrepBelt"), or "Not chosen: PDFs can't be added and nothing is backed up". A tap chooses another. |
| **Automatic backup** | "Every day · last 1 Nov, 08:12", "Every day · last backup failed" (warning colour), or "Off: choose a folder first". A tap opens the frequency sheet. |
| **Back up now** | Writes a backup now. A snackbar confirms it. |
| Export a backup / Restore from a backup / Export diagnostics | As before (D43). |

**Choosing another folder:** each source PDF is copied into the new folder, and the links are updated. The old folder is left untouched. Backups start fresh in the new folder.

**Older installs:** PDFs still in app storage (`sources/`) keep working until a folder is chosen. Choosing one moves them into it, and app storage is then cleared of them. Today shows a one-line card "Choose a folder for your PDFs and backups" until then, if the student has PDF sources.

Restoring an old backup (version 1, PDFs inside): its PDFs go to app storage as before, then move into the folder as for an older install.

## Edit source (replaces Rename)

The ⋮ sheet's "Rename" becomes **"Edit details"**, a screen at `/sources/:id/edit` in Add source's style:

| Field | For | Rule |
| --- | --- | --- |
| Title | All | Required. |
| Link | Video, link | A web address, or empty. |
| Total pages / minutes | Book (pages), video (minutes) | At least the last chapter's end. A PDF takes its page count from the file. |
| File | PDF | Its name in the folder, with "Choose another file", which works as relink above. |

- Type and chapters are not edited here; chapters are edited on the source screen.
- **Save** writes one Event and offers Undo in a snackbar.
- **States:**
  - Filled: as above.
  - Invalid: an inline message under the field, and Save stays off.
  - Error: "Couldn't save. Try again."

## Data effects

- **Schema v5:** `SourceFile.place` (`app` for app storage, `folder` for the study folder; existing rows are `app`).
- **Settings:** `backup.everyDays` (default in `defaults.dart`, with `backup.keep` 7).
- **Device file** (`device.json` in app storage, not in the database or the backup, gone with the app's data): the folder, and the last backup time and failure. A restored backup never brings another phone's folder, and noting a backup is not itself a change to back up.
- **Edits:** a relink and an edit each update rows and append an Event.
