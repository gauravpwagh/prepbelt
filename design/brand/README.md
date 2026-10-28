# PrepBelt logo and app icon concepts

Three concepts for approval. Each is an icon mark plus the "PrepBelt" wordmark (Bricolage Grotesque 700, converted to outlines). `preview.html` / `preview.png` show each at 1024, 192 and 48 px on light and dark grounds.

All three draw the knot as a slanted wrap of cloth with two tails hanging down, so the mark reads as a tied martial-arts belt. There is no box-shaped knot, which could pass for a trouser buckle. Colours come from the tokens, at most three per icon, with no text inside the mark. The mark stays inside the central 640 px of 1024, the Android adaptive-icon safe zone.

| Folder | Files |
| --- | --- |
| `1-knot/`, `2-rank-tip/`, `3-dawn/` | `icon.svg` (full-bleed app icon), `icon-foreground.svg` + `icon-background.svg` (adaptive layers), `lockup-light.svg`, `lockup-dark.svg`, `icon-1024.png` |
| `src/build_brand.py` | Source of all geometry. Run `python design/brand/src/build_brand.py` to regenerate. |

## 1 · Knot

A cream belt tied front-on, on the indigo accent. This is the most direct expression of the name: one calm, symmetrical shape that reads as "belt" at any size, including 48 px, where the band and tails stay distinct. Indigo ties it to the app's primary buttons, so the icon and the UI feel like one product. Colours: accent `#4338CA`, white belt `#F1EFE8`.

## 2 · Rank tip

The same tied belt, with the dark rank tip at its end. Its three stripes step upward like a progress chart, so the belt itself says "earned progress", which echoes the stripes the app uses for shine. It tells the richest story of the three, but the stepped stripes merge at 48 px, so in the smallest sizes it reads as Knot plus a dark end. Colours: accent `#4338CA`, white belt `#F1EFE8`, ink `#151A2D`.

## 3 · Dawn

A belt tied beneath a rising sun on ink. It is the calmest of the three: early-morning training, a new day of steady practice. It nods to the "Night to sun" palette of the progress grids. The warm sun makes it stand out on a home screen, and the dark ground suits dark mode. Colours: ink `#151A2D`, yellow belt `#FAC775`, white belt `#F1EFE8`.

## A concept rejected along the way

A diagonal "Ascent" belt rising to the upper right was dropped: with the tails hanging below, it read as a telescope on a tripod.

## After approval

Generate Android adaptive icons (foreground, background and a monochrome layer for Android 13+) and iOS icons with `flutter_launcher_icons`, plus a splash screen with `flutter_native_splash`, from PNG exports placed in `assets/brand/`. Until then the app keeps Flutter's default icon as a temporary icon.
