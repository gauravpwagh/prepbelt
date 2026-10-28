# PrepBelt — Product and Features

A general-purpose study planner for students preparing for any exam. It should feel like a calm, rewarding game, and be extremely easy to use.

## Core model: Source, Plan, Execution

- **Source**: anything a student studies from — PDF, book, video, link, notes, question bank. A source is split into **chunks** (chapters, sections, page ranges, timestamps).
- **Plan**: what to study and when, usually generated from an exam.
- **Execution**: the actual sessions — first reads, reviews, practice — each logged with date, duration and quality.
- **Task**: the unit that earns a level. A task is a *topic* (what is learned); sources and chunks are *where* it is learned. Mastery belongs to the task, so swapping a book never wipes progress.

## Main user journey

1. Student adds an exam (name, date, daily study minutes).
2. Student adds a source — by sharing a PDF or link into the app, or manually.
3. Student **surveys** the source: for each chapter, importance for this exam, difficulty, and familiarity. About 3 minutes for a 20-chapter book.
4. The planner builds a day-by-day schedule.
5. Each day the **Today** screen lists sessions. Tapping Start opens the source in its own app (external PDF viewer, YouTube, browser).
6. Back in PrepBelt, the student says where they stopped and rates recall: **Forgot / Hard / Good / Easy**.
7. Spaced repetition (FSRS) schedules the next review. Good reviews promote the task to a higher belt.

## Levels and belts

Seven levels from FSRS stability. Data stores the level; the theme decides how it looks.

| Level | Dojo theme | Gems theme (1.2) |
| --- | --- | --- |
| 1 | White | Quartz |
| 2 | Yellow | Amethyst |
| 3 | Orange | Topaz |
| 4 | Green | Emerald |
| 5 | Blue | Sapphire |
| 6 | Brown | Ruby |
| 7 | Black | Diamond |

- **Decay without punishment**: as recall fades, the belt loses stripes (gems lose shine). The stored level only changes through reviews, and one good review restores the shine.
- **Promotion moment**: animation, haptic and sound when a belt is earned.
- Badges always show the level number or stripes too, so colour is never the only signal.

## Source survey

Per chunk: importance (High, Medium, Low) for a given exam, difficulty (Easy, Medium, Hard), familiarity (New, Seen it, Comfortable). The survey drives effort estimates, belt targets (High→Black, Medium→Blue, Low→Green, capped by time before the exam), ordering and triage. Importance belongs to the exam–chunk link; difficulty and familiarity are personal. The survey self-corrects: if reviews keep coming back Hard on a chunk surveyed Easy, the app suggests raising its difficulty.

## Splitting a PDF

- **Split the reading, keep one task**: a long first read spans several sessions with "resume at page N".
- **Split into separate tasks**: each part gets its own belt and schedule.
- Rule of thumb: a task should be reviewable in about 20 minutes; a first-read session is at most 45 minutes.
- Split points, best first: the PDF's bookmarks; a pasted table of contents; size-based auto-split; manual drag divider.
- The app suggests splits during survey (first read over 45 min), during planning, and when a student repeatedly stops at the same page. Chunks under about 5 pages get a merge suggestion.

## Redefining tasks

Tasks can be renamed, rescoped, split, merged, re-sourced, moved between exams or paused. Review history is never deleted, every change shows an impact preview, and every change can be undone. See `02-data-model.md` for the exact rules.

## Exams

- Exam belt: the level reached by 80% of the importance-weighted syllabus, with a weak-link flag for any High task below Yellow.
- Readiness %, projected belt on exam day, and weak links.
- Multiple exams with shared topics arrive in 1.1.

## Progress views

- **Activity grid** (GitHub-style): study minutes per day.
- **Mastery timeline** (1.1): rows are tasks, columns are days or weeks, cell colour is the level, faded cells are planned.
- The grids use the ordered "Night to sun" palette (viridis): #440154, #443983, #31688E, #21918C, #35B779, #90D743, #FDE725.

## Game layer

Streaks with rest tokens, XP, daily quests, achievements and a collection vault. No manipulative mechanics: the fun comes from visible progress.

## Sharing

- Share into the app from other apps (Android, iOS).
- Templates — syllabus, source list, or a whole exam pack — are exported and imported as `.belt` files (1.1). They carry structure and exam importance, never personal difficulty or mastery unless the sender opts in.
