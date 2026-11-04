#!/usr/bin/env python3
"""조연 캐릭터 시트(반복 조연 4명씩 2장)를 Grok 에 요청해 data/review/uxui/cast_<종류>_v1.jpg 로 저장(2026-11-04, 일본어앱 공통 변경 ⑧).
  python3 tools/grok_cast_id.py campus|street
주인공 시트(char_id_03_sheet.jpg)를 톤 기준으로 첨부. 장면 컷 요청 때 그 조연이 나오는 편에만 첨부 2 로 붙인다(grok_scenes_id.py CAST_CAMPUS·CAST_STREET).
"""
import os
import subprocess
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import grok_scenes_id as S

UX = os.path.join(S.ROOT, 'data/review/uxui')
PEOPLE = {
    'campus': ('캠퍼스·직장', [
        'Pak Dosen — 대학 교수, 50대 남성. 희끗한 짧은 머리, 둥근 안경, 갈색 바틱 긴소매 셔츠 + 짙은 회색 바지, 책 한 권을 낀 졸린 듯 온화한 얼굴',
        'Pak Bos — 회사 사장, 40대 후반 남성. 약간 통통, 짧은 콧수염, 남색 정장 + 넥타이 없이 흰 셔츠, 배를 잡고 크게 웃는 표정',
        'Mbak Rina — 회사 선배, 30대 초 여성. 히잡 없음, 어깨 길이 짙은 갈색 단발, 겨자색 블라우스 + 검은 슬랙스, 글자 없는 사원증 끈, 서류철',
        'Pak Satpam — 캠퍼스·회사 경비 아저씨, 50대 남성. 짙은 남색 경비 제복과 모자(글자·마크 없음), 호루라기, 사람 좋은 웃음',
    ]),
    'street': ('거리·가게', [
        'Mas Kasir — 편의점 점원, 20대 초 남성. 짧은 흑발, 빨간 폴로 유니폼 + 글자 없는 명찰, 스캐너를 든 무표정',
        'Mbak Petugas — 역·공항 안내 직원, 30대 여성. 남색 히잡, 하늘색 제복 셔츠 + 남색 스카프, 글자 없는 무전기, 친절한 미소',
        'Pak Sopir — 앙콧(작은 승합 버스) 기사, 50대 남성. 까무잡잡한 피부, 흰 수건을 목에 두름, 낡은 체크 셔츠 + 샌들, 노래 부르듯 입을 벌린 신난 얼굴',
        'Bu Kos — 하숙집 주인, 60대 여성. 흰 히잡, 꽃무늬 다스터(긴 원피스), 빗자루, 잔소리하듯 손가락을 든 표정',
    ]),
}


def main(kind):
    title, ppl = PEOPLE[kind]
    lines = '\n'.join(f'{i}. {p}' for i, p in enumerate(ppl, 1))
    text = f"""[ID-CAST-{kind.upper()}] **이미지 1장을 생성해 주세요**(글 설명 없이 그림만). 인도네시아어 학습 앱 장면 컷에 반복해서 나오는 **조연 4명({title})의 캐릭터 시트**입니다.
첨부 = 우리 앱 주인공 캐릭터 시트 — 톤·질감·배경·비율·배치를 그대로 따를 것. 부드러운 펠트·점토 인형, 연한 크림 단색 배경, 4:3 가로, 네 명이 전신으로 나란히 서기. 인도네시아 사람다운 얼굴·피부색.
인물과 배경만 있는 순수한 그림(글자·이름표·말풍선·로고 없음). 실존 인물과 닮지 않게.
왼쪽부터:
{lines}
키 순서가 자연스럽게, 4:3 가로 1장만. 설명은 "그림 1장 완료" 한 줄."""
    p = os.path.join(UX, f'cast_{kind}_prompt.md')
    open(p, 'w', encoding='utf-8').write(text)
    subprocess.run(['ssh', 'macmini4', f'mkdir -p {S.M4_ATT}'], check=True)
    subprocess.run(['scp', '-q', S.SHEET, f'macmini4:{S.M4_ATT}/char_id_03_sheet.jpg'], check=True)
    g = S._grok()
    c = g.CDP(g.tab('grok.com'))
    c.call('Page.navigate', url=f'https://grok.com/project/{S.PROJECT}')
    time.sleep(7)
    subprocess.run(['/usr/bin/python3', os.path.join(S.ROOT, 'tools/grok_send.py'), p, os.path.join(UX, f'cast_{kind}_answer.md'),
                    '--tab', f'project/{S.PROJECT[:8]}', '--wait', '30', '--model', '빠른', '--attach', f'{S.M4_ATT}/char_id_03_sheet.jpg'],
                   capture_output=True, text=True)
    S.OUTDIR = UX
    ep = {'id': f'cast_{kind}'}
    c, n = S._wait(g, ep, 1)
    c.call('Page.bringToFront')
    got = S._capture(c, ep, [1], max(0, n - 1))
    if got:
        os.replace(os.path.join(UX, f'cast_{kind}_1.jpg'), os.path.join(UX, f'cast_{kind}_v1.jpg'))
    print(kind, '저장' if got else '실패', '그림', n)


if __name__ == '__main__':
    main(sys.argv[1])
