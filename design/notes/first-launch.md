# First launch (`/onboarding`) — design note

Built on 29 Oct 2026 under D36; comments welcome. Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`. Scope from `docs/03-phase1-scope.md`: pick a name and daily study minutes, then add an exam or skip, in under 60 seconds. The notification permission is asked at the end (`docs/05-architecture.md`).

## Flow (three short steps, no back-and-forth)

A step dot row (3 pills, current one in accent) sits at the top of each step. Each step is one screen with a single primary button at the bottom.

1. **Welcome**
   - The app icon (the checkmark ring, 72 px), "PrepBelt" (Bricolage 30 px), and the tagline "Exam prep, belt by belt." in muted.
   - **"What should we call you?"**: a text field, optional. The placeholder reads "Your name".
   - **"Time to study each day"**: the − / + stepper, in 15-minute steps, default 1 h 30 min.
   - A caption: "You can set each weekday later on the exam screen."
   - Button: "Continue".
2. **Daily reminder**
   - The flame icon, with the title "A nudge each evening?".
   - Body: "One reminder at 19:00 on days you haven't studied yet. Never more than one a day."
   - Primary "Turn on reminder" asks for the OS permission, then continues.
   - Text button "Not now" turns the reminder off; it can be turned on in Settings.
3. **Your exam**
   - Title "What are you preparing for?", body "Add your exam to get a day-by-day plan. You can also start with your sources and add it later."
   - Primary "Add exam" opens Add exam; saving it lands on Today.
   - Secondary "Skip for now" goes to Today.

First launch is marked done when step 2 is left, so quitting during Add exam never shows it again.

## Who sees it

Only a fresh install: no "onboarded" setting **and** no sources or exams yet. Installs from before this screen (with data) are marked onboarded silently.

## States

| State | What shows |
| --- | --- |
| Filled | As above. Nothing is required except reaching the end. |
| Permission denied | Step 2 continues anyway, and the reminder stays off. |
| Error saving | "Couldn't save. Try again." above the button. |

## Data effects

- Setting `profile.name`, if a name was given.
- Availability: the chosen minutes on all 7 weekdays.
- `ui.reminderAsked` and `ui.reminderEnabled`.
- `profile.onboarded = true`.
