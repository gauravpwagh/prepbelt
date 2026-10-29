# Source chapters (`/sources/:id`) and reading as you go — design note

For approval before building. Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`.

Owner requests (28 Oct 2026):

- *The survey is optional. I can create tasks as I progress through a source. A finished survey makes creating tasks easy, and survey → create tasks still works.*
- *A task can cover several chapters.*
- *Journey: with a large PDF, I start reading it through the app. When I come back, the app asks how much I covered. My answer creates a task, with the time it took, and the rest of the source stays open to explore.*

Answers already given: keep "Already read it?" on Add task; "Create N tasks" includes unsurveyed chapters, as Medium.

## What changes

| Today (built) | Proposed |
| --- | --- |
| Tasks are created only when a survey finishes. | There are three routes to the same tasks, and they can be mixed: the survey, per-chapter "Add task", and reading as you go. |
| A task covers one chapter. | A task covers one or more consecutive chapters of one source (several TaskChunk rows), or part of a chapter. |
| Tapping a source opens its survey. | Tapping a source opens this screen. The survey is one optional button on it. |
| Add source's main button is "Save and survey". | Its main button becomes "Save", which opens this screen. "Save and survey" stays as the second button. |
| The planner sees only tasks. | The planner also sees the unexplored rest of a source, as a "Continue reading" item (see Planner). |

An unsurveyed chapter uses the planner's defaults: Medium importance, Medium difficulty, New familiarity (`docs/04-planner-spec.md`).

## Layout (390 × 844, ground background, 20 px side padding)

1. **Top bar:** a 44 px round back button. Beside it: an overline "PDF · 480 PAGES" and the source title (16 px bold).
2. **Reading card** (surface, 16 px radius). It shows for sources with pages, minutes or questions:
   - A progress bar and the line "Explored 120 of 480 pages · about 18 h left". The time left is pages left × the student's pace.
   - A primary **"Read from p. 121"** button ("Watch from 32:10" for a video; "Start reading" at the beginning; hidden once the whole source has been read).
   - Under it, when a chapter is partly read: "Ch 5 · 18 of 40 pages read", muted.
3. **Summary card** (surface, 16 px radius):
   - The line "22 chapters · 6 tasks · surveyed 14 of 22".
   - Two buttons side by side:
     - Secondary **"Survey"** (or "Edit survey" once finished). Optional; it opens the survey.
     - **"Create 16 tasks"**: one task per chapter without one, including unsurveyed chapters. Hidden when every chapter has a task. It is secondary when the reading card shows, otherwise primary.
   - A muted caption under them:
     - With a survey: "Uses your survey answers. Unsurveyed chapters count as Medium."
     - Without one: "Chapters count as Medium. A survey makes this sharper."
4. **Chapter list**, in reading order. Each row is at least 56 px tall:
   - **Left:** the chapter number in a 28 px circle, muted. A read chapter gets a check instead, with the label "Read" for screen readers.
   - **Middle:**
     - The title, 15 px bold.
     - "pp. 40–62", plus the survey answers when present (e.g. "High · Hard · Seen it"), 12 px muted. A partly read chapter adds "18 of 40 read".
   - **Right:**
     - With no task: a small button **"Add task"**.
     - With a task: its belt badge (level 0 shows the dashed not-started belt), which opens the task. When one task covers several chapters, those rows are joined by a 2 px line at the left, and only the first row shows the badge.
   - Sub-sections from bookmarks are not listed; tasks are per chapter or chapter range (D26).
5. **Add task sheet** (bottom sheet, opened by "Add task"). It is pre-filled so that one tap on **Create** is enough:
   - **Chapters:** "Ch 3" with a "+ next chapter" chip, so one task can cover a run of chapters that have no task yet.
   - **Task name:** the chapter title, or "Ch 3–4: Rest and motion, The forces"; editable.
   - **Importance for {exam}:** High / Medium / Low chips. Pre-filled from the survey (the highest across the chapters), else Medium. Hidden without an exam.
   - **"Already read it?"** with the options "Not yet" and "Yes". "Yes" records the first read now, so the task starts at White with its first review scheduled, and counts these chapters as explored.
   - **Create** (primary). It saves as one undoable operation, then shows a snackbar "Task added" with "Undo".

## Reading as you go

### Starting

"Read from p. 121" does two things:

1. It saves an open **reading session**: source, start time, start unit. It is saved to the database, so it survives the OS killing PrepBelt in the background.
2. It opens the stored file in the student's PDF app (sources open in external apps; there is no in-app reader). Where the platform lets us pass a page, the PDF opens at p. 121; otherwise the student scrolls there.

A link or video opens in its app the same way.

### Coming back: "How far did you get?"

When PrepBelt returns to the foreground (or starts) with a reading session open, this bottom sheet shows over whatever screen is open:

- **Overline:** "HC VERMA VOL 1 · FROM P. 121".
- **Time:** "You were away 48 min" with a stepper in 5-minute steps. It is editable because time away is not always time reading. Away time over the maximum (configurable, default 3 h) pre-fills as the maximum.
- **Up to page:** a stepper, pre-filled with start + minutes ÷ pace, never past the end. Above it, chips for chapter ends within ±15 pages (configurable) of the guess: "End of Ch 5 · p. 160".
- **Preview line,** updated live: "Creates task Ch 5–6 (pp. 121–188). Ch 7: 12 of 40 pages read."
- **Buttons:** primary **Save**; text button **"I didn't read"** (closes the session and records nothing).
- Dismissing the sheet keeps the session open; the reading card then shows "Reading since 10:42 · Finish", which reopens the sheet.

### What Save does

All of it is one transaction and one undoable event:

1. **Whole chapters read** in this sitting become **one task** covering them (e.g. "Ch 5–6"). The task gets:
   - a TaskChunk per chapter and an ExamTask, with importance from the survey (highest of its chapters) or Medium;
   - a firstRead Review with `durationSec` set to the minutes given, so it starts at White and its first review is scheduled.

   If a chapter already has a task, it is skipped here; its task gets a firstRead Review instead, if it has none yet.
2. **A partly read chapter** does not become a task yet. Its pages read so far, and the minutes spent on them, are kept with the reading position. When a later sitting finishes it, that sitting's task includes it and its firstRead duration is the total from all sittings. The sheet offers **"Make Ch 7 a task now"** for students who want it anyway; that creates a not-started task for the whole chapter, whose first read is recorded when a later sitting finishes it (D29).
3. **The reading position** moves to the first page not yet read (D28).
4. **Pace:** the minutes and pages count towards the student's pace, as the planner spec already describes (calibrated after 3 sessions, blended until 10).

### Sources without chapters: progressive splitting (D47)

A source with no chapters is split as it is read. Saving a sitting makes the next part, "Pages 17–30", from the end of the last part to the page reached, with one task and its first read. A part under 10 minutes (`reading.minPartMinutes`) is held and joins the next sitting; the preview says so, and "Make it a task anyway" overrides it. The last page always makes a part.

### Finishing a source, and reading on (D47)

- **"That was the last part: I'm done with this source"** (checkbox): saves the sitting, makes any held part, and marks the source done.
- **"Done with this source"** (link under the reading button) marks it done without a sitting. A done source shows "Done · 23 pages read" and **"Read more of this source"**. Unread pages stay unread, and the plan drops its "Continue" item.
- **"Save and read on"** (secondary button, hidden when finishing): saves and starts the next sitting from the new position at once.

### Sources split by number of chapters (D49)

The chapters have no page numbers, so a chapter is the unit of reading.

- **Reading card:** "3 of 14 chapters read · about 2 h 30 min left" and **"Continue Ch 4"** (or "Start reading").
- **How far did you get?** The "Up to" stepper steps through chapters ("Ch 6"), pre-filled from the time and the minutes per chapter. Two chips under it: **"Finished it"** (default) and **"Still in it"**. The preview reads "Creates task Ch 4 – Ch 5. Ch 6: in progress."
- **Time:** a sitting's minutes are shared equally among the chapters it touched; a chapter still in progress keeps its share until a later sitting finishes it.
- **Minutes per chapter:** the median first read of this source's chapters once 3 are read; before that, pages ÷ chapters × pace, or 45 minutes when the page count is unknown.
- **Parts:** "Finished part 1 of 3" chips appear when the chapter in progress was split into parts.

### Tasks of one or more chapters, or part of one (D49)

A task covers consecutive whole chapters, or one part of one chapter:

- **Pages of a chapter** (chapters with page numbers): Add task offers "Whole chapter" or "Pages __ to __", pre-filled with the first pages without a task. The reading sheet's "Make … a task now" for a partly read chapter now makes a task of the pages read, with its first read and time (replacing D29's not-started whole chapter).
- **Part k of n** (chapters without page numbers): Add task offers "Split into N parts" (2–10), which creates all N parts at once: "Ch 7 · part 1 of 3".
- **Rules:** parts never overlap; a task stays within one topic; non-adjacent chapters are joined only by Merge (after 1.0). A part under 10 minutes gets a "short" warning, not a block.
- **Chapter rows:** a chapter with parts lists them under it, each with its range or "part k of n" and its belt. "Add task" stays on a chapter while pages of it have no task.
- **Finishing a chapter** with parts records first reads for its parts; pages without a task become a task for each gap.

### Topics

A task belongs to exactly one topic. If the chapters read span two topics, Save creates one task per topic, and the preview line says so. Chapters with no topic yet join the task as they are; the task can be given a topic later.

### Edge cases

| Case | Behaviour |
| --- | --- |
| The student reads backwards or re-reads | "Up to page" cannot go below the start page. Re-reading pages that already have a task records nothing new. |
| Two sources opened in a row | Only one reading session is open at a time. Starting a second one first asks about the first. |
| The phone is restarted mid-session | On next launch the sheet shows, with away time capped at the maximum. |
| A source without units (a link) | No reading card; tasks come from "Add task" or the survey. |

## Planner

The unexplored rest of a source is not a task yet, so today the planner would count it as no work, and the plan would look ahead of where it is.

Proposal: for each source linked to the exam, the planner adds one **"Continue {source} from p. 121"** firstRead item. Its estimate is unexplored units × pace × the defaults for difficulty and familiarity. It shrinks as the student reads and disappears when the source is fully explored. It is scheduled like a firstRead of a Medium task, and it never takes the last 2 days before the exam. On the Today screen it opens the same "Read from" flow.

This is a change to `docs/04-planner-spec.md` and will be recorded as a decision (D27) with the rest of this note.

## Data effects

- **New table `ReadingSession`** (syncable columns as usual): sourceId, startedAt, startUnit, endedAt?, endUnit?, minutes?, status (open, saved, discarded). It is the record of each sitting, including partial chapters, and makes the open session survive restarts.
- **Reading position** of a source = the first unit not covered by its saved sessions or by chapters whose task has a first read (including "Already read it?"). It is derived, not stored (D28).
- **Task over several chapters:** a Task with one TaskChunk per chapter, `order` 0, 1, 2…. TaskChunk already has start and end units, so "Make it a task now" uses a partial range.
- **Add task, Save and Create N tasks** all go through the survey repository's task creation (`createTasks`, extended to take a chapter range, the first-read flag and minutes), so the three routes cannot drift apart.
- **First read:** a firstRead Review with `durationSec` and `resumeUnit`, as in `docs/02-data-model.md`; no Review fields change.
- **Settings** (configuration, not literals): maximum away time (3 h), chapter-chip window (±15 units), away-time step (5 min).

## States

| State | What shows |
| --- | --- |
| Loading | Skeleton rows, as on the Sources list. |
| Not started | Reading card "Start reading"; the summary button reads "Create 22 tasks". |
| Reading in progress | Reading card shows the session time and "Finish". |
| Some tasks | Rows with tasks show their belt; "Create N tasks" counts only chapters without one. |
| All tasks | "Create N tasks" is hidden. The caption reads "Every chapter has a task." |
| Fully explored | The reading card shows "Read to the end · 14 h 20 min" and no button. |
| No chapters | "This source has no chapters yet." with a secondary button "Split into chapters", which goes back to the split options. |
| Error | A warning card with "Try again". |

## Out of scope for this note

- Knowing the current page inside another app; the page always comes from the student.
- A timer screen inside PrepBelt while reading.
