# PrepBelt — Phase 1 Scope

Phase 1 is fully offline and ships in three releases. 1.0 proves the core loop for one exam: add a source, survey it, study it, rate it, earn belts. Everything after it adds breadth, not new foundations.

## Releases

| Release | Goal | Adds |
| --- | --- | --- |
| 1.0 | One student, one exam, the daily loop works and feels good (Android and iOS) | Sources (share-in + manual), survey, tasks, open externally, review with 4 ratings, 5-review schedule, belts (Dojo theme), one exam, planner, Today screen, exam belt + readiness, activity grid, redefine (edit, scope, split, pause), undo, settings |
| 1.1 | Real exam season: several exams and sharing with friends | Web build, multiple exams with capacity split, triage view, mastery timeline, merge and swap source, `.belt` template export and import, rest tokens, daily quests, XP |
| 1.2 | Depth and delight | Optional flashcards and questions, gem theme and palette picker, achievements and vault, community difficulty hints, belt ceremony polish, home-screen widget |

The data model already covers all three, so no release needs a schema redesign.

## 1.0 screens

| Screen | Must do | Designed |
| --- | --- | --- |
| First launch | Pick name and daily study minutes, then add an exam or skip; under 60 seconds | No |
| Add exam | Name, date, minutes per weekday; link sources now or later | No |
| Today | Ordered sessions with time and belt; one tap to start; streak; exam card | Yes |
| Back from source | Where you stopped, time spent, 4 ratings, promotion moment | Yes |
| Sources | List with survey progress; add by file, link or share sheet | No |
| Add source | Type, title, file or URL; read PDF bookmarks or paste the chapter list; split by page ranges | No |
| Survey | Per chapter: importance, difficulty, familiarity; live estimate; bulk-set | Yes |
| Exam | Belt, projection, readiness, weak links, activity grid | Yes (timeline moves to 1.1) |
| Task detail | Belt, next review, history, sources, Start, Redefine | No |
| Redefine | Edit, scope, split, pause with impact preview and undo | Yes (split) |
| Settings | Theme (Dojo only in 1.0), reminder time, export a backup file | No |

Screens marked "No" need design before milestone 3. Follow the tokens and patterns in `06-screens.md` until then.

### Behaviours across screens

- **Share into the app** (Android, iOS): a PDF or link shared from another app opens Add source pre-filled.
- **Open externally**: Start launches the file or link in its own app and records the start; returning opens Back from source.
- **Reminder**: one local notification a day at the chosen time, with today's session count.
- **Planner**: regenerates after every review, survey change or missed day, within the daily minutes.
- **Backup**: a single exported file of the whole database, since there is no sync yet.

## Not in phase 1

- Accounts, cloud sync, multiple devices
- In-app PDF reader or annotation
- A public template library or marketplace (sharing stays file-based)
- Teacher or class dashboards
- AI-generated flashcards or syllabus extraction
- Leaderboards, friends, chat
- Web share-in (web gets file upload only, in 1.1)

## Done means (1.0 acceptance)

1.0 ships when every item passes on Android and iOS:

- [ ] Install to first planned session in under 3 minutes, unaided
- [ ] A full review (start, return, rate) takes 3 taps after the study itself
- [ ] Surveying a 20-chapter book takes under 3 minutes
- [ ] Works with no network on first launch and forever after
- [ ] Killing the app mid-session loses nothing; the return screen still appears
- [ ] Rebuilding TaskState from the Review log gives identical levels
- [ ] Every redefinition can be undone
- [ ] The planner never schedules more than the day's minutes (except one overrun of at most 10 minutes), and every task due before the exam gets a final review
- [ ] Text contrast at least 4.5:1, touch targets at least 44 px, belts readable without colour
- [ ] Today screen opens in under 1 second on a mid-range Android phone with 500 tasks
- [ ] Backup export, then import on a fresh install, restores everything

## Build order

1. **Foundations**: Flutter project for Android and iOS, kept web-compatible for 1.1; Drift schema with the event log; repository layer; theme tokens.
2. **Review engine**: the 5-review schedule fitted to the exam date, Review log, TaskState rebuild, belt and brightness rules, with unit tests replaying sample histories.
3. **Sources and survey**: add source (manual, file, share-in), chapter split from PDF bookmarks, survey flow, local file storage.
4. **Daily loop**: tasks, Today screen, open externally, return-and-rate screen, promotion animation, streak, reminder.
5. **Exam and planner**: add exam, availability, backward planner, rebalancing, exam belt, readiness, weak links, activity grid.
6. **Redefine and polish**: edit, scope, split, pause, undo; first-launch flow; settings and backup; accessibility and performance pass against Done means.

## Risks

| Risk | Mitigation |
| --- | --- |
| Return from the external app is unreliable | Persist the active session; detect app resume; "session in progress" banner; test on several Android vendors early (milestone 4) |
| Self-rating is inflated | Show the recall prompt before the ratings; optional cards in 1.2 give objective ratings |
| Planner feels wrong | Build from the planner spec with its worked example as a golden test; tune with internal testers |
| Level thresholds miscalibrated | Thresholds live in configuration; tune during the pilot |
| Web storage limits (1.1) | Request persistent storage; warn when space is low; backup export |

## Pilot

Internal testers pilot 1.0 through Play Console internal testing (Android) and TestFlight (iOS). No store listing is needed yet. Still open: how many testers, and for how long.
