#!/usr/bin/env python3
"""R1 샘플 회화 6편을 JSON 으로 쓴다(2026-11-03, 사용자 지시 "다이얼로그 작성 → Grok 재작성 → 그림").
초안은 이 세션이 자체 작문(출처 없음). rd(한글 독음)는 tools/rd_id.py 로 채운다. Grok 재작성 뒤에는 이 파일이 아니라 JSON 을 고친다.
  python3 tools/write_samples_r1.py
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# (화자, 인도네시아어, 한국어, note)
EPISODES = [
    dict(id='r1_survival_s1', island='survival', kind='survival', title='조금만 맵게', emoji='🌶️',
         scene='와룽에서 나시고렝을 시키며 「조금만 맵게」라고 했는데, Bu Sri 의 「조금」은 차원이 달랐다',
         speakers={'A': '{name}', 'B': 'Bu Sri'}, register='polite', twist=5, twist_type='chaos', flags=[],
         purpose=['travel', 'survival'], domain=['life', 'travel'],
         expressions=['Mau pesan apa?', 'pedas sedikit', 'ya', 'Lho'],
         turns=[
             ('B', 'Mau pesan apa, Kak?', '뭐 주문할래요?', 'Kak = 손님을 부르는 말(언니·오빠 둘 다)'),
             ('A', 'Nasi goreng satu, Bu.', '나시고렝 하나요, 아주머니.', 'Bu = 아주머니·여사님(Ibu 줄임)'),
             ('B', 'Pedas atau nggak?', '맵게? 아니면 안 맵게?', 'nggak = 아니(tidak 의 구어)'),
             ('A', 'Pedas sedikit aja, ya.', '조금만 맵게요.', 'sedikit aja = 조금만'),
             ('B', 'Siap! Sedikit… sedikit… sedikit…', '네! 조금… 조금… 조금…', '(삼발을 계속 붓는다) siap = 알겠어요'),
             ('A', 'Bu! Itu bukan sedikit!', '아주머니! 그건 조금이 아니에요!', 'bukan = (명사 부정) ~이 아니다'),
             ('B', 'Lho, ini sedikit buat orang sini.', '어머, 여기 사람한텐 이게 조금인데.', 'Lho = 어머·어라(의외)'),
             ('A', 'Minta es teh manis… tiga.', '달달한 아이스티… 세 잔 주세요.', 'minta = 주세요(달라고 할 때)'),
         ]),
    dict(id='r1_love_a1', island='love', kind='short', title='토요일마다 온 이유', emoji='☕',
         scene='단골 카페, Ayu 가 먼저 옆자리에 앉으며 말을 건다',
         speakers={'A': '{name}', 'B': 'Ayu'}, register='polite', twist=5, twist_type='emotion', flags=['romance'],
         purpose=['love', 'making_friends'], domain=['love'],
         expressions=['kosong?', 'Silakan', 'Makasih', 'kok'],
         turns=[
             ('B', 'Kursi ini kosong?', '이 자리 비었어요?', 'kosong = 비어 있다'),
             ('A', 'Iya, kosong. Silakan.', '네, 비었어요. 앉으세요.', 'silakan = 어서 ~하세요(권유)'),
             ('B', 'Makasih. Kamu sering ke sini?', '고마워요. 여기 자주 와요?', 'makasih = 고마워(terima kasih 줄임)'),
             ('A', 'Lumayan. Kopinya enak.', '꽤요. 커피가 맛있어서.', 'lumayan = 꽤·그럭저럭'),
             ('B', 'Aku datang tiap Sabtu… bukan karena kopi.', '나 토요일마다 왔어요… 커피 때문은 아니고.', 'bukan karena = ~ 때문이 아니라'),
             ('A', 'Terus… karena apa?', '그럼… 뭐 때문에요?', 'terus = 그러면·그래서'),
             ('B', 'Hehe. Kopinya juga enak kok.', '헤헤. 커피도 맛있긴 해요.', 'kok = (말끝) ~인걸·~거든'),
         ]),
    dict(id='r1_travel_a1', island='travel', kind='short', title='지름길', emoji='🛵',
         scene='오토바이 택시를 탔는데 Pak Darto 가 「지름길」을 안다고 한다',
         speakers={'A': '{name}', 'B': 'Pak Darto'}, register='polite', twist=4, twist_type='chaos', flags=[],
         purpose=['travel'], domain=['travel'],
         expressions=['Siap', 'Berapa menit?', 'Sebentar', 'Tenang'],
         turns=[
             ('A', 'Pak, ke stasiun, ya.', '아저씨, 역이요.', 'Pak = 아저씨·선생님(Bapak 줄임)'),
             ('B', 'Siap! Bapak tahu jalan pintas.', '알겠어요! 아저씨가 지름길 알아요.', 'jalan pintas = 지름길'),
             ('A', 'Wah, bagus. Berapa menit?', '와, 좋네요. 몇 분 걸려요?', 'berapa = 얼마·몇'),
             ('B', 'Sepuluh menit. Eh, itu rumah ibu saya!', '10분. 어, 저기 우리 어머니 집이네!', 'eh = 어(갑자기 생각났을 때)'),
             ('A', 'Pak… ini jalan pintas?', '아저씨… 이게 지름길이에요?', ''),
             ('B', 'Sebentar! Ibu mau kasih kamu pisang.', '잠깐만! 어머니가 바나나 주신대.', 'sebentar = 잠깐만'),
             ('A', 'Saya cuma mau ke stasiun…', '저는 그냥 역에 가고 싶은데요…', 'cuma = 그냥·~만'),
             ('B', 'Tenang! Sekarang kamu keluarga.', '걱정 마! 이제 너도 가족이야.', 'tenang = 진정해·걱정 마'),
         ]),
    dict(id='r1_friends_c1', island='friends', kind='chat', title='음성 메시지', emoji='🎤',
         scene='Raka 와의 채팅. 음성 메시지를 보냈는데 엉뚱한 방으로 갔다',
         speakers={'A': '{name}', 'B': 'Raka'}, register='chat', twist=4, twist_type='chaos', flags=[],
         purpose=['making_friends'], domain=['friends'],
         expressions=['jadi?', 'bro', 'HAH?!', 'udah'],
         turns=[
             ('B', 'Bro, nanti malam jadi?', '야, 오늘 밤 약속 그대로지?', 'jadi = (약속이) 그대로 하다'),
             ('A', 'Jadi! Aku kirim pesan suara, ya.', '그대로지! 음성 메시지 보낼게.', 'pesan suara = 음성 메시지'),
             ('A', '🎤 (pesan suara 0:42)', '🎤 (음성 메시지 0:42)', ''),
             ('B', 'Itu masuk grup kantor, bro 😂', '그거 회사 단톡방에 갔어 😂', 'grup = 단톡방'),
             ('A', 'HAH?! Isinya aku nyanyi!', '뭐?! 그거 내가 노래한 건데!', 'isinya = 그 내용'),
             ('B', 'Bos kamu udah balas: "Suaranya bagus."', '너네 사장님이 벌써 답장했어: "목소리 좋네."', 'udah = 벌써(sudah 구어)'),
             ('A', 'Aku mau pindah negara.', '나 다른 나라로 이사 갈래.', 'pindah = 옮기다·이사하다'),
         ]),
    dict(id='r1_life_a1', island='life', kind='short', title='네, 네, 네', emoji='🛒',
         scene='편의점 계산대. 물 한 병 사러 왔는데 점원이 묻는 말에 다 「네」라고 했다',
         speakers={'A': '{name}', 'B': 'Kasir'}, register='polite', twist=6, twist_type='chaos', flags=[],
         purpose=['travel', 'survival'], domain=['life'],
         expressions=['Mau pakai kantong?', 'Iya', 'Totalnya', 'cuma'],
         turns=[
             ('B', 'Mau pakai kantong?', '봉투 필요하세요?', 'pakai = 쓰다·사용하다'),
             ('A', 'Iya.', '네.', 'iya = 네(ya 보다 부드러움)'),
             ('B', 'Struknya mau?', '영수증 드릴까요?', 'struk = 영수증'),
             ('A', 'Iya.', '네.', ''),
             ('B', 'Ada promo, beli satu gratis satu. Mau?', '1+1 행사 있어요. 하실래요?', 'gratis = 무료'),
             ('A', 'Iya… eh?', '네… 어?', ''),
             ('B', 'Totalnya dua ratus ribu, Kak.', '총 20만 루피아입니다.', 'dua ratus ribu = 이십만'),
             ('A', 'Saya cuma beli air mineral!', '저 생수만 샀는데요!', 'air mineral = 생수'),
         ]),
    dict(id='r1_study_a1', island='study', kind='short', title='머리 말고 코코넛', emoji='🥥',
         scene='캠퍼스 매점에서 Nadia 가 음료를 사 준다고 한다',
         speakers={'A': '{name}', 'B': 'Nadia'}, register='casual', twist=4, twist_type='slip', flags=[],
         purpose=['study_abroad', 'making_friends'], domain=['study', 'friends'],
         expressions=['Makasih', 'Aku traktir', 'Maksudnya', 'tanpa'],
         turns=[
             ('B', 'Kamu dari {country}? Bahasa Indonesia kamu bagus!', '{country}에서 왔어? 인도네시아어 잘한다!', 'bagus = 좋다·잘한다'),
             ('A', 'Makasih! Aku belajar tiap hari.', '고마워! 매일 공부해.', 'tiap hari = 매일'),
             ('B', 'Mau minum apa? Aku traktir.', '뭐 마실래? 내가 살게.', 'traktir = (밥·음료를) 사 주다'),
             ('A', 'Aku mau es kepala muda!', '나 어린 머리 아이스!', 'kepala = 머리 ↔ kelapa = 코코넛'),
             ('B', 'Kepala?! Maksudnya kelapa, ya?', '머리?! 코코넛 말하는 거지?', 'maksudnya = ~라는 뜻이지'),
             ('A', 'Iya, kelapa! Bukan kepala!', '응, 코코넛! 머리 말고!', ''),
             ('B', 'Oke. Satu es kelapa muda… tanpa kepala.', '오케이. 어린 코코넛 아이스 하나… 머리는 빼고.', 'tanpa = ~ 없이'),
         ]),
]


def main():
    for e in EPISODES:
        turns = []
        for i, (sp, tl, ko, note) in enumerate(e['turns'], 1):
            t = {'num': i, 'speaker': sp, 'id': tl, 'rd': rd(tl), 'ko': ko, 'note': note, 'tags': []}
            if e['kind'] == 'chat':
                t['ui'] = 'bubble'
            turns.append(t)
        out = {k: v for k, v in e.items() if k != 'turns'}
        out.update({'region': 'R1', 'draft': True, 'turns': turns})
        d = os.path.join(ROOT, 'assets/data/dialogues/R1', e['island'])
        os.makedirs(d, exist_ok=True)
        path = os.path.join(d, e['id'] + '.json')
        json.dump(out, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print('wrote', os.path.relpath(path, ROOT), len(turns), '턴', e['twist_type'])


if __name__ == '__main__':
    main()
