#!/usr/bin/env python3
"""R1 5차 6편 초안(2026-11-04 새벽) — 4차까지 1~2회만 나온 R1 토큰(dan·kalau·harus·dengan·maaf·siapa·bagaimana·mereka·kami·kalian·tak·ayo·baik·sekali·kan·-i·ter-) 채우기,
주제별 반전 유형 보강: 공부·일 = 카오스(0%·33% 였음), 친구·생활 = reveal·ignore(지금까지 카오스만). 여성이 먼저 2편(love_a4·friends_a4).
이미 있는 파일은 건드리지 않는다(재작성 반영본 보호).
  python3 tools/write_r1_batch5.py
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

EPISODES = [
    dict(id='r1_study_a4', island='study', kind='short', title='발표 5분', emoji='🎤',
         scene='강의실. 조별 발표 날, Nadia 가 「5분만 하면 돼」라고 했는데 교수가 자꾸 질문한다',
         speakers={'A': '{name}', 'B': 'Nadia'}, register='casual', twist=4, twist_type='chaos', flags=[],
         purpose=['study'], domain=['study'], expressions=['Bagaimana kalau…', 'harus', 'Siapa yang…?', 'maaf'],
         keep=['bagaimana', 'kalau', 'harus', 'siapa', 'maaf', 'dan', 'mereka', 'tidak'],
         turns=[
             ('B', 'Tenang, presentasi kita cuma lima menit.', '걱정 마, 우리 발표 5분이면 끝이야.', 'cuma = 겨우·만'),
             ('A', 'Bagaimana kalau Pak dosen bertanya?', '교수님이 질문하시면 어떡해?', 'bagaimana kalau = ~하면 어떡하지 · ber-tanya = 묻다'),
             ('B', 'Tidak akan. Dia selalu tidur.', '안 하셔. 늘 주무시잖아.', 'akan = ~할 것이다'),
             ('A', 'Maaf, Pak... sudah bangun?', '죄송한데요, 교수님… 깨셨어요?', 'maaf = 죄송·실례'),
             ('B', 'Siapa yang bikin dia bangun?!', '누가 깨운 거야?!', 'siapa = 누구 · yang = ~하는 (사람)'),
             ('A', 'Dia bertanya lagi dan lagi!', '또 묻고 또 물으셔!', 'dan = 그리고'),
             ('B', 'Sekarang mereka semua harus menjawab.', '이제 다른 조들도 전부 대답해야 해.', 'mereka = 그들 · harus = ~해야 한다 · meN-jawab = 대답하다'),
             ('A', 'Lima menit... jadi dua jam.', '5분이… 두 시간 됐네.', 'jadi = ~이 되다'),
         ]),
    dict(id='r1_work_a4', island='work', kind='short', title='사진 한 장', emoji='📸',
         scene='사무실 복사기 앞. Dimas 가 사장님께 보낼 보고서에 사진 한 장만 붙이라고 했는데…',
         speakers={'A': '{name}', 'B': 'Dimas'}, register='polite', twist=5, twist_type='chaos', flags=[],
         purpose=['work'], domain=['work'], expressions=['Tolong …', 'dengan', 'kami', 'Baik, Pak'],
         keep=['dengan', 'kami', 'baik', 'tidak', 'sudah', 'lihat', 'meN-', 'ter-'],
         turns=[
             ('B', 'Tolong kirim laporan ini dengan satu foto.', '이 보고서에 사진 한 장 붙여서 보내 주세요.', 'dengan = ~와 함께'),
             ('A', 'Baik, Pak. Foto yang mana?', '네, 알겠습니다. 어떤 사진이요?', 'baik = 알겠다·좋다'),
             ('B', 'Foto kantor kami. Jangan foto lain.', '우리 사무실 사진요. 다른 사진은 안 돼요.', 'kami = 우리(듣는 사람 제외)'),
             ('A', 'Sudah terkirim, Pak.', '보냈습니다.', 'ter-kirim = 보내진'),
             ('B', 'Kenapa Bapak Bos tertawa?', '사장님이 왜 웃으시지?', 'ter-tawa = 웃다'),
             ('A', 'Saya tidak tahu. Coba lihat.', '모르겠어요. 한번 보세요.', 'lihat = 보다'),
             ('B', 'Ini foto kamu tidur di meja!', '이거 당신이 책상에서 자는 사진이잖아!', ''),
             ('A', 'Itu... foto kantor juga, kan?', '그것도… 사무실 사진이긴 하잖아요?', 'kan = ~잖아'),
         ]),
    dict(id='r1_love_a4', island='love', kind='short', title='누구랑 왔어?', emoji='🎬',
         scene='영화관 매표소 앞. Ayu 가 먼저 「누구랑 왔어?」 하고 묻는데, 대답할 때마다 사람이 늘어난다',
         speakers={'A': '{name}', 'B': 'Ayu'}, register='casual', twist=5, twist_type='ignore', flags=['romance'],
         purpose=['love'], domain=['love'], expressions=['Dengan siapa?', 'Ayo', 'kalian', 'sekali'],
         keep=['siapa', 'dengan', 'ayo', 'kalian', 'sekali', 'dan', 'tak', 'saja'],
         turns=[
             ('B', 'Kamu nonton dengan siapa?', '너 누구랑 보러 왔어?', 'dengan siapa = 누구와'),
             ('A', 'Sendiri saja. Kamu?', '그냥 혼자. 너는?', 'sendiri = 혼자'),
             ('B', 'Aku juga. Ayo nonton bersama.', '나도. 같이 보자.', 'ayo = ~하자 · bersama = 함께'),
             ('A', 'Hai, kalian! Raka, Nadia, Dimas...?', '어, 너희! Raka, Nadia, Dimas…?', 'kalian = 너희'),
             ('B', 'Kenapa mereka semua di sini?', '왜 얘네가 다 여기 있어?', 'mereka = 그들'),
             ('A', 'Kebetulan sekali, ya.', '우연치고 엄청나네.', 'sekali = 아주·몹시'),
             ('B', 'Aku tak mau nonton dengan lima orang.', '난 다섯 명이랑 보기 싫어.', 'tak = 안(tidak 줄임)'),
             ('A', 'Jadi... kita berdua saja?', '그럼… 우리 둘만?', 'ber-dua = 둘이서'),
         ]),
    dict(id='r1_friends_a4', island='friends', kind='short', title='비밀', emoji='🤫',
         scene='카페 구석 자리. Nadia 가 「비밀 하나 말해 줄게」 하고 끌어당긴다',
         speakers={'A': '{name}', 'B': 'Nadia'}, register='casual', twist=5, twist_type='reveal', flags=[],
         purpose=['making_friends'], domain=['friends'], expressions=['Jangan bilang siapa-siapa', 'Kalau…', 'Benar?', 'baik-baik saja'],
         keep=['kalau', 'siapa', 'benar', 'baik', 'tak', 'dan', 'mereka', 'kami'],
         turns=[
             ('B', 'Sini. Aku mau bilang satu rahasia.', '이리 와. 비밀 하나 말해 줄게.', 'rahasia = 비밀'),
             ('A', 'Rahasia? Kalau aku tak boleh tahu?', '비밀? 내가 알면 안 되는 거면?', 'kalau = 만약'),
             ('B', 'Jangan bilang siapa-siapa, ya.', '아무한테도 말하지 마.', 'siapa-siapa = 아무도(중첩)'),
             ('A', 'Baik. Aku tutup mulut.', '알았어. 입 꼭 다물게.', 'baik = 알겠다 · tutup mulut = 입을 다물다'),
             ('B', 'Raka dan Dimas tahu rahasia ini.', 'Raka 랑 Dimas 는 이 비밀 알아.', 'dan = 그리고'),
             ('A', 'Mereka tahu? Benar?', '걔들이 알아? 진짜?', 'mereka = 그들'),
             ('B', 'Kami semua tahu. Cuma kamu belum.', '우리 다 알아. 너만 아직 몰라.', 'kami = 우리(듣는 사람 제외)'),
             ('A', 'Jadi rahasia ini... tentang aku?!', '그럼 이 비밀이… 나 얘기야?!', 'tentang = ~에 대한'),
         ]),
    dict(id='r1_life_a5', island='life', kind='short', title='아저씨 아니에요', emoji='🧓',
         scene='동네 시장. 처음 보는 가게 주인에게 호칭을 잘못 불렀는데 주인이 못 들은 척한다',
         speakers={'A': '{name}', 'B': 'Bu Sri'}, register='polite', twist=4, twist_type='ignore', flags=[],
         purpose=['daily'], domain=['life'], expressions=['Maaf, Bu', 'Berapa …?', 'bagaimana', 'harus'],
         keep=['maaf', 'bagaimana', 'harus', 'tidak', 'dengan', 'baik', 'di-', '-i'],
         turns=[
             ('A', 'Pak, ini berapa?', '아저씨, 이거 얼마예요?', 'berapa = 얼마'),
             ('B', 'Hmm? Saya tidak dengar.', '응? 안 들려요.', 'dengar = 듣다'),
             ('A', 'Maaf, Bu! Ini berapa, Bu?', '죄송해요, 아주머니! 이거 얼마예요?', 'maaf = 죄송·실례 · Bu = 아주머니'),
             ('B', 'Nah, sekarang saya dengar. Lima ribu.', '자, 이제 들리네. 오천.', 'nah = 자·거봐'),
             ('A', 'Bagaimana saya harus bayar, Bu?', '어떻게 내면 돼요?', 'bagaimana = 어떻게 · harus = ~해야 한다'),
             ('B', 'Bayar dengan senyum dulu.', '먼저 웃는 얼굴로 내요.', 'dengan = ~로'),
             ('A', 'Baik, Bu... begini?', '네… 이렇게요?', 'begini = 이렇게'),
             ('B', 'Ditambahi lima ribu lagi, baru bagus.', '오천 더 얹어야 딱 좋겠네.', 'di-tambah-i = 더해지다(접사)'),
         ]),
    dict(id='r1_survival_s3', island='survival', kind='short', title='잘못 탔어요', emoji='🚌',
         scene='앙콧(미니버스) 안. 반대 방향으로 가는 걸 알았는데 기사가 안 세워 준다',
         speakers={'A': '{name}', 'B': 'Sopir'}, register='polite', twist=4, twist_type='chaos', flags=[],
         purpose=['survival', 'travel'], domain=['travel'], expressions=['Kiri, Pak!', 'Ke mana?', 'harus turun', 'Ayo'],
         keep=['ke', 'mana', 'harus', 'tidak', 'ayo', 'kalian', 'sekali', 'dan'],
         turns=[
             ('A', 'Pak, mobil ini ke mana?', '아저씨, 이 차 어디로 가요?', 'ke mana = 어디로'),
             ('B', 'Ke terminal. Duduk saja.', '터미널요. 앉아 있어요.', ''),
             ('A', 'Saya harus ke kampus, bukan terminal!', '저 캠퍼스 가야 해요, 터미널 아니고요!', 'harus = ~해야 한다 · bukan = ~이 아니다'),
             ('B', 'Tidak bisa berhenti di sini.', '여기서는 못 세워요.', 'ber-henti = 멈추다'),
             ('A', 'Kiri, Pak! Kiri!', '세워 주세요! 세워요!', 'kiri = 왼쪽(「세워 달라」는 신호)'),
             ('B', 'Semua, kalian mau turun? Ayo turun sekali!', '다들 내릴 거예요? 한꺼번에 내려요!', 'kalian = 너희 · sekali = 한 번에'),
             ('A', 'Kenapa semua orang ikut turun?', '왜 다 같이 내려요?', 'ikut = 따라 하다'),
             ('B', 'Mereka juga salah mobil, dan saya juga.', '저 사람들도 잘못 탔고, 저도요.', 'dan = 그리고'),
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
