#!/usr/bin/env python3
"""R1 4차 6편 초안(2026-11-03 밤) — 재작성에서 구어형으로 바뀌어 빠지던 표준형 R1(tidak·sudah·saja·seperti·benar…) 채우기, keep = 재작성 때 남길 낱말. 이미 있는 파일은 건드리지 않는다(재작성 반영본 보호).
카오스 3 · 감정 2 · 말실수 1(여성이 먼저 2편) — docs/DIALOGUE.md §6.
  python3 tools/write_r1_batch4.py
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

EPISODES = [
    dict(id='r1_survival_s2', island='survival', kind='short', title='여권이 없어요', emoji='🛂',
         scene='기차역 안내 창구. 여권이 없어졌다고 뛰어왔는데…',
         speakers={'A': '{name}', 'B': 'Petugas'}, register='polite', twist=5, twist_type='chaos', flags=[],
         purpose=['survival', 'travel'], domain=['travel'], expressions=['Ada yang bisa saya bantu?', 'tidak ada', 'Sudah cari?', 'Terima kasih'],
         keep=['tidak', 'sudah', 'terima kasih', 'dan', 'yang', 'bisa'],
         turns=[
             ('B', 'Selamat siang. Ada yang bisa saya bantu?', '안녕하세요. 무엇을 도와드릴까요?', 'yang = ~하는 것 · bisa = 할 수 있다'),
             ('A', 'Paspor saya tidak ada!', '제 여권이 없어요!', 'tidak ada = 없다'),
             ('B', 'Tenang. Sudah cari di tas?', '진정하세요. 가방은 찾아보셨어요?', 'sudah = 이미 ~했다'),
             ('A', 'Sudah. Tas saya kosong.', '찾아봤어요. 가방이 텅 비었어요.', 'kosong = 비다'),
             ('B', 'Itu apa di tangan Anda?', '손에 드신 건 뭐예요?', 'Anda = 당신(정중)'),
             ('A', 'Oh... ini paspor saya. Terima kasih!', '아… 이거 제 여권이네요. 고맙습니다!', 'terima kasih = 고맙습니다'),
             ('B', 'Sama-sama. Silakan duduk dan minum dulu.', '천만에요. 앉아서 물부터 드세요.', 'dan = 그리고 · silakan = ~하세요'),
         ]),
    dict(id='r1_love_a3', island='love', kind='short', title='넌 내 거야', emoji='📺',
         scene='Ayu 네 거실에서 드라마를 보는데 Ayu 가 대사를 따라 해 보라고 한다',
         speakers={'A': '{name}', 'B': 'Ayu'}, register='casual', twist=5, twist_type='emotion', flags=['romance'],
         purpose=['love'], domain=['love'], expressions=['Kau milikku', 'seperti di drama', 'Coba', '-lah'],
         keep=['kau', 'seperti', 'saja', '-lah'],
         turns=[
             ('B', 'Lihat, dia bilang "Kau milikku!"', '봐, 저 사람이 「넌 내 거야!」래.', 'kau = 너(드라마·노랫말 말투) · -ku = 나의'),
             ('A', 'Seperti di drama saja.', '딱 드라마에서나 하는 말이네.', 'seperti = ~같이'),
             ('B', 'Coba kamu bilang begitu.', '너도 그렇게 말해 봐.', 'coba = 한번 ~해 봐'),
             ('A', 'Kau... milikku?', '넌… 내 거야?', ''),
             ('B', 'Aduh, kenapa jantungku begini?', '아이고, 내 심장 왜 이래?', 'jantung = 심장'),
             ('A', 'Kamu sakit? Mau ke dokter?', '아파? 병원 갈래?', ''),
             ('B', 'Bukan sakit, bodoh. Nontonlah lagi.', '아픈 거 아니야, 바보야. 드라마나 계속 봐.', '-lah = (권유·강조)'),
         ]),
    dict(id='r1_friends_a3', island='friends', kind='short', title='사테 열 개', emoji='🍢',
         scene='저녁 캠퍼스. Nadia 가 먼저 「너희 어디 가?」 하고 끼어든다',
         speakers={'A': '{name}', 'B': 'Nadia'}, register='casual', twist=5, twist_type='chaos', flags=[],
         purpose=['making_friends'], domain=['friends'], expressions=['Kalian mau ke mana?', 'Mau ikut?', 'Benar?', 'untuk'],
         keep=['kalian', 'gak', 'enggak', 'benar', 'untuk', 'saja'],
         turns=[
             ('B', 'Kalian mau ke mana malam ini?', '너희 오늘 밤 어디 가?', 'kalian = 너희'),
             ('A', 'Ke pasar malam. Mau ikut?', '야시장. 같이 갈래?', 'ikut = 따라가다'),
             ('B', 'Mau! Tapi aku gak punya uang.', '갈래! 근데 나 돈 없어.', 'gak = 안(구어)'),
             ('A', 'Enggak apa-apa. Aku traktir.', '괜찮아. 내가 쏠게.', 'enggak = 안(구어)'),
             ('B', 'Benar? Kalau begitu aku makan sepuluh sate!', '진짜? 그럼 나 사테 열 개!', 'benar = 정말'),
             ('A', 'Sepuluh? Untuk kamu sendiri?', '열 개? 너 혼자?', 'untuk = ~을 위해'),
             ('B', 'Untuk aku sendiri. Kamu makan nasi saja.', '나 혼자. 넌 밥만 먹어.', 'saja = ~만'),
         ]),
    dict(id='r1_work_a3', island='work', kind='short', title='인사 연습', emoji='🤝',
         scene='고객 미팅 전날, Dimas 와 인도네시아어 인사를 연습한다',
         speakers={'A': '{name}', 'B': 'Dimas'}, register='polite', twist=6, twist_type='slip', flags=[],
         purpose=['work'], domain=['work'], expressions=['akan bertemu dengan', 'sudah menyiapkan', 'Terima kasih', 'bagus sekali'],
         keep=['akan', 'dengan', 'sudah', 'terima kasih', 'sekali', 'tidak', 'meN-', 'ter-'],
         turns=[
             ('B', 'Besok kita akan bertemu dengan klien.', '내일 고객이랑 만날 거예요.', 'akan = ~할 것이다 · dengan = ~와'),
             ('A', 'Baik. Saya sudah menyiapkan semua.', '네. 다 준비해 놨어요.', 'meN-siap-kan = 준비하다'),
             ('B', 'Terima kasih. Bahasamu sudah bagus sekali.', '고마워요. 인도네시아어 정말 잘하네요.', 'sekali = 매우'),
             ('A', 'Terima kasih. Saya terlalu semangat!', '감사해요. 제가 너무 신나서요!', 'ter- + lalu = 너무'),
             ('B', 'Coba latihan salam sekarang.', '지금 인사 연습해 봐요.', 'salam = 인사'),
             ('A', 'Selamat tidur, Pak! Eh, selamat datang!', '안녕히 주무세요! 아니, 어서 오세요!', 'selamat datang = 어서 오세요'),
             ('B', 'Bagus. Klien pasti tidak akan tidur.', '좋아요. 고객은 절대 안 졸겠네요.', ''),
         ]),
    dict(id='r1_life_a4', island='life', kind='short', title='양파 열 개', emoji='🧅',
         scene='Bu Sri 의 와룽 부엌. 아주머니가 「쉬워요」 하며 칼을 건넨다',
         speakers={'A': '{name}', 'B': 'Bu Sri'}, register='polite', twist=7, twist_type='chaos', flags=[],
         purpose=['survival'], domain=['life'], expressions=['Ayo', 'tak bisa', 'Gampang, kan?', 'saja'],
         keep=['ayo', 'tak', 'kan', 'saja', 'sudah', 'meN-'],
         turns=[
             ('B', 'Ayo, bantu Ibu masak!', '자, 아줌마 요리 좀 도와줘요!', 'ayo = 자·하자'),
             ('A', 'Saya tak bisa masak, Bu.', '저 요리 못 해요, 아주머니.', 'tak = 안·못(tidak 줄임)'),
             ('B', 'Gampang, kan? Potong bawang saja.', '쉽잖아요? 양파만 썰어요.', 'kan = ~잖아'),
             ('A', 'Bu... mata saya menangis!', '아주머니… 눈이 울어요!', 'meN-tangis = 울다'),
             ('B', 'Itu bukan menangis. Itu bawang!', '우는 거 아니에요. 양파 때문이지!', ''),
             ('A', 'Bu, bawangnya sudah habis.', '아주머니, 양파 다 썰었어요.', 'habis = 다 떨어지다'),
             ('B', 'Bagus! Sekarang potong sepuluh lagi!', '좋아요! 이제 열 개 더!', ''),
         ]),
    dict(id='r1_travel_a4', island='travel', kind='short', title='마지막 탑승', emoji='🪖',
         scene='귀국 전날, 늘 타던 Pak Darto 의 오토바이를 마지막으로 탄다',
         speakers={'A': '{name}', 'B': 'Pak Darto'}, register='polite', twist=6, twist_type='emotion', flags=[],
         purpose=['travel'], domain=['travel'], expressions=['terakhir', 'Terima kasih untuk semuanya', 'seperti anak', 'jangan'],
         keep=['terima kasih', 'untuk', 'seperti', 'sudah', 'ter-', 'meN-'],
         turns=[
             ('A', 'Pak, ini perjalanan terakhir saya.', '아저씨, 이게 저 마지막으로 타는 거예요.', 'ter-akhir = 마지막'),
             ('B', 'Lho, mau pulang ke Korea?', '어, 한국 돌아가?', ''),
             ('A', 'Iya, besok. Terima kasih untuk semuanya.', '네, 내일요. 그동안 다 고마웠어요.', 'untuk = ~에 대해'),
             ('B', 'Kamu sudah seperti anak Bapak sendiri.', '넌 이미 내 자식 같아.', 'seperti = ~같이'),
             ('A', 'Pak... jangan bikin saya menangis.', '아저씨… 울리지 마세요.', 'meN-tangis = 울다'),
             ('B', 'Ini, helm untuk kenang-kenangan.', '자, 기념으로 헬멧.', 'kenang-kenangan = 기념품(중첩)'),
             ('A', 'Pak, ini helm Bapak satu-satunya!', '아저씨, 이거 하나뿐인 헬멧이잖아요!', 'satu-satunya = 유일한'),
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
