import '../core/constants.dart';

/// 단어의 한 조각 — 접두사 / 어근 / 접미사.
class AffixSegment {
  final String text;
  final String kind; // AffixKind
  const AffixSegment(this.text, this.kind);

  bool get isRoot => kind == AffixKind.root;

  @override
  String toString() => '$text($kind)';
}

/// 접사 분해 결과.
class AffixParse {
  final String word;
  final List<AffixSegment> segments;
  final String root;
  final bool rootKnown; // 사전(어근 목록)에서 확인된 어근인지
  const AffixParse({
    required this.word,
    required this.segments,
    required this.root,
    required this.rootKnown,
  });

  bool get hasAffix => segments.length > 1;
  String get pattern => segments
      .map((s) => s.isRoot ? '√' : s.text)
      .join('+')
      .replaceAll('+√+', '-√-')
      .replaceAll('+√', '-√')
      .replaceAll('√+', '√-');
}

/// 인도네시아어·말레이어 접사 분해 (규칙 기반 heuristic).
///
/// zh 의 pinyin_util 에 대응. 어근 사전([knownRoots])이 있으면
/// 후보 중 사전에 있는 어근을 우선하고, 없으면 가장 긴 접사 매칭을 취한다.
class AffixUtil {
  AffixUtil._();

  static Set<String> _knownRoots = const {};

  /// 시딩된 어근 목록 주입 (RootsRepository 에서 호출).
  static void setKnownRoots(Iterable<String> roots) {
    _knownRoots = roots.map((r) => r.toLowerCase()).toSet();
  }

  static Set<String> get knownRoots => _knownRoots;

  // 접두사 후보: (표면형, kind, 비음 복원 후보 첫 글자들)
  // meN-: mem+p→p / mem+b / men+t→t / men+d,c,j / meng+k→k / meng+vowel,g,h / meny+s→s / menge+단음절
  static const _prefixes = <_Prefix>[
    _Prefix('menge', AffixKind.me, ['']),
    _Prefix('meny', AffixKind.me, ['s', '']),
    _Prefix('meng', AffixKind.me, ['k', '']),
    _Prefix('mem', AffixKind.me, ['p', '']),
    _Prefix('men', AffixKind.me, ['t', '']),
    _Prefix('me', AffixKind.me, ['']),
    _Prefix('penge', AffixKind.circum, ['']),
    _Prefix('peny', AffixKind.circum, ['s', '']),
    _Prefix('peng', AffixKind.circum, ['k', '']),
    _Prefix('pem', AffixKind.circum, ['p', '']),
    _Prefix('pen', AffixKind.circum, ['t', '']),
    _Prefix('per', AffixKind.circum, ['']),
    _Prefix('pe', AffixKind.circum, ['']),
    _Prefix('bel', AffixKind.ber, ['']),
    _Prefix('ber', AffixKind.ber, ['']),
    _Prefix('be', AffixKind.ber, ['', 'r']),
    _Prefix('di', AffixKind.di, ['']),
    _Prefix('ter', AffixKind.ter, ['']),
    _Prefix('ke', AffixKind.circum, ['']),
    _Prefix('se', AffixKind.other, ['']),
  ];

  static const _suffixes = <_Suffix>[
    _Suffix('kan', AffixKind.kan),
    _Suffix('nya', AffixKind.other),
    _Suffix('lah', AffixKind.other),
    _Suffix('kah', AffixKind.other),
    _Suffix('an', AffixKind.an),
    _Suffix('i', AffixKind.i),
  ];

  /// 단어 → 접사 분해. 분해 불가하면 전체를 어근으로 반환.
  static AffixParse parse(String rawWord) {
    final word = rawWord.toLowerCase().replaceAll(RegExp(r'[^a-z\-]'), '');
    if (word.isEmpty) {
      return AffixParse(
          word: rawWord, segments: [AffixSegment(rawWord, AffixKind.root)],
          root: rawWord, rootKnown: false);
    }
    // 중첩어(kata ulang): sedikit-sedikit → 앞 요소만 분석 후 표기 유지
    if (word.contains('-')) {
      final head = word.split('-').first;
      final p = parse(head);
      return AffixParse(
          word: rawWord,
          segments: [
            ...p.segments,
            AffixSegment('-${word.split('-').skip(1).join('-')}', AffixKind.other),
          ],
          root: p.root,
          rootKnown: p.rootKnown);
    }

    // 후보 생성: (prefix?, root, suffix?)
    final candidates = <AffixParse>[];
    // surface: 화면 표시용 표면형 어근 (menulis → 'ulis'), root: 사전 조회용 복원 어근 ('tulis')
    void add(String? pre, String preKind, String surface, String root, String? suf, String sufKind) {
      if (root.length < 2) return;
      final segs = <AffixSegment>[
        if (pre != null) AffixSegment(pre, preKind),
        AffixSegment(surface, AffixKind.root),
        if (suf != null) AffixSegment(suf, sufKind),
      ];
      // 접환사(ke-an, pe-an, per-an, ber-an) 표기: 양쪽 다 있으면 circum 으로 통일
      final isCircum = pre != null && suf != null &&
          ((preKind == AffixKind.circum && sufKind == AffixKind.an) ||
           (preKind == AffixKind.ber && sufKind == AffixKind.an));
      final fixed = isCircum
          ? segs
              .map((s) => s.isRoot ? s : AffixSegment(s.text, AffixKind.circum))
              .toList()
          : segs;
      candidates.add(AffixParse(
        word: rawWord,
        segments: fixed,
        root: root,
        rootKnown: _knownRoots.contains(root),
      ));
    }

    // 1) 원형 자체
    add(null, '', word, word, null, '');

    // 2) 접미사만
    for (final s in _suffixes) {
      if (word.endsWith(s.form) && word.length > s.form.length + 1) {
        final r = word.substring(0, word.length - s.form.length);
        add(null, '', r, r, s.form, s.kind);
      }
    }

    // 3) 접두사 (+ 접미사)
    for (final p in _prefixes) {
      if (!word.startsWith(p.form) || word.length <= p.form.length + 1) continue;
      final rest = word.substring(p.form.length);
      for (final restore in p.restore) {
        final root = '$restore$rest';
        add(p.form, p.kind, rest, root, null, '');
        for (final s in _suffixes) {
          if (root.endsWith(s.form) && root.length > s.form.length + 1) {
            add(p.form, p.kind, rest.substring(0, rest.length - s.form.length),
                root.substring(0, root.length - s.form.length), s.form, s.kind);
          }
        }
      }
    }

    // 선택: 사전 어근 우선 → 접사 수 많은 것 → 어근 길이 긴 것
    candidates.sort((a, b) {
      if (a.rootKnown != b.rootKnown) return a.rootKnown ? -1 : 1;
      if (a.rootKnown) {
        // 둘 다 사전 어근이면 더 많이 분해된 것 우선 (menyapu → meny+sapu > me+nyapu)
        return b.segments.length.compareTo(a.segments.length);
      }
      // 사전 미확인: 과분해 방지 — 원형 우선
      return a.segments.length.compareTo(b.segments.length);
    });
    return candidates.first;
  }

  /// 문장을 공백 기준으로 나눠 단어별 분석 (문장부호는 별도 세그먼트).
  static List<AffixParse> parseSentence(String sentence) {
    final out = <AffixParse>[];
    for (final tok in sentence.split(RegExp(r'\s+'))) {
      if (tok.isEmpty) continue;
      final m = RegExp(r'^([^\wÀ-ÿ\-]*)([\wÀ-ÿ\-]+)([^\wÀ-ÿ\-]*)$').firstMatch(tok);
      if (m == null) {
        out.add(AffixParse(
            word: tok, segments: [AffixSegment(tok, AffixKind.other)],
            root: tok, rootKnown: false));
        continue;
      }
      final lead = m.group(1) ?? '';
      final core = m.group(2) ?? '';
      final trail = m.group(3) ?? '';
      if (lead.isNotEmpty) {
        out.add(AffixParse(
            word: lead, segments: [AffixSegment(lead, AffixKind.other)],
            root: lead, rootKnown: false));
      }
      final p = parse(core);
      // 원래 대소문자 보존: 첫 세그먼트에 원문 첫 글자 적용
      out.add(_preserveCase(p, core));
      if (trail.isNotEmpty) {
        out.add(AffixParse(
            word: trail, segments: [AffixSegment(trail, AffixKind.other)],
            root: trail, rootKnown: false));
      }
    }
    return out;
  }

  static AffixParse _preserveCase(AffixParse p, String original) {
    if (original.isEmpty || original[0] == original[0].toLowerCase()) return p;
    final segs = List<AffixSegment>.from(p.segments);
    final first = segs.first;
    final restored = first.text.length > 1
        ? first.text[0].toUpperCase() + first.text.substring(1)
        : first.text.toUpperCase();
    // 비음 복원된 어근(mem+p)은 표면형과 다르므로 표시는 표면형 유지 불가 → 그대로
    segs[0] = AffixSegment(restored, first.kind);
    return AffixParse(
        word: original, segments: segs, root: p.root, rootKnown: p.rootKnown);
  }
}

class _Prefix {
  final String form;
  final String kind;
  final List<String> restore; // 비음 동화로 사라진 어근 첫 글자 후보 ('' = 없음)
  const _Prefix(this.form, this.kind, this.restore);
}

class _Suffix {
  final String form;
  final String kind;
  const _Suffix(this.form, this.kind);
}
