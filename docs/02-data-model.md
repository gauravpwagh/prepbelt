# PrepBelt — Data Model (Phase 1)

## Principles

Phase 1 stores everything locally in one SQLite database (Drift), shaped so phase-2 sync needs no migration of meaning. Mastery is computed from an append-only review log; every other number on screen is derived from it.

- **What vs where.** A Task is the thing being learned (a topic); Sources and Chunks are where it is learned from. Mastery belongs to the Task, so swapping a book never wipes progress.
- **Personal vs shared.** Templates carry structure and exam importance. Difficulty, familiarity and mastery are personal and never exported by default.
- **Exam-scoped importance.** Importance and target level live on the exam link, not on the task, because the same topic matters differently to different exams.
- **Theme-agnostic progress.** Data stores a level 1–7 plus a retention value. Belts, gems or palettes are a presentation layer.
- **Stored vs derived.** Stored: user input and the review and event logs. Cached: FSRS state and level on the task, the generated plan. Derived on read: exam tier, readiness, XP, streaks, both grids.

Conventions on every syncable table:

| Column | Type | Purpose |
| --- | --- | --- |
| id | UUIDv7 text | Globally unique, time-ordered, safe to create offline |
| createdAt | int (UTC ms) | Audit and sorting |
| updatedAt | int (UTC ms) | Last-writer-wins for simple fields |
| deletedAt | int, nullable | Soft delete; rows are never physically removed in phase 1 |
| hlc | text | Hybrid logical clock stamp, filled now, used by sync later |
| deviceId | text | Origin device, constant per install in phase 1 |

## Entity relationships

- Source 1–n SourceFile; Source 1–n Chunk; Chunk 1–1 ChunkSurvey.
- Exam 1–n ExamChunk (survey importance) — prefills — ExamTask (exam ↔ task, importance, target).
- Task n–n Chunk through TaskChunk. Task 1–1 TaskState (cache). Task 1–n Review (append-only). Task 1–n Card; Card 1–n CardResult.
- Topic 1–n Task (each task belongs to exactly one topic; a rough task may have none until refined).
- Availability feeds PlanItem; PlanItem is generated from everything above.
- Review is the only source of truth for mastery; TaskState, PlanItem and both grids are rebuilt from it.

## Tables

26 tables in seven groups. Convention columns are omitted below. FK = foreign key; `?` = nullable.

### Syllabus and sources

| Table | Key fields | Notes |
| --- | --- | --- |
| Topic | parentId?, name, subject?, order | Syllabus tree node. Comes from a template or is user-made. |
| Source | type (pdf, book, video, link, notes, qbank), title, uri?, unitType (page, minute, question, item), totalUnits? | Where material lives. uri = file path, URL or app deep link. |
| SourceFile | sourceId FK, localPath, bytes, sha256 | Every file-based source is copied into app storage. Web (1.1) stores it in OPFS. |
| Chunk | sourceId FK, parentChunkId?, title, order, startUnit?, endUnit?, sizeUnits? | Chapter or section. Nests for parts within chapters. |
| ChunkSurvey | chunkId FK (unique), difficulty (1–3), familiarity (0–2), surveyedAt | Personal. One row per chunk. |

### Tasks and mastery

| Table | Key fields | Notes |
| --- | --- | --- |
| Task | topicId?, title, kind (learn, practice), status (active, paused, archived), needsDetail | The unit that earns a level. Belongs to exactly one Topic; a rough task may have none until refined. |
| TaskChunk | taskId FK, chunkId FK, startUnit?, endUnit?, order | Many-to-many: a task can span several chunks or sources, or part of one. |
| TaskState | taskId FK (unique), level (0–7), fsrsStability, fsrsDifficulty, lastReviewAt?, dueAt?, reps, lapses, pausedAt? | Cache, rebuildable by replaying Review rows. level 0 = not started. |
| Review | taskId FK, at, kind (firstRead, review, quiz), rating (1–4), durationSec, resumeUnit?, levelBefore, levelAfter, stabilityAfter, dueAfter | Append-only. Source of truth for mastery and both grids. |
| TaskLineage | childTaskId FK, parentTaskId FK, op (split, merge, expand), at | Lets history follow a task through redefinitions. |
| Card | taskId FK, type (flash, mcq), front, back, options? (JSON), order | Optional flashcards and practice questions (1.2). |
| CardResult | cardId FK, reviewId FK, correct, answerMs | Quiz outcomes. A quiz review's rating is derived from these. |

### Exams and planning

| Table | Key fields | Notes |
| --- | --- | --- |
| Exam | name, date, priority (1–3), status (upcoming, done, archived), resultNote? | One row per exam. |
| ExamChunk | examId FK, chunkId FK, importance (high, medium, low) | Importance captured in the survey. Prefills ExamTask. |
| ExamTask | examId FK, taskId FK, importance, targetLevel (1–7), importanceOverridden | Drives the planner, exam tier and timeline. Unique per (exam, task). |
| Availability | weekday (0–6), minutes, lockedExamId? | Weekly study budget, e.g. Sunday locked to one exam (1.1). |
| AvailabilityOverride | date, minutes, lockedExamId? | Holidays, mock-test days, sick days, planned breaks. |
| PlanItem | date, taskId FK, examId?, kind (firstRead, review, finalReview), estMinutes, status (planned, done, skipped, moved), generation | Generated schedule for the Today screen. Regenerated, never hand-edited. |

### Gamification

| Table | Key fields | Notes |
| --- | --- | --- |
| Quest | date, type, target, progress, completedAt? | Daily quests (1.1). |
| Achievement | code (unique), unlockedAt | One-off unlocks (1.2). |
| RestToken | earnedAt, usedOn? | Streak protection (1.1). |

XP, level-ups and streaks are not stored; they are computed from Review.

### Templates and settings

| Table | Key fields | Notes |
| --- | --- | --- |
| Template | kind (syllabus, sourceList, examPack), name, author?, version, origin (local, imported), payload (JSON), importedAt? | Record of shared bundles, so re-imports update instead of duplicating. |
| ImportMap | templateId FK, externalId, localTable, localId | Maps ids inside a bundle to local rows. |
| Setting | key (unique), value (JSON) | Theme, grid palette, reminder time, retention target (default 90%, one global value), FSRS parameters, level thresholds, planner defaults. |

### Sync and undo

| Table | Key fields | Notes |
| --- | --- | --- |
| Event | entity, entityId, op (create, update, delete, split, merge, review), payload (JSON diff), hlc, deviceId | Every mutation, written in the same transaction as the change. Powers undo now and sync later. |

### Session

| Table | Key fields | Notes |
| --- | --- | --- |
| ActiveSession | taskId FK, startedAt, resumeUnit? | At most one row. Persists an in-progress session across app kills, so the return flow works. Not synced. See `05-architecture.md`. |

## Derived values

Computed from TaskState, Review and ExamTask; nothing here is stored except as a cache.

**Level (1–7) from FSRS stability.** The first read sets level 1. After that, level follows stability S (days until recall drops to 90%):

| Level | Stability S | Dojo | Gems |
| --- | --- | --- | --- |
| 1 | first read done | White | Quartz |
| 2 | ≥ 3 days | Yellow | Amethyst |
| 3 | ≥ 7 days | Orange | Topaz |
| 4 | ≥ 14 days | Green | Emerald |
| 5 | ≥ 30 days | Blue | Sapphire |
| 6 | ≥ 60 days | Brown | Ruby |
| 7 | ≥ 120 days | Black | Diamond |

Thresholds are starting values to tune with internal testers; keep them in configuration, not code.

**Shine / stripes from retrievability.** Retrievability R (0–1) is FSRS's current recall estimate. Shine = R, shown as stripes for belts or lustre for gems. When R falls below 0.7 and the task is overdue, the *displayed* level drops by one; a single good review restores it. The stored level never drops on decay alone, only through reviews.

**Exam tier.** For each ExamTask: attainment = min(level ÷ effectiveTargetLevel, 1); weight = importance (high 3, medium 2, low 1) × size. The exam's tier is the highest level L where 80% of total weight has attainment ≥ L ÷ 7. A weak-link flag is raised for any high-importance task below level 2. (Effective target: see the planner spec, "Reachable targets".)

**Projected tier.** The same formula applied to the levels each task would reach if the current PlanItem schedule is followed to the exam date.

**Readiness %.** Weighted share of tasks at their effective target level.

**Activity grid.** Per day: total study minutes from Review, bucketed into 5 intensities.

**Mastery timeline.** For each task and day: the levelAfter of the last Review on or before that day, faded by R on that day. Future cells are projected from PlanItem.

**XP and streaks.** XP per review = 10 × rating weight + promotion bonus. A streak day = any review that day, or a RestToken used on it, or a planned break.

## Redefinition operations

Every operation runs in one transaction, writes one Event row (which makes it undoable), and never deletes Review rows.

| Operation | Rows written | Mastery effect |
| --- | --- | --- |
| Rename, notes, tags | Task updated | None |
| Shrink scope | TaskChunk range updated | TaskState kept |
| Expand scope (split offered) | New Task + TaskChunk for the added range; TaskLineage (expand) | Original kept; new task at level 0 |
| Expand scope (kept as one) | TaskChunk range updated | Level kept; R reduced in proportion to the added size, so it shows as lost shine |
| Split | N new Tasks, each copying TaskState and ExamTask rows; TaskLineage (split); parent archived | Inherited; dueAt staggered by up to 2 days |
| Merge | New Task in the same Topic (cross-topic merges are blocked); TaskChunks unioned; TaskLineage (merge) per parent; parents archived | Lowest level, lowest stability, earliest dueAt |
| Swap source, same content | TaskChunk rows replaced | Kept |
| Swap source, new content | TaskChunk rows replaced; TaskState reset; old reviews stay linked via lineage | Reset to level 0 |
| Change importance or target | ExamTask updated, importanceOverridden = true | None; plan regenerated |
| Pause / resume | Task.status; TaskState.pausedAt | No decay while paused: dueAt shifted by the paused duration on resume |
| Add cards | Card rows | None; later quiz reviews derive their rating from CardResult |

**Undo** replays the inverse of the latest Event for that task. **History** for a task walks TaskLineage backwards and merges Review rows from all ancestors.

## Template export format (1.1)

A `.belt` file is a zip holding `manifest.json` plus `data.json`; PDFs are never bundled, only their titles and links. It shares structure and exam importance, and leaves personal data out unless the sender opts in.

```json
{
  "format": "belt",
  "formatVersion": 1,
  "template": { "id": "tpl-uuid", "kind": "examPack", "name": "JEE Main 2027", "author": "optional", "version": 3 },
  "topics":  [ { "id": "t1", "parentId": null, "name": "Physics" } ],
  "sources": [ { "id": "s1", "type": "book", "title": "HC Verma Vol 1", "unitType": "page" } ],
  "chunks":  [ { "id": "c1", "sourceId": "s1", "title": "Ch 3 Rest and motion", "startUnit": 40, "endUnit": 62 } ],
  "exam":    { "name": "JEE Main", "date": null },
  "importance": [ { "chunkId": "c1", "importance": "high", "targetLevel": 6 } ],
  "communityDifficulty": [ { "chunkId": "c1", "avg": 2.4 } ]
}
```

- Ids in the file are local to the bundle; ImportMap translates them, so importing version 4 later updates rows in place.
- The exam date is left blank in shared packs; the importer asks for it.
- `communityDifficulty` is optional, shown only as a hint beside the student's own rating.
- Opting in to share progress adds a `progress` block (levels only, no review history).

## Sync readiness (phase 2)

Phase 2 can ship sync by uploading the Event and Review logs; no table needs to change meaning.

- Review rows never conflict: both devices' reviews are kept and TaskState is rebuilt by replaying them in hlc order.
- Simple fields use last-writer-wins on hlc.
- Racing structural edits (split, merge) on one task: the first by hlc wins; the loser becomes an undoable suggestion.
- PlanItem is never synced; each device regenerates it.
- SourceFile bytes sync separately (opt-in, Wi-Fi only).

## Drift notes

- One database for all platforms; web (1.1) uses Drift's WASM SQLite with OPFS storage.
- Repositories write the data row and its Event row in one transaction; the UI never writes tables directly.
- TaskState and PlanItem are caches: a "rebuild" command recomputes them from Review.
- Index Review(taskId, at), PlanItem(date), ExamTask(examId) and TaskChunk(taskId).
- Keep FSRS parameters and level thresholds in Setting, so they can be tuned without a migration.
