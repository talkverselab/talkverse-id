# Supabase → Cloudflare 이관 — 인도네시아어앱 (talkverse-id)

**Supabase 사용 없음 — 확인 2026-10-26.** 옮길 것 없음.

확인한 것:
- 코드·스크립트·설정(추적·미추적 파일 모두)에 Supabase 주소·키·`supabase` 패키지 없음. 로그인(계정) 기능 없음.
- 학습 데이터는 앱 안 에셋(`assets/data/**`) → 폰 내부 SQLite(drift)로 적재, 진행 기록은 폰 안(`shared_preferences`·drift)에만 둔다.
- 앱이 쓰는 네트워크는 GitHub 릴리스(앱 안 업데이트: `latest.json`·APK)뿐.
- 공용 Supabase(SELECT 만): 이 앱 이름(`id_*`·indo·bahasa·malay)의 표·저장소 버킷 없음.

나중에 계정·진행 기록 동기화가 생기면: 계정 = `talkverse-accounts` + `talkverse-auth`, 학습 데이터 = 공용 D1 `talkverse-db`(`lang='id'`) — 태국어앱 설계 §2 를 따른다.
