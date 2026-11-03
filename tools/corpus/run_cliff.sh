#!/bin/bash
# 인도네시아어 절벽 재산출 한 번에(2026-11-03 사용자 지시): 공개 자막 말뭉치 id raw → 인도네시아 제작 작품 고르기(Q252) → 어근+접사 빈도·구간.
# 말뭉치·중간 파일은 저장소 밖 ~/corpus/id, 결과는 data/corpus/cliff_v2/(앱 데이터는 덮어쓰지 않음).
# 제작국 작품이 적어 토큰이 모자라면 비교용으로 전체(혼합) 판도 같이 낸다(label id_mixed).
set -e
PY=~/.venvs/id-corpus/bin/python   # pip install Sastrawi
D=~/corpus/id; OUT="$(cd "$(dirname "$0")/../.." && pwd)/data/corpus/cliff_v2"
mkdir -p "$D" "$OUT"
[ -s "$D/id_raw.zip" ] || { echo "말뭉치 없음 — ~/corpus/README_local.txt 의 주소(ja→id)로 $D/id_raw.zip 을 받을 것"; exit 1; }
cp -n ~/corpus/ja/title.episode.tsv.gz "$D/" 2>/dev/null || true
$PY "$(dirname "$0")/select_titles.py" "$D/id_raw.zip" Q252 "$D/id_titles.txt"
$PY "$(dirname "$0")/cliff_id.py" "$D/id_raw.zip" "$OUT" --only "$D/id_titles.txt" --label id
$PY "$(dirname "$0")/cliff_id.py" "$D/id_raw.zip" "$OUT" --label id_mixed
echo CLIFF_DONE
