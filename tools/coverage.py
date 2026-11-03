#!/usr/bin/env python3
"""회화 낱말 ↔ 절벽 구간 단어 일치율(2026-11-03).

기준 목록 data/freq/id_words_2500.csv(level R1 ≤341 · R2 ≤505 · R3 ≤1087 · R4 ≤2500).
회화 = assets/data/dialogues/R*/<주제>/*.json + 옛 L1(id/L1.json). 낱말은 소문자, 문장부호·{변수}·괄호 지문·이모지 제외.
목록에 그대로 없으면 붙은 말(-nya·-lah·-kah·-pun·-ku·-mu)을 떼어 다시 찾는다(어근까지 떼지는 않는다 — 그건 「파생어도 아는 단어로 칠지」의 문제라 따로 본다).
  python3 tools/coverage.py            → 묶음별 표 + 목록 밖 낱말
"""
import csv
import glob
import json
import os
import re
from collections import Counter, defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LV = {}
for r in csv.DictReader(open(os.path.join(ROOT, 'data/freq/id_words_2500.csv'), encoding='utf-8')):
    LV[r['word']] = r['level']
ORDER = ['R1', 'R2', 'R3', 'R4']
CLITIC = ('nya', 'lah', 'kah', 'pun', 'ku', 'mu')


def tokens(text):
    text = re.sub(r'\{[a-z_]+\}|\([^)]*\)', ' ', text)
    return [w for w in re.findall(r"[a-z]+(?:-[a-z]+)?", text.lower())]


def level_of(w):
    if w in LV:
        return LV[w]
    for c in CLITIC:
        if w.endswith(c) and w[: -len(c)] in LV:
            return LV[w[: -len(c)]]
    if '-' in w and w.split('-')[0] in LV:  # 중첩어
        return LV[w.split('-')[0]]
    return None


def load():
    groups = defaultdict(list)  # 묶음 → [낱말]
    for f in glob.glob(os.path.join(ROOT, 'assets/data/dialogues/R*/*/*.json')):
        ep = json.load(open(f, encoding='utf-8'))
        for t in ep['turns']:
            groups[f"새 {ep['region']}"].extend(tokens(t['id']))
    l1 = json.load(open(os.path.join(ROOT, 'assets/data/dialogues/id/L1.json'), encoding='utf-8'))
    for e in l1['episodes']:
        for t in e['turns']:
            groups['옛 L1 이야기'].extend(tokens(t['id']))
    return groups


def report(name, toks):
    c = Counter(level_of(w) for w in toks)
    n = len(toks)
    cum = 0
    row = [name, f'{n}개']
    for lv in ORDER:
        cum += c.get(lv, 0)
        row.append(f'~{lv} {cum * 100 / n:.0f}%')
    row.append(f'목록 밖 {c.get(None, 0) * 100 / n:.0f}%')
    print(' | '.join(row))
    out = Counter(w for w in toks if level_of(w) is None)
    above = Counter(w for w in toks if level_of(w) in ('R2', 'R3', 'R4'))
    print('   R1 밖(R2~R4):', ', '.join(f'{w}({LV.get(w) or level_of(w)})×{k}' for w, k in above.most_common(25)))
    print('   목록 밖:', ', '.join(f'{w}×{k}' for w, k in out.most_common(40)))


if __name__ == '__main__':
    for name, toks in sorted(load().items()):
        report(name, toks)
