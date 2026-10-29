# Add exam (`/exams/new`) — design note

Built on 29 Oct 2026 under D36 (proceed unless a decision is substantial and irreversible); comments welcome. Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`.

## Purpose

Sets the one exam of 1.0: its name and date, and how long the student can study each day. The planner needs all three. It is reached from the Exams tab's empty state, and later from first launch (milestone 6).

## Layout (one scrolling page, ground background, 20 px side padding)

1. **Top bar:** a 44 px round back button and the title "Add exam" (Bricolage 22 px).
2. **Exam card** (surface, 16 px radius):
   - **"Exam name":** a text field, e.g. "JEE Main".
   - **"Exam date":** a field-styled button showing "Sat 10 Jan 2027". Tapping it opens the platform date picker, which starts tomorrow. A 12 px muted line below reads "73 days from today".
3. **Study time card:**
   - "Time each day" with a − / + stepper (15-minute steps, 15 min to 8 h, default 1 h 30 min).
   - A 12 px muted line below: "The same every day for now. Set each weekday on the exam screen."
4. **What happens** (12 px muted text under the cards): "Your 12 tasks will count toward this exam as Medium. Set importance in each source's survey."
5. **Bottom:** the primary button "Add exam", disabled until the name and date are valid.

## States

| State | What shows |
| --- | --- |
| Empty | No name, date "Choose a date", Add exam disabled |
| Filled | As laid out above |
| Error: invalid input | An inline 12 px warning under the field: "Give the exam a name" / "Pick a day after today" |
| Error: save failed | "Couldn't save. Try again." above the button |

## Data effects (one undoable operation)

- An Exam row (priority Normal).
- An ExamTask for every active task that has none for this exam, as Medium with target Blue (survey importance is stored per exam, so there is none yet). The survey then sets each chapter's importance for this exam.
- Availability rows for the 7 weekdays.

The planner then runs, and Today shows the plan.

## Exams tab

- **No upcoming exam:** an empty state, with the dashed not-started belt, "No exam yet", "Add your exam to get a day-by-day plan.", and the primary button "Add exam".
- **An upcoming exam:** the Exam screen (mockup 4), without its back button.
