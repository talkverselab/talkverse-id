#!/usr/bin/env python3
"""회화 원고의 작업 기록 칸(review·draft)을 앱 묶음·서버 공개 원고에서 빼서 로컬 기록(data/review/script_meta/<편id>.json)으로 옮긴다.
출시 심사 점검(uk 11-23): 화면엔 안 보여도 공개 주소로 열리는 원고에 작업 도구 이름이 남으면 안 된다.
script_publish.py 가 올리기 전에 부른다. 이미 옮긴 칸은 기존 기록에 합친다(덮어쓰지 않음)."""
import glob, json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
META = ROOT / 'data/review/script_meta'
KEYS = ('review', 'draft')


def strip():
    META.mkdir(parents=True, exist_ok=True)
    n = 0
    for p in sorted(glob.glob(str(ROOT / 'assets/data/dialogues/R[0-9]/*/*.json'))):
        raw = Path(p).read_text(encoding='utf-8')
        d = json.loads(raw)
        got = {k: d.pop(k) for k in KEYS if k in d}
        if not got:
            continue
        m = META / f"{d.get('id', Path(p).stem)}.json"
        old = json.loads(m.read_text(encoding='utf-8')) if m.exists() else {}
        hist = old.setdefault('history', [])
        hist.append(got)
        m.write_text(json.dumps(old, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
        ind = len(raw.split('\n', 2)[1]) - len(raw.split('\n', 2)[1].lstrip(' '))  # 원래 들여쓰기 그대로
        Path(p).write_text(json.dumps(d, ensure_ascii=False, indent=ind or 1) + ('\n' if raw.endswith('\n') else ''), encoding='utf-8')
        n += 1
    return n


if __name__ == '__main__':
    print('작업 기록 칸을 옮긴 편', strip())
