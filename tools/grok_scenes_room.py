#!/usr/bin/env python3
"""장면 컷을 한 채팅방에서 여러 편 그린다 — 프롬프트 최소화(사용자 지시 2026-11-09).

  python3 tools/grok_scenes_room.py <편.json> [<편.json> ...]

첫 메시지: 규칙 파일(SCENE_RULES.txt) + 캐릭터 시트 + 조연 시트 2장 첨부, 「앞으로 파일 이름 한 줄만」 약속.
이후 편마다: `<편id>.txt` 한 줄 + 그 편 파일(장면·인물·컷 목록) + 기존 1번 컷(장소 기준) 첨부.
받은 그림 = data/review/scenes/<편id>_<n>.jpg (기존 그림은 <편id>_<n>.prev.jpg 로 남김 — 검수 뒤 지운다).
Grok = M4 크롬 9228(M6 에서 ssh -L 터널), 모델 「전문가」. 한도 문구가 나오면 멈춘다(종료 코드 3).
"""
import json
import os
import shutil
import subprocess
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import grok_scenes_id as S  # noqa: E402

ROOT, OUTDIR, M4_ATT = S.ROOT, S.OUTDIR, S.M4_ATT
WORK = os.path.join(OUTDIR, 'room')
RULES = """[ID-SCENE 규칙 — 이 방 전체에 적용]
- 첨부 1 = 인도네시아어앱 고정 인물 6명 캐릭터 시트(펠트·점토 인형). 첨부 2·3 = 조연 시트(캠퍼스·직장 / 거리·가게).
- 이후 메시지는 「<편id>.txt」 한 줄 + 그 편 파일 + 그 편의 기존 1번 컷만 보냅니다. 편 파일의 컷 목록대로 컷마다 그림 1장.
- 화풍: 시트와 같은 펠트·점토 인형(실사·사진풍 금지), 파스텔·따뜻한 조명, 인도네시아(자카르타) 분위기. 가로 4:3.
- 인물의 얼굴(눈 모양·크기)·머리·옷은 시트와 똑같이. 조연은 조연 시트의 그 번호 인물 그대로.
- 기존 1번 컷이 첨부되면 장소·조명·구도를 그 컷과 같게(같은 장면을 조연 시트대로 다시 그리는 것).
- 그림 안에 글자·말풍선·간판 글씨·상표 없음(앱이 얹음). 대사는 그리지 말고 상황·표정만.
- 표정·몸짓은 크게, 반전 턴이 든 컷은 웃기거나 설레게 — 단 실제 일상에서 있을 법한 장면으로.
- 답은 「그림 N장 완료」 한 줄.
"""


def ep_file(ep):
    adesc, bdesc = S.cast_of(ep)
    cuts = [f"{k}. " + ' / '.join(f"{x['speaker']}: {x['ko']}" for x in pr) for k, pr in enumerate(S.pairs(ep), 1)]
    side = '; '.join(S.SIDE[n][1] for n in S.side_cast(ep))
    return (f"{ep['id']} — 컷 {len(cuts)}장\n장면: {ep['scene']}\n" + (f"조연(이 편에 꼭 등장, 조연 시트 그대로): {side}\n" if side else '') + f"A = {adesc}, B = {bdesc}\n반전 턴: {ep.get('twist', '')}\n" + '\n'.join(cuts) + '\n')


def put(paths):
    subprocess.run(['ssh', 'macmini4', f'mkdir -p {M4_ATT}'], check=True)
    out = []
    for f in paths:
        subprocess.run(['scp', '-q', f, f'macmini4:{M4_ATT}/{os.path.basename(f)}'], check=True)
        out.append(f'{M4_ATT}/{os.path.basename(f)}')
    return out


def send(c, text, files):
    """현재 채팅 탭에 첨부 + 한 줄을 보낸다."""
    if files:
        doc = c.call('DOM.getDocument', depth=1)
        q = c.call('DOM.querySelector', nodeId=doc['root']['nodeId'], selector='input[type=file]')
        c.call('DOM.setFileInputFiles', nodeId=q['nodeId'], files=files)
        time.sleep(4 + 2 * len(files))
    c.ev("document.querySelector('.ProseMirror').focus()")
    c.call('Input.insertText', text=text)
    time.sleep(1)
    c.ev("(()=>{const b=[...document.querySelectorAll('button')].find(e=>['보내기','제출','Submit','Send'].includes(e.getAttribute('aria-label')||''));if(b)b.click()})()")
    time.sleep(3)
    if (c.ev("document.querySelector('.ProseMirror').innerText.trim().length") or 0) > 3:
        for typ in ('keyDown', 'keyUp'):
            c.call('Input.dispatchKeyEvent', type=typ, key='Enter', code='Enter', windowsVirtualKeyCode=13, nativeVirtualKeyCode=13)
        time.sleep(3)


MODEL = os.environ.get('GROK_MODEL', '빠른')  # 장면 그림 = 「빠른」(사용자 지시 2026-11-10 — 「전문가」는 시트를 무시하고 글자 포스터를 그렸다)


def set_model(c, name=MODEL):
    lab = c.ev("(()=>{const b=[...document.querySelectorAll('button')].find(x=>/^(모델|Model):/.test(x.getAttribute('aria-label')||''));return b?b.getAttribute('aria-label'):''})()") or ''
    if not lab or name in lab:
        return lab
    # grok_mode.py(uk) 와 같은 방식 — 단추·항목에 pointer 이벤트 + click
    c.ev("(()=>{const b=[...document.querySelectorAll('button')].find(x=>/^(모델|Model):/.test(x.getAttribute('aria-label')||''));['pointerdown','pointerup'].forEach(t=>b.dispatchEvent(new PointerEvent(t,{bubbles:true})));b.click()})()")
    time.sleep(2)
    c.ev("(()=>{const it=[...document.querySelectorAll('[role=menuitem],[role=option],[role=menuitemradio],[role=menuitemcheckbox],button,div')].find(x=>new RegExp('^" + name + "(\\\\s|$)').test((x.innerText||'').trim())&&x.offsetParent&&!(x.getAttribute('aria-label')||'').match(/^(모델|Model):/));if(!it)return 0;['pointerdown','pointerup'].forEach(t=>it.dispatchEvent(new PointerEvent(t,{bubbles:true})));it.click();return 1})()")
    time.sleep(2)
    lab = c.ev("(()=>{const b=[...document.querySelectorAll('button')].find(x=>/^(모델|Model):/.test(x.getAttribute('aria-label')||''));return b?b.getAttribute('aria-label'):''})()")
    print('model:', lab, flush=True)
    return lab


def srcs(c):
    """대화의 generated 그림 src(첫 등장 순서, 중복 없음 — 같은 그림이 두 번 걸릴 때가 있다)."""
    return json.loads(c.ev("JSON.stringify([...new Set([...document.querySelectorAll('img')].filter(i=>i.src.includes('generated')).map(i=>i.src))])"))


def busy(c):
    return c.ev("document.body.innerText.includes('이미지 생성 중')||document.body.innerText.includes('작업 중')||!![...document.querySelectorAll('button')].find(e=>['응답 중지','Stop'].includes(e.getAttribute('aria-label')||''))")


def limit(c):
    return c.ev("document.body.innerText.includes('한도에 도달')||/limit reached/i.test(document.body.innerText)")


def wait_new(g, frag, have, timeout=180):  # 3분까지만(사용자 지시 2026-11-10) — 넘으면 생성 중지
    """새 그림 1장이 나올 때까지(전문가 모드는 한 번에 1장)."""
    t0 = time.time()
    while time.time() - t0 < timeout:
        time.sleep(15)
        c = g.CDP(g.tab(frag))
        if limit(c):
            print('LIMIT', c.ev("(document.body.innerText.match(/\\d+월 \\d+일에 초기화/)||[''])[0]"), flush=True)
            sys.exit(3)
        ss = srcs(c)
        if not busy(c) and len(ss) > len(have):
            return c, ss
    stop(g.CDP(g.tab(frag)))
    print('TIMEOUT 3분 — 생성 중지', flush=True)
    sys.exit(1)


def stop(c):
    """진행 중인 생성을 멈춘다(중지 단추, 없으면 Escape)."""
    ok = c.ev("(()=>{const b=[...document.querySelectorAll('button')].find(e=>/^(응답 중지|중지|Stop)/.test(e.getAttribute('aria-label')||''));if(b){b.click();return 1}return 0})()")
    if not ok:
        for t in ('keyDown', 'keyUp'):
            c.call('Input.dispatchKeyEvent', type=t, key='Escape', code='Escape', windowsVirtualKeyCode=27)


def capture_src(c, ep, cut, src):
    """src 그림의 첫 요소를 화면에 맞춰 <편id>_<cut>.jpg 로 저장."""
    # 같은 src 가 여러 요소(숨은 미리보기 포함)일 수 있다 — 화면에 그려진 가장 큰 요소를 쓴다
    k = c.ev("(()=>{const a=[...document.querySelectorAll('img')].filter(i=>i.src.includes('generated'));let b=-1,w=0;a.forEach((i,n)=>{if(i.src==" + json.dumps(src) + "&&i.offsetWidth>w){w=i.offsetWidth;b=n}});return b})()")
    if k is None or k < 0:
        return []
    return S._capture(c, ep, [cut], k)


def save_originals(c, ep, new_srcs):
    """new_srcs(대화 순서) 를 원본 해상도로 <편id>_<n>.jpg 저장. 접힌 갤러리(+2) 그림은 숨은 Image 로 불러 리소스에서 읽는다."""
    import base64
    c.call('Page.enable')
    c.ev("(" + json.dumps(new_srcs) + ").forEach(u=>{const x=new Image();x.src=u;x.style.cssText='position:fixed;left:-9999px;width:4px';document.body.appendChild(x)})")
    time.sleep(8)
    fid = c.call('Page.getResourceTree')['frameTree']['frame']['id']
    saved = []
    for k, u in enumerate(new_srcs, 1):
        r = c.call('Page.getResourceContent', frameId=fid, url=u)
        data = base64.b64decode(r['content']) if r.get('base64Encoded') else r['content'].encode('latin1')
        cur = os.path.join(OUTDIR, f"{ep['id']}_{k}.jpg")
        if os.path.exists(cur) and not os.path.exists(cur[:-4] + '.prev.jpg'):
            shutil.move(cur, cur[:-4] + '.prev.jpg')
        open(cur, 'wb').write(data)
        saved.append(k)
    return saved


def main(paths):
    os.makedirs(WORK, exist_ok=True)
    g = S._grok()
    room = os.environ.get('ROOM')
    if not room:
        rules = os.path.join(WORK, 'SCENE_RULES.txt')
        open(rules, 'w', encoding='utf-8').write(RULES)
        c = g.CDP(g.tab('grok.com'))
        c.call('Page.bringToFront')
        c.call('Page.navigate', url='https://grok.com/')
        time.sleep(8)
        set_model(c)
        att = put([rules, S.SHEET, S.CAST_SHEETS['campus'], S.CAST_SHEETS['street']])
        send(c, '첨부 규칙대로 이 방에서 장면 컷을 그립니다. 앞으로는 파일 이름 한 줄만 보냅니다. 지금은 「확인」 한 줄만.', att)
        for _ in range(40):
            time.sleep(5)
            c = g.CDP(g.tab('grok.com'))
            room = c.ev("(location.pathname.match(/\\/c\\/([\\w-]+)/)||[])[1]")
            if room and not busy(c):
                break
    print('room', room, flush=True)
    frag = room[:8]
    skip = os.environ.get('SKIP', '')  # 이미 받은 컷, 예: "r1_life_a1:1"
    for path in paths:
        ep = json.load(open(path, encoding='utf-8'))
        n_cuts = len(S.pairs(ep))
        f = os.path.join(WORK, ep['id'] + '.txt')
        open(f, 'w', encoding='utf-8').write(ep_file(ep))
        attached = f"{ep['id']}:1" in skip
        for k in range(1, n_cuts + 1):
            if f"{ep['id']}:{k}" in skip:
                continue
            c = g.CDP(g.tab(frag))
            set_model(c)
            have = srcs(c)
            if not attached:
                files = [f, S.SHEET] + S.side_sheets(ep)  # 시트는 편마다 붙인다(11-09 study_a4 — 첫 메시지에만 두면 흐트러짐)
                ref = os.path.join(OUTDIR, ep['id'] + '_1.jpg')
                if os.path.exists(ref):
                    rc = os.path.join(WORK, ep['id'] + '_ref1.jpg')
                    shutil.copy(ref, rc)
                    files.append(rc)
                send(c, f"{os.path.basename(f)} 컷 1 — 첨부 사진(기존 컷 1)과 같은 화풍·장소, 인물·조연은 시트 그대로, 글자 없음.", put(files))
                attached = True
            else:
                send(c, f"{ep['id']} 컷 {k}", [])  # 한 메시지 = 그림 1장(이 방식에서 Grok 은 한 번에 1장만 그린다)
            c, ss = wait_new(g, frag, have)
            new = [x for x in ss if x not in have]
            cur = os.path.join(OUTDIR, f"{ep['id']}_{k}.jpg")
            if os.path.exists(cur) and not os.path.exists(cur[:-4] + '.prev.jpg'):
                shutil.move(cur, cur[:-4] + '.prev.jpg')
            import base64
            c.call('Page.enable')
            c.ev("(()=>{const x=new Image();x.src=" + json.dumps(new[-1]) + ";x.style.cssText='position:fixed;left:-9999px;width:4px';document.body.appendChild(x)})()")
            time.sleep(6)
            fid = c.call('Page.getResourceTree')['frameTree']['frame']['id']
            r = c.call('Page.getResourceContent', frameId=fid, url=new[-1])
            open(cur, 'wb').write(base64.b64decode(r['content']) if r.get('base64Encoded') else r['content'].encode('latin1'))
            print(f"{ep['id']} 컷 {k} 저장", flush=True)

if __name__ == '__main__':
    main(sys.argv[1:])
