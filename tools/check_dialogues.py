#!/usr/bin/env python3
"""회화 검사기(2026-11-03) — docs/DIALOGUE.md(턴 수·턴 길이·독음·반전 종류)와 회화 공통 원칙 §9(카오스 30%+).

  python3 tools/check_dialogues.py [--fix-rd]      → 편별 문제 + 레벨·주제별 반전 비율
--fix-rd: 비어 있거나 낡은 rd 를 tools/rd_id.py 로 다시 채운다(rd_manual: true 인 편은 건드리지 않음).
"""
import glob
import json
import os
import re
import sys
from collections import Counter, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

TURNS = {'R1': (6, 8), 'R2': (8, 12), 'R3': (12, 16), 'R4': (12, 16), 'R0': (4, 8)}
WORDS = {'R1': (3, 8), 'R2': (4, 12), 'R3': (4, 16), 'R4': (4, 16), 'R0': (2, 6)}
TWISTS = {'chaos', 'slip', 'reveal', 'emotion', 'ignore'}


def nwords(text):
    text = re.sub(r'\{[a-z_]+\}|\([^)]*\)', ' x ', text)
    return len(re.findall(r"[A-Za-z]+(?:-[A-Za-z]+)?", text))


def main():
    fix = '--fix-rd' in sys.argv
    problems = 0
    stat = defaultdict(Counter)
    for f in sorted(glob.glob(os.path.join(ROOT, 'assets/data/dialogues/R*/*/*.json'))):
        ep = json.load(open(f, encoding='utf-8'))
        lv, isl, eid = ep['region'], ep['island'], ep['id']
        msg = []
        lo, hi = TURNS.get(lv, (1, 99))
        if not lo <= len(ep['turns']) <= hi:
            msg.append(f'턴 수 {len(ep["turns"])} (기준 {lo}~{hi})')
        tt = ep.get('twist_type')
        if tt not in TWISTS:
            msg.append(f'twist_type 없음/잘못({tt})')
        stat[f'{lv}'][tt] += 1
        stat[f'{lv}/{isl}'][tt] += 1
        wlo, whi = WORDS.get(lv, (1, 99))
        changed = False
        for t in ep['turns']:
            n = nwords(t['id'])
            chatty = ep.get('kind') == 'chat' or not re.search(r'[A-Za-z]', t['id'])
            if n > whi:
                msg.append(f'{t["num"]}번 {n}단어(최대 {whi})')
            if n == 1 and not chatty:
                msg.append(f'{t["num"]}번 1단어 단답')
            if not t.get('ko'):
                msg.append(f'{t["num"]}번 한국어 없음')
            new_rd = rd(t['id'])
            if fix and not ep.get('rd_manual') and t.get('rd') != new_rd:
                t['rd'] = new_rd
                changed = True
            elif not t.get('rd') and re.search(r'[A-Za-z]', t['id']):
                msg.append(f'{t["num"]}번 독음 없음')
        if changed:
            json.dump(ep, open(f, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        if msg:
            problems += 1
            print(f'✗ {eid}: ' + ' · '.join(msg))
    print()
    for k in sorted(stat):
        c = stat[k]
        n = sum(c.values())
        chaos = c.get('chaos', 0)
        mark = '' if '/' in k or chaos * 100 / n >= 30 else '  ← 카오스 30% 미만'
        print(f'{k:16} {n:3}편 | 카오스 {chaos * 100 / n:3.0f}% | ' + ' '.join(f'{t}:{c.get(t, 0)}' for t in sorted(TWISTS)) + mark)
    print(f'\n문제 있는 편 {problems}')


if __name__ == '__main__':
    main()
