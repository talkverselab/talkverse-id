=== r0_travel_a2
level: R0
title: 옆집 호텔
emoji: 🏨
scene: 작은 호텔 접수대. 직원 Ayu가 이름을 찾는다
cast: A: {name}(학습자), B: Ayu
register: polite
twist: 5 chaos
expressions: Saya mau check-in; Atas nama …; Kamar nomor …
A | Saya mau check-in | 체크인하고 싶어요 | check-in = 체크인 | emotion=tired | tags=
B | Atas nama siapa? | 예약 이름이 뭐예요? | atas nama = 이름으로 | emotion=neutral | tags=expr:Atas nama …
A | Atas nama {name} | {name} 이름이에요 | emotion=neutral | tags=expr:Atas nama …
B | Tidak ada. Kamar nomor? | 없어요. 방 번호는? | kamar = 방 | emotion=worried | tags=
A | Ini hotel Mawar? | 여기 마와르 호텔 맞아요? | hotel = 호텔 | emotion=worried | tags=twist
B | Hotel Mawar di sebelah | 마와르 호텔은 옆집이에요 | sebelah = 옆 | emotion=embarrassed | tags=
kick: 이름 없다더니 그 호텔이 바로 옆집
