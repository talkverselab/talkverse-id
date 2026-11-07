"""절벽 단어표·회화 단어 목록을 앱 에셋으로 만든다(2026-11-07, 일본어앱 tools/freq/conv_words.py 와 같은 역할).

  python3 tools/freq/build_freq_id.py [단어그림 매니페스트.json]
  → assets/data/freq/lang_id_cliff2000.csv  (rank,word,freq,cum_pct,region,root,ko,kind — 절벽 v2 1~2,000위)
  → assets/data/freq/conv_words_id.json     (회화 레마 중 2,000위 밖이면서 단어 DB 에 있는 것, 등장 횟수순)

뜻 우선순위: tools/freq/gloss_id.json → 어근 사전(kata_dasar_core·kata_conv) → 단어 그림 목록. 없으면 빈칸(앱은 단어만 보여 준다).
"""
import collections, csv, glob, json, sys, urllib.request

A = 'assets/data'
CAP = 2000
SKIP = {'deg', 'struknya'}  # 분석기가 잘못 쪼갠 말
rows = list(csv.DictReader(open('data/corpus/cliff_v2/lang_id_top2500.csv', encoding='utf-8-sig')))[:CAP]
gloss = json.load(open('tools/freq/gloss_id.json', encoding='utf-8'))
roots = {}
for f in ('kata_dasar_core', 'kata_conv'):
    for x in json.load(open(f'{A}/roots/{f}.json', encoding='utf-8'))['roots']:
        roots.setdefault(x['root'], x.get('ko') or '')
if len(sys.argv) > 1:
    m = json.load(open(sys.argv[1], encoding='utf-8'))
else:
    q = urllib.request.Request('https://auth.talkverse.uk/art/id/manifest', headers={'User-Agent': 'talkverse-id/0.1'})
    m = json.load(urllib.request.urlopen(q, timeout=30))
art = {x['word']: x.get('ko') or '' for x in m['items']}


def ko(w):
    return gloss.get(w) or roots.get(w) or art.get(w) or ''


with open(f'{A}/freq/lang_id_cliff2000.csv', 'w', encoding='utf-8', newline='') as f:
    o = csv.writer(f, lineterminator='\n')
    o.writerow(['rank', 'word', 'freq', 'cum_pct', 'region', 'root', 'ko', 'kind'])
    for r in rows:
        o.writerow([r['rank'], r['token'], r['frequency'], r['cum_pct'], r['region'], '', ko(r['token']), r['kind']])

top = {r['token'] for r in rows}
lem = collections.Counter()
for p in glob.glob(f'{A}/dialogues/R*/**/*.json', recursive=True):
    for t in json.load(open(p, encoding='utf-8')).get('turns', []):
        for l in t.get('lemmas', []):
            if len(l) >= 2 and l[1] not in top and l[1] not in SKIP and l[1] in roots:
                lem[l[1]] += 1
out = [{'word': w, 'ko': ko(w), 'n': c} for w, c in lem.most_common()]
json.dump({'_meta': '회화 레마 중 절벽 단어표(2,000위) 밖이면서 단어 DB 에 있는 것 · tools/freq/build_freq_id.py', 'words': out},
          open(f'{A}/freq/conv_words_id.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
n = sum(1 for r in rows if ko(r['token']))
print('뜻 있음', n, '/', len(rows), '· R1~R4 뜻 없음', sum(1 for r in rows if r['region'] != 'R5' and not ko(r['token'])), '· 회화 단어', len(out))
