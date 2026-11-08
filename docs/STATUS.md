# 인도네시아어앱 현황 (2026-11-05 정리)

## 배포

| 빌드 | 커밋 | 내용 | Zealot |
|---|---|---|---|
| CI 16 | 1d1a018 | 일본어앱 11-04 공통 변경 옮김 | /0wFAp/253 |
| CI 17 | 958f164 | 회화 낱말 193어, DB 번호 5 | /0wFAp/262 |
| CI 18 | 5f4ee2a | 여자 학습자 컷 88장 | /0wFAp/268 |
| CI 19 | 13cb603 | 친구 편 3편 남자 학습자 컷 새로 | /0wFAp/275 |
| CI 20 | a730d20 | 장면 컷 220장을 그림 저장소에서 받기 | /0wFAp/278 |
| CI 21 | f1b8f4f | 단어·메뉴 개편, 낱말 탭 단어창, 독음 토글 | /0wFAp/300 |

TestFlight 최신 = 2611071643(CI 21 과 같은 코드).

PC D: 는 2026-11-07 돌아왔고 CI 21 APK 를 백업했다.

## 콘텐츠

- 회화: R1 30편(목표 R1 = 서바이벌 3 + 주제 5×16). R0 분리, R2~R4 는 아직 없음. 전부 `draft`(원어민 검수 전).
- 장면 컷: 기본 120장 + 여자판 100장(22편 88장 + 친구 3편 12장). 연애 5편은 상대가 1번 여자 주인공이라 여자판 없음(기본 컷).
- 학습자 그림: 기본 = 2번 남자 주인공, 상대가 2번인 친구 3편만 6번. 여자판 = 1번 여자 주인공.
- 조연 시트 2장(`data/review/uxui/cast_campus_v1.jpg`·`cast_street_v1.jpg`). 다음 컷 요청부터 첨부되고, 이미 그린 기본 컷에는 반영 안 됨.
- 조연 시트로 다시 그릴 기본 컷 6편 24장(life_a1·study_a4·survival_s2·s3·work_a2·a4): 2026-11-07 Grok 주간 한도로 못 그림, 11-10 초기화 뒤 `grok_scenes_id.py send`.
- 사전: 회화 낱말 193어 추가, 레마 칩 내용어 683개 중 사전에 없는 것 2개(`data/review/write/missing_lemmas.csv`, 분석기가 pengen·deg-degan 을 잘못 쪼갠 것).
- 절벽: 최종 R1~R4 = 104/139/249/523(`data/corpus/cliff_v2/`). 앱은 2026-11-07 부터 `assets/data/freq/lang_id_cliff2000.csv`(절벽 v2 1~2,000위, 어근+접사 토큰, `tools/freq/build_freq_id.py`). 뜻은 2,000개 중 952개(R1~R4 는 전부, R5 는 뜻 없는 말이 1,048개 — 인명·외래어 포함, 앱은 단어만 보임).

## 그림 저장소

- 장면 컷: `~/.venvs/img/bin/python tools/scene_upload.py [편id ...]` → R2 `scene/id/<편id>/cut<n>.webp` + D1 `art_scenes`(lang id). 여자판 편id = `<편>_f`. 같은 원본은 건너뛴다.
- 새 컷 순서: `grok_scenes_id.py send` → 검수 → `attach_scenes.py` → `scene_upload.py`.
- 앱은 저장소 컷을 먼저 쓰고(`sceneVariant`), 없으면 앱에 넣어 둔 `assets/images/scenes/`(19MB, 오프라인 첫 실행용)를 쓴다.
- 단어 그림: 1,324장, uk 세션 담당.

## 추가 목록

- `data/review/write/art_missing_lemmas.csv` — 회화 레마 257개 중 단어 그림 없는 107개(빈도순). 기능어(tidak·sudah·bisa 등)가 많아 그림 대상을 골라야 한다. 구체어 예: kelapa·bawang·es·menit·klien.
- `data/review/write/missing_lemmas.csv` — 위 2개.
- 절벽 어근 중 단어 그림 없는 수: R1 88개 중 39, R4 까지 506개 중 223(기능어 포함).

## 사용자 결정 대기

1. Play 프로텍트 경고: 이메일 칸 숨기기 또는 Play 내부 테스트 배포.
2. 무료·유료 범위와 가격(2026-11-06).
3. Sign in with Apple(출시 때).
4. 앱에 넣어 둔 장면 컷 19MB 를 뺄지.
5. 연애 5편 여자판을 만들지(상대역 인물이 새로 필요).

## 회화 음성(2026-11-07)

- 앱: `content_sync`·`dialogue_audio`·`Dialogue.view()` 이식 완료. `/art/id/audio/manifest` 에 줄이 올라오면 앱은 재빌드 없이 다음 시작 때 받아 쓴다.
- 도구: `tools/tts/`, 목소리 `data/tts/voices.json`, 계획 `data/tts/plan/`, 작성법 `data/tts/PLAN_GUIDE.md`. PC 출력 `out/ref_id/`·`out/id/<편>/`.
- 시험: 앱에 없는 14턴 편 `data/tts/episodes/r3_work_b1.json` 을 MOSS(language Malay)·VoxCPM2 두 모델로 비교(`tools/tts/trial.py`). 비교판은 R2 에만, D1 은 사용자가 고른 판만. 판단 전 전편 금지.
- 리뷰 페이지: `tools/review_id.sh` → `data/review/REVIEW_id.html`, uk 세션이 게시.
- 음질 후처리: `pack.py --post`(저역 제거·약한 잡음 제거·치찰음 완화·4~8kHz 감쇠·압축 → `<편>_pp`). VoxCPM2 는 48kHz 로 나오는데 원본 판은 24kHz 로 내려 포장했다 — 후처리판은 48kHz 유지.
- 배포(2026-11-08): 안드로이드 CI 22(Zealot https://apps.talkverse.uk/0wFAp/312) + TestFlight 2611081617. 음성 시험은 MOSS 선택, 후처리 1·2·3단계 중 사용자 선택 대기.
