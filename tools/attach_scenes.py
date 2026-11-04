#!/usr/bin/env python3
"""받은 장면 컷(data/review/scenes/<편id>_<n>.jpg)을 앱 에셋으로 줄여 넣고 턴의 art 에 연결한다(2026-11-03).
컷 n = 대화 한 쌍(턴 2n-1, 2n). 앱 에셋 = assets/images/scenes/<편id>_<n>.jpg(가로 900px, 품질 82).
  ~/.venvs/img/bin/python tools/attach_scenes.py <편.json> [...]
나중에 talkverse.uk 세션의 장면 그림 저장소(/art/id/scene)가 생기면 art 를 그 주소로 바꾸고 에셋은 뺀다.
"""
import json
import os
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'data/review/scenes')
DST = os.path.join(ROOT, 'assets/images/scenes')

FEMALE = '--female' in sys.argv  # 여자 학습자판: <편id>_f_<n>.jpg → 에셋만 넣고 art 는 그대로(앱 sceneVariant 가 고름)
for path in [x for x in sys.argv[1:] if not x.startswith('--')]:
    ep = json.load(open(path, encoding='utf-8'))
    if FEMALE:
        for k in range(1, 5):
            src = os.path.join(SRC, f"{ep['id']}_f_{k}.jpg")
            if os.path.exists(src):
                im = Image.open(src).convert('RGB')
                d = round(im.width * 0.025)
                im = im.crop((d, d, im.width - d, im.height - d)).resize((900, round((im.height - 2 * d) * 900 / (im.width - 2 * d))), Image.LANCZOS)
                im.save(os.path.join(DST, f"{ep['id']}_f_{k}.jpg"), quality=82, optimize=True)
                print(ep['id'], '여자판 컷', k)
        continue
    os.makedirs(DST, exist_ok=True)
    n = 0
    for k in range(1, 5):
        src = os.path.join(SRC, f"{ep['id']}_{k}.jpg")
        if not os.path.exists(src):
            continue
        im = Image.open(src).convert('RGB')
        d = round(im.width * 0.025)  # Grok 화면 캡처의 둥근 모서리(흰 귀퉁이)를 잘라낸다
        im = im.crop((d, d, im.width - d, im.height - d))
        im = im.resize((900, round(im.height * 900 / im.width)), Image.LANCZOS)
        rel = f"assets/images/scenes/{ep['id']}_{k}.jpg"
        im.save(os.path.join(ROOT, rel), quality=82, optimize=True)
        for t in ep['turns'][2 * (k - 1): 2 * k]:
            t['art'] = rel
        n += 1
    json.dump(ep, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(ep['id'], '컷', n)
