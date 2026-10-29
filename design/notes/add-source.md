# Add source (`/sources/new`) — design note

For approval before building. Tokens and components as in `docs/06-screens.md` and `lib/core/ui/`.

## Purpose

Adds a PDF, book, video, link, notes or question bank, and splits it into chapters (chunks), ideally in under a minute. It opens from the nav bar's + button, and opens pre-filled when a PDF or link is shared into the app.

## Layout (one scrolling page, ground background, 20 px side padding)

1. **Top bar:** a 44 px round back button and the title "Add source" (Bricolage 22 px).
2. **"What is it?"**: a 3 × 2 grid of choice chips: PDF, Book, Video, Link, Notes, Question bank. One is selected (ink fill). Shared files and links preselect PDF or Link.
3. **Details card** (surface, 16 px radius). The fields depend on the type:

   | Type | Fields |
   | --- | --- |
   | PDF | A secondary button "Choose PDF". Once chosen: file name, size, "480 pages" |
   | Book | Title; total pages (number field) |
   | Video | Title; link (optional); length in minutes |
   | Link | Link; title (fetched offline from the shared text only, otherwise typed) |
   | Notes | Title; pages |
   | Question bank | Title; number of questions |

4. **Chapters card.** The best available split comes first:
   - **PDF with bookmarks:** "Found 22 chapters in the bookmarks". It lists title and page range (e.g. "Ch 3 Rest and motion · pp. 40–62"), with "Use these" selected. Nested bookmarks are indented under their chapter.
   - **Otherwise, these options:**
     - "Paste a chapter list": a multi-line field, one chapter per line ending in its first page, e.g. "Rest and motion 40".
     - "Number of chapters" (D49): a − / + stepper, default 10. Creates Ch 1 … Ch N with no page numbers; the source is then read chapter by chapter.
     - "Split every N pages": a − / + stepper, default 20.
     - "Split as I read" (D47, D49): no chapters now; each saved sitting becomes the next part.
     - "Keep as one": a single chunk.
   - **Hints:**
     - A chunk under 5 pages gets a small "Short — merge with next?" text button.
     - A chunk whose first read is over 45 minutes gets "Long — will be read over N sessions".
5. **Bottom actions:** primary "Save and survey" (goes to the survey) and secondary "Save".

## States

| State | What shows |
| --- | --- |
| Empty | No type selected. The details and chapters cards are hidden until a type is chosen. Save is disabled. |
| Reading a PDF | Inside the details card: "Reading bookmarks…" with a small indeterminate bar. Usually under a second. |
| Filled | As laid out above. Save is enabled once the required fields are valid. |
| Error: unreadable or scanned PDF | A warning card: "This PDF has no bookmarks we can read." The three manual options show. |
| Error: duplicate file | A warning card: "Already added as HC Verma Vol 1" with a secondary button "Open it". The same file is detected by SHA-256 and never copied twice. |
| Error: invalid input | An inline 12 px message under the field in warning text, e.g. "Pages must be more than 0". |

## Data effects

Saving writes, in one undoable operation:
- a Source row;
- a SourceFile row, after copying the PDF to `<app documents>/sources/<uuid>.pdf`;
- one Chunk row per chapter ("Number of chapters" chunks have no start or end unit; "Split as I read" writes none).

Saving does not create tasks. Tasks are created from chapters when the survey finishes, one per chapter by default.
