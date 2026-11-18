#!/usr/bin/env python3
"""회화 초안 JSON ↔ Grok 대사 쓰기용 편별 글(2026-11-19, 포르투갈어앱 pt_dialogue_txt.py 를 고친 것).
  python3 tools/grok/id_dialogue_txt.py export            초안 → data/review/grok/skel/<id>.txt (대사·한국어·note 칸을 비운 뼈대)
  python3 tools/grok/id_dialogue_txt.py import [id ...]   data/review/grok/out/<id>.md → assets/data/dialogues/<급>/<섬>/<id>.json
사용자 지시(11-18, uk 전달): Claude 는 초안까지, 대사는 Grok 이 새로 쓰고 그대로 붙여 넣는다. 그래서 import 는 Grok 의
인도네시아어·한국어·note 를 낱말 하나 고치지 않고 옮긴다. Claude 몫은 형식·독음(rd)·감정·태그뿐(레마는 add_lemmas.py).
뼈대에 초안 문장을 넣지 않는다 — 대사째 주면 「빠른」 모드가 초안을 베낀다(uk 11-19). 흐름 메모는 낱말이 아니라 문장으로.
줄 수·화자 순서가 초안과 다르면 그 편은 넣지 않고 알린다."""
import glob
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from rd_id import rd  # noqa: E402

DRAFTS = sorted(glob.glob(str(ROOT / 'data/review/write/drafts_20261118/*/*/*.json')))
SKEL = ROOT / 'data/review/grok/skel'
OUT = ROOT / 'data/review/grok/out'
ASSETS = ROOT / 'assets/data/dialogues'
EMO = set('''neutral happy cheerful amused teasing excited surprised shocked laughing annoyed angry sad worried panicked embarrassed
shy warm gentle serious tired curious confused nervous moved relieved proud'''.split())
# 초안 감정 → 규칙 문서의 감정 목록
EMO_MAP = {'kind': 'warm', 'hopeful': 'warm', 'calm': 'gentle', 'confident': 'proud', 'suspicious': 'curious', 'determined': 'serious',
           'hurt': 'sad', 'skeptical': 'curious', 'pain': 'tired', 'apologetic': 'embarrassed', 'joking': 'teasing', 'awkward': 'embarrassed',
           'firm': 'serious', 'regretful': 'sad', 'disappointed': 'sad', 'hesitant': 'nervous'}


def drafts():
    for f in DRAFTS:
        yield f, json.load(open(f, encoding='utf-8'))


# 편마다 줄거리(줄 번호별 문장 메모) — 초안 대사(인도네시아어·한국어)를 인용하지 않는다.
# 11-19 첫 시도에서 줄마다 초안 한국어를 인용해 줬더니 Grok 이 한국어 칸을 그대로 옮기고 인니어는 직역했다(r0 4편 → 버림, out_try1/).
FLOW = json.load(open(ROOT / 'data/review/grok/flow_20261119.json', encoding='utf-8'))


def export():
    SKEL.mkdir(parents=True, exist_ok=True)
    n = 0
    for _, ep in drafts():
        exprs = ep.get('expressions', [])
        L = [f"=== {ep['id']}", f"level: {ep['region']}", f"title: {ep['title']}", f"emoji: {ep['emoji']}", f"scene: {ep['scene']}",
             f"cast: A: {{name}}(학습자), B: {ep['speakers'].get('B', '')}", f"register: {ep['register']}",
             f"twist: {ep['twist']} {ep['twist_type']}", f"expressions: {'; '.join(exprs)}", f"flow: {FLOW[ep['id']]}"]
        for t in ep['turns']:
            tags = [f'expr:{x}' for x in exprs if x.lower().rstrip('…?!.') in t['id'].lower()]
            if t['num'] == ep['twist']:
                tags.append('twist')
            emo = EMO_MAP.get(t['emotion'], t['emotion'])
            L.append(f"{t['speaker']} | ___ | ___ | ___ | emotion={emo} | tags={','.join(tags)}")
        (SKEL / f"{ep['id']}.txt").write_text('\n'.join(L) + '\n', encoding='utf-8')
        n += 1
    print(f'{n}편 → {SKEL}')


def parse(text):
    m = re.search(r'```[a-z]*\n(.*?)```', text, re.S)
    body = m.group(1) if m else text
    head, turns = {}, []
    for line in body.splitlines():
        line = line.strip()
        if not line or line.startswith('==='):
            continue
        if re.match(r'^[A-D]\s*\|', line):
            c = [x.strip() for x in re.split(r'(?<=\s)\|(?=\s)', line)]
            if len(c) >= 4 and re.match(r'^(emotion|tags)=', c[3]):  # note 칸을 빼먹은 줄
                c.insert(3, '')
            if len(c) < 5:
                raise ValueError('칸 부족: ' + line)
            kv = {}
            for x in c[4:]:
                if '=' in x:
                    k, v = x.split('=', 1)
                    kv[k.strip()] = v.strip()
            turns.append({'speaker': c[0], 'id': c[1], 'ko': c[2], 'note': c[3], 'emo': kv.get('emotion', ''), 'tags': kv.get('tags', '')})
        elif ':' in line:
            k, v = line.split(':', 1)
            head[k.strip().lower()] = v.strip()
    if not turns:  # 코드 블록 밖에 있을 때
        if m:
            return parse(text.replace(m.group(0), m.group(1)))
    return head, turns


def build(ep, head, turns, src):
    old = ep['turns']
    if [t['speaker'] for t in turns] != [t['speaker'] for t in old]:
        return None, f"줄 수·화자 순서 다름({len(turns)}줄 / 초안 {len(old)}줄)"
    out = {k: v for k, v in ep.items() if k != 'turns'}
    for k in ('title', 'scene', 'emoji'):
        if head.get(k):
            out[k] = head[k]
    new = []
    for o, t in zip(old, turns):
        if '___' in (t['id'] + t['ko']) or not t['id'] or not t['ko']:
            return None, f"빈 칸 {o['num']}번"
        emo = t['emo'].split('+')[0].strip()
        if emo not in EMO:
            emo = EMO_MAP.get(emo, 'neutral')
        tags = [x.strip() for x in t['tags'].split(',') if x.strip() and x.strip() != 'twist']
        if o['num'] == ep['twist']:
            tags.append('twist')
        idl = re.sub(r'\s*//\s*', ' ', t['id'])
        new.append({'num': o['num'], 'speaker': o['speaker'], 'id': idl, 'rd': rd(idl), 'ko': re.sub(r'\s*//\s*', ' ', t['ko']),
                    'note': '' if t['note'] in ('-', '—', '___') else t['note'], 'emotion': emo, 'tags': tags})
    out['review'] = {'draft': [{'num': o['num'], 'id': o['id'], 'ko': o['ko']} for o in old], 'grok': str(src.relative_to(ROOT)),
                     'grok_mode': '빠른', 'kick': head.get('kick', '')}
    out['turns'] = new
    return out, None


def do_import(ids):
    done = []
    for _, ep in drafts():
        p = OUT / f"{ep['id']}.md"
        if (ids and ep['id'] not in ids) or not p.exists():
            continue
        try:
            head, turns = parse(p.read_text(encoding='utf-8'))
            out, err = build(ep, head, turns, p)
        except Exception as e:  # noqa: BLE001
            out, err = None, str(e)
        if err:
            print(f"✗ {ep['id']}: {err}")
            continue
        d = ASSETS / ep['region'] / ep['island']
        d.mkdir(parents=True, exist_ok=True)
        (d / f"{ep['id']}.json").write_text(json.dumps(out, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
        done.append(ep['id'])
    print(f'넣음 {len(done)}편: {" ".join(done)}')


if __name__ == '__main__':
    if sys.argv[1:2] == ['export']:
        export()
    elif sys.argv[1:2] == ['import']:
        do_import(set(sys.argv[2:]))
    else:
        print(__doc__)
