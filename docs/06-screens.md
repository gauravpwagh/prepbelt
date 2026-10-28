# PrepBelt — Screens and Design Tokens

Five 1.0 screens are designed as phone mockups (390 × 844) on the design canvas "PrepBelt — Key Screens" (https://claude.ai/artifact/HgwumL1P6aNpBMYWxTxKep — private to its owner until shared). This file describes them, and their source files are in `design/mockups/` with exact styles and behaviour (see `design/README.md`). Example content (JEE Main, HC Verma, page numbers) is placeholder data.

## Design tokens

| Token | Value | Use |
| --- | --- | --- |
| ink | #151A2D | Primary text, dark cards, selected chips |
| muted | #5A6178 | Secondary text (passes 4.5:1 on white) |
| ground | #F3F4F8 | Screen background |
| surface | #FFFFFF | Cards |
| line | #E2E5EE | Card borders, dividers |
| accent | #4338CA | Primary buttons, links, active nav |
| accent soft | #EEF0FF | Tags such as "from template" |
| warning bg / border / text | #FFF7EC / #F3D7AE / #7A4100 | Weak-links card |
| Heading font | Bricolage Grotesque 600–700 | Titles, big numbers |
| Body font | Manrope 400–700 | Everything else |
| Radii | 12 chips/buttons · 16 cards · 20–22 hero cards · 999 pills | |
| Touch targets | ≥ 44 px | All buttons |

**Dojo belt colours** (badges): White #F1EFE8 (with border), Yellow #FAC775, Orange #EF9F27, Green #639922, Blue #378ADD, Brown #854F0B, Black #2C2C2A. The belt knot is a darker shade of the belt colour. Stripes (black bars at the right end) show shine; a fading belt is drawn at about 45% opacity with the word "fading".

**Grid palette, Night to sun** (levels 1→7): #440154, #443983, #31688E, #21918C, #35B779, #90D743, #FDE725. Empty cell #E2E5EE. Planned (future) cells at about 38% opacity.

**Importance markers:** High #C2410C, Medium #F0997B, Low #F5C4B3 (a 4 px bar beside the task name).

**Icons:** simple 2 px stroke icons. No emoji.

## 1. Today

- Header: date ("Wednesday, 28 Oct"), title "Today's training", streak pill (flame icon, "12 day streak").
- Exam card (dark): exam name and date, "74 days to go", belt badge with name, readiness bar ("62% ready"), "On track for Blue by exam day". Taps through to the Exam screen.
- Section header: "4 sessions · 1 h 45 m" and quest progress.
- Session cards: belt badge (or a dashed outline for new material), kind and minutes ("REVIEW · 20 MIN", "OVERDUE 2 DAYS · 25 MIN", "FIRST READ · 45 MIN"), task title, source and range, and a round 44 px Start button. New material uses a dashed card border and an outlined Start button.
- Bottom nav: Today, Exams, raised add button, Sources, Progress.

## 2. Back from source (rate it)

- Close button; "Review session".
- "Welcome back" and the task with its belt.
- "Where did you stop?" stepper (− p. 228 +) with the range, a progress bar, "Finished the whole range" or "N pages left for next time", and time logged (22 min).
- "How well could you recall it?" 2×2 buttons: Forgot (back tomorrow), Hard (next in 3 days), Good (next in 9 days), Easy (next in 18 days). The selected button fills with the accent colour. Interval text comes from FSRS.
- After rating, a dark result card: belt graphic plus "Promoted to Blue belt · +40 XP", "Green belt holds", or "Green belt, one stripe lost".
- Primary button "Done · back to Today", disabled until a rating is chosen.

## 3. Source survey

- Back button; "Scouting the terrain" and the source name.
- Progress: "Chapter 8 of 22", "about 2 min left", progress bar.
- Card per chapter: "CHAPTER 8", title, page range and page count.
  - Importance for [exam]: High / Medium / Low, with a "from template" tag when prefilled.
  - How hard does it look?: Easy / Medium / Hard, with "others said Medium" (1.2 hint).
  - Studied it before?: New / Seen it / Comfortable.
  - Live estimate: "First read ≈ 1 h 20 min" and target belt (High → Black, Medium → Blue, Low → Green).
- "Mark the other 14 as Medium" text button; Previous and Next chapter buttons.

## 4. Exam

- Back; exam name; "10 Jan 2027 · 74 days left".
- Dark hero card: large belt, "Exam belt today: Green", "Projected Blue by exam day", stat tiles (62% ready, 24 / 38 at target, 1 h 45 m today).
- Weak links card (warning colours): count and each weak task with its state and next step.
- Mastery timeline card (1.1; activity grid in 1.0): task rows sorted weakest first with importance bars, 12 weekly columns, "Now" and "Exam" column labels, a ring on the current week, faded planned weeks, and a level 1–7 legend.

## 5. Redefine (split)

- Dimmed task header behind a bottom sheet.
- Sheet: "Redefine task", "Your progress and review history are never lost."
- Action chips: Edit, Scope, Split (selected), Merge, Swap source, Move to exam, Pause.
- Split control: a range bar with a draggable handle; labels "p. 210", "after p. 219", "p. 228".
- Two part cards with editable names and ranges (Part A pp. 210–219, Part B pp. 220–228).
- "What happens": both parts keep the belt and stripes; next review dates; "Undo anytime from the task's history".
- Buttons: Cancel, "Split into 2 tasks".

## Not yet designed (needed before milestone 3)

First launch, Add exam, Sources list, Add source, Task detail, Settings. Use the tokens and patterns above.
