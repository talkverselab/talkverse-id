#!/bin/zsh
# 회화 대사 Grok 쓰기 회차(M4 크롬 9228, 「빠른」 모드 — 11-18). 방 하나에 최대 25편(uk 11-19: 20~30편마다 새 방) — 방 첫 메시지만 규칙 첨부, 이후 파일 이름 한 줄(사용자 지시 11-09).
#   zsh tools/grok/rewrite_run.sh <편id>...     결과 data/review/grok/out/<id>.md
# 전: python3 tools/grok/id_dialogue_txt.py export / 후: python3 tools/grok/id_dialogue_txt.py import
# TIMEOUT 이면 다시 보내기 전에 --fetch 로 방의 답을 먼저 읽는다(긴 방의 3분 오판 — uk 11-19).
cd "$(dirname "$0")/../.."
export GROK_CDP_PORT=9228
first=${TMPDIR:-/tmp}/grok_id_first.txt
mkdir -p data/review/grok/out
chat=""; n=0
for id in "$@"; do
  out=data/review/grok/out/$id.md
  [[ -s $out ]] && { echo "skip $id"; continue; }
  (( n >= 25 )) && { chat=""; n=0; }
  if [[ -z $chat ]]; then
    print -r -- "첨부한 rewrite_grok_id.md 가 이 방의 규칙이다. 앞으로는 파일 이름 한 줄만 보낸다. 첫 편: $id.txt" > $first
    r=$(python3 tools/grok/grok_text.py $first $out tools/grok/rewrite_grok_id.md data/review/grok/skel/$id.txt 2>&1)
  else
    r=$(python3 tools/grok/grok_text.py -m "$id.txt" $out data/review/grok/skel/$id.txt --chat "$chat" 2>&1)
  fi
  rc=$?
  if [[ $rc -eq 4 && -n $chat ]]; then  # 3분 TIMEOUT — 방에 답이 있는지 먼저 읽기
    sleep 30
    python3 tools/grok/grok_text.py --fetch $out --chat "$chat" >/dev/null 2>&1
    grep -q "=== $id" $out 2>/dev/null && { rc=0; r="$r 저장(fetch)"; } || rm -f $out
  fi
  echo "$(date +%H:%M) $id rc=$rc $(echo $r | grep -E "저장|LIMIT|TIMEOUT|모델|Error|오류" | tr '\n' ' ')"
  [[ $rc -eq 3 ]] && { echo "LIMIT — 멈춤"; exit 3; }
  c=$(echo $r | grep '^CHAT ' | awk '{print $2}' | sed 's/?.*//'); [[ -n $c ]] && { chat=$c; n=$((n+1)); }
  sleep 15
done
echo "끝 $chat"
