#!/usr/bin/python3
"""문장 조각 wav → 턴별 mp4(AAC) → R2 `audio/id/<편>/<턴>_<m|f>.mp4` + D1 `audio_lines`(그 편의 줄을 지우고 다시 넣는다).
모든 턴에 남성판·여성판 두 파일·두 줄(본문 text(인도네시아어)·reading(빈 값)·rd(한글 독음)·ko(한국어 뜻) 포함). 두 판의 소리가 같아도 따로 올린다 — 구조를 단순하게.
조각마다 앞뒤 무음을 자르고 0.45초 넘는 쉼을 줄인 뒤 0.22초 간격으로 잇고 소리 크기를 맞춘다(-18 LUFS).
  python3 tools/tts/pack.py <wav폴더> <편id>... [--upload] [--no-db] [--post [N]]   --post N = 음질 후처리 N단계(POSTS), 주소·목록은 <편>_pp(1)·_pp2·_pp3   --no-db = R2 에만 올린다(시험 비교판은 사용자가 고른 판만 D1 에 넣는다)
목록 = data/tts/audio_id.json(리뷰 페이지용). 주소에는 ?v=<sha1 앞 8자리>(서버 캐시가 1년)."""
import datetime, hashlib, json, os, subprocess, sys, tempfile
from concurrent.futures import ThreadPoolExecutor
import ttslib as L
R = L.R
TRIM = ('silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.03,areverse,'
        'silenceremove=start_periods=1:start_threshold=-45dB:start_silence=0.05,areverse,'
        'silenceremove=stop_periods=-1:stop_duration=0.45:stop_threshold=-45dB:stop_silence=0.45')
# 음질 후처리(2026-11-07 사용자 청취 뒤): 저역 웅웅 제거 → 약한 잡음 제거 → 치찰음 완화 → 4~8kHz 살짝 낮춤 → 턴 안 크기 고르기. 뒤에 loudnorm 이 이어진다.
# 단계(--post N, 결과 편 꼬리 _pp·_pp2·_pp3): 1 = 약하게, 2 = 잡음·치찰음 더 세게 + 거친 3.5kHz 낮춤 + 저역 따뜻하게, 3 = 2 보다 더 + 10.5kHz 위 코덱 쉿소리 자름.
POSTS = {
    1: ('highpass=f=70,afftdn=nr=10:nf=-45,deesser=i=0.5:m=0.5:f=0.5:s=o,equalizer=f=6500:t=q:w=1.2:g=-2,'
        'acompressor=threshold=-22dB:ratio=2:attack=10:release=120:makeup=1,'),
    2: ('highpass=f=80,afftdn=nr=16:nf=-42:tn=1,deesser=i=0.7:m=0.6:f=0.45:s=o,equalizer=f=200:t=q:w=1:g=1.5,'
        'equalizer=f=3500:t=q:w=1.5:g=-2,equalizer=f=6500:t=q:w=1.2:g=-3,acompressor=threshold=-24dB:ratio=2.5:attack=8:release=150:makeup=1.5,'),
    3: ('highpass=f=90,afftdn=nr=24:nf=-40:tn=1,deesser=i=0.85:m=0.7:f=0.4:s=o,equalizer=f=220:t=q:w=1:g=2,'
        'equalizer=f=3500:t=q:w=1.5:g=-3,equalizer=f=6500:t=q:w=1.2:g=-4,lowpass=f=10500,acompressor=threshold=-24dB:ratio=3:attack=8:release=150:makeup=2,'),
}
W = ['npx', '-y', 'wrangler@4']


def run(*a):
    subprocess.run(a, check=True, capture_output=True)


def build(wav, ep, num, tag, n, out, tmp, post=0):
    sr = '48000' if post and ep.endswith(L.VOX) else '24000'   # VoxCPM2 는 48kHz 로 나온다 — 후처리판은 내리지 않는다
    parts = []
    for i in range(n):
        o = f'{tmp}/{ep}_{num}_{i}_{tag}_{sr}.wav'
        src = f'{wav}/{ep}/{num:02d}_{i}_{tag}.wav'
        run('ffmpeg', '-y', '-i', src, '-af', TRIM, '-ar', sr, '-ac', '1', o)
        if os.path.getsize(o) < 1000:            # 소리가 작아 무음 자르기에 전부 잘려 나간 조각(ffmpeg 는 0 을 돌려준다) → 자르지 않고 쓴다
            run('ffmpeg', '-y', '-i', src, '-ar', sr, '-ac', '1', o)
        parts.append(o)
    gap = f'{tmp}/gap{sr}.wav'
    if not os.path.exists(gap):
        run('ffmpeg', '-y', '-f', 'lavfi', '-i', f'anullsrc=r={sr}:cl=mono', '-t', '0.22', gap)
    lst = f'{tmp}/{ep}_{num}_{tag}.txt'; open(lst, 'w').write(''.join(f"file '{x}'\n" for p in parts for x in (p, gap))[:-len(f"file '{gap}'\n")])
    j = f'{tmp}/{ep}_{num}_{tag}_j.wav'; run('ffmpeg', '-y', '-f', 'concat', '-safe', '0', '-i', lst, '-c', 'copy', j)
    run('ffmpeg', '-y', '-i', j, '-af', POSTS.get(post, '') + 'apad=pad_dur=0.12,loudnorm=I=-18:TP=-1.5:LRA=11,aresample=44100', '-ac', '1',
        '-c:a', 'aac', '-b:a', '80k', '-movflags', '+faststart', '-f', 'mp4', '-map_metadata', '-1', out)
    return float(subprocess.run(['ffprobe', '-v', 'error', '-show_entries', 'format=duration', '-of', 'csv=p=0', out], capture_output=True, text=True).stdout)


def put(r):
    for _ in range(3):
        x = subprocess.run(W + ['r2', 'object', 'put', f"talkverse-art/{r['key']}", '--file', r['f'], '--content-type', 'audio/mp4', '--remote'], cwd=R, capture_output=True, text=True)
        if x.returncode == 0:
            return None
    return r['key'] + ' ' + x.stderr[-200:]


def main():
    UP = '--upload' in sys.argv; DB = '--no-db' not in sys.argv; a = sys.argv[1:]; PP = 0
    if '--post' in a:
        i = a.index('--post'); PP = int(a[i + 1]) if i + 1 < len(a) and a[i + 1].isdigit() else 1; a = a[:i] + a[i + (2 if PP and i + 1 < len(a) and a[i + 1].isdigit() else 1):]
    a = [x for x in a if x not in ('--upload', '--no-db')]; wav, eps = a[0], a[1:]
    tmp = tempfile.mkdtemp(); q = lambda s: "'" + s.replace("'", "''") + "'"
    mf = f'{R}/data/tts/audio_id.json'
    for ep in eps:
        rows = []; oe = ep + ('_pp' if PP == 1 else f'_pp{PP}' if PP else '')
        for t in L.turns(ep):
            for g in 'mf':
                x = t[g]; tag = 'c' if t['same'] else g; f = f"{tmp}/{oe}_{t['num']:02d}_{g}.mp4"
                d = build(wav, ep, t['num'], tag, len(x['segs']), f, tmp, PP)
                rows.append(dict(turn=t['num'], voice=g, speaker=x['voice'], emotion='+'.join(s[0] for s in x['segs']), key=f"audio/id/{oe}/{t['num']:02d}_{g}.mp4",
                                 sha1=hashlib.sha1(open(f, 'rb').read()).hexdigest(), ms=int(d * 1000), text=x['text'], reading=x['reading'], rd=x['rd'], ko=x['ko'], f=f))
        if UP:
            with ThreadPoolExecutor(8) as ex:
                err = [e for e in ex.map(put, rows) if e]
            if err:
                sys.exit('R2 실패 ' + ' | '.join(err[:3]))
            if DB:
                now = datetime.datetime.now(datetime.UTC).strftime('%Y-%m-%d %H:%M:%S')
                sql = [f"DELETE FROM audio_lines WHERE lang='id' AND episode='{oe}';"] + [
                    "INSERT INTO audio_lines (lang,episode,turn,voice,speaker,emotion,key,ms,sha1,text,reading,rd,ko,created_at) VALUES "
                    f"('id','{oe}',{r['turn']},'{r['voice']}','{r['speaker']}','{r['emotion']}','{r['key']}',{r['ms']},'{r['sha1']}',{q(r['text'])},{q(r['reading'])},{q(r['rd'])},{q(r['ko'])},'{now}');" for r in rows]
                sf = f'{tmp}/{ep}.sql'; open(sf, 'w', encoding='utf-8').write('\n'.join(sql) + '\n')
                x = subprocess.run(W + ['d1', 'execute', 'talkverse-db', '--remote', '--file', sf, '-y'], cwd=R, capture_output=True, text=True)
                if x.returncode:
                    sys.exit('D1 실패 ' + ep + x.stderr[-400:] + x.stdout[-300:])
        M = json.load(open(mf, encoding='utf-8')) if os.path.exists(mf) else {}
        M[oe] = [{k: v for k, v in r.items() if k not in ('f', 'text', 'reading', 'rd', 'ko')} for r in rows]
        json.dump(M, open(mf, 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
        print(oe, len(rows), '줄', sum(r['ms'] for r in rows) // 1000, '초', '올림' if UP else '안 올림', flush=True)


if __name__ == '__main__':
    main()
