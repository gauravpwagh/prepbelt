"""Builds the PrepBelt logo concepts (round 2) as SVG.

Run from the repo root:  python design/brand/src/build_brand.py
Outputs go to design/brand/<concept>/ plus design/brand/preview.html.

Geometry is hand-written on a 1024 x 1024 grid; every mark stays inside
the central 640 px (Android adaptive-icon safe zone). Curves, tapered
tails and negative space replace round 1's flat polygons. The wordmark is
Bricolage Grotesque converted to outlines with fontTools, so the SVGs
need no font.
"""
import math
from pathlib import Path

from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / "design" / "brand"
FONT = ROOT / "assets" / "fonts" / "BricolageGrotesque-600.ttf"

# Tokens (docs/06-screens.md).
INK = "#151A2D"
GROUND = "#F3F4F8"
ACCENT = "#4338CA"
WHITE_BELT = "#F1EFE8"


def gradient(gid, top, bottom):
    """A quiet diagonal gradient between two token colours."""
    return (
        f'<defs><linearGradient id="{gid}" x1="0" y1="0" x2="1" y2="1">'
        f'<stop offset="0" stop-color="{top}"/>'
        f'<stop offset="1" stop-color="{bottom}"/></linearGradient></defs>'
    )


YELLOW_BELT = "#FAC775"
BLACK_BELT = "#2C2C2A"


def _halo(d, fill, gap, round_w, halo_w):
    """A shape with rounded corners and a gap-coloured halo that separates
    it from whatever it overlaps."""
    return (
        f'<path d="{d}" fill="{gap}" stroke="{gap}" stroke-width="{round_w + halo_w:.1f}" '
        'stroke-linejoin="round"/>'
        f'<path d="{d}" fill="{fill}" stroke="{fill}" stroke-width="{round_w:.1f}" '
        'stroke-linejoin="round"/>'
    )


def tails(cx, top, s, fill, gap):
    """Two tapered, gently curved tails crossing under the knot."""
    def pt(x, y):
        return f"{cx + x * s:.1f} {top + y * s:.1f}"

    left = (
        f"M {pt(18, 0)} C {pt(8, 64)} {pt(-30, 124)} {pt(-80, 182)} "
        f"L {pt(-34, 200)} C {pt(8, 142)} {pt(36, 78)} {pt(50, 8)} Z"
    )
    right = (
        f"M {pt(-18, 0)} C {pt(-8, 64)} {pt(30, 124)} {pt(80, 182)} "
        f"L {pt(34, 200)} C {pt(-8, 142)} {pt(-36, 78)} {pt(-50, 8)} Z"
    )
    return _halo(right, fill, gap, 10 * s, 18 * s) + _halo(left, fill, gap, 10 * s, 18 * s)


def knot(cx, cy, s, fill, gap):
    """The wrap: a slanted parallelogram of cloth over the band. Slanted
    and soft-cornered, so it reads as tied cloth, never as a buckle."""
    def pt(x, y):
        return f"{cx + x * s:.1f} {cy + y * s:.1f}"

    d = f"M {pt(-74, -70)} L {pt(22, -70)} L {pt(74, 70)} L {pt(-22, 70)} Z"
    return _halo(d, fill, gap, 30 * s, 26 * s)


def ribbon_band(fill, thickness=1.0):
    """A belt band that curves gently and swells toward the centre."""
    mid_top, mid_bot = 512 - 40 * thickness, 512 + 40 * thickness
    end_top, end_bot = 470, 520
    return (
        f'<path d="M 190 {end_top} C 330 {mid_top + 14:.0f} 430 {mid_top:.0f} 512 {mid_top:.0f} '
        f'C 594 {mid_top:.0f} 694 {mid_top + 14:.0f} 834 {end_top} '
        f'L 834 {end_bot} C 694 {mid_bot + 10:.0f} 594 {mid_bot:.0f} 512 {mid_bot:.0f} '
        f'C 430 {mid_bot:.0f} 330 {mid_bot + 10:.0f} 190 {end_bot} Z" '
        f'fill="{fill}" stroke="{fill}" stroke-width="18" stroke-linejoin="round"/>'
    )


def _centred(body):
    """Moves a ribbon mark up so its visual centre sits on the icon's."""
    return f'<g transform="translate(0 -70)">{body}</g>'


def concept_wrapped(gap):
    """1 · Wrapped: the belt runs edge to edge, as if the icon is tied."""
    band = f'<rect x="-10" y="452" width="1044" height="104" fill="{WHITE_BELT}"/>'
    return (
        band
        + tails(512, 552, 1.0, WHITE_BELT, gap)
        + knot(512, 504, 1.0, WHITE_BELT, gap)
    )


def concept_ribbon(gap):
    """2 · Ribbon: a softly curved band with a slanted wrap."""
    return _centred(
        ribbon_band(ACCENT, thickness=1.3)
        + tails(512, 564, 1.05, ACCENT, gap)
        + knot(512, 508, 1.05, ACCENT, gap)
    )


def concept_gradient(gap):
    """3 · Gradient: the belt shades from yellow to black along its length."""
    gid = "belt-progress"
    defs = (
        f'<defs><linearGradient id="{gid}" x1="190" y1="0" x2="834" y2="0" '
        f'gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="{YELLOW_BELT}"/>'
        f'<stop offset="1" stop-color="{BLACK_BELT}"/></linearGradient></defs>'
    )
    paint = f"url(#{gid})"
    return defs + _centred(
        ribbon_band(paint, thickness=1.3)
        + tails(512, 564, 1.05, paint, gap)
        + knot(512, 508, 1.05, paint, gap)
    )


def concept_ring(gap):
    """4 · Belt ring: the seven Dojo belts, white to black, as rounded arc
    segments of a progress ring around a tied belt."""
    belts = ["#F1EFE8", "#FAC775", "#EF9F27", "#639922", "#378ADD", "#854F0B", "#2C2C2A"]
    cx = cy = 512
    r, w = 300, 62
    step = 360 / 7
    sweep = step - 22
    arcs = []
    for i, color in enumerate(belts):
        a0 = math.radians(-90 - sweep / 2 + i * step)
        a1 = a0 + math.radians(sweep)
        x0, y0 = cx + r * math.cos(a0), cy + r * math.sin(a0)
        x1, y1 = cx + r * math.cos(a1), cy + r * math.sin(a1)
        d = f"M {x0:.1f} {y0:.1f} A {r} {r} 0 0 1 {x1:.1f} {y1:.1f}"
        if color == "#2C2C2A":
            # The black belt needs an edge to show on the dark ground.
            arcs.append(
                f'<path d="{d}" fill="none" stroke="#5A6178" stroke-width="{w + 8}" '
                'stroke-linecap="round"/>'
            )
        arcs.append(
            f'<path d="{d}" fill="none" stroke="{color}" stroke-width="{w}" '
            'stroke-linecap="round"/>'
        )
    band = f'<rect x="318" y="478" width="388" height="64" rx="18" fill="{WHITE_BELT}"/>'
    centre = (
        f'<g transform="translate(512 512) scale(0.62) translate(-512 -512)">'
        f'{tails(512, 552, 1.0, WHITE_BELT, gap)}{knot(512, 504, 1.0, WHITE_BELT, gap)}</g>'
    )
    return "".join(arcs) + band + centre


CONCEPTS = {
    "1-wrapped": {
        "name": "Wrapped",
        "draw": concept_wrapped,
        "bg": ("flat", ACCENT),
    },
    "2-ribbon": {
        "name": "Ribbon",
        "draw": concept_ribbon,
        "bg": ("flat", GROUND),
    },
    "3-gradient": {
        "name": "Gradient",
        "draw": concept_gradient,
        "bg": ("flat", GROUND),
    },
    "4-ring": {
        "name": "Belt ring",
        "draw": concept_ring,
        "bg": ("flat", INK),
    },
}


def background(gid, c, rx=0):
    """Returns (defs + rect, the colour used to cut gaps between shapes)."""
    if c["bg"][0] == "flat":
        color = c["bg"][1]
        return f'<rect width="1024" height="1024" rx="{rx}" fill="{color}"/>', color
    top, bottom = c["bg"][1], c["bg"][2]
    # On a gradient, gaps take the darker token colour and read as shadow.
    return (
        gradient(gid, top, bottom)
        + f'<rect width="1024" height="1024" rx="{rx}" fill="url(#{gid})"/>',
        INK,
    )


def wordmark_path(text, size, x0, baseline, tracking=-0.02):
    font = TTFont(FONT)
    glyphs = font.getGlyphSet()
    cmap = font.getBestCmap()
    scale = size / font["head"].unitsPerEm
    pen = SVGPathPen(glyphs)
    x = x0
    for ch in text:
        name = cmap[ord(ch)]
        glyphs[name].draw(TransformPen(pen, (scale, 0, 0, -scale, x, baseline)))
        x += glyphs[name].width * scale + tracking * size
    return pen.getCommands(), x - x0


def svg(w, h, body):
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {w} {h}" '
        f'width="{w}" height="{h}">{body}</svg>\n'
    )


def build():
    for old in OUT.iterdir():
        if old.is_dir() and old.name[0].isdigit():
            for f in old.iterdir():
                f.unlink()
            old.rmdir()
    for key, c in CONCEPTS.items():
        d = OUT / key
        d.mkdir(parents=True, exist_ok=True)
        bg, gap = background(f"bg-{key}", c)
        mark = c["draw"](gap)

        # App icon: full-bleed square; the OS applies its own mask.
        (d / "icon.svg").write_text(svg(1024, 1024, bg + mark), encoding="utf-8")
        # Adaptive-icon layers for Android (after approval).
        (d / "icon-foreground.svg").write_text(svg(1024, 1024, mark), encoding="utf-8")
        (d / "icon-background.svg").write_text(svg(1024, 1024, bg), encoding="utf-8")

        # Lockups: rounded mark + wordmark, for light and dark grounds.
        for mode, text_color in (("light", INK), ("dark", "#FFFFFF")):
            words, width = wordmark_path("PrepBelt", 300, 0, 0)
            rounded, _ = background(f"bg-{key}-lockup-{mode}", c, rx=230)
            body = (
                '<svg x="0" y="0" width="400" height="400" viewBox="0 0 1024 1024">'
                f"{rounded}{mark}</svg>"
                f'<path transform="translate(460 300)" d="{words}" fill="{text_color}"/>'
            )
            (d / f"lockup-{mode}.svg").write_text(
                svg(int(460 + width + 20), 400, body), encoding="utf-8"
            )


def preview():
    """design/brand/preview.html: every concept at 1024, 192 and 48 px on
    light and dark grounds, plus both lockups."""
    rows = []
    for key, c in CONCEPTS.items():
        icon = (OUT / key / "icon.svg").read_text(encoding="utf-8")
        cells = []
        for mode, ground in (("light", GROUND), ("dark", INK)):
            # Each inline copy needs its own gradient id.
            sizes = "".join(
                f'<div class="ic" style="width:{s}px;height:{s}px;border-radius:{s * 0.225}px">'
                f'{icon.replace(f"bg-{key}", f"bg-{key}-{mode}-{s}")}</div>'
                for s in (1024, 192, 48)
            )
            lock = (OUT / key / f"lockup-{mode}.svg").read_text(encoding="utf-8")
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
        ".ic{overflow:hidden;flex:none;box-shadow:0 0 0 1px rgba(21,26,45,.08)}"
        ".ic svg{width:100%;height:100%;display:block}"
        ".lock svg{height:120px;width:auto;display:block}</style>"
        + "".join(rows)
    )
    (OUT / "preview.html").write_text(html, encoding="utf-8")


if __name__ == "__main__":
    build()
    preview()
