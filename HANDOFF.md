# HANDOFF — talkverse-id (인도네시아어유니버스) · 2026-11-09

다음 세션은 이 파일 → `CLAUDE.md` → `docs/STATUS.md` 순서로 읽는다. 빌드·서명 규칙은 CLAUDE.md §1·§2(새 키스토어 금지, CI APK 만 Zealot).

## 지금 배포된 것
- 아래 「마지막 배포」 참고. 매번 **Zealot + TestFlight 를 함께** 올리고 둘 다 보고(사용자 지시 2026-11-07).
- 순서: 커밋·푸시 → `gh run watch -R talkverselab/talkverse-id <id>` → `bash tools/zealot_push.sh "<한 줄>"` → `bash tools/ios_release.sh`(백그라운드, 병행 가능) → CI APK 를 `pc:D:/OneDrive/app project/talkverse-id/talkverse-id-latest.apk` + `BUILD.txt` → 잡음 되돌리기(`analysis_options.yaml`·`ios/Runner.xcodeproj/project.pbxproj`·`Runner.xcscheme`·`contents.xcworkspacedata`).
- 마지막 배포(07673fb, 통합 앱 연결 준비): **TestFlight 2611091207 업로드 완료**. 안드로이드 CI 25 는 돌던 중 이 세션의 대기 작업이 메모리 부족으로 멈춰 **Zealot 업로드·PC 백업을 아직 안 했다** → CI 25 가 성공했으면 `bash tools/zealot_push.sh "통합 앱 연결 준비"` 와 PC 백업부터. 그 전 Zealot 은 빌드 24(https://apps.talkverse.uk/0wFAp/394).

## 이번 주에 들어간 것(2026-11-07 ~ 09)
1. **회화 음성 받기·재생**(`content_sync`·`dialogue_audio`·`Dialogue.view()`) — `/art/id/audio/manifest` 에 줄이 올라오면 재빌드 없이 다음 시작 때 받는다. 지금 D1 `audio_lines`(lang id)는 **비어 있다**.
2. **음성 도구** `tools/tts/`(일본어·한국어 이식), 감정 계획 자동 생성 `make_plan.py`(회화 파일의 `emotion`·`segs` → `data/tts/plan/`), 후처리 `pack.py --post N`.
3. **알파벳과 발음**(학습 → 기초 첫 줄) — 모음 6·자음 21·겹글자 5·이중모음 4·끝소리 8. 조음 그림은 **임시**(출시 전 Grok 그림으로 교체, 출처 표기 넣지 않기 — 사용자 지시).
4. **확정 가격표 이용권**(`~/talkverse/PRICING.md`) — 1개월·3개월·1년·평생, 종합 1년·평생. 출시 때 잠금 없음. 상품 목록 `docs/STORE_PRODUCTS.md`(등록은 사용자).
5. **스토어 차별화 문안** `docs/store/listing.md`(첫 줄·전용 도구·실측 숫자·심사 메모 문단·스크린샷 순서), 심사 메모 `docs/store/review_notes.md`.
6. **통합 앱(Talkverse) 연결 준비** 07673fb — `lib/embed.dart`(embedInit·embedApp), `lib/core/embed_env.dart`(assetPath·dataDir), `lib/core/prefs.dart`(설정 키 `id_` 접두, 단독 앱 옛 키 1회 이전), clientId 통합=talkverse, 결제 스트림 분리(`Purchase.ownStream`·`onPurchaseUpdates`), 프로필 「다른 언어 배우기」. 통합 앱 자체는 uk 가 연결 — **여기서 고치거나 빌드하지 않는다**.

## 기다리는 결정·신호
- **음성 후처리 단계**: 사용자가 MOSS 를 골랐고 후처리 1·2·3 단계 비교판을 리뷰 페이지(`r3_work_b1`, https://talkverse.uk/talkverse/review/id/)에 올렸다. 단계를 고르면 → 그 판을 D1 에 넣고(`pack.py … --post N --upload`), **전편은 uk 가 PC 순서를 준 뒤**(「지금 시작」 → 끝나면 「GPU 끝」·「REVIEW_id 갱신」). 전편 전에 R1 30편에 감정 열을 채우고 `make_plan.py`.
- **Grok 장면 그림**: 11월 9일 13:30 재개(uk 공지). 다시 그릴 6편 = life_a1·study_a4·survival_s2·s3·work_a2·a4(`docs/STATUS.md`). Grok 은 M4 Chrome `~/chrome-grok-id`(9228), 한 번에 한 작업, 끝나면 Chrome·터널 닫기. **2026-11-09 허브 공지**: 크롬을 켠 뒤 M4 에서 `ssh macmini4 /usr/bin/python3 ~/talkverse-uk/tools/grok_cookie_sync.py 9231 9228` 로 쿠키 동기화(uk 방은 건드리지 않기). 한자 세션은 더 이상 대행하지 않는다 — 직접 처리, 요청 도구는 M6 `~/Hanja/tools/grok_req.py`·`grok_cdp.py` 를 복사해 쓴다. **Grok 프롬프트 최소화(사용자 지시 2026-11-09)**: 규칙은 문서에 한 번만 두고, 방 첫 메시지에서 「앞으로 파일 이름 한 줄만 보낸다」고 약속한 뒤 채팅은 한 줄씩만. 그림이 처음과 달라지면 최초 통과 그림을 기준으로 맞춘다(이미 만든 그림은 그대로).
- **CLAUDE.md §2**: 「앱 업데이트」 타일 안내와 「가격 결정 대기」 문구가 옛 내용 — 사용자에게 고칠지 물어 둔 상태(다른 세션 요청만으로는 고치지 않는다).
- 사용자 결정 남음: R5 낱말 1,048개 뜻 없음(인명·영어·민감어 숨길지), 사랑 5편 여성판, 번들 장면 컷 19MB 제거, Play Protect 경고.

- **회화 만들기 규칙(사용자 지시 2026-11-09)**: 새 회화를 만들 때 **줄마다 음성을 고려한 감정 열(`emotion`)** 을 처음부터 넣는다(나중에 `make_plan.py` 가 그대로 씀).

- **회화는 일상이 먼저(사용자 지시 2026-11-09, 원칙 페이지 §9 https://talkverse.uk/talkverse/dialogue-rules/)**: 가게·식당·길·집·학교·직장·약속·전화의 흔한 표현이 중심, 반전은 말실수·착각·깜빡함·예상 밖 대답·설렘 정도까지. 비현실적 사건·과장된 소동·판타지 금지, 반전 때문에 일상 표현이 빠지면 반전을 줄인다.
  - **R1 점검(11-09, 장면·한국어 줄만 읽음) — 고칠 편**: ① `friends_a1` 셀카(「강아지에 백 명」「셀럽 됐어」) → 지나가는 사람에게 사진 부탁·한 명이 실수로 끼는 정도. ② `love_a4` 영화관(친구 셋이 우연히 다 나타남·「완전 미쳤어」) → 표 사기·좌석 고르기 중심, 아는 사람 한 명 마주치는 정도. ③ `travel_a3` 지름길(늦었는데 기사 집에 들러 밥) → 길 막힘·다른 길로 돌아감 정도.
  - 가볍게 다듬을 편: `life_a4`(양파 「스무 개 더」), `work_a2`(사장님께 「자기야」·「나 죽었어」), `friends_a2`(이웃이 두드리는데 「더 크게」).
  - 고칠 때 줄마다 감정 열을 넣고, 장면이 바뀌는 편만 그림·Grok 프롬프트를 새로 만든다(나머지는 이미 통과한 그림 유지).

## 출시
- 지금 출시 = 한자앱만. 이 앱은 **아직 내지 않는다**: 회화 R1 30편만(전부 원어민 검수 전 초안), 음성 없음, 조음 그림 임시, 로그인 화면에 「준비 중」 제공자(구글·네이버·카카오).

## 주의
- 공개 저장소 — 자막·말뭉치 제공처, 책·작품 이름을 어디에도(커밋 메시지 포함) 남기지 않는다.
- `flutter test` 는 `analysis_options.yaml` 을 바꾼다 → 되돌린다. 다른 세션의 flutter 가 시작 잠금을 오래 쥐면 `dart analyze` 는 `/opt/homebrew/share/flutter/bin/cache/dart-sdk/bin/dart` 로 직접.
- 시뮬레이터 확인은 임시 기기(`xcrun simctl create … iOS-27-0`)를 만들고 끝나면 지운다. 디스크가 찰 수 있다(2026-11-09 한 번 가득 참).
- 회화 음성 PC 출력은 `out/ref_id/`·`out/id/<편>/` 로 언어별 분리. GPU 는 uk 신호를 받고만 쓴다.
