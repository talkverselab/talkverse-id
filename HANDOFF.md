# HANDOFF — talkverse-id (인도네시아어)

## Zealot 설정 — 정리됨 (2026-10-25)

- 빌드 번호: **Zealot 에는 CI 가 만든 APK 를 올린다**(사용자 결정). `tools/zealot_push.sh` 가 `latest` 릴리스를 내려받아 올린다. 상세 CLAUDE.md §2.
- Zealot 앱이름 「인도네시아어유니버스」로 확정, 빌드 2·3·4 업로드됨. PC 백업 `D:\OneDrive\app project\talkverse-id\`.
- 2026-10-25: 화면 톤(`a74e7d9`)·런처 아이콘(`d695902`)을 talkverse.uk 에 맞춤 — CI 빌드 3·4.

## 다음에 할 내용 (2026-10-11)

세션 정리용 점검 메모. CLAUDE.md·git 기록·작업 트리만 읽고 썼다(코드·빌드·커밋·푸시 없음).

### 현재 상태

- 브랜치 `main`, `origin/main` 과 같은 위치(앞섬·뒤짐 없음). remote 는 `talkverselab/talkverse-id` 로 이미 맞춰져 있다.
- 마지막 커밋은 2026-09-11 `7fad36b`(문서: `adb install --user 0`). 기능 쪽 마지막은 2026-09-10 앱 내 업데이트(`3173790`)와 CI 서명 수정(`45ee65c`). 그 뒤 한 달간 커밋 없음.
- 작업 트리에 **수정 표시 44개 파일(4497줄 추가 / 4497줄 삭제)** 이 있지만 **내용 변경은 0** 이다. 공백·줄 끝을 무시한 diff(`git diff -w --ignore-cr-at-eol`)가 비어 있다 — 작업 폴더 파일이 CRLF 줄 끝으로 들어와 있을 뿐이다(노트북에서 옮겨 온 흔적으로 보임, 추정). 스테이징된 것도 없다.
- `.gitattributes` 없음, `core.autocrlf` 미설정.
- 이 `HANDOFF.md` 는 새로 만든 파일이라 아직 git 에 올라가 있지 않다(untracked).
- 콘텐츠 규모(2026-08-20 커밋 기준): 대화 L1 ep1·ep2 총 80턴, 어근 80, ID↔MS 변이 41, 빈도 단어 120. 빈도 단어 외움 체크(2026-09-02)까지 들어가 있다.

### 남은 일 (순서대로)

1. ~~줄 끝 정리~~ — 2026-10-25 완료: 작업 트리를 HEAD 로 되돌리고 `.gitattributes`(`* text=auto eol=lf`) 추가(`0af9354`).
2. **로컬 서명 파일 확인.** `android/key.properties`·`android/app/signing-key.jks` 가 이 맥에 있는지 이번에는 확인하지 않았다. 로컬 릴리스 빌드 전에 CLAUDE.md §1 대로 `~/.android/debug.keystore` 에서 만든다(맥의 그 키 SHA-1 이 `9C:C4:BC:…:47:6B` 인지 먼저 대조 — 다르면 노트북의 키를 가져와야 한다).
3. **CI 가 지금도 도는지 확인.** 마지막 릴리스 빌드가 9월 10~11일이다. `gh run list -R talkverselab/talkverse-id -L 5` 로 최근 실행과 `latest` 릴리스의 `latest.json` 빌드 번호를 본다.
4. **다음 콘텐츠 확장.** 지난 흐름(ep1·ep2 → 어근 → 변이 → 빈도 단어)을 이어 대화 ep3 이후, 어근·빈도 단어 추가. 범위는 사용자에게 먼저 묻는다 — 이 폴더에는 다음 목표가 적혀 있지 않다.
5. **`CLAUDE_UPDATES.md` 갱신.** 9월 5일 이후 내용(앱 내 업데이트, 서명 수정)이 빠져 있으면 보탠다.
6. 푸시하면 CI 가 서명 APK 를 `latest` 릴리스에 올린다. 폰은 앱의 「앱 업데이트」로 받는다. 전역 규칙에 따라 로컬에서 APK 를 빌드했다면 `~/bin/zealot-upload` 와 PC OneDrive 백업도 한다(이 앱의 Zealot 앱이름은 아직 정해 적어 둔 것이 없다 — 처음 쓸 때 CLAUDE.md 에 기록).

### 주의할 점

- **새 키스토어 금지.** 서명이 바뀌면 폰에서 앱을 지워야 하고 학습 기록이 사라진다. CI 의 `Restore signing key` 단계와 `build.gradle.kts` release 서명 설정을 건드리지 말 것.
- **CLAUDE.md §2 는 `master`(또는 기본 브랜치)라고 쓰지만 이 리포의 기본 브랜치는 `main`** 이다. `.github/workflows/release.yml` 의 트리거 브랜치가 `main` 을 포함하는지 푸시 전에 확인.
- `**.md` 만 고친 푸시는 빌드하지 않는다(`paths-ignore`) — 이 메모만 올리면 새 빌드가 생기지 않는 게 정상.
- **공개 저장소.** 자막·말뭉치 제공처, 책 이름·쪽수, 작품 제목을 코드·에셋·문서·파일명 어디에도 남기지 않는다. 이 메모를 커밋할 때도 같은 기준으로 다시 읽을 것.
- 폰에 케이블로 설치할 때는 `adb -s R3CY20HDN2K install --user 0 -r <apk>` — 프로필을 빼면 복제본 아이콘이 생긴다.
- 줄 끝을 되돌릴 때 `android/key.properties` 같은 무시된 파일은 영향이 없지만, `git clean` 은 쓰지 말 것(서명 파일·이 메모가 지워진다).
