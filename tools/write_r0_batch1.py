#!/usr/bin/env python3
"""R0(왕초보) 14편 초안(2026-11-18) — 턴 2~6단어, 6턴. 인사·숫자·이름·좋아/싫어·어디·얼마 같은 첫걸음 표현.
  python3 tools/write_r0_batch1.py"""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from write_batch_common import ep, write  # noqa: E402

E = [
 ep('r0_love_a1', 'love', '이름이 뭐예요?', '💌', '동네 카페. 옆자리 Raka 가 자꾸 쳐다보다 말을 건다', 'Raka', 'casual', 6, 'reveal', ['Siapa nama kamu?', 'Nama saya …', 'Senang kenalan'], [
  ('B', 'Halo, siapa nama kamu?', '안녕, 이름이 뭐야?', 'siapa = 누구 · nama = 이름', 'shy'),
  ('A', 'Nama saya {name}.', '내 이름은 {name}이야.', 'nama saya = 내 이름은', 'neutral'),
  ('B', 'Nama yang bagus sekali.', '이름 정말 예쁘다.', 'bagus = 좋은 · sekali = 아주', 'happy'),
  ('A', 'Terima kasih. Kamu siapa?', '고마워. 너는?', 'terima kasih = 고마워', 'shy'),
  ('B', 'Aku Raka. Aku tetanggamu.', '나 라카야. 너희 옆집 살아.', 'tetangga = 이웃 · -mu = 너의', 'teasing'),
  ('A', 'Oh! Yang suka bernyanyi malam-malam?', '아! 밤마다 노래 부르는 그 사람?', 'ber-nyanyi = 노래하다', 'surprised'),
 ]),
 ep('r0_love_a2', 'love', '커피 좋아해요?', '☕', '대학 앞 노점. Ayu 가 먼저 음료를 고르고 묻는다', 'Ayu', 'casual', 5, 'slip', ['Kamu suka …?', 'Aku suka …', 'Mau?'], [
  ('B', 'Kamu suka kopi?', '너 커피 좋아해?', 'suka = 좋아하다', 'neutral'),
  ('A', 'Suka sekali. Kamu?', '엄청 좋아해. 너는?', '', 'happy'),
  ('B', 'Aku suka teh manis.', '난 단 차가 좋아.', 'teh manis = 달게 탄 차', 'neutral'),
  ('A', 'Aku juga suka kamu.', '나도 너 좋아해.', 'juga = ~도 — 「teh」라고 하려다 말이 헛나왔다', 'embarrassed'),
  ('B', 'Apa? Suka aku?', '뭐? 나를 좋아한다고?', '', 'surprised'),
  ('A', 'Maksudku... teh! Teh manis!', '내 말은… 차! 단 차!', 'maksudku = 내 말은', 'embarrassed'),
 ]),
 ep('r0_love_a3', 'love', '내일 시간 있어?', '📅', '퇴근길 정류장. Dimas 가 휴대폰 달력을 보며 묻는다', 'Dimas', 'casual', 6, 'chaos', ['Besok ada waktu?', 'Jam berapa?', 'Boleh'], [
  ('B', 'Besok kamu ada waktu?', '내일 시간 있어?', 'besok = 내일 · ada waktu = 시간이 있다', 'shy'),
  ('A', 'Ada. Kenapa?', '있어. 왜?', 'kenapa = 왜', 'neutral'),
  ('B', 'Mau nonton film?', '영화 볼래?', 'mau = ~할래 · nonton = 보다', 'hopeful'),
  ('A', 'Boleh! Jam berapa?', '좋아! 몇 시?', 'jam berapa = 몇 시', 'happy'),
  ('B', 'Jam lima pagi.', '아침 다섯 시.', 'pagi = 아침', 'neutral'),
  ('A', 'Pagi?! Film apa itu?', '아침?! 그게 무슨 영화야?', '', 'surprised'),
 ]),
 ep('r0_life_a1', 'life', '얼마예요?', '🥭', '시장 과일 가게. Bu Sri 가 망고를 권한다', 'Bu Sri', 'polite', 5, 'chaos', ['Berapa harganya?', 'Mahal', 'Boleh kurang?'], [
  ('A', 'Bu, ini berapa?', '아주머니, 이거 얼마예요?', 'berapa = 얼마', 'neutral'),
  ('B', 'Sepuluh ribu, Nak.', '만 루피아야.', 'ribu = 천 · Nak = 얘야', 'happy'),
  ('A', 'Wah, mahal. Boleh kurang?', '와, 비싸요. 깎아 주실 수 있어요?', 'mahal = 비싸다 · kurang = 덜', 'worried'),
  ('B', 'Boleh. Delapan ribu.', '그래. 팔천.', 'delapan = 여덟', 'neutral'),
  ('A', 'Lima ribu, ya?', '오천 어때요?', '', 'hopeful'),
  ('B', 'Lima ribu... setengah mangga.', '오천이면… 망고 반 개.', 'setengah = 반', 'teasing'),
 ]),
 ep('r0_life_a2', 'life', '화장실 어디예요?', '🚻', '쇼핑몰. 급한데 직원 Dimas 가 너무 천천히 설명한다', 'Dimas', 'polite', 5, 'chaos', ['Di mana …?', 'Kiri / kanan', 'Terima kasih'], [
  ('A', 'Permisi, toilet di mana?', '실례합니다, 화장실 어디예요?', 'di mana = 어디에', 'worried'),
  ('B', 'Lurus, lalu belok kiri.', '쭉 가서 왼쪽으로 도세요.', 'lurus = 곧장 · kiri = 왼쪽', 'neutral'),
  ('A', 'Kiri? Terima kasih!', '왼쪽이요? 고맙습니다!', '', 'relieved'),
  ('B', 'Eh, maaf, kanan!', '어, 죄송해요, 오른쪽!', 'kanan = 오른쪽', 'embarrassed'),
  ('A', 'Kanan atau kiri?!', '오른쪽이에요 왼쪽이에요?!', 'atau = 아니면', 'annoyed'),
  ('B', 'Ikut saya saja!', '그냥 저 따라오세요!', 'ikut = 따라가다', 'excited'),
 ]),
 ep('r0_life_a3', 'life', '몇 살이에요?', '🎂', '이웃집 생일 잔치. Bu Sri 가 케이크 초를 꽂고 있다', 'Bu Sri', 'polite', 4, 'reveal', ['Umur berapa?', 'Selamat ulang tahun'], [
  ('A', 'Selamat ulang tahun, Bu!', '생신 축하드려요!', 'selamat ulang tahun = 생일 축하해', 'happy'),
  ('B', 'Terima kasih, Nak.', '고마워.', '', 'happy'),
  ('A', 'Umur Ibu berapa?', '몇 살 되셨어요?', 'umur = 나이 · Ibu = (상대 여성) 당신', 'curious'),
  ('B', 'Rahasia, dong.', '그건 비밀이지.', 'rahasia = 비밀 · dong = ~지', 'teasing'),
  ('A', 'Lilinnya banyak sekali.', '초가 엄청 많네요.', 'lilin = 초 · banyak = 많다', 'surprised'),
  ('B', 'Itu lilin cucu saya!', '그건 손주 초야!', 'cucu = 손주', 'laughing'),
 ]),
 ep('r0_friends_a1', 'friends', '어디 가?', '🛵', '골목. Nadia 가 오토바이에 앉아 손을 흔든다', 'Nadia', 'casual', 5, 'chaos', ['Mau ke mana?', 'Ikut, dong', 'Ayo'], [
  ('B', 'Hai! Mau ke mana?', '안녕! 어디 가?', 'ke mana = 어디로', 'happy'),
  ('A', 'Ke pasar. Kamu?', '시장. 너는?', 'pasar = 시장', 'neutral'),
  ('B', 'Aku juga! Ikut, yuk.', '나도! 같이 가자.', 'ikut = 같이 가다 · yuk = ~하자', 'excited'),
  ('A', 'Oke. Helmnya mana?', '좋아. 헬멧은?', 'mana = 어디', 'neutral'),
  ('B', 'Helm? Aku lupa.', '헬멧? 깜빡했다.', 'lupa = 잊다', 'embarrassed'),
  ('A', 'Kita jalan kaki saja.', '그냥 걸어가자.', 'jalan kaki = 걷다', 'annoyed'),
 ]),
 ep('r0_friends_a2', 'friends', '배고파', '🍜', '저녁 기숙사. Raka 가 라면을 들고 문을 두드린다', 'Raka', 'casual', 4, 'reveal', ['Aku lapar', 'Ada makanan?', 'Enak'], [
  ('B', 'Aku lapar sekali.', '나 엄청 배고파.', 'lapar = 배고프다', 'sad'),
  ('A', 'Aku juga. Ada makanan?', '나도. 먹을 거 있어?', 'makanan = 음식', 'neutral'),
  ('B', 'Ada mi, tapi satu.', '라면 있어, 근데 하나.', 'mi = 면 · tapi = 근데', 'worried'),
  ('A', 'Kita bagi dua.', '반씩 나누자.', 'bagi dua = 둘로 나누다', 'kind'),
  ('B', 'Kamu baik sekali.', '너 진짜 착하다.', 'baik = 착하다', 'happy'),
  ('A', 'Tapi itu mi aku!', '근데 그거 내 라면이잖아!', '', 'surprised'),
 ]),
 ep('r0_friends_a3', 'friends', '사진 찍어 줄래?', '📸', '공원. Nadia 가 휴대폰을 내밀며 포즈를 잡는다', 'Nadia', 'casual', 5, 'chaos', ['Tolong fotokan', 'Satu, dua, tiga', 'Lagi'], [
  ('B', 'Tolong fotokan aku, ya.', '나 사진 좀 찍어 줘.', 'tolong = ~해 줘 · foto-kan = 사진 찍어 주다', 'happy'),
  ('A', 'Oke. Satu, dua, tiga!', '좋아. 하나, 둘, 셋!', 'satu dua tiga = 하나 둘 셋', 'neutral'),
  ('B', 'Lagi, lagi! Senyum dulu.', '한 번 더! 나 먼저 웃고.', 'lagi = 또 · senyum = 웃다', 'excited'),
  ('A', 'Satu, dua... sudah?', '하나, 둘… 됐어?', 'sudah = 됐다', 'tired'),
  ('B', 'Lagi! Dua puluh kali.', '한 번 더! 스무 번.', 'dua puluh = 이십 · kali = 번', 'teasing'),
  ('A', 'Tanganku sudah capek!', '나 팔 아파!', 'tangan = 손 · capek = 지치다', 'annoyed'),
 ]),
 ep('r0_travel_a1', 'travel', '이 버스 어디 가요?', '🚌', '정류장. Pak Darto 가 오토바이를 세우고 말을 건다', 'Pak Darto', 'polite', 4, 'ignore', ['Bus ini ke mana?', 'Naik ojek?', 'Berapa?'], [
  ('A', 'Pak, bus ke Kota di sini?', '아저씨, 시내 가는 버스 여기 서요?', 'di sini = 여기', 'neutral'),
  ('B', 'Bus? Naik ojek saja.', '버스? 그냥 오젝 타요.', 'naik = 타다 · ojek = 오토바이 택시', 'happy'),
  ('A', 'Saya mau naik bus.', '저 버스 탈 거예요.', '', 'neutral'),
  ('B', 'Ojek lebih cepat, lho.', '오젝이 더 빨라요.', 'lebih cepat = 더 빠르다', 'teasing'),
  ('A', 'Berapa, Pak?', '얼마예요?', '', 'curious'),
  ('B', 'Untuk kamu, gratis!', '당신은 공짜!', 'gratis = 공짜', 'excited'),
 ]),
 ep('r0_travel_a2', 'travel', '체크인', '🏨', '작은 호텔 접수대. 직원 Ayu 가 이름을 찾는다', 'Ayu', 'polite', 5, 'chaos', ['Saya mau check-in', 'Atas nama …', 'Kamar nomor …'], [
  ('A', 'Selamat malam. Mau check-in.', '안녕하세요. 체크인하려고요.', 'selamat malam = 저녁 인사', 'tired'),
  ('B', 'Atas nama siapa?', '누구 이름으로 하셨어요?', 'atas nama = ~의 이름으로', 'neutral'),
  ('A', 'Atas nama {name}.', '{name} 이름으로요.', '', 'neutral'),
  ('B', 'Maaf, nama itu tidak ada.', '죄송한데, 그 이름이 없어요.', 'tidak ada = 없다', 'worried'),
  ('A', 'Ini hotel Melati, kan?', '여기 멜라티 호텔 맞죠?', 'kan = ~죠', 'worried'),
  ('B', 'Bukan. Melati di sebelah.', '아니요. 멜라티는 옆집이에요.', 'sebelah = 옆', 'embarrassed'),
 ]),
 ep('r0_culture_a1', 'culture', '맵지 않아요?', '🌶️', '와룽. Bu Sri 가 삼발을 듬뿍 얹어 준다', 'Bu Sri', 'polite', 5, 'chaos', ['Pedas?', 'Sedikit saja', 'Enak'], [
  ('B', 'Mau sambal, Nak?', '삼발 줄까?', 'sambal = 고추 양념', 'happy'),
  ('A', 'Sedikit saja, Bu.', '조금만요.', 'sedikit = 조금 · saja = 만', 'neutral'),
  ('B', 'Ini sedikit.', '이게 조금이야.', '', 'happy'),
  ('A', 'Itu satu piring!', '그거 한 접시잖아요!', 'piring = 접시', 'surprised'),
  ('B', 'Orang sini makan begini.', '여기 사람들은 이렇게 먹어.', 'begini = 이렇게', 'teasing'),
  ('A', 'Air! Minta air!', '물! 물 주세요!', 'minta = 달라고 하다', 'panicked'),
 ]),
 ep('r0_culture_a2', 'culture', '바틱 셔츠', '👕', '금요일 사무실 입구. Dimas 가 바틱 셔츠를 입고 있다', 'Dimas', 'casual', 4, 'reveal', ['Bagus', 'Beli di mana?', 'Hari Jumat'], [
  ('A', 'Bajumu bagus sekali.', '네 옷 정말 멋지다.', 'baju = 옷', 'happy'),
  ('B', 'Ini batik. Hari Jumat.', '이거 바틱이야. 금요일이거든.', 'Jumat = 금요일', 'proud'),
  ('A', 'Kenapa hari Jumat?', '왜 금요일이야?', '', 'curious'),
  ('B', 'Kantor kami pakai batik.', '우리 회사는 바틱 입어.', 'pakai = 입다·쓰다', 'neutral'),
  ('A', 'Aku tidak punya batik.', '나 바틱이 없는데.', 'punya = 가지다', 'worried'),
  ('B', 'Ini, untukmu. Hadiah.', '여기, 너 거야. 선물.', 'hadiah = 선물', 'shy'),
 ]),
 ep('r0_culture_a3', 'culture', '오른손으로', '🤝', '이웃집 방문. Pak Darto 가 차를 내준다', 'Pak Darto', 'polite', 4, 'slip', ['Silakan', 'Tangan kanan', 'Maaf'], [
  ('B', 'Silakan minum tehnya.', '차 드세요.', 'silakan = ~하세요', 'kind'),
  ('A', 'Terima kasih, Pak.', '감사합니다.', '', 'neutral'),
  ('B', 'Pakai tangan kanan, ya.', '오른손으로 받아요.', 'tangan kanan = 오른손 — 물건은 오른손으로', 'kind'),
  ('A', 'Oh, maaf! Begini?', '아, 죄송해요! 이렇게요?', '', 'embarrassed'),
  ('B', 'Itu tangan kiri lagi.', '그것도 또 왼손이에요.', '', 'laughing'),
  ('A', 'Aku kidal, Pak!', '저 왼손잡이예요!', 'kidal = 왼손잡이', 'embarrassed'),
 ]),
]

if __name__ == '__main__':
    write('R0', E)
