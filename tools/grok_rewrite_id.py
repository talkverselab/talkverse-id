#!/usr/bin/env python3
"""회화 편을 Grok 에 재작성 맡기고 답을 JSON 에 반영한다(2026-11-03).

  python3 tools/grok_rewrite_id.py prompt <편.json>          → data/review/rewrite/<id>_prompt.md 만들기
  python3 tools/grok_rewrite_id.py send <편.json>            → 프롬프트 만들고 Grok(「인도네시아어 회화 검수」)에 보내 답 저장
  python3 tools/grok_rewrite_id.py apply <편.json>           → data/review/rewrite/<id>_grok.md 를 편에 반영(원문은 review.draft 에 보관)

Grok = M4 Chrome(포트 9228, M6 에서는 ssh -L 터널). 한 요청 = 편 1개, 매번 프로젝트 첫 화면에서 새 대화.
규칙: 초안 문장 「유지」 금지 — 그 나라 사람이 실제로 하는 말로 새로 쓰게 한다(일본어앱 rewrite_grok_v2 교훈).
"""
import json
import os
import re
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

PROJECT = 'fe15a410-676a-4268-86cf-88620539e3f7'
OUTDIR = os.path.join(ROOT, 'data/review/rewrite')

REGISTER = {
    'polite': '낯선 사이·가게·택시 — saya / Kak·Bu·Pak 호칭, 정중하지만 딱딱하지 않은 실제 말투',
    'casual': '친구 — aku/kamu 또는 gue/lo, 구어(nggak·udah·banget·sih·dong·kok·deh)',
    'chat': '친구 채팅 — 줄임말·이모지·wkwk 같은 채팅체, aku/kamu 또는 gue/lo',
    'mixed': '처음엔 정중하게, 가까워지며 반말로',
}

TEMPLATE = """[ID-RW {id}] 아래는 한국인을 위한 인도네시아어 학습 앱의 회화 1편 초안입니다. **장면·인물·턴 수·턴 순서·각 턴의 역할·반전 위치·{{변수}}** 는 그대로 두고, **모든 턴을 자카르타 사람이 지금 실제로 하는 말로 새로 써 주세요.** 초안 문장을 그대로 「유지」하지 마세요 — 같은 뜻이라도 더 살아 있는 표현으로.

장면: {scene}
인물: A = 학습자({{name}}), B = {b}. 말투: {register}
반전: {twist}번 턴({twist_type}) — 이 턴이 더 크게 터지게.

반드시:
① **카오스·재미·심쿵을 더 세게** — 웃음 포인트 2개 이상(엉뚱한 반응·과장·받아치기), 연애 장면이면 마음을 들키는 한 줄과 여백. 마지막 줄은 짧은 한 방(다짐·감사로 끝내지 말 것).
② 초급(R1): 한 턴 3~8단어, 쉬운 일상어. 1단어 단답 금지(채팅의 이모지 턴 제외).
③ 구어 추임새(nggak·udah·banget·sih·dong·kok·deh·wkwk 등)는 편 전체에 2~4개, 뜻이 맞는 자리에만. 교과서체·번역투·설명 대사 금지.
④ 학습자가 외우고 싶어지는 짧은 한 줄을 하나 이상.
⑤ 실제 브랜드·작품·인물 이름 금지, 성적 묘사 금지(12+).
⑥ 한국어는 인도네시아어 말투에 맞춘 자연스러운 구어(존댓말/반말 일치).

출력(이것만, 다른 설명 없이): 줄마다 `번호 화자: 인도네시아어 / 한국어`. 마지막 줄에 `킥: ` 뒤에 이 편의 웃음·설렘 포인트 한 줄.

초안:
{lines}"""


def load(path):
    return json.load(open(path, encoding='utf-8'))


def prompt_for(ep):
    b = ep['speakers'].get('B', 'B')
    lines = '\n'.join(f"{t['num']} {t['speaker']}: {t['id']} / {t['ko']}" for t in ep['turns'])
    return TEMPLATE.format(id=ep['id'], scene=ep['scene'], b=b, register=REGISTER.get(ep.get('register', ''), ep.get('register', '')),
                           twist=ep.get('twist', ''), twist_type=ep.get('twist_type', ''), lines=lines)


def cmd_prompt(path):
    ep = load(path)
    os.makedirs(OUTDIR, exist_ok=True)
    p = os.path.join(OUTDIR, ep['id'] + '_prompt.md')
    open(p, 'w', encoding='utf-8').write(prompt_for(ep))
    return ep, p


def cmd_send(path):
    ep, p = cmd_prompt(path)
    sys.path.insert(0, '/Users/talkverse/Hanja/tools')
    import grok_cdp as g
    g.BASE = 'http://127.0.0.1:9228'
    c = g.CDP(g.tab('grok.com'))
    c.call('Page.navigate', url=f'https://grok.com/project/{PROJECT}')
    time.sleep(7)
    out = os.path.join(OUTDIR, ep['id'] + '_grok.md')
    r = subprocess.run(['/usr/bin/python3', os.path.join(ROOT, 'tools/grok_send.py'), p, out, '--tab', f'project/{PROJECT[:8]}', '--wait', '240'],
                       capture_output=True, text=True)
    print(r.stdout.strip().splitlines()[-1] if r.stdout.strip() else r.stderr[-300:])


LINE = re.compile(r'^\s*(\d+)\s*([AB])\b[^:]*:\s*(.+?)\s+/\s+(.+?)\s*$')


def cmd_apply(path):
    ep = load(path)
    src = os.path.join(OUTDIR, ep['id'] + '_grok.md')
    text = open(src, encoding='utf-8').read()
    got = {}
    kick = ''
    for line in text.splitlines():
        line = line.strip().strip('`').strip()
        if line.startswith('킥:'):
            kick = line[2:].strip()
            continue
        m = LINE.match(line)
        if m:
            got[int(m.group(1))] = (m.group(2), m.group(3).strip(), m.group(4).strip())
    turns = ep['turns']
    if len(got) != len(turns):
        sys.exit(f'{ep["id"]}: 턴 수가 다름 — 초안 {len(turns)}, Grok {len(got)} (반영 안 함)')
    draft = [{'num': t['num'], 'id': t['id'], 'ko': t['ko']} for t in turns]
    for t in turns:
        sp, tl, ko = got[t['num']]
        if sp != t['speaker']:
            sys.exit(f'{ep["id"]} {t["num"]}번: 화자가 다름({t["speaker"]}→{sp}) — 반영 안 함')
        t['id'], t['ko'], t['rd'] = tl, ko, rd(tl)
    ep['review'] = {'draft': draft, 'grok_rewrite': os.path.relpath(src, ROOT), 'kick': kick}
    json.dump(ep, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('applied', ep['id'], len(turns), '턴', '| 킥:', kick)


if __name__ == '__main__':
    cmd, path = sys.argv[1], sys.argv[2]
    {'prompt': cmd_prompt, 'send': cmd_send, 'apply': cmd_apply}[cmd](path)
