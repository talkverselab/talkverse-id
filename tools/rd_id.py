#!/usr/bin/env python3
"""인도네시아어 → 한글 독음(rd) — docs/DIALOGUE.md §4 표 그대로(2026-11-03 초안, 원어민 검수 전).

규칙 요지: p/t/k 첫소리 = ㅃ/ㄸ/ㄲ, 약한 e(ə) = 으(강한 é 는 예외표), c = ㅉ, ny = 니+모음, ng = ㅇ,
끝소리 -k = ㄱ, -t = ㅅ, -p = ㅂ, -h = 흐, -r = 르, -l = ㄹ, -s = 스, 모음 사이 l = ㄹㄹ, ai/au = 아이/아우.
  python3 tools/rd_id.py "Halo! Apa kabar?"      → 할로! 아빠 까바르?
라이브러리로: from rd_id import rd
"""
import re
import sys

CHO = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ'
JUNG = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ'
JONG = ['', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ']

# 강한 e(é)로 읽는 낱말 — 철자로 구분이 안 되어 예외표로 둔다(나머지 e 는 약한 e = 으)
E_STRONG = {
    'enak', 'ekor', 'ember', 'meja', 'sate', 'kafe', 'kopi', 'teh', 'beres', 'boleh', 'nonton', 'pedas',
    'desa', 'merah', 'leher', 'nenek', 'bebek', 'cewek', 'cowok', 'gue', 'deh', 'sore', 'oke', 'hebat', 'lele',
    'ekstra', 'telepon', 'sepeda', 'karena', 'enggak', 'nggak', 'gede', 'bete', 'keren', 'mesra', 'elo', 'lo',
    'heran', 'ledek', 'mepet', 'sep', 'es', 'yes', 'helm', 'helo', 'hey', 'hei', 'he', 'ewe', 'pe', 'je', 'ke', 'se',
    'goreng', 'gado-gado', 'tempe', 'warteg', 'kece', 'becek', 'kepo', 'ngeri', 'cerewet', 'ojek', 'nenek', 'kek',
    'sendok', 'bebas', 'lebay', 'gemes', 'genit', 'hehe', 'wkwk', 'mbak', 'besok', 'pesta', 'enam',
}
E_STRONG -= {'ke', 'se', 'pe', 'je', 'karena'}  # 접두사·관용은 약한 e 로

# 첫소리 자음(한 글자 또는 이중) → 초성
ONSET = {
    'ng': 'ㅇ', 'ny': 'ㄴ', 'sy': 'ㅅ', 'kh': 'ㅎ',
    'b': 'ㅂ', 'c': 'ㅉ', 'd': 'ㄷ', 'f': 'ㅍ', 'g': 'ㄱ', 'h': 'ㅎ', 'j': 'ㅈ', 'k': 'ㄲ', 'l': 'ㄹ',
    'm': 'ㅁ', 'n': 'ㄴ', 'p': 'ㅃ', 'q': 'ㄲ', 'r': 'ㄹ', 's': 'ㅅ', 't': 'ㄸ', 'v': 'ㅍ', 'w': 'ㅇ',
    'x': 'ㅅ', 'y': 'ㅇ', 'z': 'ㅈ',
}
# 끝소리(받침이 되는 것)
CODA = {'k': 'ㄱ', 't': 'ㅅ', 'p': 'ㅂ', 'm': 'ㅁ', 'n': 'ㄴ', 'ng': 'ㅇ', 'l': 'ㄹ', 'b': 'ㅂ', 'd': 'ㅅ', 'g': 'ㄱ'}
# 받침이 안 되고 「으」를 붙이는 끝소리
CODA_SYL = {'h': '흐', 'r': '르', 's': '스', 'f': '프', 'c': '츠', 'j': '즈', 'z': '즈', 'x': '스', 'y': '이', 'w': '우', 'v': '브'}

VOWELS = 'aeiouéə'


def compose(cho, jung, jong=''):
    return chr(0xAC00 + (CHO.index(cho) * 21 + JUNG.index(jung)) * 28 + JONG.index(jong))


def vowel_jamo(v, glide):
    """모음(+앞 활음 y/w) → 중성."""
    base = {'a': 'ㅏ', 'e': 'ㅔ', 'é': 'ㅔ', 'ə': 'ㅡ', 'i': 'ㅣ', 'o': 'ㅗ', 'u': 'ㅜ'}[v]
    if glide == 'y':
        return {'ㅏ': 'ㅑ', 'ㅔ': 'ㅖ', 'ㅡ': 'ㅡ', 'ㅣ': 'ㅣ', 'ㅗ': 'ㅛ', 'ㅜ': 'ㅠ'}[base]
    if glide == 'w':
        return {'ㅏ': 'ㅘ', 'ㅔ': 'ㅞ', 'ㅡ': 'ㅝ', 'ㅣ': 'ㅟ', 'ㅗ': 'ㅗ', 'ㅜ': 'ㅜ'}[base]
    return base


def mark_e(word):
    """낱말 안의 e 를 é(강한) 또는 ə(약한)로."""
    if word in E_STRONG:
        return word.replace('e', 'é')
    # 기본: 약한 e. 단 낱말 끝 -e 와 「ai·au 앞」은 강하게(sore·kafe 류는 예외표)
    return word.replace('e', 'ə')


# 낱말 통째로 읽는 것(감탄사·외래어·줄임말)
WHOLE = {'lho': '로', 'klien': '끌리엔', 'cek': '쩩', 'korea': '꼬레아', 'terakhir': '뜨르악히르', 'deg': '덱', 'degan': '드간', 'ssst': '쉿', 'sst': '쉿', 'seember': '스엠브르', 'ember': '엠브르', 'loh': '로', 'wkwk': '웍웍', 'hehe': '헤헤', 'haha': '하하', 'hahaha': '하하하', 'oke': '오께', 'ok': '오께',
         'bro': '브로', 'sis': '시스', 'hah': '하', 'eh': '에', 'oh': '오', 'wah': '와', 'yuk': '육', 'kak': '깍', 'promo': '쁘로모',
         'mineral': '미느랄', 'grup': '그룹', 'bos': '보스', 'struk': '스뜨룩'}


def word_rd(w):
    lw = w.lower()
    if lw in WHOLE:
        return WHOLE[lw]
    if not re.fullmatch(r"[a-z'-]+", lw):
        return w
    if '-' in lw:  # 중첩어
        return '-'.join(word_rd(p) for p in lw.split('-'))
    s = mark_e(lw.replace("'", ''))
    out = []
    i = 0
    n = len(s)
    # 낱말 첫머리 비음 + 자음(mbak·ndak·nggak·ngga) → 음·은·응 한 음절로 먼저
    m0 = re.match(r'(ng|m|n)(?=[bcdfgjkpstz])', s)
    if m0:
        out.append({'ng': '응', 'm': '음', 'n': '은'}[m0.group(1)])
        i = len(m0.group(1))
        if s.startswith('g', i) and m0.group(1) == 'ng':
            pass
    while i < n:
        # 첫소리
        onset = 'ㅇ'
        glide = ''
        for k in ('ng', 'ny', 'sy', 'kh'):
            if s.startswith(k, i) and i + len(k) < n and s[i + len(k)] in VOWELS:
                onset = ONSET[k]
                glide = 'y' if k in ('ny', 'sy') else ''
                i += len(k)
                break
        else:
            if s[i] not in VOWELS:
                c = s[i]
                if i + 1 < n and s[i + 1] in VOWELS:
                    onset = ONSET.get(c, 'ㅇ')
                    if c == 'y':
                        glide = 'y'
                    elif c == 'w':
                        glide = 'w'
                    i += 1
                elif i + 1 < n and s[i + 1] in 'yw' and i + 2 < n and s[i + 2] in VOWELS:
                    onset = ONSET.get(c, 'ㅇ')
                    glide = s[i + 1]
                    i += 2
                else:
                    # 모음 없이 홀로(자음 연쇄 앞부분: str-, tr-, pr-, ks …) → 「으」를 붙여 한 음절
                    out.append(compose(ONSET.get(c, 'ㅇ'), 'ㅡ'))
                    i += 1
                    continue
        if i >= n:
            break
        v = s[i]
        i += 1
        # 이중모음 ai·au·oi → 아이·아우·오이 (뒤 i/u 를 다음 음절로)
        jung = vowel_jamo(v, glide)
        # 끝소리: 다음이 자음이고 그 다음이 자음이거나 낱말 끝
        jong = ''
        tail = ''
        if i < n and s[i] not in VOWELS:
            if s.startswith('ng', i) and (i + 2 == n or s[i + 2] not in VOWELS):
                jong = 'ㅇ'
                i += 2
            elif s.startswith('ng', i):
                # 모음 사이 ng → 앞 받침 ㅇ + 다음 첫소리 ㅇ
                jong = 'ㅇ'
                i += 2
                s = s[:i] + s[i:]
            elif i + 1 == n or (s[i + 1] not in VOWELS and not (s[i + 1] in 'yw' and i + 2 < n and s[i + 2] in VOWELS)):
                c = s[i]
                if c in CODA:
                    jong = CODA[c]
                else:
                    tail = CODA_SYL.get(c, '')
                i += 1
            elif s[i] == 'l' and i + 1 < n and s[i + 1] in VOWELS:
                # 모음 사이 l → ㄹㄹ
                jong = 'ㄹ'
        out.append(compose(onset, jung, jong) + tail)
    return ''.join(out)


def rd(text):
    """문장 → 독음. 문장부호·{변수}·괄호 지문은 그대로."""
    parts = re.split(r"(\{[a-z_]+\}|\([^)]*\)|[A-Za-z'é-]+)", text)
    return ''.join(word_rd(p) if re.fullmatch(r"[A-Za-z'é-]+", p or '') else p for p in parts)


if __name__ == '__main__':
    for t in (sys.argv[1:] or ['Halo! Apa kabar?', 'Terima kasih banyak.', 'Saya mau nasi goreng, pedas sedikit ya.',
                               'Gue nggak tahu, sumpah!', 'Mbak, berapa harganya?', 'Selamat pagi, Pak.']):
        print(t, '→', rd(t))
