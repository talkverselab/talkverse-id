#!/usr/bin/python3
"""회화 파일의 감정 열 → 감정 계획(data/tts/plan/<편id>.json) 자동 생성 — 감정을 다시 손으로 적지 않는다(사용자 지시 2026-11-07).
  python3 tools/tts/make_plan.py <편id>... [--force]     편을 안 주면 감정 열이 있는 편 전부. 있는 계획은 --force 없으면 건너뛴다(손본 계획 보호).
턴의 `segs`([감정, 본문] 목록)가 있으면 그대로, 없으면 `emotion` 으로 한 조각. 둘 다 없는 턴이 있으면 그 편은 만들지 않고 알린다(neutral 로 채우지 않는다).
목소리: 편의 `cast`({화자: 목소리})가 먼저, 없으면 고정 인물·호칭으로 정한다. 턴의 `m`·`f`(성별판)는 그대로 옮긴다.
숫자·지문이 있는 조각은 세 번째 칸(읽기)을 자동으로 넣는다(`5` → `lima`, 괄호 지문 뺌). 만든 뒤 check_plan.py 로 검사한다."""
import json, os, re, sys
import ttslib as L

NAMED = {'Ayu': 'ayu', 'Raka': 'raka', 'Nadia': 'nadia', 'Dimas': 'dimas', 'Bu Sri': 'busri', 'Pak Darto': 'darto', 'Kasir': 'woman_y', 'Sopir': 'man_m', 'Petugas': 'man_m'}
TITLE = (('Mbak', 'woman_y'), ('Mas', 'man_y'), ('Bu', 'woman_m'), ('Ibu', 'woman_m'), ('Pak', 'man_m'), ('Bapak', 'man_m'), ('Nenek', 'woman_o'), ('Kakek', 'man_o'))
ONES = 'nol satu dua tiga empat lima enam tujuh delapan sembilan sepuluh sebelas'.split()


def say(n):
    """정수 → 인도네시아어 낱말(0~999,999)."""
    if n < 12:
        return ONES[n]
    if n < 20:
        return ONES[n - 10] + ' belas'
    if n < 100:
        return (ONES[n // 10] + ' puluh ' + (ONES[n % 10] if n % 10 else '')).strip()
    if n < 1000:
        return (('seratus' if n < 200 else ONES[n // 100] + ' ratus') + ' ' + (say(n % 100) if n % 100 else '')).strip()
    return (('seribu' if n < 2000 else say(n // 1000) + ' ribu') + ' ' + (say(n % 1000) if n % 1000 else '')).strip()


def reading(s):
    r = re.sub(r'\([^)]*\)', '', s)
    r = re.sub(r'[^\w\s.,!?…{}\'"-]', '', r)
    r = re.sub(r'\d+', lambda m: say(int(m.group())), r)
    return re.sub(r'\s+', ' ', r).strip()


def seg(e, s):
    r = reading(s)
    return [e, s] if r == s else [e, s, r]


def voice(sp, name, d):
    if sp in d.get('cast', {}):
        return d['cast'][sp]
    if name in NAMED:
        return NAMED[name]
    for t, v in TITLE:
        if name.startswith(t + ' '):
            return v
    return None


def plan(ep):
    d = json.load(open(L.EP[ep], encoding='utf-8')); errs = []
    cast = {}
    for k, n in d['speakers'].items():
        if k != 'A':
            cast[k] = voice(k, n, d)
            if not cast[k]:
                errs.append(f'목소리 없음 {k}={n}')
    turns = {}
    for t in d['turns']:
        if t.get('segs'):
            T = {'segs': [seg(s[0], s[1]) for s in t['segs']]}
        elif t.get('emotion'):
            T = {'segs': [seg(t['emotion'], t['id'])]}
        else:
            errs.append(f"턴 {t['num']} 감정 없음"); continue
        for g in 'mf':
            if t.get(g):
                T[g] = t[g]
        turns[str(t['num'])] = T
    return {'ep': ep, 'cast': cast, 'turns': turns}, errs


def main():
    a = [x for x in sys.argv[1:] if x != '--force']; force = '--force' in sys.argv
    ids = a or sorted(e for e, p in L.EP.items() if any(t.get('emotion') or t.get('segs') for t in json.load(open(p, encoding='utf-8'))['turns']))
    made = skip = bad = 0
    for ep in ids:
        f = f'{L.R}/data/tts/plan/{ep}.json'
        if os.path.exists(f) and not force:
            skip += 1; continue
        P, errs = plan(ep)
        if errs:
            bad += 1; print(ep, *errs, sep='\n  '); continue
        json.dump(P, open(f, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); made += 1
    print('만듦', made, '건너뜀', skip, '문제', bad)


if __name__ == '__main__':
    main()
