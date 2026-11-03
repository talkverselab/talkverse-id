#!/usr/bin/env python3
"""R1 2차 6편 초안(2026-11-03). 이미 있는 파일은 건드리지 않는다(재작성 반영본 보호).
카오스 4 · 심쿵 2(여성이 먼저) — docs/DIALOGUE.md §6.
  python3 tools/write_r1_batch2.py
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

EPISODES = [
    dict(id='r1_love_c1', island='love', kind='chat', title='하트 세 개', emoji='💗',
         scene='Ayu 와의 채팅. 「잘 자」에 하트를 보내려다 엉뚱한 방에 하트 세 개를 보냈다',
         speakers={'A': '{name}', 'B': 'Ayu'}, register='chat', twist=4, twist_type='chaos', flags=['romance'],
         purpose=['love'], domain=['love', 'friends'], expressions=['Udah tidur?', 'Belum', 'Kok', 'Mimpi indah'],
         turns=[
             ('B', 'Udah tidur?', '벌써 자?', 'udah = 벌써(sudah)'),
             ('A', 'Belum. Kamu?', '아직. 너는?', 'belum = 아직 아니다'),
             ('B', 'Belum juga. Mimpi indah, ya.', '나도 아직. 좋은 꿈 꿔.', 'mimpi indah = 좋은 꿈'),
             ('A', '❤️❤️❤️', '❤️❤️❤️', ''),
             ('B', 'Kok sepi? Kamu kirim ke mana?', '왜 조용해? 어디로 보낸 거야?', 'kok = 왜(의아함)'),
             ('A', 'Ke grup keluarga… Ibu udah balas.', '가족 단톡방에… 엄마가 벌써 답장했어.', 'keluarga = 가족'),
             ('B', 'Hahaha. Terus buat aku mana?', '하하하. 그럼 내 건?', 'mana = 어디(재촉)'),
             ('A', '❤️', '❤️', ''),
         ]),
    dict(id='r1_friends_a1', island='friends', kind='short', title='셀카 한 장', emoji='🤳',
         scene='Raka 와 공원에서 셀카를 찍는데 사람이 자꾸 늘어난다',
         speakers={'A': '{name}', 'B': 'Raka'}, register='casual', twist=5, twist_type='chaos', flags=[],
         purpose=['making_friends'], domain=['friends'], expressions=['Ayo', 'Senyum', 'Siapa?', 'Satu lagi'],
         turns=[
             ('B', 'Ayo foto! Senyum!', '사진 찍자! 웃어!', 'ayo = 자·하자(권유)'),
             ('A', 'Oke. Satu, dua…', '오케이. 하나, 둘…', ''),
             ('B', 'Eh, ada bapak ikut senyum.', '어, 아저씨 한 분도 같이 웃는데.', 'ikut = 따라·같이'),
             ('A', 'Siapa dia?', '그분 누구야?', 'siapa = 누구'),
             ('B', 'Nggak tahu! Sekarang ada anjing juga!', '몰라! 이제 강아지도 있어!', 'anjing = 개'),
             ('A', 'Kenapa semua orang datang?', '왜 다들 오는 거야?', 'kenapa = 왜'),
             ('B', 'Satu lagi, ya. Bapaknya minta.', '한 장만 더. 아저씨가 원하셔.', 'minta = 달라고 하다'),
         ]),
    dict(id='r1_work_a1', island='work', kind='short', title='아홉 시 회의', emoji='🕘',
         scene='회사 첫 주. Dimas 가 「내일 아홉 시 회의」라고 했는데…',
         speakers={'A': '{name}', 'B': 'Dimas'}, register='polite', twist=5, twist_type='slip', flags=[],
         purpose=['work'], domain=['work'], expressions=['Selamat pagi', 'jam sembilan', 'Lho', 'Nggak apa-apa'],
         turns=[
             ('B', 'Besok rapat jam sembilan, ya.', '내일 아홉 시에 회의예요.', 'rapat = 회의'),
             ('A', 'Siap, Mas Dimas.', '알겠어요, 디마스 씨.', 'Mas = (젊은 남자) ~씨·형'),
             ('A', 'Selamat malam! Saya sudah siap.', '안녕하세요(저녁)! 준비됐어요.', 'selamat malam = 저녁 인사'),
             ('B', 'Lho? Kamu di kantor jam sembilan malam?', '어? 밤 아홉 시에 회사에 있어요?', 'malam = 밤'),
             ('A', 'Rapatnya bukan sekarang?', '회의 지금 아니에요?', ''),
             ('B', 'Jam sembilan pagi! Pulang, tidur!', '아침 아홉 시요! 집에 가서 자요!', 'pagi = 아침'),
             ('A', 'Oke… tapi saya bawa kopi dua.', '네… 근데 커피 두 잔 사 왔는데요.', 'bawa = 가져오다'),
             ('B', 'Nggak apa-apa. Saya temani lima menit.', '괜찮아요. 오 분만 같이 있어 줄게요.', 'temani = 함께 있어 주다'),
         ]),
    dict(id='r1_life_a2', island='life', kind='short', title='아무거나', emoji='🍛',
         scene='Bu Sri 의 와룽. 메뉴가 너무 많아 「아무거나요」라고 했더니',
         speakers={'A': '{name}', 'B': 'Bu Sri'}, register='polite', twist=4, twist_type='chaos', flags=[],
         purpose=['travel', 'survival'], domain=['life'], expressions=['Apa saja', 'Habiskan', 'Kenyang', 'Enak'],
         turns=[
             ('B', 'Mau makan apa hari ini?', '오늘은 뭐 먹을래요?', 'hari ini = 오늘'),
             ('A', 'Apa saja, Bu. Semua enak.', '아무거나요, 아주머니. 다 맛있어서요.', 'apa saja = 아무거나'),
             ('B', 'Oke! Apa saja… ya.', '오케이! 아무거나… 라.', ''),
             ('B', 'Ini ayam, ikan, tahu, tempe, sayur, telur…', '닭, 생선, 두부, 템페, 채소, 달걀…', '(접시가 계속 나온다)'),
             ('A', 'Bu! Ini buat sepuluh orang!', '아주머니! 이거 열 명분이에요!', 'orang = 사람'),
             ('B', 'Kamu bilang apa saja. Habiskan, ya!', '아무거나라며. 다 먹어요!', 'habiskan = 다 먹다'),
             ('A', 'Saya… sudah kenyang lihat saja.', '저… 보기만 해도 배불러요.', 'kenyang = 배부르다'),
         ]),
    dict(id='r1_travel_a2', island='travel', kind='short', title='비옷', emoji='🌧️',
         scene='비가 쏟아지는 길, Pak Darto 의 오토바이 택시 뒷자리',
         speakers={'A': '{name}', 'B': 'Pak Darto'}, register='polite', twist=5, twist_type='emotion', flags=[],
         purpose=['travel'], domain=['travel'], expressions=['Hujan', 'Pakai ini', 'Hati-hati', 'Nggak usah'],
         turns=[
             ('B', 'Waduh, hujan besar!', '아이고, 비 엄청 오네!', 'waduh = 아이고'),
             ('A', 'Pak, saya nggak bawa payung.', '아저씨, 저 우산 안 가져왔어요.', 'payung = 우산'),
             ('B', 'Ini, pakai jas hujan Bapak.', '자, 아저씨 비옷 입어요.', 'jas hujan = 비옷'),
             ('A', 'Terus Bapak pakai apa?', '그럼 아저씨는 뭐 입어요?', ''),
             ('B', 'Bapak sudah biasa basah. Hehe.', '아저씨는 젖는 거 익숙해. 헤헤.', 'basah = 젖다'),
             ('A', 'Pak… makasih banyak.', '아저씨… 정말 고마워요.', ''),
             ('B', 'Nggak usah. Tapi bayar dua kali, ya!', '됐어. 근데 요금은 두 배야!', 'nggak usah = 괜찮아·안 해도 돼'),
         ]),
    dict(id='r1_study_a2', island='study', kind='short', title='도서관 재채기', emoji='📚',
         scene='조용한 도서관. Nadia 옆에서 참고 참던 재채기가 터졌다',
         speakers={'A': '{name}', 'B': 'Nadia'}, register='casual', twist=4, twist_type='emotion', flags=['romance'],
         purpose=['study_abroad', 'love'], domain=['study', 'love'], expressions=['Ssst', 'Maaf', 'lucu', 'Malu'],
         turns=[
             ('B', 'Ssst. Ini perpustakaan.', '쉿. 여기 도서관이야.', 'perpustakaan = 도서관'),
             ('A', 'Iya, maaf… Hah… HACIH!', '응, 미안… 하… 에취!', 'maaf = 미안'),
             ('B', 'Semua orang lihat kita!', '사람들이 다 우리 봐!', 'lihat = 보다'),
             ('A', 'Aduh, aku malu banget.', '아이고, 나 진짜 창피해.', 'malu = 창피하다'),
             ('B', 'Kamu lucu kalau malu.', '너 창피해할 때 귀엽다.', 'lucu = 귀엽다·웃기다'),
             ('A', 'Hah? Kamu bilang apa?', '어? 뭐라고 했어?', ''),
             ('B', 'Ssst. Ini perpustakaan.', '쉿. 여기 도서관이야.', '(콜백 — 첫 줄을 되돌려준다)'),
         ]),
]

for e in EPISODES:
    d = os.path.join(ROOT, 'assets/data/dialogues/R1', e['island'])
    os.makedirs(d, exist_ok=True)
    path = os.path.join(d, e['id'] + '.json')
    if os.path.exists(path):
        print('skip(있음)', e['id'])
        continue
    turns = []
    for i, (sp, tl, ko, note) in enumerate(e['turns'], 1):
        t = {'num': i, 'speaker': sp, 'id': tl, 'rd': rd(tl), 'ko': ko, 'note': note, 'tags': []}
        if e['kind'] == 'chat':
            t['ui'] = 'bubble'
        turns.append(t)
    out = {k: v for k, v in e.items() if k != 'turns'}
    out.update({'region': 'R1', 'draft': True, 'turns': turns})
    json.dump(out, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print('wrote', e['id'], len(turns), '턴', e['twist_type'])
