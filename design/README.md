# Design mockups

These are the source files of the five designed 1.0 screens, exported from the PrepBelt design canvas. Build the Flutter screens to match them.

| File | Screen |
| --- | --- |
| `mockups/1-today.html` | Today |
| `mockups/2-back-from-source.html` | Back from source (rate it) |
| `mockups/3-survey.html` | Source survey |
| `mockups/4-exam.html` | Exam belt and timeline |
| `mockups/5-redefine.html` | Redefine a task (split) |

## How to read them

- Each file is one 390 × 844 phone screen written as HTML with inline styles. They will not render on their own: they depend on the canvas runtime (`support.js`, `<x-dc>`, `<sc-for>`, `<sc-if>`, `{{holes}}`). Read them as an exact specification instead.
- **Exact values live in the inline `style` attributes:** colours, font sizes and weights, spacing, radii, borders, and layout (flex, grid, gaps).
- **Behaviour lives in the `<script type="text/x-dc">` block** at the end of the file. For example, `2-back-from-source.html` shows the page stepper bounds, the four ratings and the result messages; `3-survey.html` shows the live first-read estimate and target belt.
- Belts are inline SVGs; rebuild them as a Flutter `BeltBadge` widget (see `docs/06-screens.md`).
- Example content (JEE Main, HC Verma, page numbers, minutes) is placeholder data, not product copy.

## Translating to Flutter

- Fonts: Bricolage Grotesque (headings) and Manrope (body) via `google_fonts` or bundled assets.
- Map the colours to the tokens in `docs/06-screens.md`, never hard-code them in widgets.
- The mockups show light mode only; derive dark mode from the tokens.
- Where a mockup and a spec in `docs/` disagree, the spec wins on behaviour and the mockup wins on look. Flag the conflict.

Six 1.0 screens are not designed yet (First launch, Add exam, Sources list, Add source, Task detail, Settings). Claude Code designs them in the same tokens and patterns, writing a short layout note per screen in `design/notes/` for approval before building (see "Design ownership" in `CLAUDE.md`).
