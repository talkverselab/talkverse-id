#!/usr/bin/env python3
"""편 JSON 의 턴마다 `lemmas`(내용어 [표면형, 어근, ""]) 를 채운다 — 문장 레마 ↔ 단어장 연결(사용자 지시 2026-11-04, 일본어앱과 같은 구조).
인도네시아어는 라틴 문자라 낱말 단위 + 어근(절벽 도구 tools/corpus/cliff_id.py 의 analyze — 접사를 벗긴 kata dasar).
기능어(전치사·접속사·대명사·담화 소사)와 사람 이름은 뺀다. 세 번째 칸(읽기)은 비워 둔다.
앱 어근 사전(assets/data/roots/kata_dasar_core.json)에 없는 어근은 data/review/write/missing_lemmas.csv 로(빈도순 — uk 세션에 넘겨 단어·그림 제작).
  ~/.venvs/id-corpus/bin/python tools/add_lemmas.py"""
import csv, glob, json, re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
# cliff_id.py 는 맨 위가 스크립트라 analyze 까지의 함수 부분만 빌린다
src = (ROOT / 'tools/corpus/cliff_id.py').read_text(encoding='utf-8')
head = src[:src.index('def docs(')]
head = re.sub(r"^(src, out|only|label) = .*$", "", head, flags=re.M)
ns = {}
exec(head, ns)
analyze = ns['analyze']

FUNC = set('''yang dan atau tapi tetapi karena kalau jika sama dengan di ke dari pada untuk buat oleh dalam antara sampai hingga
seperti bagai sebagai tentang bahwa agar supaya biar walau meski meskipun lalu terus kemudian juga pun saja aja hanya cuma
itu ini sini situ sana begini begitu aku saya kamu kau engkau dia ia kita kami kalian mereka anda gue gua lo lu elo
dong sih kok ya yah deh kan nih tuh loh lho wah wow hah eh oh ah aduh waduh hai halo nah ayo yuk lah kah pun tah ha haha hahaha hehe ssst wkwk
pak bu bapak ibu mas mbak kak dik om tante bang neng nya ku mu'''.split())
NAMES = set('raka nadia dimas ayu sri budi sari mark mina rina andi joko putri dewi'.split())
VAR = re.compile(r'\{[a-z_]+\}')
WORD = re.compile(r"[A-Za-z]+(?:-[A-Za-z]+)*")

roots = {r['root'] for f in ('kata_dasar_core', 'kata_conv') for r in json.load(open(ROOT / f'assets/data/roots/{f}.json', encoding='utf-8'))['roots']}
miss = Counter(); ex = {}; tot = hit = 0; changed = 0
for f in sorted(glob.glob(str(ROOT / 'assets/data/dialogues/R*/*/*.json'))):
    d = json.load(open(f, encoding='utf-8')); ch = False
    for t in d['turns']:
        out, seen = [], set()
        for i, m in enumerate(WORD.finditer(VAR.sub(' ', t['id']))):
            surf = m.group(0); low = surf.lower()
            if low in FUNC or low in NAMES or (surf[0].isupper() and i > 0 and low not in roots):
                continue
            toks = analyze(low)
            base = next((x for x in toks if not x.endswith('-') and not x.startswith('-') and x != 'RED'), low)
            if base in FUNC or len(base) < 2 or base in seen:
                continue
            seen.add(base)
            out.append([surf, base, '']); tot += 1
            if base in roots: hit += 1
            else: miss[base] += 1; ex.setdefault(base, (surf, t['id']))
        if t.get('lemmas') != out:
            t['lemmas'] = out; ch = True
    if ch:
        changed += 1
        open(f, 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=1) + '\n')
with open(ROOT / 'data/review/write/missing_lemmas.csv', 'w', encoding='utf-8', newline='') as fo:
    w = csv.writer(fo); w.writerow(['lemma', 'surface', 'count', 'example'])
    for b, n in miss.most_common(): w.writerow([b, ex[b][0], n, ex[b][1]])
print(f'편 {changed}개 갱신 · 내용어 {tot} · 어근 사전 있음 {hit/max(tot,1):.0%} · 없는 어근 {len(miss)} → missing_lemmas.csv')
