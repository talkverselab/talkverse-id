#!/usr/bin/env python3
"""회화 음성 시험 — 한 편을 MOSS(language Malay)·VoxCPM2 두 모델로 만들어 R2 에 올리고 리뷰 페이지를 다시 만든다. D1 은 건드리지 않는다(사용자가 고른 판만 나중에 넣는다).
  <venv>/bin/python tools/tts/trial.py <작업폴더> <편id>      venv = mlx-whisper 가 있는 파이썬. PC 는 한 번에 한 세션 — uk 세션 신호를 받은 뒤 돌린다."""
import json, os, subprocess, sys, time
import ttslib as L
PC = 'Administrator@100.127.143.37'; HERE = os.path.dirname(os.path.abspath(__file__))
work, ep = sys.argv[1], sys.argv[2]; eps = [ep, ep + L.VOX]
job = f'{work}/job'; wav = f'{work}/wav'; os.makedirs(job, exist_ok=True); os.makedirs(f'{wav}/retake', exist_ok=True)
log = lambda *a: print(time.strftime('%H:%M:%S'), *a, flush=True)


def sh(*a, check=True, **k):
    return subprocess.run(a, check=check, capture_output=True, text=True, **k)


def state():
    return sh('ssh', PC, "(Get-ScheduledTask -TaskName 'TTS job 2060').State", check=False).stdout


def pc_run():
    """있는 작업 파일만 PC 에 놓고(없는 쪽은 지운다) 끝날 때까지 기다린다."""
    while 'Ready' not in state():
        time.sleep(30)
    for n in ('vox_jobs.json', 'moss_jobs.json'):
        if os.path.exists(f'{job}/{n}'):
            sh('scp', '-q', f'{job}/{n}', f'{PC}:D:/tts_test/job/')
        else:
            sh('ssh', PC, f'Remove-Item D:\\tts_test\\job\\{n} -ErrorAction SilentlyContinue')
    sh('ssh', PC, "Start-ScheduledTask -TaskName 'TTS job 2060'")
    time.sleep(20)
    while 'Ready' not in state():
        time.sleep(30)


def fetch(path, dst):
    os.makedirs(dst, exist_ok=True)
    sh('scp', '-q', '-r', f'{PC}:D:/tts_test/job/out/id/{path}', dst + '/', check=False)


for n in ('vox_jobs.json', 'moss_jobs.json'):
    if os.path.exists(f'{job}/{n}'):
        os.remove(f'{job}/{n}')
sh(sys.executable, f'{HERE}/make_jobs.py', job, '--refs', ep)
log(sh(sys.executable, f'{HERE}/make_jobs.py', job, *eps).stdout.strip())
pc_run(); log('생성 끝')
for e in eps:
    fetch(e, wav)
for rnd in range(3):
    jobs = []
    for e in eps:
        q = f'{job}/qa_{e}.json'
        try:
            r = subprocess.run([sys.executable, f'{HERE}/qa.py', wav, e, '--jobs', q], capture_output=True, text=True, timeout=600)
            log(e, r.stdout.strip() or r.stderr.strip()[-300:])
        except subprocess.TimeoutExpired:
            log('TIMEOUT', e); continue
        if os.path.exists(q):
            jobs += json.load(open(q, encoding='utf-8')); os.remove(q)
    if not jobs:
        break
    for n, x in (('moss_jobs.json', [j for j in jobs if 'language' in j]), ('vox_jobs.json', [j for j in jobs if 'language' not in j])):
        if x:
            json.dump(x, open(f'{job}/{n}', 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
        elif os.path.exists(f'{job}/{n}'):
            os.remove(f'{job}/{n}')
    pc_run()
    for e in eps:
        fetch(f'retake/{e}', f'{wav}/retake')
log('PC 끝')
for e in eps:
    r = sh(sys.executable, f'{HERE}/pack.py', wav, e, '--upload', '--no-db', check=False)
    log(r.stdout.strip() or (r.stderr or '')[-300:])
sh('zsh', f'{L.R}/tools/review_id.sh')
log('끝')
