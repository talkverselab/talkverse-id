# Claude 업데이트 메모 — indo_universe (id)

> 기준 앱: chinese_universe(zh). 이식 세부 규격은 `zh/docs/PORTING_GUIDE_2026-09.md` 참고.
> 작성: 2026-09-05 (Claude Code 세션). 이후 변경은 git log 참고.

## 변경 이력
- `9f6ff68` (2026-09-02) 빈도 단어 외움 체크

## 변경 내용
- `services/memorized_store.dart` 신설. `screens/word_freq_screen.dart` 행 trailing에 외움 체크(◯/✓) 버튼 추가(원문 `word` 키, 영구 저장).

## 보류 사유
- 주제별 단어·표현 메뉴는 넣지 않음 — 쓸 수 있는 자체 정제 자료가 없음. 자체 제작 자료가 생기면 다른 언어앱의 주제별 단어 화면을 포팅.
- 독음 토글도 독음 데이터가 없어 미적용.
