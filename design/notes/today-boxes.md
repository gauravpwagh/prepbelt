# Today in three boxes — design note (D50)

Replaces the single session list of mockup 1 (`design/mockups/`, `docs/06-screens.md` §1) below the exam card. The header (date, streak, Settings, "Today's training") and the exam card stay as designed.

## Purpose

Everything a student could act on, in three places: what is due, what has not been read yet, and what comes later. Nothing due is hidden, and the plan for today stays visible.

## Layout

1. **Header and exam card:** as in mockup 1.
2. **Summary line** (section style): "4 reviews due · 2 first reads planned · about 55 min". Without an exam (no plan): "4 reviews due · 12 not started".
3. **Three boxes**, 12 px apart. Each is a surface card (16 px radius, 1 px line border, 14 px padding) with:
   - a header row: title (card title style) and a count pill (accent soft, accent text);
   - its rows: the first 3 (`ui.todayBoxVisible`), each a session card as in mockup 1;
   - "Show all 12" / "Show fewer" (text link, 44 px tall) when there are more.

| Box | Title | Rows, in order | Row action |
| --- | --- | --- | --- |
| 1 | Reviews due | Every task with a review due by the end of today, however many: overdue first (most overdue first), then due today. Kind line "OVERDUE 2 DAYS · 15 MIN", "REVIEW · 10 MIN" or "FINAL REVIEW". | Start |
| 2 | Not started | Tasks without a first read and sources with reading left. Today's planned first reads and "Continue reading" first, marked "PLANNED TODAY · FIRST READ · 45 MIN"; then the rest by their planned date, importance, source and position. Sources with chapters but no tasks and nothing left to read show "8 chapters without tasks". | Start (task), Read (source), or open the source |
| 3 | Reviews ahead | Each task's next review, soonest first, no grouping. Kind line "TOMORROW", "IN 3 DAYS", "IN 18 DAYS · 16 NOV" (date after 13 days). | No Start: a tap opens the task. Early reviews stay possible from the task (they count, but are not one tap away here). |

Paused tasks appear in no box.

## States

| State | What shows |
| --- | --- |
| Loading | The header, then three skeleton cards. |
| No sources yet | The existing empty message with "Add a source". |
| Box empty | Inside the box, one muted line: "No reviews due. You're clear today." / "Every task has had its first read." / "No reviews scheduled yet. They start after a first read." |
| Error | The existing warning card with "Try again". |

## Data effects

None. The boxes read task states, the stored plan and sources.
