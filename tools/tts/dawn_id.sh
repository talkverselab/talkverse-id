#!/bin/zsh
# 새벽 음성 전편(2026-11-22). uk 순서: 11-25 03:40 첫 순서, 06:30 이후 새 묶음 금지, 06:55 까지 3090 비움. 남으면 11-27 00:01 이어서.
# 3090 이 비기(메모리 3GB 미만)를 기다림 → 참고 음성(vox, 2060) → run_all(묶음 4편, STOP_AT 06:30).
set -u
cd ~/talkverse/id
W=~/tts_work/id; PC=Administrator@100.127.143.37; PY=~/.venvs/whisper/bin/python
log(){ echo "$(date +%H:%M:%S) $*" >> $W/dawn.log; }
log "시작"
# PC 작업 멈춤(사용자 11-22 19시, uk 전달) — 풀렸다는 전달이 오면 이 파일을 지운다
[ -f $W/PC_PAUSED ] && { log "PC 멈춤 중(PC_PAUSED) — 시작 안 함"; exit 3; }
while true; do
  m=$(ssh $PC "nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits -i 0" 2>/dev/null | tr -dc 0-9)
  [ -n "$m" ] && [ "$m" -lt 3000 ] && break
  [ "$(date +%H%M)" -ge 0600 ] && { log "3090 안 빔(${m}MiB) — 포기"; exit 2; }
  sleep 60
done
log "3090 빔(${m}MiB)"
if [ ! -f $W/refs_done ]; then
  until ssh $PC "(Get-ScheduledTask -TaskName 'TTS job 2060').State" | grep -q Ready; do sleep 30; done
  scp -q $W/job/vox_jobs.json "$PC:D:/tts_test/job/"
  ssh $PC "Remove-Item D:\\tts_test\\job\\moss_jobs.json -ErrorAction SilentlyContinue; Start-ScheduledTask -TaskName 'TTS job 2060'"
  sleep 20
  until ssh $PC "(Get-ScheduledTask -TaskName 'TTS job 2060').State" | grep -q Ready; do sleep 30; done
  touch $W/refs_done; log "참고 음성 끝"
fi
STOP_AT=${STOP_AT:-06:30} $PY tools/tts/run_all.py $W 4 >> $W/run.log 2>&1
log "run_all 끝 $(cat $W/left.txt 2>/dev/null)"
