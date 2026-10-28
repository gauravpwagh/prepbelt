# PrepBelt logo and app icon

**Chosen: 4 · Belt ring** (owner, 28 Oct 2026). The other concepts are kept for reference.

## Concepts (round 2)

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

## 4 · Belt ring (owner's direction)

Revised to the owner's direction, after their reference image: a bold white checkmark inside a ring of five vivid, rounded arcs (yellow, orange, green, blue, violet, clockwise from the top) on a navy-to-ink gradient. It is an original design in that style, not a copy: its own colours, order, segment count and proportions. The checkmark says "done, ready"; the ring of colours says progress. `4-ring/small-sizes.png` shows it at 192, 96 and 48 px, where it stays crisp.

Choosing it overrides two CLAUDE.md brand rules: the mark is no longer a martial-arts belt, and it uses vivid colours outside the tokens (five plus the gradient). The belts stay the in-app progress system.

## App assets

`python design/brand/src/build_brand.py` writes the chosen icon's SVGs to `assets/brand/`:

| File | Use |
| --- | --- |
| `icon` | iOS and legacy Android icon, full bleed, no transparency |
| `icon-foreground`, `icon-background` | Android adaptive layers; the mark is scaled to 0.8 so it clears round masks |
| `icon-monochrome` | Android 13+ themed icon |
| `splash`, `splash-android12` | Splash mark on ink `#151A2D`; Android 12+ uses the smaller one |

Render each SVG to a 1024 px PNG of the same name, with a transparent background for every file except `icon` and `icon-background`. For example, with Chrome:

```
chrome --headless=new --hide-scrollbars --default-background-color=00000000 --window-size=1024,1024 --screenshot=assets/brand/icon-foreground.png file:///.../assets/brand/icon-foreground.svg
```

Then run `dart run flutter_launcher_icons` and `dart run flutter_native_splash:create`. Configuration lives in `flutter_launcher_icons.yaml` and `flutter_native_splash.yaml`.
