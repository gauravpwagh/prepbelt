"""Builds the three PrepBelt logo concepts as SVG.

Run from the repo root:  python design/brand/src/build_brand.py
Outputs go to design/brand/<concept>/. Geometry is hand-written below on a
1024 x 1024 grid; the mark stays inside the central 640 px so it survives
Android's adaptive-icon mask (safe zone 66%).
The wordmark is Bricolage Grotesque 700 converted to outlines with
fontTools, so the SVGs need no font.
"""
from pathlib import Path

from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / "design" / "brand"
FONT = ROOT / "assets" / "fonts" / "BricolageGrotesque-700.ttf"

# Tokens (docs/06-screens.md).
INK = "#151A2D"
GROUND = "#F3F4F8"
ACCENT = "#4338CA"
WHITE_BELT = "#F1EFE8"
YELLOW_BELT = "#FAC775"


def knot_and_tails(cx, cy, s, belt, gap, angle=0):
    """A martial-arts knot seen from the front, centred on (cx, cy): a
    slanted wrap of cloth over the band (never a box, which would read as
    a buckle) and two tails that hang straight down whatever the belt's
    angle. s scales the design; angle tilts the wrap with the band.
    Overlaps are separated by strokes in the background colour.
    """
    def p(x, y, rot=0.0):
        import math
        a = math.radians(rot)
        rx = x * math.cos(a) - y * math.sin(a)
        ry = x * math.sin(a) + y * math.cos(a)
        return f"{cx + rx * s:.1f},{cy + ry * s:.1f}"

    w = 16 * s
    tails = (
        f'<polygon points="{p(-40, 40)} {p(40, 54)} {p(-70, 345)} {p(-165, 318)}" '
        f'fill="{belt}" stroke="{gap}" stroke-width="{w:.1f}" stroke-linejoin="round"/>'
        f'<polygon points="{p(40, 40)} {p(-40, 54)} {p(70, 345)} {p(165, 318)}" '
        f'fill="{belt}" stroke="{gap}" stroke-width="{w:.1f}" stroke-linejoin="round"/>'
    )
    wrap = (
        f'<polygon points="{p(-100, -84, angle)} {p(28, -84, angle)} {p(100, 84, angle)} {p(-28, 84, angle)}" '
        f'fill="{belt}" stroke="{gap}" stroke-width="{18 * s:.1f}" stroke-linejoin="round"/>'
    )
    return tails + wrap


def concept_knot(bg):
    """1 · Knot: the tied belt, front on. Cream belt on indigo."""
    belt, gap = WHITE_BELT, bg
    band = f'<rect x="176" y="420" width="672" height="120" rx="24" fill="{belt}"/>'
    return band + knot_and_tails(512, 480, 1.0, belt, gap)


def concept_rank_tip(bg):
    """2 · Rank tip: a tied belt whose dark rank tip carries three stripes
    that step upward, so the belt itself reads as earned progress."""
    belt, gap = WHITE_BELT, bg
    band = f'<rect x="160" y="420" width="704" height="120" rx="24" fill="{belt}"/>'
    tip = f'<path d="M 640 420 H 840 A 24 24 0 0 1 864 444 V 516 A 24 24 0 0 1 840 540 H 640 Z" fill="{INK}"/>'
    stripes = "".join(
        f'<rect x="{x}" y="{540 - 16 - h}" width="30" height="{h}" rx="6" fill="{belt}"/>'
        for x, h in ((672, 36), (730, 60), (788, 88))
    )
    return band + tip + stripes + knot_and_tails(400, 480, 0.92, belt, gap)


def concept_dawn(bg):
    """3 · Dawn: a belt tied below a rising sun. Calm, early training."""
    belt, gap = WHITE_BELT, bg
    sun = (
        f'<path d="M 272 520 A 240 240 0 0 1 752 520 Z" fill="{YELLOW_BELT}"/>'
    )
    band = f'<rect x="176" y="508" width="672" height="112" rx="22" fill="{belt}" stroke="{gap}" stroke-width="16"/>'
    return sun + band + knot_and_tails(512, 564, 0.92, belt, gap)


CONCEPTS = {
    "1-knot": {
        "name": "Knot",
        "draw": concept_knot,
        "icon_bg": ACCENT,
        "colors": [ACCENT, WHITE_BELT],
    },
    "2-rank-tip": {
        "name": "Rank tip",
        "draw": concept_rank_tip,
        "icon_bg": ACCENT,
        "colors": [ACCENT, WHITE_BELT, INK],
    },
    "3-dawn": {
        "name": "Dawn",
        "draw": concept_dawn,
        "icon_bg": INK,
        "colors": [INK, YELLOW_BELT, WHITE_BELT],
    },
}


def wordmark_path(text, size, x0, baseline):
    font = TTFont(FONT)
    glyphs = font.getGlyphSet()
    cmap = font.getBestCmap()
    scale = size / font["head"].unitsPerEm
    pen = SVGPathPen(glyphs)
    x = x0
    for ch in text:
        name = cmap[ord(ch)]
        tpen = TransformPen(pen, (scale, 0, 0, -scale, x, baseline))
        glyphs[name].draw(tpen)
        x += glyphs[name].width * scale
    return pen.getCommands(), x - x0


def svg(w, h, body):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" '
        f'width="{w}" height="{h}">{body}</svg>\n'
    )


def build():
    for key, c in CONCEPTS.items():
        d = OUT / key
        d.mkdir(parents=True, exist_ok=True)
        bg = c["icon_bg"]

        # App icon: full-bleed square; the OS applies its own mask.
        (d / "icon.svg").write_text(
            svg(1024, 1024, f'<rect width="1024" height="1024" fill="{bg}"/>' + c["draw"](bg))
        )
        # Adaptive-icon layers for Android (after approval).
        (d / "icon-foreground.svg").write_text(svg(1024, 1024, c["draw"](bg)))
        (d / "icon-background.svg").write_text(
            svg(1024, 1024, f'<rect width="1024" height="1024" fill="{bg}"/>')
        )

        # Lockups: rounded mark + wordmark, for light and dark grounds.
        for mode, text_color in (("light", INK), ("dark", "#FFFFFF")):
            words, width = wordmark_path("PrepBelt", 300, 0, 0)
            mark = (
                f'<svg x="0" y="0" width="400" height="400" viewBox="0 0 1024 1024">'
                f'<rect width="1024" height="1024" rx="230" fill="{bg}"/>{c["draw"](bg)}</svg>'
            )
            body = mark + (
                f'<path transform="translate(460 300)" d="{words}" fill="{text_color}"/>'
            )
            (d / f"lockup-{mode}.svg").write_text(svg(int(460 + width + 20), 400, body))


if __name__ == "__main__":
    build()


def preview():
    """design/brand/preview.html: every concept at 1024, 192 and 48 px on
    light and dark grounds, plus both lockups."""
    rows = []
    for key, c in CONCEPTS.items():
        icon = (OUT / key / "icon.svg").read_text()
        cells = []
        for mode, ground in (("light", GROUND), ("dark", INK)):
            sizes = "".join(
                f'<div class="ic" style="width:{s}px;height:{s}px;border-radius:{s * 0.225}px">{icon}</div>'
                for s in (1024, 192, 48)
            )
            lock = (OUT / key / f"lockup-{mode}.svg").read_text()
            cells.append(
                f'<div class="mode" style="background:{ground}">{sizes}'
                f'<div class="lock">{lock}</div></div>'
            )
        rows.append(f'<section><h2>{c["name"]}</h2>{"".join(cells)}</section>')
    html = (
        "<!doctype html><meta charset=utf-8><title>PrepBelt logo concepts</title>"
        "<style>body{margin:0;font:600 28px system-ui;color:#151A2D;background:#fff}"
        "section{padding:24px}h2{margin:0 0 12px}"
        ".mode{display:flex;align-items:flex-end;gap:32px;padding:32px;margin-bottom:12px;border-radius:24px}"
        ".ic{overflow:hidden;flex:none}.ic svg{width:100%;height:100%;display:block}"
        ".lock svg{height:120px;width:auto;display:block}</style>"
        + "".join(rows)
    )
    (OUT / "preview.html").write_text(html)


if __name__ == "__main__":
    preview()
