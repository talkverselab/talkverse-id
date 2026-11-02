# 어근(kata dasar) 가족 — 구조와 만드는 법 (2026-11-02)

인도네시아어는 어근 하나에 접사를 붙여 파생어를 만든다(baca 읽다 → membaca·dibaca·bacaan·pembaca). 이 앱은 **어근 → 파생어 가족**을 학습 단위로 쓴다. 태국어앱 「루트 단어」(`~/talkverse/th/docs/ROOT_WORDS.md`)와 같은 자리지만, 판정은 문자열 포함이 아니라 **접사 규칙**으로 한다.

## 1. 데이터

| 파일 | 내용 |
|---|---|
| `data/freq/id_words_2500.csv` | 빈도 단어 2,500 — `rank,word,reading,ko,en,pos,level,picturable`(level = 절벽 R1 ≤341 · R2 ≤505 · R3 ≤1087 · R4 ≤2500). 그림 저장소 `talkversehanja` 의 `talkverse_art/words/id.csv` 와 같은 파일 |
| `assets/data/roots/kata_dasar_core.json` | 어근 목록. 항목 = `root, rank, pos, phase, ko, family[{word, affix, ko}]`. **phase 1** = 손으로 검토한 핵심 80개(그대로 유지, 목록에서 새로 찾은 가족만 뒤에 덧붙임), **phase 2** = 도구로 뽑은 어근 중 어근이 R1·R2, **phase 3** = R3·R4 |
| `assets/data/freq/lang_id_top2500.csv` | 앱 빈도 단어 화면 — `rank,word,freq,cum_pct,region,root`(root = 그 단어의 어근. 빈도·누적%는 실측 전이라 0) |
| `data/roots/reject.txt` | 우연 일치로 빼는 `단어 어근` 쌍(kalian≠kali, tetapi≠tetap, 띄어 써야 하는 di atas 등) |
| `data/roots/candidates.tsv` | 도구가 뽑은 새 어근과 가족(사람 검토용) |

2026-11-02 결과: 어근 80 → 178(새 98), 기존 어근 가족에 48개 덧붙임, 빈도 단어 2,500 중 796개에 어근이 붙음.

## 2. 판정 규칙 — `tools/build_roots.py`(표준 라이브러리만)

1. 단어에서 접두사·접미사·접환사를 떼어 **어근 후보**를 만든다.
   - 접두사: meN-·peN-(첫 자음 변형을 되돌림: mem+p, men+t, meng+k, meny+s / 되돌리지 않을 때는 뒤 글자 조건 — men 뒤 d·c·j·z, mem 뒤 b·f·v, meng 뒤 모음·g·h·k, me 뒤 l·m·n·r·w·y), ber-/be-/bel-, di-, ter-, se-, per-
   - 접미사: -kan, -an, -i (‑nya·-lah·-kah 는 떼지 않는다 — 대명사·강조라 가족이 아님)
   - 접환사: ke-an, peN-an, per-an, ber-an. ke- 는 -an 과 함께일 때만, per- 는 -an·-kan·-i 와 함께일 때만.
2. **어근 후보가 목록에 단어로 있을 때만** 인정(앱 `lib/services/affix_util.dart` 와 같은 「사전 우선」).
3. 후보가 여럿이면 기존(phase 1) 어근 우선, 그다음 **긴 어근**(덜 뗀 쪽 — 과분해 방지).
4. 후보 어근이 접미사 붙은 형태(gunakan·miliki·katakan)면 한 단계 더 내려간다(menggunakan → guna, meN-kan).
5. 새 어근 = 기존에 없고 **자기 말고 가족이 2개 이상**.
6. `reject.txt` 의 쌍은 뺀다 — 새로 돌린 뒤 `candidates.tsv` 를 훑어 우연 일치를 여기에 더하고 다시 돌린다.

표기는 기존 손 검토 데이터와 같게: `meN-`, `meN-kan`, `meN-i`, `di-kan`, `-an`, `ke-an`, `peN-an`, `per-an`, `ber-an`, `se-`, `ter-`.

## 3. 앱에 넣기

- 데이터가 바뀌면 `lib/data/db/seed_loader.dart` 의 `_kRootsWordsKey`(지금 `db_roots_words_v3`)만 올린다. **`_kSeededKey` 를 올리면 회화 학습 기록까지 지워진다**(회화 턴을 지우고 다시 넣는 구조).
- 어근 화면(`lib/screens/roots_screen.dart`)은 phase 칩으로 1·2·3 을 나눠 보인다. 회화 리더의 「단어 분석」 시트(Grok 시안 01·02)는 이 데이터의 가족을 쓴다(적용은 사용자 확정 뒤).

## 4. 다른 언어로 옮길 때(예: 아랍어)

- 구조(빈도 목록 → 어근 후보 → 「목록에 있을 때만」 → 가족 2개 이상 → 사람 검토 reject → phase 나누기 → 씨앗 키 분리)는 그대로 쓴다.
- 판정만 그 언어 형태론으로 바꾼다. 아랍어는 **세 자음 어근(ك-ت-ب)과 틀(وزن: فاعل·مفعول·مَفعَل·تفعيل…)** — 접두·접미 떼기 대신 「단어 = 어근 자음 + 틀」을 맞춘다(모음 부호 없는 표기면 자음 뼈대 비교, 약자음 و·ي·ا 와 중복 자음 처리 필요). 정관사 ال·전치사 접두(بـ·لـ·وـ·فـ)·대명사 접미(ـه·ـها·ـك…)는 가족 계산 전에 뗀다.
- 태국어앱처럼 「포함 + 경계」가 맞는 언어(복합어형)와, 인도네시아어·아랍어처럼 「규칙 분해」가 맞는 언어(파생형)를 나눠 생각한다.
