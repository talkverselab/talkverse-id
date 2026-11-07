#!/usr/bin/env python3
"""어근(kata dasar) 가족 뽑기 — 2,500 빈도 단어 목록에서 「어근 + 접사 = 단어」를 찾아 어근 데이터를 늘린다(2026-11-02).

입력
  data/freq/id_words_2500.csv   rank,word,reading,ko,en,pos,level,picturable (talkversehanja words/id.csv 와 같은 파일)
  assets/data/roots/kata_dasar_core.json   지금 어근(손으로 검토한 80개 — 그대로 둔다)
  data/roots/reject.txt          우연 일치로 빼는 「단어 어근」 쌍(한 줄에 `단어 어근`, # 주석)
출력
  assets/data/roots/kata_dasar_core.json   기존 어근 + 새 어근(phase 2·3), 가족은 목록 안 단어만
  data/roots/candidates.tsv      새 어근 후보와 가족(사람 검토용)

판정(태국어앱 ROOT_WORDS.md 의 「포함 + 경계」 대신 인도네시아어 형태론):
  - 접두사 meN-/peN-(첫 자음 변형 p→m, t→n, k→ng, s→ny 를 되돌림), ber-/be-/bel-, di-, ter-, se-, per-
  - 접미사 -kan, -i, -an, (-nya 는 빼지 않는다 — 대명사·정관사라 가족에 넣지 않음)
  - 접환사 ke-…-an, peN-…-an, per-…-an, ber-…-an
  - 어근이 목록에 **단어로 있을 때만** 인정(앱 lib/services/affix_util.dart 와 같은 규칙, 사전 우선).
  - 새 어근 = 자기 말고 가족이 2개 이상인 어근.
사용: python3 tools/build_roots.py   (표준 라이브러리만)
"""
import csv
import json
import os
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WORDS = os.path.join(ROOT, 'data/freq/id_words_2500.csv')
ROOTS = os.path.join(ROOT, 'assets/data/roots/kata_dasar_core.json')
REJECT = os.path.join(ROOT, 'data/roots/reject.txt')
CAND_OUT = os.path.join(ROOT, 'data/roots/candidates.tsv')

VOWELS = set('aeiou')

# (표면형, 표시 이름, 되돌릴 첫 글자 후보)
PREFIXES = [
    ('menge', 'meN-', ['']), ('meny', 'meN-', ['s']), ('meng', 'meN-', ['k', '']), ('mem', 'meN-', ['p', '']),
    ('men', 'meN-', ['t', '']), ('me', 'meN-', ['']),
    ('penge', 'peN-', ['']), ('peny', 'peN-', ['s']), ('peng', 'peN-', ['k', '']), ('pem', 'peN-', ['p', '']),
    ('pen', 'peN-', ['t', '']), ('pe', 'peN-', ['']), ('per', 'per-', ['']),
    ('ber', 'ber-', ['']), ('bel', 'ber-', ['']), ('be', 'ber-', ['']),
    ('di', 'di-', ['']), ('ter', 'ter-', ['']), ('se', 'se-', ['']), ('ke', 'ke-', ['']),
]
SUFFIXES = [('kan', '-kan'), ('an', '-an'), ('i', '-i')]
# 접두사만 단독으로 붙일 수 없는 것: ke- 는 -an 과 함께(또는 수사)만, pe-/per- 는 -an 이 없으면 행위자 명사(peN-)만
NEEDS_AN = {'ke-'}


def load_words():
    rows = list(csv.DictReader(open(WORDS, encoding='utf-8')))
    return rows, {r['word']: r for r in rows}


def candidates(word, vocab):
    """word → [(root, affix_label)] — 어근이 vocab 에 있는 것만."""
    out = []

    def ok(r):
        return len(r) >= 3 and r in vocab and r != word

    # 접미사만
    for s, sl in SUFFIXES:
        if word.endswith(s):
            r = word[: -len(s)]
            if ok(r):
                out.append((r, sl))
    # 접두사(+접미사)
    for p, pl, restore in PREFIXES:
        if not word.startswith(p):
            continue
        rest = word[len(p):]
        for first in restore:
            for s, sl in [('', '')] + SUFFIXES:
                if s and not rest.endswith(s):
                    continue
                stem = rest[: len(rest) - len(s)] if s else rest
                r = first + stem
                if not ok(r):
                    continue
                # 비음 변형 규칙 검사: men+t→n, mem+p→m, meng+k→ng, meny+s→ny 는 되돌린 자음이 있어야 맞음.
                # 되돌리지 않은 men/mem/meng 은 그 뒤가 d·c·j / b·f·v / 모음·g·h 일 때만.
                if pl in ('meN-', 'peN-') and first == '':
                    head = stem[:1]
                    if p in ('men', 'pen') and head not in ('d', 'c', 'j', 'z', 's'):
                        continue
                    if p in ('mem', 'pem') and head not in ('b', 'f', 'v'):
                        continue
                    if p in ('meng', 'peng') and not (head in VOWELS or head in ('g', 'h', 'k')):
                        continue
                    if p in ('me', 'pe') and head not in ('l', 'm', 'n', 'r', 'w', 'y', 'ng'):
                        continue
                if pl in NEEDS_AN and s != 'an':
                    continue
                if pl in ('per-',) and s not in ('an', 'kan', 'i'):
                    continue
                label = pl + (sl.lstrip('-') if sl else '')  # 기존 손 검토 데이터와 같은 표기: meN-kan · di-i
                if pl in ('ke-', 'peN-', 'per-', 'ber-') and sl == '-an':
                    label = {'ke-': 'ke-an', 'peN-': 'peN-an', 'per-': 'per-an', 'ber-': 'ber-an'}[pl]
                out.append((r, label))
    # 중첩어: kata-kata → kata
    if '-' in word:
        head = word.split('-')[0]
        if head in vocab and head != word:
            out.append((head, '중첩'))
    return out


def resolve(rt, label, vocab, reject, word):
    """어근 후보가 접미사 붙은 형태(gunakan·miliki·katakan…)면 한 단계 더 내려간다: menggunakan → guna(meN-…-kan)."""
    for s, sl in SUFFIXES:
        base = rt[: -len(s)] if rt.endswith(s) else None
        if base and len(base) >= 3 and base in vocab and (word, base) not in reject and (rt, base) not in reject:
            if label.startswith('-') or label.count('-') >= 2 or label in ('ke-an', 'peN-an', 'per-an', 'ber-an'):
                return resolve(base, label, vocab, reject, word)
            new = sl if label == '중첩' else (label + sl.lstrip('-'))
            return resolve(base, new, vocab, reject, word)
    return rt, label


def main():
    rows, vocab = load_words()
    data = json.load(open(ROOTS, encoding='utf-8'))
    old = {r['root']: r for r in data['roots']}
    reject = set()
    if os.path.exists(REJECT):
        for line in open(REJECT, encoding='utf-8'):
            line = line.split('#')[0].strip()
            if line:
                w, r = line.split()[:2]
                reject.add((w, r))

    fam = defaultdict(dict)  # root → {word: affix}
    word_root = {}
    for r in rows:
        w = r['word']
        cs = [(rt, a) for rt, a in candidates(w, vocab) if (w, rt) not in reject]
        if not cs:
            continue
        # 기존(검토된) 어근 우선, 그다음 더 짧은 어근(접사를 더 많이 뗀 쪽) 대신 더 긴 어근(덜 뗀 쪽 — 과분해 방지)
        cs.sort(key=lambda x: (x[0] not in old, -len(x[0])))
        rt, a = resolve(*cs[0], vocab, reject, w)
        fam[rt][w] = a
        word_root[w] = rt

    # 새 어근: 기존에 없고, 가족 2개 이상
    new_roots = []
    for rt, members in fam.items():
        if rt in old or len(members) < 2:
            continue
        base = vocab[rt]
        rank = int(base['rank'])
        new_roots.append({
            'root': rt,
            'rank': rank,
            'pos': {'verb': 'v', 'noun': 'n', 'adj': 'adj', 'adv': 'adv'}.get(base['pos'], base['pos']),
            'phase': 2 if base['level'] in ('R1', 'R2') else 3,
            'ko': base['ko'],
            'family': [
                {'word': w, 'affix': a, 'ko': vocab[w]['ko']}
                for w, a in sorted(members.items(), key=lambda x: int(vocab[x[0]]['rank']))
            ],
        })
    new_roots.sort(key=lambda r: r['rank'])

    # 기존 어근: 가족은 손으로 검토한 것을 유지하고, 목록에서 새로 찾은 단어만 뒤에 덧붙인다
    added_old = 0
    for rt, r in old.items():
        have = {f['word'] for f in r.get('family', [])}
        for w, a in sorted(fam.get(rt, {}).items(), key=lambda x: int(vocab[x[0]]['rank'])):
            if w not in have:
                r.setdefault('family', []).append({'word': w, 'affix': a, 'ko': vocab[w]['ko']})
                added_old += 1

    data['version'] = 'v3-2026-11-02'
    data['note'] = ('어근(kata dasar). phase 1 = 손으로 검토한 핵심 80개(회화 첫 100 어근 목표), phase 2·3 = 2,500 빈도 단어 목록에서 '
                    'tools/build_roots.py 로 뽑은 어근(phase 2 = 어근이 R1·R2, 3 = R3·R4). 가족은 목록 안 단어만. ms 는 말레이어에서 다른 형태만.')
    data['roots'] = list(old.values()) + new_roots
    json.dump(data, open(ROOTS, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)

    # 앱 빈도 단어 CSV 는 2026-11-07 부터 tools/freq/build_freq_id.py 가 만든다(절벽 v2)

    os.makedirs(os.path.dirname(CAND_OUT), exist_ok=True)
    with open(CAND_OUT, 'w', encoding='utf-8') as f:
        f.write('root\trank\tko\tfamily\n')
        for r in new_roots:
            f.write('{}\t{}\t{}\t{}\n'.format(r['root'], r['rank'], r['ko'], ' · '.join(f"{x['word']}({x['affix']})" for x in r['family'])))

    print(f'어근 {len(old)} → {len(data["roots"])} (새 {len(new_roots)}), 기존 어근 가족에 덧붙임 {added_old}, '
          f'어근이 붙은 빈도 단어 {sum(1 for r in rows if word_root.get(r["word"]) or r["word"] in roots_all)}/{len(rows)}')


if __name__ == '__main__':
    main()
