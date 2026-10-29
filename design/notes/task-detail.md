# Task detail (`/tasks/:id`) — design note

Built on 29 Oct 2026 (decision D36); comments still welcome (CLAUDE.md, "Design ownership"). Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`. Scope from `docs/03-phase1-scope.md`: belt, next review, history, sources, Start, Redefine.

## Purpose

One task: how strong it is, when it comes back, what it covers, and how its reviews went. It is reached by tapping a belt badge on a source's chapters screen, and later from the Exam screen and the Progress grid. From here the student can start the next session or review early (reviewing early counts).

## Layout (one scrolling page, ground background, 20 px side padding)

1. **Top bar:** a 44 px round back button, and the overline "TASK" (13 px muted). On the right, a 44 px round "more" button opens a sheet with Redefine. The sheet arrives in milestone 6; until then the button is hidden.
2. **Title:** the task name in Bricolage 28 px (up to 3 lines). Below it, the importance marker (the 4 px bar in High, Medium or Low colour) and "High importance · JEE Main" in 13 px muted. With no exam, this line is left out.
3. **Belt card** (dark ink, 20 px radius, like the Today exam card):
   - **Left:** the belt badge at 64 × 28, with stripes, or at 45% with "fading".
   - **Right:** "Green belt" (Bricolage 22 px, white), then "Level 4 of 7 · target Black" (12 px, #D5D9E8).
   - **Underneath: review steps.** One pill per planned review, filled for done and outlined for to come, e.g. ● ● ● ○ ○. They are labelled "3 of 5 reviews done", so colour is never the only signal.
4. **Next card** (surface):
   - **The line, by state:**

     | State | Line |
     | --- | --- |
     | Due today | "Review due today" |
     | Overdue | "Overdue 2 days · the belt is fading", in warning text |
     | Scheduled | "Next review Sat 31 Oct · in 4 days" |
     | Not started | "Not started · first read about 45 min" |
     | Schedule finished | "All reviews done · review any time to keep it fresh" |
     | Paused | "Paused since 12 Oct" |

   - **The button** (full-width primary, 52 px):

     | State | Button |
     | --- | --- |
     | Due today or overdue | "Start review" |
     | Scheduled | "Review early". Under it, 12 px muted: "Counts like any review." |
     | Not started | "Start first read" |
     | Paused | No button |

     Start opens the source in its own app, exactly as from Today.
5. **Covers** (section header 17 px bold, then a surface card with one row per chapter):
   - Each row shows the source title and chapter (15 px), and the range in 12 px muted: "HC Verma Vol 1 · Ch 3 · pp. 40–62".
   - Tapping a row opens that source's chapters screen.
6. **History** (section header, then a surface card):
   - One row per review, newest first:
     - date "Wed 28 Oct";
     - kind "Review 3" / "Retry" / "First read";
     - a rating chip: Forgot, Hard, Good or Easy (Good and Easy in accent soft, the others in warning bg);
     - minutes;
     - the small belt badge after the review.
   - A row that earned a belt adds "→ Green" in accent.
   - Shows 10 rows, then "Show all N".

## States

| State | What shows |
| --- | --- |
| Loading | Skeleton blocks for the title, belt card and two cards (no shimmer). |
| Filled | As laid out above. |
| Not started | The belt card shows the dashed "not started" badge, "Not started", and every step outlined. History reads "No reviews yet. The first read earns White." |
| Paused | The belt card at 60% opacity; the next card says "Paused since 12 Oct" and has no button. |
| Removed | The task was deleted, or its id is unknown: centred "This task was removed." with a secondary button "Back". |
| Error | A warning card: "Couldn't load this task." with a secondary button "Try again". |

## Accessibility

- The belt card is one Semantics node: "Green belt, level 4 of 7, 2 stripes, 3 of 5 reviews done, target Black."
- History rows read as one sentence: "28 October, review 3, rated Good, 22 minutes, promoted to Green."
- Every button is at least 44 px; text sizes reflow at 1.3×. The belt card stacks the badge above the text when the text would wrap past 3 lines.

## Data

Read-only. It uses Task, TaskState, the task's TaskChunks with their Chunk and Source, the ExamTask for the upcoming exam, and the Review log. "Review early" and "Start" go through the same session flow as Today (ActiveSession, then Back from source).
