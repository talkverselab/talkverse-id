# data/scripts — 코퍼스 → assets 파이프라인 (zh/data/scripts 대응)

계획 (파일명은 zh 규칙 `NN_동사_대상.py` 를 따른다):

| # | 스크립트 | 입력 | 출력 |
|---|---|---|---|
| 01 | `01_extract_subtitles.py` | 공개 말뭉치 id/ms | `data/corpus/*.txt` |
| 02 | `02_tokenize_freq.py` | corpus | `data/reports/freq_id.tsv` |
| 03 | `03_stem_roots.py` | freq | 어근(kata dasar) 빈도 — Sastrawi/Nazief-Adriani stemmer |
| 04 | `04_root_cliff.py` | 어근 빈도 | 어근 N개 → 청취 커버리지 cliff (zh 한자 cliff 대응) |
| 05 | `05_affix_stats.py` | corpus | 접사별 빈도 → `assets/data/grammar/affixes.json` 보강 |
| 06 | `06_id_ms_diff.py` | id/ms 병렬 코퍼스 | `assets/data/variants/id_ms_diff.json` |
| 07 | `07_gen_dialogues.py` | LLM + 규칙 | `assets/data/dialogues/id/L1~L3.json` |
| 08 | `08_tts_generate.py` | dialogues | `assets/audio/L*/*.mp3` + `audio_manifest.json` |

`data/corpus/`, `data/reports/*.csv|parquet` 는 .gitignore.
