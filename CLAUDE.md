# PrepBelt

An offline-first exam-preparation app for students, built with Flutter. Students add study sources (PDFs, books, videos, links), survey them, study them, and review each topic 5 times on a schedule fitted to the exam date. Each topic earns a level from 1 to 7, shown as a martial-arts belt (white to black). An exam planner schedules everything backwards from the exam date.

The name: PrepBelt says what the app does — exam prep, mastered belt by belt, from white to black. Belts are the signature progress system; the gems theme (1.2) is an optional alternative skin. Always show a belt as a martial-arts belt (knot, dojo), never as a trouser belt, which for some students can recall punishment at home.

## Read these first

The specs in `docs/` are the source of truth. When code and spec disagree, ask before changing either.

| File | What it defines |
| --- | --- |
| `docs/01-product.md` | Concept, features, user journeys, game design |
| `docs/02-data-model.md` | Every table, derived value and redefinition operation |
| `docs/03-phase1-scope.md` | What ships in 1.0, 1.1 and 1.2, acceptance criteria, milestones |
| `docs/04-planner-spec.md` | The scheduling algorithm, with a worked example |
| `docs/05-architecture.md` | Packages, folders, layers, platform integration, testing |
| `docs/06-screens.md` | The five designed screens and the design tokens |
| `design/mockups/*.html` | Source of the five mockups: exact colours, sizes, spacing and behaviour. Build screens to match them (see `design/README.md`) |

## Current status

Design is complete. No code exists yet. Start with `KICKOFF.md`, which covers milestones 1 and 2 (foundations and the review engine).

## Platforms and stack

- **1.0 targets Android and iOS only.** Web follows in 1.1, so keep code web-compatible (Drift supports a WASM backend) but do not ship or test web yet.
- Flutter latest stable (3.44 / Dart 3.12 or newer).
- Drift (SQLite) for storage, Riverpod 3 with code generation for state, go_router for navigation. No spaced-repetition package: the review schedule is our own simple rule (`docs/02-data-model.md`).
- Fully offline in phase 1. No accounts, no network calls, no analytics.

## Architecture rules (enforce these)

1. **Layers:** `features` → `engines` and `core`. `engines` depend on nothing but Dart and `core/time`. No Flutter imports in `lib/engines/`.
2. **Repositories are the only writers.** Every write changes the row and appends an `Event` row in the same Drift transaction. Screens never touch the database or repositories directly; they go through Riverpod providers.
3. **The Review table is append-only** and is the source of truth for mastery. `TaskState` and `PlanItem` are caches that can be rebuilt from it.
4. **Time is injected.** Never call `DateTime.now()` outside `core/time`. Engines take `now` as a parameter.
5. **Every tunable number is configuration**, not a literal: the review schedule (number of reviews, gap weights, retry gap), planner defaults. They live in the `Setting` table with defaults in one Dart file.
6. **Keep the review model simple.** Belts move only through reviews: Good earns the next belt, anything else dims it. Do not add a spaced-repetition algorithm (FSRS was removed on purpose).
7. **Themes are presentation only.** Data stores level 1–7 and a dim (brightness) value; belt names, colours and gems come from a `LevelTheme`.

## Conventions

- IDs are UUIDv7 strings. Timestamps are UTC milliseconds (int).
- Every syncable table has `id`, `createdAt`, `updatedAt`, `deletedAt` (soft delete), `hlc` and `deviceId`.
- Immutable domain types use `freezed`. Generated files are committed.
- Strings go in ARB files from the start (Hindi and other Indian languages later).
- Accessibility: contrast at least 4.5:1, touch targets at least 44 px, never colour alone (show level number or stripes), Semantics labels on badges and grid cells.

## Commands

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

## Design ownership

There is no separate designer for 1.0. You own the UI:

- **Five screens are designed** (`design/mockups/`). Match them closely.
- **Six screens are not designed** (First launch, Add exam, Sources list, Add source, Task detail, Settings). When their milestone comes, design them yourself in the same visual language: same tokens, components and patterns. Before building each one, describe its layout and states (empty, loading, filled, error) in a short note in `design/notes/` and ask for approval.
- **Build a component library first** (buttons, chips, session card, belt badge, stat tile, bottom sheet, nav bar) and compose screens from it.
- **Reward moments** (belt promotion, stripe lost and restored, streak) are built in code with `flutter_animate`: short (under about 1.5 s), skippable, with haptics. Keep timings in one place so they can be tuned.
- **Logo and app icon: approved (28 Oct 2026).** The icon is the "ring" concept in `design/brand/4-ring/`: a white checkmark inside five vivid rounded arcs (yellow, orange, green, blue, violet) on a navy-to-ink gradient. The owner chose it over belt-based marks, so it intentionally has no belt and uses colours outside the tokens. Belts remain the in-app progress system, and the in-app rule still applies: always a martial-arts belt, never a trouser belt.
  - Source geometry: `design/brand/src/build_brand.py` (`CHOSEN`). It writes the app assets to `assets/brand/`; render them to PNG, then run `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create` (steps in `design/brand/README.md`).
  - Keep all brand assets in `assets/brand/` so they can be refined later without code changes.
- **Verify the look** with golden tests of each screen in light and dark mode, at 360 and 390 widths, and at 1.3× text size.

## Decisions already made (do not reopen without asking)

- One exam at a time in 1.0; multiple exams in 1.1.
- A task belongs to exactly one topic. Merging across topics is blocked.
- Reviews: 5 per task after the first read, growing gaps fitted before the exam; Good earns the next belt (5 → Brown, Black by an extra review), Forgot/Hard dims and repeats the step next day; any task may be reviewed early and it counts.
- Source files are copied into app storage on every platform.
- Sources open in external apps; there is no in-app PDF reader.
- Flashcards and practice questions are optional and arrive in 1.2.
- Overdue reviews always come first in a day; there is no backlog cap.
- Students cannot drag sessions by hand; undone sessions become overdue and are replanned.
- No cram mode: the last 2 days before an exam are reviews only.
- Mock tests are availability overrides, not plan items.
- Shared template files use the `.belt` extension.
- Internal testers pilot 1.0 through Play Console internal testing and TestFlight.
- Default theme is Dojo (belts). Gems theme arrives in 1.2. The progress grid uses the "Night to sun" palette.
- App icon: the checkmark ring (`design/brand/4-ring/`), chosen by the owner on 28 Oct 2026.
