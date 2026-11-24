#!/bin/zsh
# 새벽 음성 전편(2026-11-22). uk 순서: 11-25 03:40 첫 순서, 06:30 이후 새 묶음 금지, 06:55 까지 3090 비움. 남으면 11-27 00:01 이어서.
# 2026-11-23 사용자: 낮에도 실행 — 시각 제한 없음(필요하면 STOP_AT=06:30 GIVEUP_AT=0600). 멈춤 = touch $W/PAUSE.
# uk 「id 지금 시작」(또는 앞 순서 fa 의 「GPU 끝」) 뒤에만 실행. 3090 이 비기(메모리 3GB 미만 3번 연속 + PC 작업 파일 5분 정지)를 기다림 → 참고 음성(vox, 2060) → run_all(묶음 4편, STOP_AT 06:30).
set -u
cd ~/talkverse/id
W=~/tts_work/id; PC=Administrator@100.127.143.37; PY=~/.venvs/whisper/bin/python
log(){ echo "$(date +%H:%M:%S) $*" >> $W/dawn.log; }
log "시작"
# PC 작업 멈춤(사용자 11-22 19시, uk 전달) — 풀렸다는 전달이 오면 이 파일을 지운다
[ -f $W/PC_PAUSED ] && { log "PC 멈춤 중(PC_PAUSED) — 시작 안 함"; exit 3; }
while true; do
  m=$(ssh $PC "nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits -i 0" 2>/dev/null | tr -dc 0-9)
  # 묶음마다 모델을 내렸다 올리는 실행기는 몇 초씩 비어 보인다(uk 11-23) — 낮은 값이 1분 간격 3번 + PC 작업 파일이 5분 넘게 멈춤일 때만 빈 것으로
  if [ -n "$m" ] && [ "$m" -lt 3000 ]; then
    low=$(( ${low:-0} + 1 ))
    age=$(ssh $PC "\$t=@('D:\\tts_test\\job\\job.log','D:\\tts_test\\job\\moss_jobs.json') | ?{Test-Path \$_} | %{(Get-Item \$_).LastWriteTime} | sort -desc | select -first 1; if(\$t){[int]((Get-Date)-\$t).TotalSeconds}else{99999}" 2>/dev/null | tr -dc 0-9)
    [ "$low" -ge 3 ] && [ -n "$age" ] && [ "$age" -gt 300 ] && break
  else
    low=0
  fi
  [ -n "${GIVEUP_AT:-}" ] && [ "$(date +%H%M)" -ge "$GIVEUP_AT" ] && { log "3090 안 빔(${m}MiB) — 포기"; exit 2; }
  sleep 60
done
log "3090 빔(${m}MiB)"
# 참고 음성: PC 에 실제로 없는 것이 있을 때만 만든다(다 있으면 모델을 읽지 않는다, 2026-11-24). 확인 실패(-1)면 만들기 단계로.
refs_missing(){ ssh $PC "(Get-ChildItem D:\\tts_test\\job\\out\\ref_id -Filter *.wav).Name -join ' '" 2>/dev/null | python3 -c "
import json,os,sys
h=set(sys.stdin.read().split()); j=json.load(open('$W/job/vox_jobs.json'))
print(sum(os.path.basename(x['out']) not in h for x in j) if h else -1)"; }
python3 tools/tts/make_jobs.py $W/job --refs >> $W/dawn.log
miss=$(refs_missing); log "참고 음성 없는 것 $miss"
if [ "$miss" != 0 ]; then
  until ssh $PC "(Get-ScheduledTask -TaskName 'TTS job 2060').State" | grep -q Ready; do sleep 30; done
  scp -q $W/job/vox_jobs.json "$PC:D:/tts_test/job/"
  ssh $PC "Remove-Item D:\\tts_test\\job\\moss_jobs.json -ErrorAction SilentlyContinue; Start-ScheduledTask -TaskName 'TTS job 2060'"
  sleep 20
  until ssh $PC "(Get-ScheduledTask -TaskName 'TTS job 2060').State" | grep -q Ready; do sleep 30; done
  miss=$(refs_missing); log "참고 음성 끝 — 없는 것 $miss"
  [ "$miss" != 0 ] && { log "참고 음성이 모자라 멈춤"; exit 4; }
fi
STOP_AT=${STOP_AT:-} $PY tools/tts/run_all.py $W 4 >> $W/run.log 2>&1
log "run_all 끝 $(cat $W/left.txt 2>/dev/null)"
