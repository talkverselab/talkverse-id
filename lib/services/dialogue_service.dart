import 'dart:convert';

import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'content_sync.dart';
import 'learner_prefs.dart';

/// 회화 리더(일본어앱 시안 02 「만화책 읽기형」)용 회화 모델 — 2026-11-02, 일본어앱 `dialogue_service.dart` 를 옮김.
///
/// 지금 데이터는 옛 `assets/data/dialogues/id/L1.json`(ep1·ep2, 각 40턴) 하나뿐이라 그것을 그대로 읽어 이 모양으로 바꾼다.
/// 회화 콘텐츠는 바꾸지 않는다(사용자 지시 2026-11-02 "회화는 아직 하지마") — 새 구조(R0~R4·주제별 편 파일)는 회화 작성이 풀리면.
/// 칸: tl = 인도네시아어, gloss = 단어별 뜻, rd = 한글 독음(아직 없음), ko = 한국어.
/// 문장 내용어 한 개: 표면형(문장 속 모양)·어근(kata dasar)·읽기(인도네시아어는 비움) — 단어장 연결(2026-11-04, tools/add_lemmas.py).
class Lemma {
  final String surface, base, reading;
  const Lemma(this.surface, this.base, this.reading);
}

class DialogueTurn {
  final int num;
  final String speaker; // A·B
  final String tl;
  final String gloss;
  final String rd;
  final String ko;
  final String note;
  final List<String> tags;
  final String? art; // 장면 그림 URL(나중에 채움)
  final List<Lemma> lemmas; // 문장 내용어 — 레마 칩 → 어근 사전(2026-11-04)
  const DialogueTurn({
    required this.num,
    required this.speaker,
    required this.tl,
    required this.gloss,
    required this.rd,
    required this.ko,
    required this.note,
    required this.tags,
    this.art,
    this.lemmas = const [],
  });

  factory DialogueTurn.fromL1(Map<String, dynamic> j) => DialogueTurn(
        num: j['num'] as int? ?? 0,
        speaker: j['speaker'] as String? ?? 'A',
        tl: j['id'] as String? ?? '',
        gloss: j['gloss'] as String? ?? '',
        rd: j['rd'] as String? ?? '',
        ko: j['ko'] as String? ?? '',
        note: j['note'] as String? ?? '',
        tags: (j['tags'] as List?)?.cast<String>() ?? const [],
        art: j['art'] as String?,
        lemmas: [for (final l in (j['lemmas'] as List? ?? const [])) if (l is List && l.length >= 2) Lemma('${l[0]}', '${l[1]}', l.length > 2 ? '${l[2]}' : '')],
      );

  /// 음성이 읽는 본문으로 바꾼 턴(나머지 칸은 그대로).
  DialogueTurn withText({required String tl, required String rd, required String ko}) => DialogueTurn(
        num: num, speaker: speaker, tl: tl, gloss: gloss, rd: rd, ko: ko, note: note, tags: tags, art: art, lemmas: lemmas);

  /// 문장에서 단어장과 이어지는 낱말(소문자 표면형) — 밑줄 색으로 표시.
  Set<String> get lemmaSurfaces => {for (final l in lemmas) l.surface.toLowerCase()};

  /// 그림 조회용 핵심 단어 후보: gloss 의 표제어(`kata=뜻`).
  List<String> get pictureWords => [
        for (final m in RegExp(r"([A-Za-z][A-Za-z'-]*)=").allMatches(gloss)) m.group(1)!,
      ];
}

class Dialogue {
  final String id;
  final String region; // 지금은 옛 레벨 이름(L1) 그대로 — R 재태그는 회화 작업 때
  final String island; // 주제
  final String title;
  final String emoji;
  final String scene;
  final Map<String, String> speakers;
  final Map<String, String> genders;
  final List<String> expressions;
  final List<DialogueTurn> turns;
  final String? art;
  const Dialogue({
    required this.id,
    required this.region,
    required this.island,
    required this.title,
    required this.emoji,
    required this.scene,
    required this.speakers,
    required this.genders,
    required this.expressions,
    required this.turns,
    this.art,
  });

  /// 화면에 보일 턴: 생성 음성이 있으면 그 음성이 읽는 본문(학습자 성별판, 이름이 들어간 글) — 듣는 말과 글이 같아야 한다.
  DialogueTurn view(DialogueTurn t) {
    final l = ContentSync.instance.audioIndex[id]?[t.num]?[LearnerPrefs.isFemale ? 'f' : 'm'];
    if (l == null || l.text.isEmpty) return t;
    return t.withText(tl: l.text, rd: l.rd, ko: l.ko);
  }

  /// 화자 표시 이름. `{name}` 자리는 학습자 이름(없으면 「나」).
  String speakerName(String sp) {
    final raw = speakers[sp] ?? sp;
    if (raw.contains('{name}')) return LearnerPrefs.name.value.isNotEmpty ? LearnerPrefs.name.value : '나';
    return raw.replaceAll(RegExp(r'[{}]'), '');
  }

  /// 목소리 성별 — 지금 회화는 화자 이름·성별이 정해진 이야기(A Mark 남 · B Sari 여)라 데이터의 성별을 따른다.
  String voiceGender(String sp) => genders[sp] ?? LearnerPrefs.voiceGender(sp);
}

class DialogueService {
  DialogueService._();
  static final DialogueService instance = DialogueService._();

  static const islands = ['survival', 'friends', 'love', 'life', 'travel', 'culture', 'work', 'study'];
  static const islandKo = {
    'survival': '서바이벌',
    'friends': '친구',
    'love': '사랑',
    'life': '생활',
    'travel': '여행',
    'culture': '문화',
    'work': '일',
    'study': '학업',
  };
  static const islandEmoji = {
    'survival': '🆘',
    'friends': '🤝',
    'love': '💘',
    'life': '🏠',
    'travel': '✈️',
    'culture': '🎬',
    'work': '💼',
    'study': '🎓',
  };
  static const levelKo = {'L1': '이야기', 'R0': '왕초보', 'R1': '초보', 'R2': '중급', 'R3': '고급', 'R4': '최상급'};
  static const _prefLast = 'dialogue_last';

  final List<Dialogue> _all = [];
  String? _lastOpened;
  String? get lastOpenedId => _lastOpened;
  Future<void> setLastOpened(String id) async {
    _lastOpened = id;
    (await SharedPreferences.getInstance()).setString(_prefLast, id);
  }

  /// 여러 화면이 동시에 불러도 한 번만 읽는다(넓은 화면에서 홈·회화 홈이 함께 떠 편이 두 번 채워지던 문제).
  Future<void> ensureLoaded() => _loading ??= _load();
  Future<void>? _loading;

  Future<void> _load() async {
    _lastOpened = (await SharedPreferences.getInstance()).getString(_prefLast);
    try {
      final j = json.decode(await rootBundle.loadString('assets/data/dialogues/id/L1.json')) as Map<String, dynamic>;
      final chars = (j['characters'] as Map<String, dynamic>? ?? const {});
      final names = chars.map((k, v) => MapEntry(k, ((v as Map)['name'] ?? k).toString()));
      final genders = chars.map((k, v) => MapEntry(k, ((v as Map)['gender'] ?? 'female').toString()));
      final level = j['level'] as String? ?? 'L1';
      for (final e in (j['episodes'] as List? ?? const [])) {
        final m = e as Map<String, dynamic>;
        final turns = ((m['turns'] as List?) ?? const []).map((t) => DialogueTurn.fromL1(t as Map<String, dynamic>)).toList();
        if (turns.isEmpty) continue;
        _all.add(Dialogue(
          id: '${level}_${m['id']}',
          region: level,
          island: 'love', // 옛 L1 = 매칭 앱에서 시작하는 연애 이야기(원칙: 기존 연애 서사는 love 주제)
          title: m['title'] as String? ?? m['id'] as String,
          emoji: m['emoji'] as String? ?? '💬',
          scene: m['scenario'] as String? ?? '',
          speakers: names,
          genders: genders,
          expressions: const [],
          turns: turns,
        ));
      }
    } catch (_) {}
    await _loadNew();
  }

  /// 고정 인물(data/review/uxui/CHARACTERS.md) 목소리 성별. A = 학습자 프로필.
  static const _voice = {'Ayu': 'female', 'Raka': 'male', 'Bu Sri': 'female', 'Pak Darto': 'male', 'Nadia': 'female', 'Dimas': 'male', 'Kasir': 'female'};

  /// 새 회화(일본어앱 구조): assets/data/dialogues/R<레벨>/<주제>/<편id>.json — 2026-11-03.
  Future<void> _loadNew() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths = manifest.listAssets().where((p) => RegExp(r'^assets/data/dialogues/R[0-4]/[^/]+/[^/]+\.json$').hasMatch(p)).toList()..sort();
    for (final p in paths) {
      try {
        final m = json.decode(await rootBundle.loadString(p)) as Map<String, dynamic>;
        final turns = ((m['turns'] as List?) ?? const []).map((t) => DialogueTurn.fromL1(t as Map<String, dynamic>)).toList();
        if (turns.isEmpty) continue;
        final sp = ((m['speakers'] as Map?) ?? const {}).map((k, v) => MapEntry(k.toString(), v.toString()));
        _all.add(Dialogue(
          id: m['id'] as String,
          region: m['region'] as String? ?? 'R1',
          island: m['island'] as String? ?? 'life',
          title: m['title'] as String? ?? '',
          emoji: m['emoji'] as String? ?? '💬',
          scene: m['scene'] as String? ?? '',
          speakers: sp,
          genders: {for (final e in sp.entries) if (_voice.containsKey(e.value)) e.key: _voice[e.value]!},
          expressions: (m['expressions'] as List?)?.cast<String>() ?? const [],
          turns: turns,
        ));
      } catch (_) {}
    }
  }

  Dialogue? byId(String id) => _all.where((d) => d.id == id).firstOrNull;
  List<Dialogue> get all => List.unmodifiable(_all);
  /// 레벨 순서: R0~R4 먼저, 옛 이야기(L1)는 뒤.
  List<String> get regions {
    final r = _all.map((d) => d.region).toSet().toList();
    r.sort((a, b) => (a.startsWith('R') ? a : 'Z$a').compareTo(b.startsWith('R') ? b : 'Z$b'));
    return r;
  }

  List<Dialogue> list({String? region, String? island}) =>
      _all.where((d) => (region == null || d.region == region) && (island == null || d.island == island)).toList();

  List<String> islandsOf(String region) {
    final has = _all.where((d) => d.region == region).map((d) => d.island).toSet();
    return islands.where(has.contains).toList();
  }

  int count(String region) => _all.where((d) => d.region == region).length;
}
