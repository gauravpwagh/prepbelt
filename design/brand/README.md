# PrepBelt logo and app icon concepts (round 2)

Round 1 (Knot, Rank tip, Dawn) was declined as not modern or elegant enough. Round 2 drops its flat slabs and hard polygon gaps in favour of curves, tapered tails, softer corners and more negative space.

All three share one knot: a slanted wrap of cloth with soft corners, with two tapered, curved tails crossing beneath it. A slanted wrap with tails reads as a tied martial-arts belt. An upright box or an outlined rectangle on a strap reads as a buckle, so both were ruled out. Colours come from the tokens, with no text in the mark, and the mark stays inside the central 640 px of 1024 (Android's adaptive-icon safe zone).

`preview.html` / `preview.png` show each concept at 1024, 192 and 48 px on light and dark grounds, with lockups. `small-sizes.png` puts the 192 and 48 px renders side by side.

| Folder | Files |
| --- | --- |
| `1-wrapped/`, `2-ribbon/`, `3-gradient/` | `icon.svg` (full-bleed app icon), `icon-foreground.svg` + `icon-background.svg` (adaptive layers), `lockup-light.svg`, `lockup-dark.svg`, `icon-1024.png` |
| `src/build_brand.py` | Source of all geometry. Run `python design/brand/src/build_brand.py` to regenerate. |

## 1 · Wrapped

The belt runs edge to edge across the icon, as if the app itself were tied, with the knot at its centre. It is the boldest of the three, and the most recognisable on a crowded home screen: a single cream band on the accent indigo, legible down to 48 px. Colours: accent `#4338CA`, white belt `#F1EFE8`.

## 2 · Ribbon

A softly curved band that swells toward the knot, like a belt seen tied around a gi, in accent indigo on a light ground. It is the lightest and most calligraphic, with a quiet, premium feel. On light home screens it relies on the platform's icon edge for its outline. Colours: ground `#F3F4F8`, accent `#4338CA`.

## 3 · Gradient

The Ribbon form, with the cloth shading from yellow belt to black belt along its length. Progress is the belt itself, the app's whole idea in one shape, and the warm-gold-to-black blend gives it the most elegant finish. It uses the Dojo belt colours rather than the UI accent, so it reads as "belts" before "app". Colours: ground `#F3F4F8`, yellow belt `#FAC775` → black belt `#2C2C2A`.

## 4 · Belt ring (from the owner's reference)

An original take on a segmented progress-ring style the owner shared, not a copy of it. Seven rounded arcs in the Dojo belt colours run clockwise from White at the top to Black, around a tied cream belt where the reference had a checkmark. The ring says "progress through the belts" and the centre says "martial-arts belt", which suits the product better than a generic checkmark. The Black arc has a muted edge so it shows on the dark ground. `4-ring/small-sizes.png` shows it at 192, 96 and 48 px.

It breaks the CLAUDE.md rule of at most 2–3 colours (it uses seven belt colours plus ink), so choosing it means waiving that rule.

## After approval

Generate Android adaptive icons (foreground, background and a monochrome layer for Android 13+) and iOS icons with `flutter_launcher_icons`, plus a splash screen with `flutter_native_splash`, from PNG exports placed in `assets/brand/`. Until then the app keeps Flutter's default icon as a temporary icon.
