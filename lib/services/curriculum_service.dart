import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import '../core/embed_env.dart';
import '../core/prefs.dart';
import 'dialogue_service.dart';

/// 토크버스 커리큘럼 — 전 언어 공통 기준(`~/talkverse/CURRICULUM_SPEC.md`, 2026-11-22).
///
/// 회화 레벨(R0~R4)에서 학습자가 다이얼로그 3·5·10편을 골라 코스로 묶고 → 편마다 듣기·확인 문제 → 코스 시험 80% 이상이면 통과.
/// 틀린 문제·연습한 줄은 간격 반복(1일 → 3일 → 7일) 복습 대기열에. 하루 목표(새 편 1·2·3 + 복습)와 연속 일수.
/// 저장 = 기기(`curriculum_v1`, 키 이름은 전 언어 같게 — Prefs 가 언어 접두를 붙인다). 서버 동기화는 나중에 uk 가 붙인다.

/// 간격 반복 간격(일). 맞히면 다음 간격, 틀리면 처음(1일)으로. 마지막(7일)을 맞히면 대기열에서 졸업.
const kReviewSteps = [1, 3, 7];

/// 통과 기준(%) — 사용자 원문 「80% 이상이 넘으면 코스가 넘어가고」.
const kPassPercent = 80;

/// 점수 = 정답 수 / 문제 수, 소수점 버림.
int scorePercent(int correct, int total) => total <= 0 ? 0 : (correct * 100) ~/ total;
bool isPass(int correct, int total) => scorePercent(correct, total) >= kPassPercent;

String ymd(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
DateTime parseYmd(String s) {
  final p = s.split('-').map(int.parse).toList();
  return DateTime(p[0], p[1], p[2]);
}
String addDays(String day, int n) {
  final d = parseYmd(day);
  return ymd(DateTime(d.year, d.month, d.day + n));
}

/// 복습 한 줄. lineId = `<편id>#<턴번호>`.
class ReviewItem {
  final String lineId;
  String due; // yyyy-MM-dd
  int step; // kReviewSteps 의 몇 번째 간격까지 왔나
  ReviewItem(this.lineId, this.due, this.step);
  factory ReviewItem.fromJson(Map j) => ReviewItem('${j['lineId']}', '${j['due']}', (j['step'] as num?)?.toInt() ?? 0);
  Map<String, dynamic> toJson() => {'lineId': lineId, 'due': due, 'step': step};
  String get dialogueId => lineId.split('#').first;
  int get turn => int.tryParse(lineId.split('#').last) ?? 0;
}

class Course {
  final String id;
  final List<String> dialogueIds;
  final List<String> practiced;
  final List<int> examScores;
  String? passedAt;
  Course(this.id, this.dialogueIds, {List<String>? practiced, List<int>? examScores, this.passedAt})
      : practiced = practiced ?? [],
        examScores = examScores ?? [];
  factory Course.fromJson(Map j) => Course(
        '${j['id']}',
        [for (final x in (j['dialogueIds'] as List? ?? const [])) '$x'],
        practiced: [for (final x in (j['practiced'] as List? ?? const [])) '$x'],
        examScores: [for (final x in (j['examScores'] as List? ?? const [])) (x as num).toInt()],
        passedAt: j['passedAt'] as String?,
      );
  Map<String, dynamic> toJson() => {'id': id, 'dialogueIds': dialogueIds, 'practiced': practiced, 'examScores': examScores, 'passedAt': passedAt};
  bool get allPracticed => dialogueIds.every(practiced.contains);
  bool get passed => passedAt != null;
}

/// `curriculum_v1` 한 벌. 기준 형식 + `today`(오늘 한 양 — 홈 카드 진행 막대용, 기준 문서에 없는 칸이라 uk 에 알림).
class CurriculumState {
  String? level;
  int dailyGoal; // 새 편 수: 1 가볍게 · 2 보통 · 3 집중
  Course? course;
  final List<String> passedDialogues;
  final List<ReviewItem> review;
  int streakCount;
  String? streakLastDay;
  String? todayDay;
  int todayNew, todayReview;
  /// 하루 목표 단계(1 가볍게·2 보통·3 집중) → 새 편 수. 단계 JSON 의 daily 로 바뀐다(저장하지 않음).
  Map<int, int> dailyMap = const {1: 1, 2: 2, 3: 3};

  CurriculumState({
    this.level,
    this.dailyGoal = 2,
    this.course,
    List<String>? passedDialogues,
    List<ReviewItem>? review,
    this.streakCount = 0,
    this.streakLastDay,
    this.todayDay,
    this.todayNew = 0,
    this.todayReview = 0,
  })  : passedDialogues = passedDialogues ?? [],
        review = review ?? [];

  factory CurriculumState.fromJson(Map j) {
    final st = (j['streak'] as Map?) ?? const {};
    final td = (j['today'] as Map?) ?? const {};
    return CurriculumState(
      level: j['level'] as String?,
      dailyGoal: (j['dailyGoal'] as num?)?.toInt() ?? 2,
      course: j['course'] is Map ? Course.fromJson(j['course'] as Map) : null,
      passedDialogues: [for (final x in (j['passedDialogues'] as List? ?? const [])) '$x'],
      review: [for (final x in (j['review'] as List? ?? const [])) if (x is Map) ReviewItem.fromJson(x)],
      streakCount: (st['count'] as num?)?.toInt() ?? 0,
      streakLastDay: st['lastDay'] as String?,
      todayDay: td['day'] as String?,
      todayNew: (td['new'] as num?)?.toInt() ?? 0,
      todayReview: (td['review'] as num?)?.toInt() ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'level': level,
        'dailyGoal': dailyGoal,
        'course': course?.toJson(),
        'passedDialogues': passedDialogues,
        'review': [for (final r in review) r.toJson()],
        'streak': {'count': streakCount, 'lastDay': streakLastDay},
        'today': {'day': todayDay, 'new': todayNew, 'review': todayReview},
      };

  void _rollDay(String today) {
    if (todayDay == today) return;
    todayDay = today;
    todayNew = 0;
    todayReview = 0;
  }

  /// 오늘 복습할 줄(기한이 오늘이거나 지난 것).
  List<ReviewItem> dueReview(String today) => review.where((r) => r.due.compareTo(today) <= 0).toList();

  /// 오늘 남은 새 편 수.
  int newLeft(String today) => max(0, (dailyMap[dailyGoal] ?? dailyGoal) - (todayDay == today ? todayNew : 0));

  /// 오늘 분량을 다 했나(복습 0 + 새 편 목표 채움).
  bool dayDone(String today) => dueReview(today).isEmpty && newLeft(today) == 0;

  /// 줄을 대기열에 넣는다(이미 있으면 그대로). 내일부터.
  void enqueue(String lineId, String today) {
    if (review.any((r) => r.lineId == lineId)) return;
    review.add(ReviewItem(lineId, addDays(today, kReviewSteps[0]), 0));
  }

  /// 복습·연습 문제 한 개의 결과. 맞히면 다음 간격(마지막을 맞히면 졸업), 틀리면 1일 뒤 처음 간격으로.
  void grade(String lineId, bool correct, String today, {bool countReview = true}) {
    _rollDay(today);
    final i = review.indexWhere((r) => r.lineId == lineId);
    if (countReview && i >= 0 && review[i].due.compareTo(today) <= 0) todayReview++;
    if (!correct) {
      if (i >= 0) {
        review[i]
          ..step = 0
          ..due = addDays(today, kReviewSteps[0]);
      } else {
        review.add(ReviewItem(lineId, addDays(today, kReviewSteps[0]), 0));
      }
      _touchStreak(today);
      return;
    }
    if (i < 0) return _touchStreak(today);
    final next = review[i].step + 1;
    if (next >= kReviewSteps.length) {
      review.removeAt(i);
    } else {
      review[i]
        ..step = next
        ..due = addDays(today, kReviewSteps[next]);
    }
    _touchStreak(today);
  }

  /// 편 연습을 마침 — 코스의 연습 표시 + 오늘 새 편 +1 + 그 편 줄을 대기열에.
  void markPracticed(String dialogueId, Iterable<int> turns, String today) {
    _rollDay(today);
    final c = course;
    if (c != null && c.dialogueIds.contains(dialogueId) && !c.practiced.contains(dialogueId)) {
      c.practiced.add(dialogueId);
      todayNew++;
    }
    for (final t in turns) {
      enqueue('$dialogueId#$t', today);
    }
    _touchStreak(today);
  }

  /// 코스 시험 결과. 통과면 코스 완료·통과 편 기록, 아니면 틀린 편의 연습 표시를 지워 다시 연습하게.
  bool recordExam(int correct, int total, Set<String> wrongDialogues, String today, {int pass = kPassPercent}) {
    final c = course;
    if (c == null) return false;
    final s = scorePercent(correct, total);
    c.examScores.add(s);
    if (s >= pass) {
      c.passedAt = today;
      for (final id in c.dialogueIds) {
        if (!passedDialogues.contains(id)) passedDialogues.add(id);
      }
      return true;
    }
    c.practiced.removeWhere(wrongDialogues.contains);
    return false;
  }

  /// 오늘 분량을 처음 다 했을 때 연속 일수를 올린다(어제도 했으면 +1, 아니면 1).
  void _touchStreak(String today) {
    if (!dayDone(today) || streakLastDay == today) return;
    streakCount = streakLastDay == addDays(today, -1) ? streakCount + 1 : 1;
    streakLastDay = today;
  }

  /// 화면에 보일 연속 일수(어제·오늘 끊기지 않았을 때만).
  int streakShown(String today) => streakLastDay == today || streakLastDay == addDays(today, -1) ? streakCount : 0;
}

/// 확인 문제 한 개.
class CurQuestion {
  final String dialogueId;
  final int turn;
  final String kind; // meaning · blank
  final String prompt; // 보여 줄 줄(빈칸이면 ＿＿ 가 들어간 글)
  final String hint; // 아래 작은 글(뜻 고르기 = 없음, 빈칸 = 우리말 뜻)
  final List<String> choices;
  final int answer;
  const CurQuestion(this.dialogueId, this.turn, this.kind, this.prompt, this.hint, this.choices, this.answer);
  String get lineId => '$dialogueId#$turn';
}

/// 편의 줄로 문제를 만든다 — 뜻 고르기(4지선다)와 빈칸 낱말 고르기를 번갈아. 줄 수만큼, 최대 [limit].
/// [pool] = 오답 보기를 뽑을 다른 편들(같은 레벨). 같은 [seed] 면 같은 문제.
List<CurQuestion> buildQuestions(Dialogue d, {required int limit, List<Dialogue> pool = const [], int seed = 0, Set<int>? onlyTurns}) {
  final rnd = Random(seed ^ d.id.hashCode);
  final turns = d.turns.where((t) => t.tl.trim().isNotEmpty && t.ko.trim().isNotEmpty && (onlyTurns == null || onlyTurns.contains(t.num))).toList()..shuffle(rnd);
  final kos = <String>{for (final t in d.turns) t.ko.trim(), for (final p in pool) for (final t in p.turns) t.ko.trim()}..removeWhere((s) => s.isEmpty);
  final words = <String>{for (final t in d.turns) for (final l in t.lemmas) l.surface, for (final p in pool) for (final t in p.turns) for (final l in t.lemmas) l.surface}
    ..removeWhere((s) => s.trim().isEmpty);
  final out = <CurQuestion>[];
  for (final t in turns) {
    if (out.length >= limit) break;
    final ja = t.tl.replaceAll(RegExp(r"\([^)]*\)"), "").replaceAll(RegExp(r'\{[a-z_]+\}'), '○○');
    final lem = t.lemmas.where((l) => l.surface.length >= 2 && ja.contains(l.surface)).toList();
    if (out.length.isOdd && lem.isNotEmpty && words.length >= 4) {
      final l = lem[rnd.nextInt(lem.length)];
      final wrong = (words.toList()..remove(l.surface)..shuffle(rnd)).take(3).toList();
      final ch = [l.surface, ...wrong]..shuffle(rnd);
      out.add(CurQuestion(d.id, t.num, 'blank', ja.replaceFirst(l.surface, '＿＿'), t.ko, ch, ch.indexOf(l.surface)));
      continue;
    }
    final right = t.ko.trim();
    final wrong = (kos.toList()..remove(right)..shuffle(rnd)).take(3).toList();
    if (wrong.length < 3) continue;
    final ch = [right, ...wrong]..shuffle(rnd);
    out.add(CurQuestion(d.id, t.num, 'meaning', ja, '', ch, ch.indexOf(right)));
  }
  return out;
}

/// 코스 시험 문제 수: 편당 최소 3, 전체 최대 30.
int examPerDialogue(int dialogues) => dialogues <= 0 ? 0 : max(3, min(10, 30 ~/ dialogues));

/// 추천으로 채우기: 아직 통과·선택 안 한 편에서 주제가 겹치지 않게 돌아가며.
List<String> recommend(List<Dialogue> levelList, Set<String> passed, Set<String> picked, int count) {
  final left = levelList.where((d) => !passed.contains(d.id) && !picked.contains(d.id)).toList();
  final byIsland = <String, List<Dialogue>>{};
  for (final d in left) {
    byIsland.putIfAbsent(d.island, () => []).add(d);
  }
  final usedIslands = <String>{
    for (final id in picked)
      for (final d in levelList)
        if (d.id == id) d.island
  };
  final out = <String>[];
  var round = 0;
  while (out.length + picked.length < count && byIsland.values.any((l) => l.length > round)) {
    for (final isl in [...byIsland.keys.where((k) => !usedIslands.contains(k)), ...byIsland.keys.where(usedIslands.contains)]) {
      if (out.length + picked.length >= count) break;
      final l = byIsland[isl]!;
      if (l.length > round) out.add(l[round].id);
    }
    round++;
  }
  return out;
}

class CurriculumService {
  CurriculumService._();
  static final CurriculumService instance = CurriculumService._();
  static const key = 'curriculum_v1';

  CurriculumState state = CurriculumState();
  bool _loaded = false;
  final ValueNotifier<int> changed = ValueNotifier(0);

  /// 테스트에서 날짜를 고정할 때.
  @visibleForTesting
  DateTime Function() now = DateTime.now;
  String get today => ymd(now());

  /// 단계 목록(§12, 11-23) — 서버 `GET /api/curriculum/id` 가 앱 묶음(`assets/curriculum_id.json`)보다 rev 가 높으면 그것. 읽기 실패면 회화 레벨(R) 그대로.
  List<CurStage> stages = const [];
  int contentRev = -1;
  static const contentUrl = 'https://talkverse.uk/api/curriculum/id';
  static const _contentKey = 'curriculum_content';

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    await DialogueService.instance.ensureLoaded();
    final p = await Prefs.getInstance();
    final raw = p.getString(key);
    if (raw != null) {
      try {
        state = CurriculumState.fromJson(json.decode(raw) as Map);
      } catch (_) {}
    }
    Map<String, dynamic>? content;
    try {
      content = json.decode(await rootBundle.loadString(assetPath('assets/curriculum_id.json'))) as Map<String, dynamic>;
    } catch (_) {}
    try {
      final c = p.getString(_contentKey);
      if (c != null) {
        final m = json.decode(c) as Map<String, dynamic>;
        if (((m['rev'] as num?) ?? 0) > ((content?['rev'] as num?) ?? -1)) content = m;
      }
    } catch (_) {}
    _apply(content);
    _loaded = true;
    _fetch(); // 뒤에서 서버 판 확인(기다리지 않음)
  }

  void _apply(Map<String, dynamic>? content) {
    final st = content == null ? <CurStage>[] : parseStages(content, DialogueService.instance.byId);
    stages = st.isNotEmpty ? st : regionStages();
    contentRev = st.isNotEmpty ? ((content!['rev'] as num?)?.toInt() ?? 0) : -1;
    final lv = state.level;
    if (lv != null && stages.every((s) => s.key != lv)) state.level = migrateLevel(lv, stages);
    syncDaily();
  }

  Future<void> _fetch() async {
    try {
      final r = await http.get(Uri.parse(contentUrl)).timeout(const Duration(seconds: 8));
      if (r.statusCode != 200) return;
      final m = json.decode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
      if (((m['rev'] as num?) ?? 0) <= contentRev) return;
      if (parseStages(m, DialogueService.instance.byId).isEmpty) return;
      await (await Prefs.getInstance()).setString(_contentKey, json.encode(m));
      _apply(m);
      changed.value++;
    } catch (_) {}
  }

  Future<void> save() async {
    await (await Prefs.getInstance()).setString(key, json.encode(state.toJson()));
    changed.value++;
  }

  CurStage? stageOf(String? key) => stages.where((s) => s.key == (key ?? state.level)).firstOrNull;
  String stageTitle(String key) => stageOf(key)?.title ?? key;
  /// 지금 단계의 고를 개수·통과 점수·하루 새 편 수(단계 JSON, 없으면 기본 3·5·10 / 80 / 1·2·3).
  List<int> get pick => stageOf(null)?.pick ?? const [3, 5, 10];
  int get pass => stageOf(null)?.pass ?? kPassPercent;
  void syncDaily() => state.dailyMap = stageOf(null)?.daily ?? const {1: 1, 2: 2, 3: 3};

  List<Dialogue> levelList([String? level]) {
    final st = stageOf(level);
    return st == null ? const [] : [for (final id in st.ids) DialogueService.instance.byId(id)].whereType<Dialogue>().toList();
  }

  /// 오답 보기를 뽑을 편들 — 그 편이 든 단계(없으면 같은 회화 레벨).
  List<Dialogue> poolFor(Dialogue d) {
    final st = stages.where((s) => s.ids.contains(d.id)).firstOrNull;
    return st == null ? DialogueService.instance.list(region: d.region) : levelList(st.key);
  }

  /// 단계의 편을 모두 통과했나.
  bool levelDone(String level) {
    final l = levelList(level);
    return l.isNotEmpty && l.every((d) => state.passedDialogues.contains(d.id));
  }

  /// 다음 단계(편이 있는 것), 없으면 null.
  String? nextLevel(String level) {
    final i = stages.indexWhere((s) => s.key == level);
    return i >= 0 && i + 1 < stages.length ? stages[i + 1].key : null;
  }

  Future<void> startCourse(List<String> ids) async {
    state.course = Course('c${now().millisecondsSinceEpoch}', ids);
    await save();
  }
}

/// 커리큘럼 단계 하나 — key 는 단계 번호('1'~'5', 서버 판) 또는 회화 레벨('R1', 서버·묶음을 못 읽었을 때).
class CurStage {
  final String key, title, desc;
  final List<String> ids;
  final List<int> pick; // 고를 개수
  final int pass; // 통과 점수(%)
  final Map<int, int> daily; // 하루 목표 1·2·3 → 새 편 수
  const CurStage(this.key, this.title, this.desc, this.ids, {this.pick = const [3, 5, 10], this.pass = kPassPercent, this.daily = const {1: 1, 2: 2, 3: 3}});
}

/// 서버·묶음 JSON → 단계. 앱에 없는 편 id 는 건너뛰고, 편이 0개인 단계는 숨긴다.
List<CurStage> parseStages(Map<String, dynamic> j, Dialogue? Function(String) byId) {
  final out = <CurStage>[];
  final raw = j['stages'];
  if (raw is! List) return out;
  for (final s in raw) {
    if (s is! Map || s['dialogueIds'] is! List) continue;
    final ids = [for (final x in s['dialogueIds'] as List) '$x'].where((id) => byId(id) != null).toList();
    if (ids.isEmpty) continue;
    final n = '${s['n']}';
    final pick = s['pick'] is List ? [for (final x in s['pick'] as List) if (x is num && x > 0) x.toInt()] : <int>[];
    final d = s['daily'] is Map ? s['daily'] as Map : const {};
    int dn(String k, int def) => d[k] is num && (d[k] as num) > 0 ? (d[k] as num).toInt() : def;
    out.add(CurStage(n, '${s['title'] ?? '$n단계'}', '${s['desc'] ?? ''}', ids,
        pick: pick.isEmpty ? const [3, 5, 10] : pick,
        pass: s['pass'] is num && (s['pass'] as num) > 0 && (s['pass'] as num) <= 100 ? (s['pass'] as num).toInt() : kPassPercent,
        daily: {1: dn('light', 1), 2: dn('normal', 2), 3: dn('focus', 3)}));
  }
  return out;
}

/// 단계 JSON 을 못 읽었을 때: 회화 레벨(R0~R5) 그대로.
List<CurStage> regionStages() => [
      for (final r in DialogueService.levels)
        if (DialogueService.instance.count(r) > 0)
          CurStage(r, '$r ${DialogueService.levelKo[r] ?? ''}'.trim(), '', [for (final d in DialogueService.instance.list(region: r)) d.id]),
    ];

/// 옛 진도의 레벨 값(R0~R5) → 단계(기본 대응 R0·R1 → 1, Rn → n). 맞는 단계가 없으면 첫 단계.
String? migrateLevel(String lv, List<CurStage> stages) {
  if (stages.isEmpty) return null;
  final m = RegExp(r'^R(\d)$').firstMatch(lv);
  if (m != null) {
    final n = max(1, int.parse(m.group(1)!)).toString();
    if (stages.any((s) => s.key == n)) return n;
  }
  return stages.first.key;
}
