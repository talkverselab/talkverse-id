# 인도네시아어유니버스 (IndoUniverse)

> 한국 화자 대상 **인도네시아어 + 말레이어** 단일 앱. `zh`(중국어유니버스) 구조를 그대로 옮겨 Flutter 로 구축.
> 앱 이름: **인도네시아어유니버스**
> Package: `com.talkverse.indo_universe`
> Stack: **Flutter** (Material 3) + **Drift** (SQLite) + audioplayers + flutter_tts. Brand: `#CE1126` (Merah Putih × Batik).
> Git: **local only** (GitHub 사용 X).

---

## 한 페이지 요약

id/ms = 교착어(접사)·라틴 문자·무성조. 학습 3축 = **(1) 접사 체계 (meN-/ber-/di-/ter-/-kan/-i/-an/ke-an) / (2) 어근(kata dasar) 인지 / (3) 어순 (SVO + 수식어 후치 DM) + 소사·대명사**.

zh 와의 대응:

| zh (중국어) | id (인도네시아어·말레이어) |
|---|---|
| 한자 cliff (Hanzi 100/209/300) | **어근 cliff** (kata dasar N개 → 청취 커버리지) — `data/scripts/04_root_cliff.py` 예정 |
| 발음부(声旁) 200 → 1500자 | **접사 14개** → 파생어 수천 (`assets/data/grammar/affixes.json`) |
| 4성+경성 컬러 | **접사 컬러** (파랑 meN- / 초록 ber- / 보라 di- / 주황 -kan / 빨강 -i / 틸 -an / 진빨강 ke-an) |
| dialect north/south | **variant id/ms** (턴별 `ms` 필드 + `id_ms_diff.json`) |
| pinyin_util | `services/affix_util.dart` (규칙 기반 접사 분해 + 비음 동화 복원) |
| SelectableHanzi | `widgets/affix_text.dart` (접사 색상 + 단어 탭 → 어근 시트) |
| 中国风 데코 | 바틱 카웅/파랑 데코 (`widgets/indo_decor.dart`) |

---

## 진입

```powershell
cd C:\Users\Johnjeon\talkverse\id
claude
```

빌드:
```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift codegen (app_database.g.dart)
flutter analyze
flutter test
flutter run                                  # 개발 (실기기)
flutter build apk --release                  # release APK
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 폴더

| 위치 | 내용 |
|---|---|
| `lib/main.dart` | 앱 진입점 (DB 시딩 → 전역 repo → MainScreen) |
| `lib/core/` | `theme.dart` (팔레트·접사 컬러), `constants.dart` (LangVariant id/ms, Levels, AffixKind) |
| `lib/data/db/` | **Drift** schema (`Turns`/`Roots`/`Affixes`/`Words`/`Annotations`/`UserProgress`/`RootProgress`/`UserMemos`) + `seed_loader.dart` |
| `lib/data/models/` | `EpisodeMeta`, `Speaker` |
| `lib/data/repositories/` | `DialogueRepository`, `RootRepository`, `VariantRepository` |
| `lib/services/` | `affix_util` (접사 분해), `tts_service` (id-ID/ms-MY 남녀 보이스), `audio_service`, `memo_service` |
| `lib/widgets/` | `affix_text` (접사 색상 문장), `indo_decor` (BadgeStamp/BatikPattern/ParangDivider/IndoCard/VariantChip), `today_mission`, `memo_toggle` |
| `lib/screens/` | `main_screen` (홈/학습/진행/프로필 4탭), `conversation_screen` (에피소드 목록), `episode_screen` (턴 버블 + TTS + MS 토글 + 메모), `affix_screen` (접사 표 + 분해기), `roots_screen` (어근 카드), `word_freq_screen`, `variants_screen` (ID↔MS), `flashcard_screen`, `progress_screen`, `profile_screen` |
| `assets/data/dialogues/id/` | `L1.json` (ep1 10턴 샘플) + `_meta.json` — JSON SOT |
| `assets/data/dialogues/ms/` | `_meta.json` (정책: 별도 파일 없이 id 턴의 `ms` 필드로 차이만) |
| `assets/data/grammar/affixes.json` | 접사 14개 (변이형·예시) |
| `assets/data/roots/kata_dasar_core.json` | 어근 core 40 + 파생어 가족 (임시 rank) |
| `assets/data/freq/lang_id_top2500.csv` | 빈도 단어 (현재 50행 placeholder — 코퍼스 실측 후 교체) |
| `assets/data/variants/id_ms_diff.json` | ID↔MS 차이 25쌍 |
| `assets/data/audio_manifest.json` | roots/turns → mp3 매핑 (비어 있음, TTS 폴백) |
| `assets/audio/{roots,L1}/` | mp3 (.gitignore) |
| `assets/images/` | icon (미생성 — `flutter_launcher_icons` 실행 전 `icon_full.png`/`icon_foreground.png` 필요) |
| `data/scripts/` | 코퍼스 파이프라인 계획 (`README.md`) |
| `test/` | `AffixUtil` 단위 테스트 |

---

## 콘텐츠 schema (zh v4 동일)

```
L1: 5 ep × 40 turn = 200 turn         매칭 narrative  (Mark × Sari)   ← ep1 10턴 샘플
L2: 23 dial × 5 block ≈ 300 turn      카오스 채팅      (미작성)
L3: 23 dial × 5 block ≈ 304 turn      사랑 narrative   (미작성)
```

Turn JSON:
```json
{
  "num": 4, "speaker": "B",
  "id": "Oh, senang berkenalan! Nama saya Sari.",
  "ms": "(말레이어 대응문 — 차이 있을 때만)",
  "ko": "아, 만나서 반가워요! 제 이름은 사리예요.",
  "gloss": "senang=기쁜 ber-kenal-an=서로 알게 되다",
  "note": "ber-…-an 접환사: kenal → berkenalan",
  "tags": ["affix:ber-an", "greeting"]
}
```

DB 컬럼: `zh`→`body`, `pinyin/tones`→`gloss`, `dialect`→`variant`, `Hanzi`→`Roots`, `PhoneticRoots`→`Affixes`.

---

## 핵심 IP

- **접사 분해기** (`AffixUtil`): meN- 비음 동화 복원 (mem+p / men+t / meng+k / meny+s), ber- 변이 (be-/bel-), 접환사 (ke-an/peN-an/per-an/ber-an), 중첩어. 어근 사전 주입 시 사전 어근 우선 → 과분해 방지. 표시는 표면형, 조회는 복원형.
- **어근 → 파생어 가족**: kata dasar 1개 → meN-/ber-/peN-/-an/ke-an 파생 4~6개 (한자 발음부 압축률 대응).
- **ID↔MS 변이**: 같은 화면에서 토글, TTS 로케일 자동 전환, 위험 어휘(butuh/percuma/bisa) 경고.
- **빨간펜 시스템**: `Annotations` 테이블 스키마 준비 (자동 추출 rule: 접사·소사 ya/sih/dong·대명사·어순), UI 는 zh 의 AnnotatedText 포팅 예정.

---

## 미결 (`memo/id/decisions/` 에 결정 로그 예정)

1. 앱 이름/패키지 최종 (인도네시아어유니버스 vs 인니·말레이유니버스 / `com.talkverse.indo_universe`)
2. 어근 cliff 실측 — 코퍼스(OpenSubtitles id / Leipzig / TED id) + stemmer 선택 (Sastrawi vs 자체 AffixUtil)
3. MS 콘텐츠 깊이 — 턴별 `ms` 필드만 vs 별도 `ms/L1.json` (등장인물 Aisyah)
4. L1 캐릭터 이름 (Sari) 확정, L2/L3 시나리오
5. TTS 정책 (시스템 flutter_tts dev → 클라우드 TTS release), 사전 녹음 여부
6. 앱 아이콘 (`assets/images/icon_full.png` 미생성)

---

## 메모 (SOT)

`C:/Users/Johnjeon/OneDrive/memo/id/` (생성 예정) — zh 와 동일 구성: `HANDOFF.md`, `architecture.md`, `content-plan.md`, `build.md`, `decisions/`.
