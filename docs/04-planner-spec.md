# PrepBelt — Planner Spec

The planner turns tasks, surveys and an exam date into a day-by-day schedule: every review on the day it is due, and first reads in the student's daily minutes, so every topic gets at least 5 reviews before exam day (D53). It runs entirely on the device and reruns after every change.

## Inputs and outputs

The planner is a pure function: same inputs and date, same plan. It reads only stored data and writes only PlanItem rows.

| Input | From | Used for |
| --- | --- | --- |
| Exam date, priority | Exam | Deadline and, in 1.1, capacity share |
| Tasks with importance | ExamTask | Order of reviews and first reads; readiness weight |
| Size, familiarity | Chunk, ChunkSurvey via TaskChunk | Time estimates |
| Level, review step, due date, resume page | TaskState, Review | What is due and how much is left to read |
| Daily minutes per weekday, overrides, locked days | Availability, AvailabilityOverride | Capacity per day |
| Student's pace per subject | Derived from Review durations | Calibrating estimates |
| Review schedule | Setting (gaps 1, 3, 7, 14, 30, 60 days; at least 5 reviews before the exam) | When reviews come due |
| Today's date | Injected clock | Start of the plan |
| Unexplored units per source | Source, ReadingSession, read tasks (D27) | "Continue reading" items |

**Output:** PlanItem rows from today to exam day, each with date, task, kind (firstRead, review, finalReview), estimated minutes and an order within the day. Every run writes a new `generation`; older generations are discarded.

**When it runs:** after a review, a survey edit, a task redefinition, an availability change, on opening the app on a new day, and on demand ("Replan"). A full run must finish in under 200 ms for 500 tasks on a mid-range phone; it runs in a background isolate.

## Estimating effort

```
firstRead = remainingUnits × pace[subject] × f[familiarity]
```

| Factor | Values | Default |
| --- | --- | --- |
| pace (minutes per unit) | page: 3 · video minute: 1.5 · question: 2 | Calibrated per subject after 3 sessions |
| f (familiarity) | New 1.0 · Seen it 0.7 · Comfortable 0.45 | New if not surveyed |

Difficulty is no longer surveyed or used (D53); answers stored before stay in ChunkSurvey and are ignored.

- **remainingUnits** shrinks as the student reads: the range minus pages already read (from the last `resumeUnit`).
- **Reviews:** the first review is 35% of the first read, later ones 20%, clamped to 5–30 minutes.
- **Calibration:** after 3 or more sessions in a subject, pace = median of actual minutes per unit, blended 50/50 with the default until 10 sessions, then fully personal.
- **Session size:** a first read over 45 minutes is split into reading sessions of at most 45 minutes, at PDF outline boundaries where available. They remain one task.

## How many reviews

Every task follows the same rule (see `02-data-model.md`): a first read (White), then reviews at the gaps 1, 3, 7, 14, 30 and 60 days, each Solid one earning the next belt, so the sixth reaches Black. Importance does not change how many reviews a task gets (D53).

- **At least 5 before the exam.** When fewer than 5 of the default gaps fit before the deadline (the day before the exam), the first 5 are squeezed to fit, keeping their proportions, at least a day apart.
- **A last review before the exam.** When the next default gap would pass the deadline and the task has had at least 5 reviews, one more review lands in the last days before the exam: its final review.
- **Far exams and no exam:** after the sixth gap, reviews repeat at the last gap (60 days).
- With fewer than 6 days left, a task gets one review a day until the exam.

**Target:** every task aims at Black. Readiness and the exam tier count Brown as the target, since at least 5 reviews always fit; Black comes on top when the sixth review fits before the exam (D53).

## Scheduling reviews

1. **Due dates:** after each review the engine sets the next one from the rules above. The final review lands in the last days before the exam (within the importance's final window).
2. **Forgot or Shaky:** repeats the same step the next day; the remaining reviews re-fit after it.
3. **Early reviews:** a student may review any task before it is due; it counts as the next step and the rest re-fit. Unplanned reviews are never added to the plan silently.
4. **No capacity limit (D53):** every review is planned on the day it is due, however many fall on one day. Daily minutes limit first reads only. Only a break day (0 minutes) moves a review, to the next day with minutes.
5. **Overdue reviews:** planned for today, ahead of first reads.
6. **Order within a day:** reviews by importance (High first), then by due date (most overdue first). The student covers as many as they can; what is left stays overdue and comes first again tomorrow.
7. **Taper:** the 2 days before the exam hold reviews only, no first reads. The exam day is left empty.

## Placing first reads

Deadlines are computed backward from the exam, but first reads are placed as early as capacity allows, because every day of head start buys a higher reachable belt.

**Deadline per unstarted task:** the latest day its first read can finish and still leave a day for each of its 5 reviews before the exam (exam day − 6).

**Placement order** (earliest first):

1. Earliest deadline.
2. Higher importance.
3. Source order: chapter 8 never before chapter 7 unless the source is marked "any order".
4. Variety: at most 2 first reads from the same subject per day when there is an alternative.

Partly read tasks continue before new ones in the same subject, from the resume page.

### Exploring a source (D27)

A student may read a source as they go instead of turning every chapter into a task first. The part of a source no task covers and nobody has read yet would otherwise count as no work, so the planner adds one **explore** item per source linked to the exam (through any of its chapters or ExamChunks):

- **Size:** unexplored units = the source's units not covered by a saved ReadingSession, a read task, or a task not yet read (those are planned as first reads already).
- **Estimate:** unexplored units × pace × New familiarity, split into reading sessions like any first read.
- **Placement:** like the first read of a Medium task, in source order after the source's existing unread tasks; never in the taper. The item has `sourceId` set and no `taskId`.
- It shrinks as the student reads, and disappears when the source is fully explored or every chapter has a task.
- On Today it opens the source's "Read from" flow.

**Feasibility:** if a High task cannot meet its deadline with all capacity before it, the Exam screen asks the student (see "When time runs out").

## Filling each day

```
for day in today..examDay-1:
  cap = minutesFor(day)                      // availability, overrides, taper
  place every review due by day (overdue included), by importance then due date
  left = cap - placed                       // reviews are never limited by cap
  // a break day (cap 0) carries its reviews to the next day
  while left >= 15 and firstReads remain:
    t = next first read by placement order
    session = min(t.nextSession, left)       // a reading session, ≤ 45 min
    place session; left -= session
  schedule the planned reviews of tasks started today, fitted before the exam
```

- **15-minute floor:** a new first-read session never starts with less than 15 minutes left. Continuing a started reading may use less.
- **One overrun:** a session may push the day up to 10 minutes over to finish a session rather than split it.
- **Today screen order:** reviews (overdue, due and final) by importance, then due date; then first reads by importance.
- **Bonus items:** when the student finishes early, the next day's first read is offered as optional, never added silently.
- **Determinism:** ties break by task id.

## Missed days and rebalancing

Overdue reviews always come first, ahead of any new material. Sessions are never moved by hand: anything not done becomes overdue and is replanned.

- **Detection:** on the first app open of a new day, PlanItems still planned for earlier dates are marked `moved`, and the planner reruns from today.
- **Overdue first:** overdue reviews are planned for today, before anything else, by importance then due date, however many there are.
- **First reads shift later** when reviews take the day's minutes. If that pushes a High task past its deadline, the Exam screen asks the student.
- **No punishment:** belts never drop. Overdue tasks dim; one Solid review restores them.
- **Message:** one line on Today, e.g. "Yesterday's 3 sessions are spread over the next 2 days · ". If the projection drops, say so plainly.
- **Breaks and mock tests:** set in advance as an AvailabilityOverride (0 minutes, or reduced minutes on a mock-test day). Planned around, never counted as missed, and they don't break the streak.

## When time runs out

Reviews are never cut (D53): they are all planned, and the student covers what they can. The automatic cuts of earlier versions (dropping final reviews, lowering targets, skims) are gone.

**Trigger:** first reads cannot all finish before the taper, or a High task cannot meet its first-read deadline.

**The Exam screen asks the student:** add daily minutes (showing the exact number that would fit everything), or choose tasks to drop from the plan. Choices are stored as ExamTask overrides and can be undone.

## Several exams (1.1)

```
share[e] = w[e] × remaining[e] / daysLeft[e]  ÷  Σ_k ( w[k] × remaining[k] / daysLeft[k] )
```

- w = exam priority weight: low 1, normal 1.5, high 2. remaining = that exam's planned minutes not yet done.
- Locked days give that day entirely to one exam and are excluded from shares.
- Shared tasks take the earliest exam's deadline and the highest importance; a review advances every exam it belongs to.
- A shared task gets a final review before each exam, unless the exams are within 7 days of each other.
- Overload: the lowest-priority exam asks first.
- Shares are recomputed every run.

## Worked example (use as a golden test)

**Setup:** JEE Main on 10 Jan 2027; today 28 Oct 2026 (day 0); 73 study days. 105 minutes Monday to Saturday, 240 on Sunday: 870 minutes a week, about 151 hours total.

**Workload:** 38 tasks (12 High, 16 Medium, 10 Low), 9 not started. Remaining first reads about 22 h; reviews are planned on their days whatever the load.

**Rotational motion** (High, HC Verma pp. 166–197, New):

1. Estimate: 32 pages × 3 × 1.0 = 96 min → reading sessions of 45, 45 and 6 on days 0, 1, 2.
2. Reviews from day 2, the exam on day 74 (deadline day 73): the default gaps put them on days 3, 6, 13, 27 and 57. The next gap (60) would pass the deadline, so a sixth, final review lands in the High final window before the exam. Six Solid reviews: Yellow to Black.
3. First review 30 min (35% of 96, capped), the rest about 19.

The golden test should assert the structure: the reading sessions, reviews at the default gaps, a final review in the last days before the exam, and at least 5 reviews.

**Short on time:** the student drops to 30 min every day. Every review is still planned on its day; first reads move later, and those that no longer fit before the taper show on the Exam screen with the extra minutes a day that would fit them.

## Configuration defaults

| Setting | Default | Student can change |
| --- | --- | --- |
| Review gaps | 1, 3, 7, 14, 30, 60 days; at least 5 reviews before the exam; retry after 1 day | Yes (Settings, D53) |
| Daily minutes per weekday | Set at first launch | Yes |
| Max reading session | 45 min | No |
| New-session floor | 15 min | No |
| Overdue reviews | Always first, before first reads | No |
| Taper before exam | 2 days | No |
| Last review | By the day before the exam | No |
| Source order | Enforced | Per source ("any order") |

## Decisions

- No manual dragging of sessions.
- No cram mode; the taper stays reviews only.
- Mock tests are availability overrides.
- Overdue reviews always come first; no backlog cap.
