#!/usr/bin/env python3
"""인도네시아어 절벽구간 재산출 — 어근(kata dasar) + 접사 분리 토큰(사용자 지시 2026-11-03, 문법 세션·talkverse-uk 경유).

  python cliff_id.py <자막 말뭉치.zip> <출력 폴더> [--only <작품 번호 목록>]   (목록 = select_titles.py <zip> Q252 <목록>)

- 단위: 어근 1 + 접사 각 1 토큰. makanan → makan + -an, memakan → meN- + makan, dimakan → di- + makan,
  둘러싸기 ke-…-an → ke- + -an, 중첩 orang-orang → orang + RED(중첩 표지 1). 접어 -nya·-ku·-mu·-lah·-kah·-pun 도 각각 1 토큰.
  어근 판정 = 공개 어근 사전(약 3만 어근) 기반 형태소 분석기 + 아래 접두사 되짚기(meN-/peN- 비음 변이 p·t·k·s 복원).
  되짚기가 안 맞으면(사전 밖 말·외래어·구어) 그 낱말 통째로 1 토큰.
- 숫자·로마숫자 낱자·문장부호 제외, 소문자. 가중 없음, frequency = 토큰 수 ÷ 전체 토큰 수, cum_pct = 1위부터 누적.
- 구간(절대, 19개 언어 통일): 누적 55·60·70·80% 에 처음 닿는 순위가 R1~R4 끝, 80% 밖은 R5.
- 작품당 자막 1판, 청각장애인용 소리 설명 제거. 공개 저장소에는 말뭉치 이름을 적지 않는다.
출력: lang_id_top2500.csv(rank,token,kind,frequency,cum_pct,region) · id_cliff_summary.json · id_affix_rank.csv
"""
import csv
import json
import re
import sys
import time
import zipfile
from collections import Counter

from Sastrawi.Stemmer.StemmerFactory import StemmerFactory

src, out = sys.argv[1], sys.argv[2]
only = set(open(sys.argv[sys.argv.index('--only') + 1]).read().split()) if '--only' in sys.argv else None
label = sys.argv[sys.argv.index('--label') + 1] if '--label' in sys.argv else 'id'
STEM = StemmerFactory().create_stemmer()
TAG_RE = re.compile(r'<[^>]+>')
SDH_PAT = re.compile(r'\([^)]*\)|\[[^\]]*\]|♪[^♪]*♪?|♫[^♫]*♫?|^\s*-\s*')
WORD = re.compile(r"[a-z]+(?:-[a-z]+)*")

# 접두사 겉모양 → (형태소, 복원할 첫 글자 후보)
PREFIX = [
    ('menge', 'meN-', ['']), ('meng', 'meN-', ['', 'k']), ('meny', 'meN-', ['s']), ('mem', 'meN-', ['', 'p']), ('men', 'meN-', ['', 't']), ('me', 'meN-', ['']),
    ('penge', 'peN-', ['']), ('peng', 'peN-', ['', 'k']), ('peny', 'peN-', ['s']), ('pem', 'peN-', ['', 'p']), ('pen', 'peN-', ['', 't']),
    ('per', 'per-', ['']), ('pe', 'peN-', ['']),
    ('ber', 'ber-', ['']), ('bel', 'ber-', ['']), ('be', 'ber-', ['']),
    ('ter', 'ter-', ['']), ('te', 'ter-', ['']),
    ('di', 'di-', ['']), ('ke', 'ke-', ['']), ('se', 'se-', ['']),
]
PARTICLE = ['lah', 'kah', 'pun', 'tah']
POSSESS = ['nya', 'ku', 'mu']
DERIV = ['kan', 'an', 'i']
MAIN14 = ['meN-', 'ber-', 'di-', 'ter-', 'peN-', 'per-', 'se-', 'ke-', '-kan', '-i', '-an', '-nya', '-lah', '-kah']


def prefixes(c, r, depth=0):
    """c 앞의 접두사를 벗겨 어근 r 에 닿는 형태소 목록(없으면 None)."""
    if c == r:
        return []
    if depth >= 2:
        return None
    for surf, morph, restore in PREFIX:
        if not c.startswith(surf) or len(c) - len(surf) < 2:
            continue
        rest = c[len(surf):]
        for f in restore:
            got = prefixes(f + rest if f else rest, r, depth + 1)
            if got is not None:
                return [morph] + got
    return None


def suffix_splits(w):
    """(남은 몸통, 접미 형태소들) 후보를 긴 것부터."""
    outs = [(w, [])]
    for p in [''] + PARTICLE:
        if p and not w.endswith(p):
            continue
        a = w[:len(w) - len(p)] if p else w
        for q in [''] + POSSESS:
            if q and not a.endswith(q):
                continue
            b = a[:len(a) - len(q)] if q else a
            for d in [''] + DERIV:
                if d and not b.endswith(d):
                    continue
                c = b[:len(b) - len(d)] if d else b
                tail = [('-' + x) for x in (d, q, p) if x]
                if tail and len(c) >= 2:
                    outs.append((c, tail))
    return sorted(outs, key=lambda x: -len(x[1]))


_cache = {}


def analyze_simple(w):
    if w in _cache:
        return _cache[w]
    r = STEM.stem(w)
    res = [w]
    if r and r != w:
        for core, tail in suffix_splits(w):
            pre = prefixes(core, r)
            if pre is not None:
                res = pre + [r] + tail
                break
    _cache[w] = res
    return res


def analyze(w):
    if '-' not in w:
        return analyze_simple(w)
    parts = w.split('-')
    if len(parts) == 2:
        a, b = analyze_simple(parts[0]), analyze_simple(parts[1])
        ra = [x for x in a if not x.endswith('-') and not x.startswith('-')]
        rb = [x for x in b if not x.endswith('-') and not x.startswith('-')]
        if ra and rb and ra[0] == rb[0]:  # 중첩: orang-orang, sehari-hari, bermain-main, buah-buahan
            return [x for x in a if x.endswith('-')] + ra + ['RED'] + [x for x in b if x.startswith('-')]
    toks = []
    for p in parts:
        toks += analyze_simple(p)
    return toks


def docs(zf):
    seen = set()
    for name in zf.namelist():
        if not name.endswith('.xml'):
            continue
        key = name.rsplit('/', 1)[0]
        folder = key.rsplit('/', 1)[1]
        if only is not None:
            parts = folder.split('_')
            lead = parts[0].lstrip('0')
            if lead not in only and not (len(parts) > 1 and parts[1].lstrip('0') in only):
                continue
        if key in seen:
            continue
        text = zf.read(name).decode('utf-8', 'ignore')
        lines = [TAG_RE.sub(' ', l) for l in re.findall(r'<s\b[^>]*>(.*?)</s>', text, re.S)] or [TAG_RE.sub(' ', text)]
        body = ' '.join(lines)
        if len(body) < 2000:
            continue
        seen.add(key)
        yield [SDH_PAT.sub(' ', l) for l in lines]


surf = Counter()
ndoc = 0
t0 = time.time()
with zipfile.ZipFile(src) as zf:
    for lines in docs(zf):
        ndoc += 1
        for l in lines:
            surf.update(WORD.findall(l.lower()))
        if ndoc % 500 == 0:
            print(f'{ndoc}편 {sum(surf.values())/1e6:.1f}M 낱말 {time.time()-t0:.0f}s', flush=True)
print(f'읽기 끝 {ndoc}편, 낱말 종류 {len(surf)}', flush=True)

cnt = Counter()
whole = 0
for i, (w, c) in enumerate(surf.items()):
    toks = analyze(w)
    if toks == [w] and '-' not in w:
        whole += c
    for t in toks:
        cnt[t] += c
    if i % 50000 == 0:
        print(f'분석 {i}/{len(surf)} {time.time()-t0:.0f}s', flush=True)
total = sum(cnt.values())


def kind(t):
    return 'affix' if t.endswith('-') or t.startswith('-') else ('redup' if t == 'RED' else 'root')


ranked = cnt.most_common()
rows = []
acc = 0.0
for i, (t, c) in enumerate(ranked[:2500], 1):
    fr = c / total
    acc += fr
    rows.append([i, t, kind(t), round(fr, 8), round(acc * 100, 4)])
cut = {}
for name, p in (('R1', 55), ('R2', 60), ('R3', 70), ('R4', 80)):
    cut[name] = next((r[0] for r in rows if r[4] >= p), None)
for r in rows:
    r.append(next((n for n in ('R1', 'R2', 'R3', 'R4') if cut[n] and r[0] <= cut[n]), 'R5'))
with open(f'{out}/lang_{label}_top2500.csv', 'w', encoding='utf-8', newline='') as fo:
    wr = csv.writer(fo)
    wr.writerow(['rank', 'token', 'kind', 'frequency', 'cum_pct', 'region'])
    wr.writerows(rows)
rank_of = {t: i for i, (t, _) in enumerate(ranked, 1)}
with open(f'{out}/{label}_affix_rank.csv', 'w', encoding='utf-8', newline='') as fo:
    wr = csv.writer(fo)
    wr.writerow(['affix', 'rank', 'count', 'in_R1'])
    for a in sorted([t for t in cnt if kind(t) != 'root'], key=lambda t: rank_of[t]):
        wr.writerow([a, rank_of[a], cnt[a], bool(cut['R1'] and rank_of[a] <= cut['R1'])])
summ = {'docs': ndoc, 'tokens': total, 'surface_words': sum(surf.values()), 'types': len(cnt),
        'unsegmented_share': round(whole / sum(surf.values()) * 100, 2),
        'max_cum_2500': rows[-1][4], 'R1': cut['R1'], 'R2': cut['R2'], 'R3': cut['R3'], 'R4': cut['R4'],
        'main14_rank': {a: rank_of.get(a) for a in MAIN14},
        'main14_in_R1': [a for a in MAIN14 if rank_of.get(a) and cut['R1'] and rank_of[a] <= cut['R1']],
        'redup_rank': rank_of.get('RED'),
        'method': '어근+접사 분리(공개 어근 사전 형태소 분석 + meN-/peN- 비음 변이 복원), 중첩 = 어근 1 + RED 1, 접어 각 1 토큰, 숫자·부호 제외, 가중 없음, 절대 구간(누적 55/60/70/80% 첫 순위)',
        'date': time.strftime('%Y-%m-%d')}
json.dump(summ, open(f'{out}/{label}_cliff_summary.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(json.dumps(summ, ensure_ascii=False))
