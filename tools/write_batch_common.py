"""회화 편 **초안** 쓰기 공용(2026-11-18 R0·R2·R3·R4 추가 — 심사 기준 「급마다 나눠 30%」). write_r1_batch*.py 와 같은 꼴 + 줄마다 감정 열(emotion).
턴 = (화자, 인니어, 한국어, note, emotion). 이미 있는 파일은 건드리지 않는다.
사용자 지시(2026-11-18, uk 전달): Claude 는 초안까지, 대사는 Grok 이 새로 쓰고 그대로 붙여 넣는다 — 그래서 초안은 앱 에셋이 아니라
data/review/write/drafts_20261118/<급>/ 에 쓴다(script_publish 가 올리지 않게). Grok 판을 받은 뒤 assets/data/dialogues/ 로."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def write(region, episodes):
    for e in episodes:
        d = os.path.join(ROOT, 'data/review/write/drafts_20261118', region, e['island'])
        os.makedirs(d, exist_ok=True)
        path = os.path.join(d, e['id'] + '.json')
        if os.path.exists(path):
            print('skip(있음)', e['id'])
            continue
        turns = []
        for i, (sp, tl, ko, note, emo) in enumerate(e['turns'], 1):
            turns.append({'num': i, 'speaker': sp, 'id': tl, 'rd': rd(tl), 'ko': ko, 'note': note, 'emotion': emo, 'tags': []})
        out = {k: v for k, v in e.items() if k != 'turns'}
        out.setdefault('kind', 'short')
        out.setdefault('flags', [])
        out.update({'region': region, 'draft': True, 'turns': turns})
        json.dump(out, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print('wrote', e['id'], len(turns), '턴', e['twist_type'])


def ep(id, island, title, emoji, scene, b, register, twist, tt, expressions, turns, purpose=None, kind='short'):
    return dict(id=id, island=island, kind=kind, title=title, emoji=emoji, scene=scene, speakers={'A': '{name}', 'B': b},
                register=register, twist=twist, twist_type=tt, flags=[], purpose=purpose or [island], domain=[island],
                expressions=expressions, turns=turns)
