# PrepBelt — Flutter Architecture

PrepBelt is a layered, offline Flutter app: screens send actions down through Riverpod providers to repositories, which are the only code that writes the database. Screens update from Drift database streams, never by hand. Platform services (share-in, opening files, notifications) feed the providers. Engines hold every rule from the specs as pure Dart, so they are fast to test and can run in a background isolate.

```
 Platform                    Core stack                     Engines (pure Dart)
 ┌───────────────────┐       ┌──────────────────────┐       ┌──────────────────┐
 │ Share into app    │       │ Screens              │       │ Review engine    │
 │ Open and return   │       │   ↓ actions ↑ streams│       │ Planner engine   │
 │ Files, PDF outline│ ────▶ │ Riverpod providers   │ ────▶ │ Exam engine      │
 │ Notifications     │       │   ↓          ↑       │ calls │                  │
 └───────────────────┘       │ Repositories         │ ────▶ │                  │
                             │   ↓          ↑       │       └──────────────────┘
                             │ Drift database       │
                             │ (tables, events,     │
                             │  review log)         │
                             └──────────────────────┘
```

## Packages

Target the latest Flutter stable (3.44 with Dart 3.12, released May 2026, or newer). Versions were checked on 28 Oct 2026; pin them at project setup.

| Need | Package | Version checked | Notes |
| --- | --- | --- | --- |
| Database | drift, drift_flutter, drift_dev | 2.32.0 | SQLite on Android and iOS; WASM ready for web in 1.1 |
| State | flutter_riverpod, riverpod_annotation, riverpod_generator | 3.2.1 | Code-generated providers |
| Navigation | go_router | 17.1.0 | Typed routes |
| Share into the app | receive_sharing_intent | 1.9.0 | Android intent filters, iOS share extension (Swift Package Manager) |
| Open externally | open_filex | 4.7.0 | PDFs in the user's viewer; url_launcher for links |
| PDF outline, page count | pdfrx | 2.4.7 | Reads bookmarks offline; no in-app viewer |
| Files | file_picker, path_provider | latest stable | Import, app storage paths |
| Notifications | flutter_local_notifications | latest stable | One daily reminder |
| Models | freezed, json_serializable | latest stable | Immutable types, template export |
| IDs | uuid | latest stable | UUIDv7 |
| Motion | flutter_animate, lottie | latest stable | Promotion moments |


## Project structure

```
lib/
  main.dart                 // bootstrap: DB, providers, router, share listener
  app/                      // MaterialApp, router, theme selection
  core/
    db/                     // Drift tables, DAOs, migrations, event log
    ids/  time/  result/    // UUIDv7, injectable clock, error types
    config/                 // defaults for every tunable number
  engines/                  // pure Dart, no Flutter imports
    review/                 // review schedule, belt and brightness rules, rebuild
    planner/                // estimate, reachability, schedule, triage
    exam/                   // exam tier, readiness, weak links
  features/
    today/  session/  sources/  survey/  exams/
    tasks/  redefine/  progress/  onboarding/  settings/
      each: data/ (repository)  state/ (providers)  ui/ (screens, widgets)
  platform/
    share_in/  open_external/  pdf_outline/  notifications/  files/
  theme/
    tokens/  themes/dojo/  themes/gems/  palettes/
test/  integration_test/
```

**Dependency direction:** `features` → `engines` and `core`; `engines` → only Dart and `core/time`, `core/config`. Enforce with an import check in CI.

## Data layer

- Tables follow `02-data-model.md` exactly. Syncable tables share a mixin for id, timestamps, deletedAt, hlc and deviceId.
- One repository per aggregate (Source, Task, Exam, Review, Settings). Repositories are the only writers. Screens read through repository streams (Drift `watch`).
- **Event log:** each repository method writes `Event(entity, entityId, op, payload diff, hlc)` in the same transaction. Undo applies the inverse diff of the latest event for that entity, inside a new transaction that also logs an event.
- **Reviews are append-only.** `ReviewRepository.record()` writes the Review and updates TaskState through the review engine in one transaction.
- **Rebuild:** replays all Review rows to regenerate TaskState; must match exactly.
- **Migrations:** Drift step-by-step migrations, schema snapshots committed, a test per migration.
- **Files:** imported PDFs are copied to `<app documents>/sources/<uuid>.pdf`, SHA-256 de-duplicated. The database stores only the relative path.
- **Backup:** export zips the SQLite file and the sources folder; import replaces both after a version check.

## Domain engines

**Review engine** (`engines/review`)

- No spaced-repetition algorithm: a schedule of up to 5 reviews (set by the task's belt target) with growing gaps, fitted before the exam (`02-data-model.md`). Every number comes from configuration.
- `applyReview(state, rating, at, deadline) → (newState, levelBefore, levelAfter, stepAfter, dueAfter)`.
- `dueFor(state, deadline)`, `display(state, now)` (level, dim, stripes, fading) and `displayedLevel(state, now)`, which is always the stored level.
- `pause`, `resume` and `rebuild(reviews, pauses, deadline) → TaskState`.

**Planner engine** (`engines/planner`)

- `plan(PlannerInput, today) → List<PlanItem>`, implementing `04-planner-spec.md` step by step.
- Runs in `Isolate.run` with a snapshot of inputs; the result is written in one transaction as a new generation.
- Debounced: changes within 500 ms trigger one run. Deterministic.

**Exam engine** (`engines/exam`)

- Exam tier, projected tier, readiness, weak links, from `02-data-model.md`. Computed on read.

## State and navigation

| Provider | Type | Feeds |
| --- | --- | --- |
| `todayPlanProvider` | Stream | Today screen |
| `activeSessionProvider` | Notifier, persisted | The open session: task, start time, resume page |
| `examSummaryProvider(examId)` | Stream | Exam card and Exam screen |
| `surveyProvider(sourceId)` | Notifier | Survey flow |
| `redefineProvider(taskId)` | Notifier | Impact preview, then apply |
| `plannerProvider` | Notifier | Debounced replans, "Replanning…" status |
| `settingsProvider` | Stream | Theme, reminder time, review schedule |

**Routes:** `/today`, `/session/:taskId`, `/sources`, `/sources/new`, `/sources/:id/survey`, `/exams/:id`, `/tasks/:id`, `/tasks/:id/redefine`, `/settings`, `/onboarding`. First-time users redirect to `/onboarding`; a pending active session redirects to `/session/:taskId` on resume.

**Bottom navigation:** Today, Exams, Sources, Progress, with the add button in the middle.

## Platform integration

**Open externally and the return flow** (riskiest part; build and test on real devices in milestone 4)

1. Start writes ActiveSession (task, start time, resume page) before anything opens.
2. PDFs open with open_filex; links and videos with url_launcher.
3. On `AppLifecycleState.resumed` or cold start, if ActiveSession exists, route to Back from source with elapsed time filled in.
4. On iOS, open_filex may show the PDF in a system preview inside PrepBelt rather than switching apps; closing the preview then counts as returning. Test both paths.
5. If the student never returns, Today shows "Session in progress". After 6 hours the session closes as unfinished and the task becomes overdue.

**Share into the app**

- Android: intent filters for `application/pdf` and `text/plain` (links).
- iOS: a Share Extension target as receive_sharing_intent describes, passing files through an App Group.
- Read the initial shared item on cold start and listen to the stream while running; route to Add source pre-filled and copy the file into app storage.

**PDF outline**

- On import, read page count and bookmarks with pdfrx; turn bookmarks into chunk ranges (each runs to the page before the next bookmark).
- No bookmarks or a scanned PDF: fall back to a pasted table of contents or the size-based split.
- Verified at the start of milestone 3: pdfrx 2.4.7 (the newest release that supports Flutter 3.41) exposes `PdfDocument.loadOutline()` → `PdfOutlineNode(title, dest.pageNumber, children)`, so no fallback package is needed.

**Notifications**

- One daily reminder via flutter_local_notifications, inexact scheduling. Android 13+ needs the notification permission, asked at the end of onboarding.
- Reminder text is rescheduled after every plan run.

## Theming

- Tokens from the mockups (see `06-screens.md`).
- `LevelTheme` (a ThemeExtension) holds 7 level names, 7 colours, an action word (Promote / Polish), a dimming style (stripes / shine), an exam emblem and a badge builder. 1.0 ships Dojo; Gems in 1.2.
- Grid palette separate from the theme: Night to sun by default.
- Dark mode from day one. Accessibility as in `CLAUDE.md`. Strings in ARB files.

## Testing and release

| Layer | What | Tools |
| --- | --- | --- |
| Engine unit tests | Review rules, thresholds, rebuild equality, every planner rule, the worked example as a golden test | `test`, injected clock |
| Repository tests | Transactions, event log, undo of every redefinition, migrations | Drift in-memory database |
| Widget tests | Today, Back from source, Survey, Redefine | `flutter_test`, goldens in light and dark |
| Integration tests | Onboarding to first session, backup and restore | `integration_test` |
| Manual device matrix | Share-in, open and return, notifications | 3 Android vendors (Samsung, Xiaomi, stock Android) and 2 iPhones |

- **CI:** on every push run analyze, the import-direction check and all tests. On a release tag, build signed Android and iOS artifacts.
- **Distribution:** Play Console internal testing and TestFlight.
- **Diagnostics:** fully offline. Testers export a diagnostics file from Settings (app version, recent events, planner inputs, no file contents). Crash reporting, if added, must be opt-in.
