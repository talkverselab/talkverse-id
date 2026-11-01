"""talkverse.uk 톤 앱 아이콘 생성.

사이트 첫 화면(흰 바탕 + 복숭아·분홍·라벤더·하늘색 메시 그라데이션, 남색 #0a2540 글자,
하늘색→인디고 #00b3ff→#635bff 강조선)을 아이콘으로 옮긴다.
공용판(~/talkverse/branding/make_icon.py) — 언어앱 폴더 안에서 실행한다(현재 폴더 = 앱 저장소 루트).
  python make_icon.py <글자> [--font <글꼴 파일> --index <면 번호>]                    # 모든 아이콘 파일을 덮어씀
  python make_icon.py --preview out.png [--font <글꼴>] 글자1 글자2 … # 후보 비교 그림만
Android(레거시·라운드·적응형 전경/배경, mipmap-anydpi-v26 xml)와 iOS AppIcon 을 모두 만든다. Pillow 필요.
글꼴 기본값은 히라기노(한자·가나). 문자별 맥 기본 글꼴은 ~/talkverse/branding/TONE.md 표.
"""
import json
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageChops

ROOT = Path.cwd()
RES = ROOT / "android/app/src/main/res"
IOS = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
FONT = "/System/Library/Fonts/ヒラギノ角ゴシック W6.ttc"
FONT_INDEX = 0
INK = (10, 37, 64)
GRAD = ((0, 179, 255), (99, 91, 255))  # 강조선 왼쪽 하늘색 → 오른쪽 인디고 (2026-10-26 사용자 결정)
# 사이트 .mesh: (가로 반경, 세로 반경, 중심 x, 중심 y, 색) — 아이콘 비율에 맞게 옮김
MESH = [
    (0.55, 0.60, 0.10, 0.30, (255, 211, 155)),
    (0.50, 0.55, 0.45, 0.05, (245, 184, 230)),
    (0.60, 0.65, 0.85, 0.35, (169, 164, 255)),
    (0.55, 0.60, 0.80, 0.95, (143, 227, 255)),
]
LEGACY = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
ADAPTIVE = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}
M = 1024


def mesh():
    im = Image.new("RGB", (M, M), (255, 255, 255))
    blob = ImageChops.invert(Image.radial_gradient("L"))  # 가운데 255 → 가장자리 0
    for rx, ry, cx, cy, col in MESH:
        w, h = int(M * rx * 2), int(M * ry * 2)
        mask = blob.resize((w, h), Image.BICUBIC).point(lambda v: min(255, int(v * 1.1)))
        layer = Image.new("L", (M, M), 0)
        layer.paste(mask, (int(M * cx - w / 2), int(M * cy - h / 2)))
        im.paste(Image.new("RGB", (M, M), col), (0, 0), layer)
    im = im.filter(ImageFilter.GaussianBlur(M * 0.06))
    veil = Image.linear_gradient("L").resize((M, M)).point(lambda v: int(38 + v * 0.38))  # 위 15% → 아래 55% 흰 막
    im.paste(Image.new("RGB", (M, M), (255, 255, 255)), (0, 0), veil)
    return im


def gradient_bar(w, h, grad=GRAD):
    g = Image.linear_gradient("L").rotate(90).resize((w, h))
    a, b = (Image.new("RGB", (w, h), c) for c in grad)
    return Image.composite(b, a, g)


def draw_glyph(im, ch, box, fill=INK, grad=None):
    """box 가운데에 남색 글자, 그 아래에 하늘색→인디고 강조선."""
    x0, y0, x1, y1 = box
    w = x1 - x0
    d = ImageDraw.Draw(im)
    font = ImageFont.truetype(FONT, index=FONT_INDEX, size=int(w * 0.56 / (1.3 if len(ch) > 1 else 1)))
    l, t, r, b = d.textbbox((0, 0), ch, font=font)
    cx, cy = (x0 + x1) / 2, y0 + w * 0.46
    d.text((cx - (l + r) / 2, cy - (t + b) / 2), ch, font=font, fill=fill)
    bw, bh = int(w * 0.30), max(2, int(w * 0.045))
    bar = gradient_bar(bw, bh, grad or GRAD)
    mask = Image.new("L", (bw, bh), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, bw - 1, bh - 1), radius=bh // 2, fill=255)
    im.paste(bar, (int(cx - bw / 2), int(y0 + w * 0.80)), mask)


def full(ch):
    im = mesh()
    draw_glyph(im, ch, (0, 0, M, M))
    return im


def rounded(im, r=0.22):
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, im.size[0] - 1, im.size[1] - 1), radius=int(im.size[0] * r), fill=255)
    out = Image.new("RGBA", im.size, (0, 0, 0, 0))
    out.paste(im, (0, 0), mask)
    return out


def circle(im):
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).ellipse((0, 0, im.size[0] - 1, im.size[1] - 1), fill=255)
    out = Image.new("RGBA", im.size, (0, 0, 0, 0))
    out.paste(im, (0, 0), mask)
    return out


def foreground(ch):
    """적응형 전경: 108dp 중 가운데 66% 안전 영역에 글자·강조선. 바탕 투명."""
    im = Image.new("RGBA", (M, M), (0, 0, 0, 0))
    pad = M * 0.17
    draw_glyph(im, ch, (pad, pad, M - pad, M - pad))
    return im


def write(ch):
    sq = full(ch)
    for k, px in LEGACY.items():
        rounded(sq).resize((px, px), Image.LANCZOS).save(RES / f"mipmap-{k}/ic_launcher.png")
        circle(sq).resize((px, px), Image.LANCZOS).save(RES / f"mipmap-{k}/ic_launcher_round.png")
    fg, bg = foreground(ch), mesh()
    for k, px in ADAPTIVE.items():
        fg.resize((px, px), Image.LANCZOS).save(RES / f"mipmap-{k}/ic_launcher_foreground.png")
        bg.resize((px, px), Image.LANCZOS).save(RES / f"mipmap-{k}/ic_launcher_background.png")
    for name in ("ic_launcher.xml", "ic_launcher_round.xml"):
        (RES / "mipmap-anydpi-v26" / name).write_text(
            '<?xml version="1.0" encoding="utf-8"?>\n'
            '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
            '    <background android:drawable="@mipmap/ic_launcher_background"/>\n'
            '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
            '    <monochrome android:drawable="@mipmap/ic_launcher_foreground"/>\n'
            '</adaptive-icon>\n', encoding="utf-8")
    write_ios(ch, sq)


def dark(ch):
    """iOS 다크 모양: 메시를 남색 밤하늘로 눌러 깔고 흰 글자 + 같은 강조선."""
    bg = Image.blend(mesh(), Image.new("RGB", (M, M), (8, 22, 40)), 0.86)
    draw_glyph(bg, ch, (0, 0, M, M), fill=(255, 255, 255))
    return bg


def tinted(ch):
    """iOS 틴티드 모양: 시스템이 색을 입히는 회색조 — 검정 바탕, 밝은 회색 글자·강조선."""
    bg = Image.new("RGB", (M, M), (0, 0, 0))
    draw_glyph(bg, ch, (0, 0, M, M), fill=(236, 236, 236), grad=((150, 150, 150), (236, 236, 236)))
    return bg.convert("L").convert("RGB")


def write_ios(ch, sq):
    """iOS 18+ 정책: 1024 한 장(universal) + 다크·틴티드 모양. 작은 크기는 Xcode 가 만든다.
    iOS 26+ 의 Liquid Glass 효과는 시스템이 이 그림에 입힌다. 투명·둥근 모서리 금지(시스템이 깎음), RGB."""
    for p in IOS.glob("*.png"):
        p.unlink()
    sq.save(IOS / "AppIcon-1024.png")
    dark(ch).save(IOS / "AppIcon-1024-dark.png")
    tinted(ch).save(IOS / "AppIcon-1024-tinted.png")
    img = lambda f, v=None: {**({"appearances": [{"appearance": "luminosity", "value": v}]} if v else {}),
                             "filename": f, "idiom": "universal", "platform": "ios", "size": "1024x1024"}
    (IOS / "Contents.json").write_text(json.dumps({"images": [
        img("AppIcon-1024.png"), img("AppIcon-1024-dark.png", "dark"), img("AppIcon-1024-tinted.png", "tinted")],
        "info": {"author": "xcode", "version": 1}}, indent=2) + "\n", encoding="utf-8")


def preview(chars, out):
    tile, gap = 300, 40
    im = Image.new("RGB", (gap + (tile + gap) * len(chars), gap + (tile + gap) * 3), (246, 249, 252))
    for i, ch in enumerate(chars):
        for j, f in enumerate((full, dark, tinted)):  # 줄: 기본 · iOS 다크 · iOS 틴티드
            t = rounded(f(ch)).resize((tile, tile), Image.LANCZOS)
            im.paste(t, (gap + i * (tile + gap), gap + j * (tile + gap)), t)
    im.save(out)


if __name__ == "__main__":
    a = sys.argv[1:]
    if "--font" in a:
        i = a.index("--font"); FONT = a[i + 1]; del a[i:i + 2]
    if "--index" in a:
        i = a.index("--index"); FONT_INDEX = int(a[i + 1]); del a[i:i + 2]
    if not (RES.is_dir() and IOS.is_dir()) and not (a and a[0] == "--preview"):
        sys.exit(f"앱 저장소 루트에서 실행하세요: {RES} / {IOS} 가 없습니다")
    if a and a[0] == "--preview":
        preview(a[2:], a[1])
    else:
        write(a[0] if a else "あ")
