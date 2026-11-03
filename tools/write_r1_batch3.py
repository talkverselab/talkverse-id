#!/usr/bin/env python3
"""R1 3차 6편 초안(2026-11-03 밤) — 새 절벽(어근+접사) R1 중 회화에 안 나온 토큰 채우기. 이미 있는 파일은 건드리지 않는다(재작성 반영본 보호).
카오스 4 · 심쿵 2(여성이 먼저 2편) — docs/DIALOGUE.md §6.
  python3 tools/write_r1_batch3.py
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

EPISODES = [
    dict(id='r1_love_a2', island='love', kind='short', title='커피 기다려', emoji='☕',
         scene='단골 카페. Ayu 가 먼저 「애인 있어?」 하고 묻더니 말이 꼬인다',
         speakers={'A': '{name}', 'B': 'Ayu'}, register='casual', twist=5, twist_type='slip', flags=['romance'],
         purpose=['love'], domain=['love'], expressions=['Kamu punya pacar?', 'Tanya saja', 'Jangan lihat aku', 'dari tadi'],
         turns=[
             ('B', 'Kamu punya pacar?', '너 애인 있어?', 'punya = 가지다'),
             ('A', 'Tidak punya. Kenapa?', '없어. 왜?', 'tidak = 아니다(동사·형용사 부정)'),
             ('B', 'Nggak apa-apa. Tanya saja.', '아니 그냥. 물어본 거야.', 'saja = 그냥·~만'),
             ('A', 'Kamu sendiri punya?', '너는 있어?', 'sendiri = 자신'),
             ('B', 'Belum. Aku tunggu kamu... eh, kopiku!', '아직. 너 기다려… 아, 내 커피!', '-ku = 나의'),
             ('A', 'Kopimu sudah datang dari tadi.', '네 커피 아까부터 와 있었는데.', '-mu = 너의 · tadi = 아까'),
             ('B', 'Ya sudah. Jangan lihat aku begitu!', '됐어. 그렇게 쳐다보지 마!', 'jangan = ~하지 마'),
             ('A', 'Aku lihat kopimu saja kok.', '나 네 커피만 보는 건데.', ''),
         ]),
    dict(id='r1_friends_a2', island='friends', kind='short', title='한 곡 더', emoji='🎤',
         scene='Raka 네 원룸에서 둘이 노래방 앱을 켰다. 벽이 얇다',
         speakers={'A': '{name}', 'B': 'Raka'}, register='casual', twist=5, twist_type='chaos', flags=[],
         purpose=['making_friends'], domain=['friends'], expressions=['Ayo', 'lebih bagus', 'harus diam', 'satu lagi'],
         turns=[
             ('B', 'Ayo nyanyi! Kamu dan aku, duet!', '자 노래하자! 너랑 나랑 듀엣!', 'ayo = 자·하자 · dan = 그리고'),
             ('A', 'Oke. Suaramu bagus?', '오케이. 너 목소리 좋아?', ''),
             ('B', 'Lebih bagus dari penyanyi!', '가수보다 낫지!', 'lebih = 더'),
             ('A', 'Aduh, telingaku! Berhenti dulu!', '아이고 내 귀! 일단 멈춰!', 'dulu = 먼저·일단'),
             ('B', 'Kenapa tetangga ketuk pintu?', '왜 이웃이 문을 두드려?', ''),
             ('A', 'Mereka bilang kami harus diam.', '우리 조용히 하래.', 'mereka = 그들 · kami = 우리(상대 제외) · harus = ~해야 한다'),
             ('B', 'Tidak bisa! Satu lagi untuk mereka!', '안 돼! 저 사람들 위해 한 곡 더!', 'bisa = 할 수 있다 · untuk = ~위해'),
         ]),
    dict(id='r1_life_a3', island='life', kind='short', title='공짜 아니었어', emoji='🍳',
         scene='Bu Sri 의 와룽. 아주머니가 오늘은 돈 내지 말라고 한다',
         speakers={'A': '{name}', 'B': 'Bu Sri'}, register='polite', twist=7, twist_type='chaos', flags=[],
         purpose=['survival'], domain=['life'], expressions=['yang pedas', 'Terima kasih', 'seperti anak saya', 'baik sekali'],
         turns=[
             ('B', 'Mau makan apa, Nak?', '뭐 먹을래요?', 'Nak = (아이·젊은이를 부를 때) 얘야'),
             ('A', 'Nasi goreng satu, Bu. Yang pedas.', '나시고렝 하나요, 아주머니. 매운 걸로요.', 'yang = ~한 것'),
             ('B', 'Ini dia. Makan yang banyak.', '자 여기요. 많이 먹어요.', ''),
             ('A', 'Terima kasih, Bu. Berapa?', '고맙습니다, 아주머니. 얼마예요?', 'terima kasih = 고맙습니다'),
             ('B', 'Tidak usah bayar. Kamu seperti anak saya.', '돈 안 내도 돼요. 내 자식 같아서.', 'seperti = ~같이 · anak = 아이·자식'),
             ('A', 'Wah, Ibu baik sekali!', '와, 아주머니 정말 좋으세요!', 'baik = 좋다·착하다 · sekali = 매우'),
             ('B', 'Tapi yang kemarin belum dibayar, ya.', '근데 어제 거는 아직 안 냈죠?', 'di- = ~되다(수동)'),
         ]),
    dict(id='r1_travel_a3', island='travel', kind='short', title='지름길', emoji='🛵',
         scene='늦어서 Pak Darto 의 오토바이 택시를 탔는데 지름길이 이상하다',
         speakers={'A': '{name}', 'B': 'Pak Darto'}, register='polite', twist=6, twist_type='chaos', flags=[],
         purpose=['travel'], domain=['travel'], expressions=['terlambat', 'Pegangan', 'mampir dulu', 'masih ada'],
         turns=[
             ('A', 'Pak, ke stasiun, ya. Saya terlambat!', '아저씨, 역으로요. 저 늦었어요!', 'ter- = 저절로·이미 그렇게 된'),
             ('B', 'Siap! Pegangan dengan kuat!', '알겠어요! 꽉 잡아요!', 'dengan = ~하게·~와'),
             ('A', 'Pak, kenapa kita masuk gang?', '아저씨, 왜 골목으로 들어가요?', 'kenapa = 왜'),
             ('B', 'Jalan pintas. Bapak tahu semua jalan.', '지름길이야. 아저씨는 길 다 알아.', ''),
             ('A', 'Pak... ini rumah Bapak?', '아저씨… 여기 아저씨 집이에요?', ''),
             ('B', 'Iya, mampir dulu. Istri saya masak!', '응, 잠깐 들러. 아내가 밥 했어!', 'mampir = 들르다'),
             ('A', 'Pak! Kereta saya bagaimana?', '아저씨! 제 기차는요?', 'bagaimana = 어떻게'),
             ('B', 'Kereta berikutnya masih ada. Makan dulu!', '다음 기차 아직 있어. 밥부터 먹어!', 'masih = 아직'),
         ]),
    dict(id='r1_study_a3', island='study', kind='short', title='매일 같이', emoji='📝',
         scene='시험 망친 날, 캠퍼스 벤치. Nadia 가 먼저 다가온다',
         speakers={'A': '{name}', 'B': 'Nadia'}, register='casual', twist=5, twist_type='emotion', flags=['romance'],
         purpose=['study_abroad', 'love'], domain=['study', 'love'], expressions=['Bagaimana', 'Kenapa tidak bilang', 'akan', 'Benar?'],
         turns=[
             ('B', 'Bagaimana ujianmu tadi?', '아까 시험 어땠어?', 'bagaimana = 어때·어떻게'),
             ('A', 'Jelek. Aku tidak belajar.', '망했어. 공부 안 했어.', ''),
             ('B', 'Kenapa tidak bilang aku?', '왜 나한테 말 안 했어?', 'bilang = 말하다'),
             ('A', 'Aku malu. Kamu selalu pintar.', '창피해서. 넌 늘 똑똑하잖아.', ''),
             ('B', 'Mulai besok aku akan mengajarimu.', '내일부터 내가 가르쳐 줄게.', 'meN-ajar-i = 가르치다 · akan = ~할 것이다'),
             ('A', 'Benar? Setiap hari?', '진짜? 매일?', 'benar = 정말·맞다'),
             ('B', 'Setiap hari. Tapi kamu traktir kopi.', '매일. 대신 커피는 네가 사.', 'traktir = 한턱내다'),
         ]),
    dict(id='r1_work_a2', island='work', kind='short', title='자기야', emoji='📞',
         scene='퇴근 무렵 사무실. Dimas 가 전화로 「자기야」라고 했는데 번호가…',
         speakers={'A': '{name}', 'B': 'Dimas'}, register='polite', twist=5, twist_type='chaos', flags=[],
         purpose=['work'], domain=['work'], expressions=['masih di kantor', 'punya pacar', 'salah sambung', 'bilang apa'],
         turns=[
             ('B', 'Halo, sayang? Iya, aku masih di kantor.', '여보세요, 자기야? 응, 아직 회사야.', 'sayang = 자기야·사랑하는 · masih = 아직'),
             ('A', 'Mas Dimas punya pacar?', '디마스 씨 애인 있어요?', 'Mas = (젊은 남자) ~씨'),
             ('B', 'Ssst! Iya... pacar saya.', '쉿! 응… 내 여자친구야.', ''),
             ('A', 'Lho, itu bukan nomor Bu Bos?', '어, 그거 사장님 번호 아니에요?', 'bukan = 아니다(명사 부정)'),
             ('B', 'Aduh! Saya salah sambung!', '아이고! 전화 잘못 걸었어요!', 'salah sambung = 잘못 건 전화'),
             ('A', 'Terus, Bu Bos bilang apa?', '그래서 사장님이 뭐래요?', ''),
             ('B', 'Dia bilang, besok ke ruangan dia.', '내일 자기 방으로 오래요.', 'dia = 그·그녀'),
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
