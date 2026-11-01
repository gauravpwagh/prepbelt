# Google Play store listing

Text and assets for PrepBelt's Play Store listing (Grow → Store presence → Main store listing). Internal testing works without it; it is needed before a closed, open or production release. Limits are Play's: title 30 characters, short description 80, full description 4000.

Keep every claim true for the build being released. If a feature moves to a later version (Gems theme, flashcards, multiple exams, web), it stays out of the listing until it ships.

## App details

| Field | Value |
| --- | --- |
| App name | PrepBelt |
| Default language | English (India) — en-IN |
| App or game | App |
| Free or paid | Free |
| Category | Education |
| Tags | Study planner, Education, Productivity (pick the closest Play offers) |
| Contact email | The owner's developer email (required, shown publicly) |
| Website | Optional; leave empty until there is one |
| Privacy policy | Public URL of `docs/release/privacy-policy.md` |

## Short description (80 max)

```
Exam prep, belt by belt: plan, study and review every chapter before exam day.
```

## Full description (4000 max)

```
PrepBelt plans your exam preparation backwards from the exam date, then helps you study and review every chapter in time. Each topic earns a martial-arts belt, from White to Black, as you review it.

ADD WHAT YOU STUDY FROM
• PDFs, books, videos, links, notes and question banks.
• Share a PDF or a link straight into PrepBelt from any app.
• Split a source into chapters, or into parts of a chapter.

SURVEY IN A FEW MINUTES
For each chapter, say how important it is for this exam, how hard it is and how well you know it. A 20-chapter book takes about three minutes. PrepBelt uses your answers to decide how much time each chapter needs and how far to take it.

A PLAN THAT FITS YOUR EXAM
• A day-by-day schedule built from your exam date and the study time you have each day.
• Overdue reviews always come first, and missed sessions are replanned for you.
• The last two days before the exam are for reviews only, no cramming.

STUDY IN THE APP YOU ALREADY USE
Tap Start and your PDF, video or link opens in its own app. Come back, say where you stopped, and PrepBelt remembers where to resume.

REVIEWS THAT EARN BELTS
• After the first read, each chapter gets its reviews at growing gaps, all fitted before the exam.
• A Good review earns the next belt: White, Yellow, Orange, Green, Blue, Brown, and Black for an extra review.
• A shaky review never takes a belt away. It dims, and one Good review restores it.
• Review any chapter early whenever you like; it counts.

SEE WHERE YOU STAND
Today shows what is due, what you have not started and what is coming up. The progress grid shows every chapter's belt at a glance.

YOUR DATA STAYS ON YOUR PHONE
• Works fully offline. No account, no ads, no analytics.
• Your PDFs live in a folder you choose, where you can see and manage them.
• PrepBelt saves a backup of your progress in that folder automatically, so a new phone or a reinstall picks up where you left off.

Built for students preparing for school, university, entrance and competitive exams.
```

About 2,000 characters, well under the limit.

## Graphics

| Asset | Size | Source |
| --- | --- | --- |
| App icon | 512 × 512 PNG, 32-bit, no transparency needed | Export from `design/brand/` (the ring icon); `assets/brand/icon.png` is 1024 px |
| Feature graphic | 1024 × 500 PNG or JPG | Not made yet: the ring icon on the navy-to-ink gradient with "PrepBelt" and the short description |
| Phone screenshots | 2–8, 9:16, at least 1080 px on the short side | Taken from the release build, light mode |

Suggested screenshots, in order:

1. Today with sessions due (the three boxes).
2. A belt promotion moment.
3. The progress grid.
4. The survey of a book.
5. The exam planner.
6. Settings showing the study folder and automatic backup.

Use sample data (a realistic exam and sources), never a tester's real name. Every belt shown must be a martial-arts belt with its knot, never a trouser belt.

## Release notes

Each release has its own notes (500 characters max per language).

### 0.1.0 (5)

```
• Your PDFs now live in a study folder you choose.
• Automatic backup of your progress into that folder, daily by default.
• Moved a PDF? PrepBelt finds it again, or asks you to relink it.
• Edit a source's title, link, total pages and file.
• Sharing a link from chat apps such as ChatGPT now works.
```

### 0.1.0 (4)

```
Today in three boxes: reviews due, not started, reviews ahead.
```

## Data safety form

Unchanged by the listing; see `android.md` (App content). In short: no data collected, no data shared, no network access. The study folder and its backups stay on the phone in a place the student chose.
