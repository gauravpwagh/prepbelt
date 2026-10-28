# Sources list (`/sources`) — design note

For approval before building (CLAUDE.md, "Design ownership"). Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`.

## Purpose

Shows every study source, with how much of each survey is done and a one-tap route into the survey. It is reached from the Sources tab; new sources come from the raised + in the nav bar.

## Layout (390 × 844, ground background, 20 px side padding)

1. **Header**, as on Today:
   - **Subtitle**, 13 px muted: "3 sources · 2 surveyed".
   - **Title**, Bricolage 30 px: "Sources".
2. **Source cards**: a list with 10 px gaps. Each card has a surface fill, a 1 px line border, a 16 px radius and 12/14 px padding.
   - **Left:** a 40 px rounded square (12 px radius) in accent-soft with the type icon in accent: PDF, book, video, link, notes or question bank. The icons are 2 px strokes in the existing icon set.
   - **Middle:**
     - Overline in muted: "PDF · 480 PAGES".
     - Title, 15 px bold, up to 2 lines.
     - Caption: "22 chapters".
   - **Bottom of the card:** survey progress as a 6 px bar (track in line colour, fill in accent) with "Surveyed 14 of 22" beside it in 12 px muted.
   - **Right:**
     - Survey not finished: a small secondary button "Survey" (44 px touch target).
     - Survey finished: a check in muted with the label "Surveyed".
   - **Tap the card:** opens the survey (`/sources/:id/survey`), which resumes at the first unsurveyed chapter.
   - **Long-press:** a bottom sheet with Rename and Remove. Remove is a soft delete with an "Undo" snackbar.
3. **Order:** sources with an unfinished survey first, then by title.

## States

| State | What shows |
| --- | --- |
| Empty | Centred on the screen: a dashed-outline belt (the not-started badge, large); "No sources yet" in 17 px bold; "Add a PDF, book, video or link you'll study from." in muted; a primary button "Add a source". |
| Loading | Three skeleton cards (line-colour blocks, no shimmer, to keep motion calm). This normally flashes for under 100 ms from the local database. |
| Filled | As laid out above. |
| Error | A warning card (warning bg, border and text tokens): "Couldn't load your sources." with a secondary button "Try again". |

## Accessibility

- Each card is one Semantics node: "HC Verma Vol 1, PDF, 480 pages, surveyed 14 of 22 chapters. Double-tap to continue the survey."
- The progress bar is labelled with its text, so it never relies on colour alone.
