# Kickoff: Milestones 1 and 2

Paste the prompt below into Claude Code from the root of an empty repository that contains this handover pack (`CLAUDE.md`, `KICKOFF.md`, `docs/`).

---

## Prompt

Read `CLAUDE.md` and every file in `docs/` before writing code. Then build milestones 1 and 2 of PrepBelt as described below. Work in small commits, one per step. Stop and ask me if a spec is ambiguous or two specs disagree; do not guess.

### Milestone 1 — Foundations

1. **Create the Flutter project** `prepbelt` (org `app.prepbelt` unless I say otherwise) for Android and iOS. Keep the code web-compatible but do not add a web target yet. Set up the folder structure from `docs/05-architecture.md`.
2. **Add dependencies** from the Packages table, pinned to current stable versions. Set up `build_runner`, `freezed`, `riverpod_generator` and `drift_dev`. Add strict analysis options.
3. **Core utilities:** an injectable `Clock` in `core/time`, UUIDv7 ids in `core/ids`, and `core/config/defaults.dart` holding every tunable number from the specs (level thresholds, retention target, planner defaults).
4. **Drift schema:** all 26 tables from `docs/02-data-model.md`, with the shared convention columns as a mixin, the indexes listed there, and a schema snapshot for migrations.
5. **Event log and repositories:** a base repository that writes a row and its `Event` in one transaction. Implement `SourceRepository`, `TaskRepository`, `ExamRepository` and `SettingsRepository` with create, update, soft delete, watch streams, and undo of the last event per entity.
6. **Theme tokens:** `theme/tokens` from `docs/06-screens.md` and the exact values in `design/mockups/` (light and dark), and a `LevelTheme` ThemeExtension with the Dojo theme (names, colours, stripes decay style, badge builder). Add a `BeltBadge` widget that always shows the level number or stripes in addition to colour, with a Semantics label.
7. **App shell:** go_router with the routes from the architecture doc as placeholder screens, the bottom navigation, and Riverpod `ProviderScope` bootstrapping the database.
8. **CI:** a GitHub Actions workflow running `flutter analyze`, an import-direction check (no Flutter or Drift imports under `lib/engines/`), and `flutter test`.

**Milestone 1 is done when:** the app launches on Android and iOS to the placeholder Today screen; repository tests prove every write logs an Event and undo restores the previous row; the migration test passes; CI is green.

### Milestone 2 — Review engine

1. **`SpacedRepetition` interface** in `lib/engines/review`, with `FsrsScheduler` wrapping the `fsrs` package. No other file may import `fsrs`.
2. **Rules:** `applyReview`, `levelFor(stability)`, `shineFor(retrievability)`, `displayedLevel(state, now)` (drops one level when R < 0.7 and overdue, without changing stored level), and `rebuild(reviews)`. First read sets level 1; later levels follow the stability table in the data model doc, read from configuration.
3. **ReviewRepository.record()** writes the Review row (append-only, with levelBefore, levelAfter, stabilityAfter, dueAfter), updates TaskState through the engine, and logs an Event — all in one transaction.
4. **Pause handling:** paused tasks don't decay; on resume, dueAt shifts by the paused duration.
5. **Rebuild command:** recompute every TaskState from Review rows; expose it as a debug action.

**Tests required for milestone 2** (all with an injected clock):

- A sample history of Good ratings promotes a task through levels in order, never skipping the first-read level-1 rule.
- Forgot after several Good reviews lowers stability and never deletes reviews.
- `displayedLevel` drops by one when overdue with R below 0.7, and one Good review restores it.
- `rebuild(reviews)` produces a TaskState identical to the one built incrementally, for at least 5 randomised histories (seeded).
- Changing level thresholds in configuration changes `levelFor` without code changes.
- Pausing for 10 days then resuming shifts dueAt by 10 days.
- No file outside `lib/engines/review` imports `fsrs` (checked in CI).

**Milestone 2 is done when** all of the above pass and CI is green.

### Also in milestone 1: start the component library

Add `BeltBadge`, a primary and secondary button, a chip, and a session card as widgets in `lib/theme/` or `lib/core/ui/`, each with golden tests in light and dark mode, matching `design/mockups/1-today.html`. Screens come later, but these components set the visual language early.

### Also in milestone 1: logo and app icon concepts

Following "Design ownership" in `CLAUDE.md`, create 3 logo and app icon concepts as SVG in `design/brand/`, with previews at 1024, 192 and 48 px on light and dark backgrounds and a short rationale each. Stop and ask me to choose one. Until I choose, use a temporary icon.

### Out of scope for now

Screens beyond placeholders, the planner, share-in, opening files externally, notifications. Those are milestones 3–6 in `docs/03-phase1-scope.md`.

When both milestones are done, summarise what was built, list any spec ambiguities you hit and how you resolved them, and propose the plan for milestone 3.
