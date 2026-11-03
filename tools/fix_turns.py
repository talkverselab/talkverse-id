#!/usr/bin/env python3
"""재작성 반영 뒤 검수에서 고친 줄을 넣는다(독음 다시 생성, review.final 에 사유 기록).
  python3 tools/fix_turns.py <편.json> "<사유>" <번호>="<인니어>|<한국어>" ...   (한국어 생략 가능)
"""
import json, sys, os
sys.path.insert(0, os.path.dirname(__file__))
from rd_id import rd
path, why = sys.argv[1], sys.argv[2]
ep = json.load(open(path, encoding='utf-8'))
for arg in sys.argv[3:]:
    n, val = arg.split('=', 1)
    tl, _, ko = val.partition('|')
    t = ep['turns'][int(n) - 1]
    t['id'], t['rd'] = tl, rd(tl)
    if ko:
        t['ko'] = ko
ep.setdefault('review', {})['final'] = why
json.dump(ep, open(path, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('fixed', ep['id'], sys.argv[3:])
