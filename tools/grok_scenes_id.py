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
PROJECT = 'b1727d84-c387-4168-9355-77c6b7df2073'  # talkverse UXUI id (2026-11-03 M4 원본 프로필 계정이 바뀌어 새로 만듦)
OUTDIR = os.path.join(ROOT, 'data/review/scenes')
SHEET = os.path.join(ROOT, 'data/review/uxui/char_id_03_sheet.jpg')
M4_ATT = '/tmp/grok_att/id'

# 시트 번호 = 인물
CAST = {'Ayu': 1, 'Raka': 2, 'Bu Sri': 3, 'Pak Darto': 4, 'Nadia': 5, 'Dimas': 6}
DESC = {1: '1번 여자 주인공(웨이브 흑발·꽃 머리핀·파란 꽃무늬 셔츠)', 2: '2번 남자 주인공(곱슬 흑발·바틱 셔츠)',
        3: '3번 와룽 아주머니(연갈색 히잡·바틱 앞치마)', 4: '4번 오토바이 기사 아저씨(콧수염·초록 재킷·헬멧)',
        5: '5번 대학 친구(분홍 히잡·안경)', 6: '6번 직장 동료(안경·흰 셔츠)'}
# 조연 시트(2026-11-04, tools/grok_cast_id.py) — 그 조연이 나오는 편에만 첨부 2 로. 대사에만 나오는 조연(교수·사장)도 장면 설명에 이름이 있으면 붙인다
CAST_SHEETS = {'campus': os.path.join(ROOT, 'data/review/uxui/cast_campus_v1.jpg'), 'street': os.path.join(ROOT, 'data/review/uxui/cast_street_v1.jpg')}
SIDE = {'Pak Dosen': ('campus', '조연 시트(캠퍼스·직장) 1번 교수(희끗한 머리·둥근 안경·갈색 바틱 셔츠)'),
        'Pak Bos': ('campus', '조연 시트(캠퍼스·직장) 2번 사장(통통·콧수염·남색 정장·흰 셔츠)'),
        'Mbak Rina': ('campus', '조연 시트(캠퍼스·직장) 3번 선배(갈색 단발·겨자색 블라우스)'),
        'Satpam': ('campus', '조연 시트(캠퍼스·직장) 4번 경비(남색 제복·모자·호루라기)'),
        'Kasir': ('street', '조연 시트(거리·가게) 1번 점원(곱슬 흑발·빨간 폴로)'),
        'Petugas': ('street', '조연 시트(거리·가게) 2번 안내 직원(남색 히잡·하늘색 제복)'),
        'Sopir': ('street', '조연 시트(거리·가게) 3번 앙콧 기사(목에 흰 수건·체크 셔츠·샌들)'),
        'Bu Kos': ('street', '조연 시트(거리·가게) 4번 하숙집 주인(흰 히잡·꽃무늬 원피스)')}
SIDE_ALIAS = {'dosen': 'Pak Dosen', '교수': 'Pak Dosen', 'Bos': 'Pak Bos', '사장': 'Pak Bos', 'satpam': 'Satpam', '경비': 'Satpam'}


def side_cast(ep):
    """이 편에 나오는 조연 이름 목록(화자 + 대사·장면에 나오는 반복 조연)."""
    found = [v for v in ep['speakers'].values() if v in SIDE]
    text = ep.get('scene', '') + ' '.join(t.get('tl', '') + t.get('ko', '') for t in ep['turns'])
    for k, v in SIDE_ALIAS.items():
        if k in text and v not in found:
            found.append(v)
    return found


def side_sheets(ep):
    ks = []
    for n in side_cast(ep):
        k = SIDE[n][0]
        if k not in ks:
            ks.append(k)
    return [CAST_SHEETS[k] for k in ks]

# 그림을 화면 위에서 110px 아래(고정 머리띠 아래)에 맞춘다 — 실제로 스크롤되는 조상 틀을 찾아 움직인다
PLACE = ("(()=>{{const im=[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated'))[{k}];"
         "let p=im.parentElement; while(p && !(p.scrollHeight>p.clientHeight+10 && ['auto','scroll'].includes(getComputedStyle(p).overflowY))) p=p.parentElement;"
         "const top=im.getBoundingClientRect().top; if(p) p.scrollTop+= top-110; else window.scrollBy(0, top-110); return 1}})()")
OK_TOP, OK_BOTTOM = 90, 170  # 고정 머리띠 아래, 떠 있는 입력창 위


FEMALE = '--female' in sys.argv  # 여자 학습자판(2026-11-04): A = 1번 여자 주인공, 결과 <편id>_f_<n>.jpg — 앱은 프로필 성별이 여자면 이쪽을 먼저


def cast_of(ep):
    b = ep['speakers'].get('B', '')
    bnum = CAST.get(b)
    a = 6 if bnum == 2 else 2  # 학습자 A = 남자 주인공, 상대가 남자 주인공이면 6번(2026-11-04 — 전엔 1번 여자 주인공이라 남자 학습자에게 여자가 보였음, 그 컷은 _f 로 옮김)
    if FEMALE:
        a = 1  # 상대가 1번이면(연애 편) 여자판을 만들지 않는다 — female_targets()
        return DESC[1] + ' — 이번엔 남자 주인공 대신 이 여자 주인공이 A(웨이브 흑발·꽃 머리핀·파란 꽃무늬 셔츠 그대로, 머리색·옷 바꾸지 말 것)', \
            (DESC[bnum] if bnum else (SIDE[b][1] if b in SIDE else f'{b}(시트에 없는 단역, 같은 점토 화풍, 유니폼·명찰 글자 없음)'))
    bdesc = DESC[bnum] if bnum else (SIDE[b][1] if b in SIDE else f'{b}(시트에 없는 단역, 같은 점토 화풍, 유니폼·명찰 글자 없음)')
    return DESC[a], bdesc


def side_note(ep):
    xs = [n for n in side_cast(ep) if n not in ep['speakers'].values()]
    if not side_cast(ep):
        return ''
    out = '두 번째 이후 첨부 = 조연 시트 — 조연의 얼굴·머리·옷을 그대로.'
    if xs:
        out += ' 이 회화에 나오는 조연: ' + ', '.join(SIDE[n][1] for n in xs) + '.'
    return out + chr(10)


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
{side_note(ep)}{'마지막 첨부 = 이 회화의 기존 1번 컷(남자 주인공판) — **장소·조명·B 의 차림은 이 컷과 같게**, A 만 여자 주인공으로.' + chr(10) if FEMALE else ''}화풍: 펠트·점토 인형, 파스텔·따뜻한 조명, 인도네시아(자카르타) 분위기가 나는 배경. **그림 안에 글자·말풍선·간판 글씨·상표 없음**(말풍선은 앱이 얹습니다). 가로 4:3.
{'**채팅 장면**: 두 사람은 같은 곳에 있지 않다 — 컷마다 화면을 좌우로 나눠(분할 화면) 각자 자기 방·자리에서 휴대폰을 보는 모습. 한 공간에 둘이 함께 있게 그리지 말 것.' + chr(10) if ep.get('kind') == 'chat' else ''}표정과 몸짓이 크게 — 이 앱은 카오스·재미·심쿵이 핵심이라 반전 컷({ep.get('twist', '')}번 턴이 든 컷)은 과장되게 웃기거나 설레게.

컷마다 이 대화 한 쌍의 순간(대사는 그리지 말고 상황·표정만):
""" + '\n'.join(cuts) + f"\n\n그림 {len(cuts)}장만, 설명은 \"그림 {len(cuts)}장 완료\" 한 줄."


def cmd_prompt(path):
    ep = json.load(open(path, encoding='utf-8'))
    if FEMALE:
        ep['id'] += '_f'
    os.makedirs(OUTDIR, exist_ok=True)
    p = os.path.join(OUTDIR, ep['id'] + '_prompt.md')
    open(p, 'w', encoding='utf-8').write(prompt_for(ep))
    return ep, p


def _grok():
    sys.path.insert(0, '/Users/talkverse/Hanja/tools')
    import grok_cdp as g
    g.BASE = 'http://127.0.0.1:9228'
    return g


def _wait(g, ep, want_n):
    """그림 want_n 장이 다 나올 때까지 기다린다. 빈 답이면 같은 대화에서 한 번 재촉."""
    nudged = False
    for i in range(60):
        c = g.CDP(g.tab('grok.com'))
        busy = c.ev("document.body.innerText.includes('이미지 생성 중')||document.body.innerText.includes('작업 중')||!![...document.querySelectorAll('button')].find(e=>(e.getAttribute('aria-label')||'')==='응답 중지')")
        n = c.ev("[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated')).length")
        if not busy and n >= want_n:
            break
        if not busy and n == 0 and i >= 4 and not nudged:
            # 「빠른」이 그림 없이 빈 답을 낼 때가 있다(2026-11-03 두 번) — 같은 대화에서 한 번 재촉
            chat = c.ev("new URLSearchParams(location.search).get('chat')") or ''
            q = os.path.join(OUTDIR, ep['id'] + '_redo_nudge.md')
            open(q, 'w', encoding='utf-8').write(f"답이 비어 있어요. 위 설명대로 그림 {want_n}장을 지금 그려 주세요.")
            subprocess.run(['/usr/bin/python3', os.path.join(ROOT, 'tools/grok_send.py'), q, q + '.ans', '--tab', 'chat=' + chat[:8],
                            '--wait', '30', '--model', '빠른'], capture_output=True, text=True)
            nudged = True
        time.sleep(15)
    return c, n


def female_targets(ep):
    """여자판이 필요한 편 = 기본 컷의 A 가 남자 주인공(2번)이고 상대가 1번 여자 주인공이 아닌 편."""
    b = CAST.get(ep['speakers'].get('B', ''))
    return b not in (1, 2)


def cmd_send(path):
    if FEMALE:
        ep0 = json.load(open(path, encoding='utf-8'))
        if not female_targets(ep0):
            print(ep0['id'], '여자판 대상 아님')
            return
    ep, p = cmd_prompt(path)
    n_cuts = len(pairs(ep))
    subprocess.run(['ssh', 'macmini4', f'mkdir -p {M4_ATT}'], check=True)
    remote = []
    ref = [os.path.join(OUTDIR, ep['id'][:-2] + '_1.jpg')] if FEMALE and os.path.exists(os.path.join(OUTDIR, ep['id'][:-2] + '_1.jpg')) else []
    for f in [SHEET] + side_sheets(ep) + ref:
        subprocess.run(['scp', '-q', f, f'macmini4:{M4_ATT}/{os.path.basename(f)}'], check=True)
        remote.append(f'{M4_ATT}/{os.path.basename(f)}')
    g = _grok()
    c = g.CDP(g.tab('grok.com'))
    c.call('Page.navigate', url=f'https://grok.com/project/{PROJECT}')
    time.sleep(7)
    subprocess.run(['/usr/bin/python3', os.path.join(ROOT, 'tools/grok_send.py'), p, os.path.join(OUTDIR, ep['id'] + '_answer.md'),
                    '--tab', f'project/{PROJECT[:8]}', '--wait', '30', '--model', '빠른', '--attach', ','.join(remote)], capture_output=True, text=True)
    c, n = _wait(g, ep, n_cuts)
    c.call('Page.bringToFront')
    saved = len(_capture(c, ep, list(range(1, min(n, n_cuts) + 1)), max(0, n - n_cuts)))
    print(f"{ep['id']}: 컷 {saved}/{n_cuts} 저장")


def _capture(c, ep, cut_nums, offset):
    """화면의 generated 그림 중 offset 번째부터 차례로 cut_nums 번 컷 파일로 저장."""
    J = "(()=>{{const im=[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated'))[{k}]; const b=im.getBoundingClientRect(); return JSON.stringify({{x:b.x,y:b.y,w:b.width,h:b.height,nw:im.naturalWidth,vh:innerHeight}})}})()"
    c.call('Input.dispatchMouseEvent', type='mouseMoved', x=5, y=5)  # 그림 위 떠 있는 단추(동영상·내려받기)가 찍히지 않게
    saved = []
    for i, cut in enumerate(cut_nums):
        k = offset + i
        for _ in range(12):
            if _ % 4 == 0:
                c.ev(PLACE.format(k=k))
            time.sleep(2)
            a = json.loads(c.ev(J.format(k=k)))
            shot = c.call('Page.captureScreenshot', format='jpeg', quality=92,
                          clip={'x': a['x'], 'y': a['y'], 'width': a['w'], 'height': a['h'], 'scale': a['nw'] / a['w']})
            b = json.loads(c.ev(J.format(k=k)))
            if abs(a['y'] - b['y']) < 0.5 and a['y'] >= OK_TOP and a['y'] + a['h'] <= a['vh'] - OK_BOTTOM:
                open(os.path.join(OUTDIR, f"{ep['id']}_{cut}.jpg"), 'wb').write(base64.b64decode(shot['data']))
                saved.append(cut)
                break
    return saved


def cmd_redo(path, cuts, extra):
    """검수에서 걸린 컷만 새 대화에서 다시 그린다. 시트 + 같은 편의 통과 컷 1장을 장소·차림 기준으로 첨부.
    python3 tools/grok_scenes_id.py redo <편.json> 3,4 "고칠 점"   (기준 컷 = 다시 그리지 않는 컷 중 첫 번째)"""
    ep = json.load(open(path, encoding='utf-8'))
    if FEMALE:
        ep['id'] += '_f'
    want = [int(x) for x in cuts.split(',')]
    allc = list(range(1, len(pairs(ep)) + 1))
    keep = [k for k in allc if k not in want and os.path.exists(os.path.join(OUTDIR, f"{ep['id']}_{k}.jpg"))]
    adesc, bdesc = cast_of(ep)
    lines = []
    for k in want:
        pr = pairs(ep)[k - 1]
        lines.append(f"컷 {k}. " + ' / '.join(f"{x['speaker']}: {x['ko']}" for x in pr))
    ref = f"두 번째 첨부 = 이 편의 {keep[0]}번 컷(이미 통과) — **장소·조명·인물 차림을 이 컷과 똑같이**." if keep else ''
    text = f"""[ID-SCENE-REDO {ep['id']}] 첫 번째 첨부 = 캐릭터 시트(펠트·점토 인형). {ref}
아래 컷 **{len(want)}장**만 다시 그려 주세요(컷마다 그림 1장, 가로 4:3, 글자·말풍선 없음).
화풍: **시트와 같은 펠트·점토 인형**(실사·사진풍 금지), 파스텔·따뜻한 조명.
장면: {ep['scene']}
인물: A = {adesc}, B = {bdesc}. **얼굴(눈 모양·크기 포함)·머리·옷은 시트와 똑같이** — 옷을 바꾸거나 겉옷을 더하지 말 것.
{'채팅 장면: 좌우 분할 화면, 각자 자기 방에서 휴대폰. 한 공간에 둘이 있으면 안 됨.' + chr(10) if ep.get('kind') == 'chat' else ''}고칠 점: {extra}

""" + '\n'.join(lines) + f"\n\n그림 {len(want)}장만, 설명은 \"그림 {len(want)}장 완료\" 한 줄."
    p = os.path.join(OUTDIR, ep['id'] + '_redo_prompt.md')
    open(p, 'w', encoding='utf-8').write(text)
    att = [SHEET] + ([os.path.join(OUTDIR, f"{ep['id']}_{keep[0]}.jpg")] if keep else []) + side_sheets(ep)
    subprocess.run(['ssh', 'macmini4', f'mkdir -p {M4_ATT}'], check=True)
    remote = []
    for f in att:
        subprocess.run(['scp', '-q', f, f'macmini4:{M4_ATT}/{os.path.basename(f)}'], check=True)
        remote.append(f'{M4_ATT}/{os.path.basename(f)}')
    g = _grok()
    c = g.CDP(g.tab('grok.com'))
    c.call('Page.navigate', url=f'https://grok.com/project/{PROJECT}')
    time.sleep(7)
    subprocess.run(['/usr/bin/python3', os.path.join(ROOT, 'tools/grok_send.py'), p, os.path.join(OUTDIR, ep['id'] + '_redo_answer.md'),
                    '--tab', f'project/{PROJECT[:8]}', '--wait', '30', '--model', '빠른', '--attach', ','.join(remote)], capture_output=True, text=True)
    c, n = _wait(g, ep, len(want))
    c.call('Page.bringToFront')
    # 재촉 뒤에는 빈 답 자리의 그림까지 겹쳐 나올 수 있어 마지막 len(want) 장을 쓴다 — 검수에서 확인
    saved = _capture(c, ep, want, n - len(want))
    print(f"{ep['id']}: 다시 그린 컷 {saved} 저장 (요청 {want}, 그림 {n})")


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
    if sys.argv[1] == 'redo':
        cmd_redo(*[x for x in sys.argv[2:] if x != '--female'][:3])
        sys.exit()
    if sys.argv[1] == 'recapture':
        cmd_recapture(*sys.argv[2:5])
        sys.exit()
    cmd, path = sys.argv[1], [x for x in sys.argv[2:] if not x.startswith('--')][0]
    {'prompt': cmd_prompt, 'send': cmd_send}[cmd](path)
