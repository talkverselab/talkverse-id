#!/usr/bin/env python3
"""회화 편의 장면 컷(A·B 대화 한 쌍 = 1컷)을 Grok 에 요청하고 받은 그림을 저장한다(2026-11-03).

  python3 tools/grok_scenes_id.py prompt <편.json>   → data/review/scenes/<id>_prompt.md
  python3 tools/grok_scenes_id.py send <편.json>     → 캐릭터 시트 첨부해 Grok(「talkverse UXUI id」)에 보내고, 끝나면 컷 그림을 캡처해
                                                     data/review/scenes/<id>_<n>.jpg 로 저장(n = 1부터, 쌍 순서)
한 메시지 = 한 편(최대 4컷). 그림 안 글자·말풍선 없음(앱이 얹는다). 인물 = data/review/uxui/CHARACTERS.md 6명.
Grok = M4 Chrome 9228(M6 에서는 ssh -L 터널), 첨부는 M4 /tmp/grok_att/id/ 로 먼저 보낸다.
"""
import base64
import json
import os
import subprocess
import sys
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROJECT = '6e555047-e631-4661-bc3c-99d935b4ece0'  # talkverse UXUI id
OUTDIR = os.path.join(ROOT, 'data/review/scenes')
SHEET = os.path.join(ROOT, 'data/review/uxui/char_id_03_sheet.jpg')
M4_ATT = '/tmp/grok_att/id'

# 시트 번호 = 인물
CAST = {'Ayu': 1, 'Raka': 2, 'Bu Sri': 3, 'Pak Darto': 4, 'Nadia': 5, 'Dimas': 6}
DESC = {1: '1번 여자 주인공(웨이브 흑발·꽃 머리핀·파란 꽃무늬 셔츠)', 2: '2번 남자 주인공(곱슬 흑발·바틱 셔츠)',
        3: '3번 와룽 아주머니(연갈색 히잡·바틱 앞치마)', 4: '4번 오토바이 기사 아저씨(콧수염·초록 재킷·헬멧)',
        5: '5번 대학 친구(분홍 히잡·안경)', 6: '6번 직장 동료(안경·흰 셔츠)'}

# 그림을 화면 위에서 110px 아래(고정 머리띠 아래)에 맞춘다 — 실제로 스크롤되는 조상 틀을 찾아 움직인다
PLACE = ("(()=>{{const im=[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated'))[{k}];"
         "let p=im.parentElement; while(p && !(p.scrollHeight>p.clientHeight+10 && ['auto','scroll'].includes(getComputedStyle(p).overflowY))) p=p.parentElement;"
         "const top=im.getBoundingClientRect().top; if(p) p.scrollTop+= top-110; else window.scrollBy(0, top-110); return 1}})()")
OK_TOP, OK_BOTTOM = 90, 170  # 고정 머리띠 아래, 떠 있는 입력창 위


def cast_of(ep):
    b = ep['speakers'].get('B', '')
    bnum = CAST.get(b)
    a = 1 if bnum == 2 else 2  # 학습자 A = 상대가 아닌 주인공(기본 남자 주인공)
    bdesc = DESC[bnum] if bnum else f'{b}(점원 — 시트에 없는 단역, 같은 점토 화풍의 20대 점원, 유니폼·명찰 글자 없음)'
    return DESC[a], bdesc


def pairs(ep):
    t = ep['turns']
    return [t[i:i + 2] for i in range(0, len(t), 2)][:4]


def prompt_for(ep):
    adesc, bdesc = cast_of(ep)
    cuts = []
    for k, pr in enumerate(pairs(ep), 1):
        lines = ' / '.join(f"{x['speaker']}: {x['ko']}" for x in pr)
        cuts.append(f'{k}. {lines}')
    return f"""[ID-SCENE {ep['id']}] 첨부한 캐릭터 시트(인도네시아어앱 고정 인물 6명, 펠트·점토 인형)의 인물로, 아래 회화의 장면 컷 **{len(cuts)}장**을 그려 주세요(컷마다 그림 1장, 모두 같은 장소·같은 차림).

장면: {ep['scene']}
인물: A = {adesc}, B = {bdesc}. 시트의 얼굴·머리·옷을 그대로.
화풍: 펠트·점토 인형, 파스텔·따뜻한 조명, 인도네시아(자카르타) 분위기가 나는 배경. **그림 안에 글자·말풍선·간판 글씨·상표 없음**(말풍선은 앱이 얹습니다). 가로 4:3.
표정과 몸짓이 크게 — 이 앱은 카오스·재미·심쿵이 핵심이라 반전 컷({ep.get('twist', '')}번 턴이 든 컷)은 과장되게 웃기거나 설레게.

컷마다 이 대화 한 쌍의 순간(대사는 그리지 말고 상황·표정만):
""" + '\n'.join(cuts) + f"\n\n그림 {len(cuts)}장만, 설명은 \"그림 {len(cuts)}장 완료\" 한 줄."


def cmd_prompt(path):
    ep = json.load(open(path, encoding='utf-8'))
    os.makedirs(OUTDIR, exist_ok=True)
    p = os.path.join(OUTDIR, ep['id'] + '_prompt.md')
    open(p, 'w', encoding='utf-8').write(prompt_for(ep))
    return ep, p


def _grok():
    sys.path.insert(0, '/Users/talkverse/Hanja/tools')
    import grok_cdp as g
    g.BASE = 'http://127.0.0.1:9228'
    return g


def cmd_send(path):
    ep, p = cmd_prompt(path)
    n_cuts = len(pairs(ep))
    subprocess.run(['ssh', 'macmini4', f'mkdir -p {M4_ATT}'], check=True)
    subprocess.run(['scp', '-q', SHEET, f'macmini4:{M4_ATT}/char_id_03_sheet.jpg'], check=True)
    g = _grok()
    c = g.CDP(g.tab('grok.com'))
    c.call('Page.navigate', url=f'https://grok.com/project/{PROJECT}')
    time.sleep(7)
    subprocess.run(['/usr/bin/python3', os.path.join(ROOT, 'tools/grok_send.py'), p, os.path.join(OUTDIR, ep['id'] + '_answer.md'),
                    '--tab', f'project/{PROJECT[:8]}', '--wait', '30', '--attach', f'{M4_ATT}/char_id_03_sheet.jpg'], capture_output=True, text=True)
    # 그림이 다 나올 때까지 기다린다
    for _ in range(60):
        c = g.CDP(g.tab('grok.com'))
        busy = c.ev("document.body.innerText.includes('이미지 생성 중')||document.body.innerText.includes('작업 중')||!![...document.querySelectorAll('button')].find(e=>(e.getAttribute('aria-label')||'')==='응답 중지')")
        n = c.ev("[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated')).length")
        if not busy and n >= n_cuts:
            break
        time.sleep(15)
    c.call('Page.bringToFront')
    J = "(()=>{{const im=[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated'))[{k}]; const b=im.getBoundingClientRect(); return JSON.stringify({{x:b.x,y:b.y,w:b.width,h:b.height,nw:im.naturalWidth,vh:innerHeight}})}})()"
    saved = 0
    for k in range(n):
        c.ev(PLACE.format(k=k))
        for _ in range(8):
            time.sleep(2)
            a = json.loads(c.ev(J.format(k=k)))
            shot = c.call('Page.captureScreenshot', format='jpeg', quality=92,
                          clip={'x': a['x'], 'y': a['y'], 'width': a['w'], 'height': a['h'], 'scale': a['nw'] / a['w']})
            b = json.loads(c.ev(J.format(k=k)))
            if abs(a['y'] - b['y']) < 0.5 and a['y'] >= OK_TOP and a['y'] + a['h'] <= a['vh'] - OK_BOTTOM:
                open(os.path.join(OUTDIR, f"{ep['id']}_{k + 1}.jpg"), 'wb').write(base64.b64decode(shot['data']))
                saved += 1
                break
    print(f"{ep['id']}: 컷 {saved}/{n_cuts} 저장")


def cmd_recapture(path, chat, which):
    """이미 그려진 대화(chat id 앞 8자)에서 k번째 그림만 다시 캡처."""
    ep = json.load(open(path, encoding='utf-8'))
    g = _grok()
    c = g.CDP(g.tab('chat=' + chat))
    c.call('Page.bringToFront')
    J = "(()=>{{const im=[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated'))[{k}]; const b=im.getBoundingClientRect(); return JSON.stringify({{x:b.x,y:b.y,w:b.width,h:b.height,nw:im.naturalWidth,vh:innerHeight}})}})()"
    k = int(which) - 1
    c.ev(PLACE.format(k=k))
    for _ in range(8):
        time.sleep(2)
        a = json.loads(c.ev(J.format(k=k)))
        shot = c.call('Page.captureScreenshot', format='jpeg', quality=92, clip={'x': a['x'], 'y': a['y'], 'width': a['w'], 'height': a['h'], 'scale': a['nw'] / a['w']})
        b = json.loads(c.ev(J.format(k=k)))
        if abs(a['y'] - b['y']) < 0.5 and a['y'] >= OK_TOP and a['y'] + a['h'] <= a['vh'] - OK_BOTTOM:
            open(os.path.join(OUTDIR, f"{ep['id']}_{k + 1}.jpg"), 'wb').write(base64.b64decode(shot['data']))
            print('saved', k + 1, a)
            return
    print('위치가 안 맞음', a)


if __name__ == '__main__':
    if sys.argv[1] == 'recapture':
        cmd_recapture(*sys.argv[2:5])
        sys.exit()
    cmd, path = sys.argv[1], sys.argv[2]
    {'prompt': cmd_prompt, 'send': cmd_send}[cmd](path)
