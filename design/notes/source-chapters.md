# Source chapters (`/sources/:id`) — design note

For approval before building. Owner request (28 Oct 2026): *the survey is optional; I can create tasks as I progress through a source; a finished survey makes creating tasks easy; survey → create tasks still works.* Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`.

## What changes

| Today (built) | Proposed |
| --- | --- |
| Tasks are created only when a survey finishes. | Tasks can also be created per chapter, at any time, with or without a survey. Finishing a survey still creates the rest in one step. |
| Tapping a source opens its survey. | Tapping a source opens this screen. The survey is one button on it. |
| Add source's main button is "Save and survey". | Its main button becomes "Save", which opens this screen; "Save and survey" stays as the second button. |

An unsurveyed chapter uses the planner's defaults: Medium importance, Medium difficulty, New familiarity (docs/04-planner-spec.md).

## Layout (390 × 844, ground background, 20 px side padding)

1. **Top bar:** a 44 px round back button. Beside it: an overline "PDF · 480 PAGES" and the source title (16 px bold).
2. **Summary card** (surface, 16 px radius):
   - The line "22 chapters · 6 tasks · surveyed 14 of 22".
   - Two buttons side by side:
     - Secondary **"Survey"** (or "Edit survey" once finished). Optional; it opens the survey.
     - Primary **"Create 16 tasks"**: one task for every chapter that has none. Hidden when every chapter has a task.
   - A muted caption under them:
     - With a survey: "Uses your survey answers."
     - Without one: "Unsurveyed chapters count as Medium."
3. **Chapter list**, in reading order. Each row is at least 56 px tall:
   - **Left:** the chapter number in a 28 px circle, muted.
   - **Middle:**
     - The title, 15 px bold.
     - "pp. 40–62", plus the survey answers when present (e.g. "High · Hard · Seen it"), 12 px muted.
   - **Right:**
     - With no task: a small button **"Add task"**.
     - With a task: its belt badge (level 0 shows the dashed not-started belt), which opens the task.
   - Sub-sections from bookmarks are not listed; tasks are per chapter (D26).
4. **Add task sheet** (bottom sheet, opened by "Add task"). It is pre-filled so that one tap on **Create** is enough:
   - **Task name:** the chapter title, editable.
   - **Importance for {exam}:** High / Medium / Low chips. Pre-filled from the survey, else Medium. Hidden without an exam.
   - **"Already read it?"** with the options "Not yet" and "Yes". "Yes" records the first read now, so the task starts at White with its first review scheduled. This lets a student who is partway through a book add what they've covered.
   - **Create** (primary). It saves as one undoable operation, then shows a snackbar "Task added" with "Undo".

## States

| State | What shows |
| --- | --- |
| Loading | Skeleton rows, as on the Sources list. |
| No tasks yet | As laid out. The primary button reads "Create 22 tasks". |
| Some tasks | Rows with tasks show their belt; the primary button counts only the chapters without one. |
| All tasks | The primary button is hidden. The caption reads "Every chapter has a task." |
| No chapters | "This source has no chapters yet." with a secondary button "Split into chapters", which goes back to the split options. |
| Error | A warning card with "Try again". |

## Data effects

- **Add task:** a Task, its TaskState (level 0), a TaskChunk for the chapter, and, with an exam, an ExamTask whose importance and target come from the sheet. This is one event under the task. "Already read it" also appends a first-read Review in the same transaction.
- **Create N tasks** and **finishing the survey** share one operation: `createTasks`, already built and tested. It creates tasks only for chapters without one, as one undoable event.
- A survey change after a task exists updates that task's ExamTask, unless the student overrode the importance (already built).

## Open questions

1. **"Already read it?" on Add task.** I think it fits "as I progress", but it means recording a first read without a study session. Keep it, or leave it out for now?
2. **Creating several tasks at once.** Should "Create N tasks" also create tasks for unsurveyed chapters? Or should it count only the surveyed ones, with per-chapter "Add task" for the rest?
