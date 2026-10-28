# PrepBelt — Planner Spec

The planner turns tasks, surveys and an exam date into a day-by-day schedule that fits the student's daily minutes and gets every important topic to its belt target by exam day. It runs entirely on the device and reruns after every change.

## Inputs and outputs

The planner is a pure function: same inputs and date, same plan. It reads only stored data and writes only PlanItem rows.

| Input | From | Used for |
| --- | --- | --- |
| Exam date, priority | Exam | Deadline and, in 1.1, capacity share |
| Tasks with importance, target level | ExamTask | What must reach which belt |
| Size, difficulty, familiarity | Chunk, ChunkSurvey via TaskChunk | Time estimates |
| Level, review step, due date, resume page | TaskState, Review | What is due and how much is left to read |
| Daily minutes per weekday, overrides, locked days | Availability, AvailabilityOverride | Capacity per day |
| Student's pace per subject | Derived from Review durations | Calibrating estimates |
| Review schedule | Setting (at most 5 reviews, gap weights 1 : 2 : 3 : 5 : 8) and the ExamTask target | When reviews come due, and how many |
| Today's date | Injected clock | Start of the plan |

**Output:** PlanItem rows from today to exam day, each with date, task, kind (firstRead, review, finalReview), estimated minutes and an order within the day. Every run writes a new `generation`; older generations are discarded.

**When it runs:** after a review, a survey edit, a task redefinition, an availability change, on opening the app on a new day, and on demand ("Replan"). A full run must finish in under 200 ms for 500 tasks on a mid-range phone; it runs in a background isolate.

## Estimating effort

```
firstRead = remainingUnits × pace[subject] × d[difficulty] × f[familiarity]
```

| Factor | Values | Default |
| --- | --- | --- |
| pace (minutes per unit) | page: 3 · video minute: 1.5 · question: 2 | Calibrated per subject after 3 sessions |
| d (difficulty) | Easy 0.67 · Medium 1.0 · Hard 1.33 | Medium if not surveyed |
| f (familiarity) | New 1.0 · Seen it 0.7 · Comfortable 0.45 | New if not surveyed |

- **remainingUnits** shrinks as the student reads: the range minus pages already read (from the last `resumeUnit`).
- **Reviews:** the first review is 35% of the first read, later ones 20%, clamped to 5–30 minutes.
- **Calibration:** after 3 or more sessions in a subject, pace = median of actual minutes per unit, blended 50/50 with the default until 10 sessions, then fully personal.
- **Session size:** a first read over 45 minutes is split into reading sessions of at most 45 minutes, at PDF outline boundaries where available. They remain one task.

## Reachable targets

Every task follows the same rule (see `02-data-model.md`): a first read (White), then one review per belt above White up to its target, at most 5, with growing gaps all fitted before the exam. High → Black plans 5 reviews, Medium → Blue 4, Low → Green 3. Each Good review earns the next belt, so a task reaches its target by exam day if its first read leaves at least a day per planned review. **Black** takes one extra review the student chooses to do; the planner never schedules it.

**Effective target** = min(exam target level, Brown). Readiness, exam tier and triage use effective targets. A target of Black shows as "Brown by exam day · Black with one extra review". After the exam the original target returns.

## Scheduling reviews

1. **Due dates:** after each review the engine fits the task's remaining reviews between that review and the deadline (the day before the exam), in the gap proportions 1 : 2 : 3 : 5 : 8, at least a day apart. The next one is the task's due date. The last planned review is the final review and lands in the last days before the exam.
2. **Not Good:** a Forgot or Hard review repeats the same step the next day; the remaining gaps re-fit after it.
3. **Early reviews:** a student may review any task before it is due; it counts as the next step and the rest re-fit. Unplanned reviews are never added to the plan silently.
4. **Smoothing:** a review may move up to 2 days earlier than due, or 1 day later, to even out load, never past the deadline. Never later than that, except through triage.
5. **Overdue reviews:** scheduled from today ahead of everything else, the dimmest high-importance tasks first.
6. **Taper:** the 2 days before the exam hold reviews only, no first reads. The exam day is left empty.

Moving a review changes when it is planned, not what the review earns when it is done.

## Placing first reads

Deadlines are computed backward from the exam, but first reads are placed as early as capacity allows, because every day of head start buys a higher reachable belt.

**Deadline per unstarted task:** the latest day its first read can finish and still reach its effective target (e.g. Green needs about 25 days, so with the exam on day 74 and a 2-day taper the deadline is about day 47).

**Placement order** (earliest first):

1. Earliest deadline.
2. Higher importance.
3. Hard before easy.
4. Source order: chapter 8 never before chapter 7 unless the source is marked "any order".
5. Variety: at most 2 first reads from the same subject per day when there is an alternative.

Partly read tasks continue before new ones in the same subject, from the resume page.

**Feasibility:** if a High task cannot meet its deadline with all capacity before it, raise a triage case.

## Filling each day

```
for day in today..examDay-1:
  cap = minutesFor(day)                      // availability, overrides, taper
  place overdue reviews first, most at-risk first
  place reviews due on day (after smoothing), by importance then decay
  if reviews exceed cap: carry the rest to the next day, still ahead of first reads
  left = cap - placed
  while left >= 15 and firstReads remain:
    t = next first read by placement order
    session = min(t.nextSession, left)       // a reading session, ≤ 45 min
    place session; left -= session
  schedule the planned reviews of tasks started today, fitted before the exam
```

- **15-minute floor:** a new first-read session never starts with less than 15 minutes left. Continuing a started reading may use less.
- **One overrun:** a session may push the day up to 10 minutes over to finish a session rather than split it.
- **Today screen order:** overdue reviews, due reviews, final reviews, first reads by importance.
- **Bonus items:** when the student finishes early, the next day's first read is offered as optional, never added silently.
- **Determinism:** ties break by task id.

## Missed days and rebalancing

Overdue reviews always come first, ahead of any new material. Sessions are never moved by hand: anything not done becomes overdue and is replanned.

- **Detection:** on the first app open of a new day, PlanItems still planned for earlier dates are marked `moved`, and the planner reruns from today.
- **Overdue first:** overdue reviews fill each day before anything else, most at-risk first. If they exceed a day's minutes, the rest carry to the next day, still ahead of first reads.
- **First reads shift later.** If that pushes a High task past its deadline, the effective target is recomputed and triage is raised.
- **No punishment:** belts never drop. Overdue tasks dim; one Good review restores them.
- **Message:** one line on Today, e.g. "Yesterday's 3 sessions are spread over the next 2 days · still on track for Blue". If the projection drops, say so plainly.
- **Breaks and mock tests:** set in advance as an AvailabilityOverride (0 minutes, or reduced minutes on a mock-test day). Planned around, never counted as missed, and they don't break the streak.

## Triage when time runs out

The planner cuts the least valuable work first, shows exactly what it cut, and lets the student undo any cut. High-importance tasks are never cut automatically.

**Triggers:** total planned minutes exceed available minutes before the exam, or a High task cannot meet its first-read deadline.

| Step | Cut |
| --- | --- |
| 1 | Drop the final review of Low tasks (their target falls one belt) |
| 2 | Lower Low targets to Yellow |
| 3 | Mark Low and Easy first reads as "skim": 40% of the estimate, one review |
| 4 | Lower Medium targets by one level |
| 5 | Stop and ask the student |

Step 5 offers: add daily minutes (showing the exact number), choose which Medium or High tasks to drop, or accept a lower projected belt. Restoring a cut re-runs triage, which shows the next cut before confirming. Choices are stored as ExamTask overrides.

## Several exams (1.1)

```
share[e] = w[e] × remaining[e] / daysLeft[e]  ÷  Σ_k ( w[k] × remaining[k] / daysLeft[k] )
```

- w = exam priority weight: low 1, normal 1.5, high 2. remaining = that exam's planned minutes not yet done.
- Locked days give that day entirely to one exam and are excluded from shares.
- Shared tasks take the earliest exam's deadline and the highest importance; a review advances every exam it belongs to.
- A shared task gets a final review before each exam, unless the exams are within 7 days of each other.
- Overload: triage runs on the lowest-priority exam first.
- Shares are recomputed every run.

## Worked example (use as a golden test)

**Setup:** JEE Main on 10 Jan 2027; today 28 Oct 2026 (day 0); 73 study days. 105 minutes Monday to Saturday, 240 on Sunday: 870 minutes a week, about 151 hours total.

**Workload:** 38 tasks (12 High, 16 Medium, 10 Low), 9 not started. Remaining first reads about 22 h, planned reviews about 58 h, roughly 80 h. Fits; no triage.

**Rotational motion** (High, target Black, HC Verma pp. 166–197, Hard, New):

1. Estimate: 32 pages × 3 × 1.33 × 1.0 ≈ 128 min → reading sessions of 45, 45, 38 on days 0, 1, 2.
2. Reachable: the first read finishes day 2, with 71 days left, so all 5 reviews fit. Effective target Brown; Black needs one extra review by choice.
3. Reviews (all Good), gaps in proportion 1 : 2 : 3 : 5 : 8 over days 2–73: about days 6, 15, 27, 46 and 73. Each earns a belt, Yellow to Brown. First review 30 min (35% of 128, capped), the rest about 26.
4. The fifth review on day 73 (9 Jan) is the final review.
5. Total: 128 min reading + 5 reviews ≈ 135 min.

The golden test should assert the structure (sessions, 5 reviews with growing gaps, the last one before the exam, effective target Brown, no day over capacity), allowing a day either way for rounding and smoothing.

**Triage:** the student drops to 30 min every day → 2,190 min (about 36 h) against 80 h.

| Step | Cut | Plan size after |
| --- | --- | --- |
| 1 | Final reviews of 10 Low tasks | about 77 h |
| 2 | Low targets to Yellow | about 70 h |
| 3 | 4 Low and Easy first reads become skims | about 66 h |
| 4 | Medium targets down one level | about 58 h |
| 5 | Ask the student | — |

Step 5 message: "About 18 more minutes a day keeps this reduced plan. About 36 more keeps everything."

## Configuration defaults

| Setting | Default | Student can change |
| --- | --- | --- |
| Reviews per task | One per belt above White up to the target, at most 5; gaps 1 : 2 : 3 : 5 : 8; retry after 1 day | No |
| Daily minutes per weekday | Set at first launch | Yes |
| Max reading session | 45 min | No |
| New-session floor | 15 min | No |
| Overdue reviews | Always first, before first reads | No |
| Taper before exam | 2 days | No |
| Last review | By the day before the exam | No |
| Review smoothing | 2 days earlier, 1 day later | No |
| Source order | Enforced | Per source ("any order") |

## Decisions

- No manual dragging of sessions.
- No cram mode; the taper stays reviews only.
- Mock tests are availability overrides.
- Overdue reviews always come first; no backlog cap.
