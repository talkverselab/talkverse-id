# Claude 업데이트 메모 — indo_universe (id)

> 기준 앱: chinese_universe(zh). 이식 세부 규격은 `zh/docs/PORTING_GUIDE_2026-09.md` 참고.
> 작성: 2026-09-05 (Claude Code 세션). 이후 변경은 git log 참고.

## 변경 이력
- `9f6ff68` (2026-09-02) 빈도 단어 외움 체크

## 변경 내용
- `services/memorized_store.dart` 신설. `screens/word_freq_screen.dart` 행 trailing에 외움 체크(◯/✓) 버튼 추가(원문 `word` 키, 영구 저장).

## 보류 사유
- co-Trip류 정제 MD가 없음(전자책 폴더의 인니어 자료는 스캔 OCR raw.md만 있고 글자 깨짐 심함) → 주제별 단어·표현 메뉴는 넣지 않음.
- 정제 MD가 생기면 `es/tool/parse_cotrip_generic.py`를 복사해 투입 가능 (es의 `topic_vocab_screen.dart`도 함께 포팅).
- 독음 토글도 독음 데이터가 없어 미적용.
