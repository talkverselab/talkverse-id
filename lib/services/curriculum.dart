import 'dart:convert';
import 'dart:math';

import '../core/prefs.dart';
import 'dialogue_service.dart';

/// 토크버스 커리큘럼(전 언어 공통 기준 ~/talkverse/CURRICULUM_SPEC.md, 2026-11-22).
/// 회화 레벨에서 편을 골라 코스 → 편마다 연습·확인 문제 → 간격 반복 복습(1·3·7일) → 코스 시험 80% 이상이면 통과.
/// 저장 키 `curriculum_v1`(전 언어 같게). 형식은 문서 §7 + 오늘 분량 칸 `today`.

const passPercent = 80;
const reviewSteps = [1, 3, 7]; // 일
const goalNew = {'light': 1, 'normal': 2, 'focus': 3};

String dayOf(DateTime t) => '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}';
String addDays(String day, int n) => dayOf(DateTime.parse(day).add(Duration(days: n)));

/// 점수 = 정답 수 / 문제 수(백분율, 소수점 버림).
int scoreOf(int correct, int total) => total == 0 ? 0 : (correct * 100) ~/ total;
bool passed(int score) => score >= passPercent;

class ReviewItem {
  final String lineId; // <편id>#<턴번호>
  String due;
  int step; // reviewSteps 의 자리
  ReviewItem(this.lineId, this.due, this.step);
  Map<String, dynamic> toJson() => {'lineId': lineId, 'due': due, 'step': step};
  factory ReviewItem.fromJson(Map<String, dynamic> j) => ReviewItem(j['lineId'] as String, j['due'] as String, (j['step'] as num?)?.toInt() ?? 0);
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
  bool get allPracticed => dialogueIds.every(practiced.contains);
  Map<String, dynamic> toJson() => {'id': id, 'dialogueIds': dialogueIds, 'practiced': practiced, 'examScores': examScores, 'passedAt': passedAt};
  factory Course.fromJson(Map<String, dynamic> j) => Course(
        j['id'] as String,
        (j['dialogueIds'] as List).cast<String>(),
        practiced: (j['practiced'] as List? ?? const []).cast<String>().toList(),
        examScores: (j['examScores'] as List? ?? const []).map((e) => (e as num).toInt()).toList(),
        passedAt: j['passedAt'] as String?,
      );
}

class CurriculumState {
  String? level;
  String dailyGoal = 'normal';
  Course? course;
  final Set<String> passedDialogues = {};
  final List<ReviewItem> review = [];
  int streakCount = 0;
  String? streakLastDay;
  // 오늘 분량(문서 §6) — 날짜가 바뀌면 0 으로.
  String? todayDay;
  int todayNew = 0, todayReview = 0;

  Map<String, dynamic> toJson() => {
        'level': level,
        'dailyGoal': dailyGoal,
        'course': course?.toJson(),
        'passedDialogues': passedDialogues.toList(),
        'review': [for (final r in review) r.toJson()],
        'streak': {'count': streakCount, 'lastDay': streakLastDay},
        'today': {'day': todayDay, 'newDone': todayNew, 'reviewDone': todayReview},
      };

  static CurriculumState fromJson(Map<String, dynamic> j) {
    final s = CurriculumState()
      ..level = j['level'] as String?
      ..dailyGoal = j['dailyGoal'] as String? ?? 'normal'
      ..course = j['course'] is Map ? Course.fromJson((j['course'] as Map).cast<String, dynamic>()) : null;
    s.passedDialogues.addAll((j['passedDialogues'] as List? ?? const []).cast<String>());
    s.review.addAll([for (final r in (j['review'] as List? ?? const [])) ReviewItem.fromJson((r as Map).cast<String, dynamic>())]);
    final st = (j['streak'] as Map?) ?? const {};
    s.streakCount = (st['count'] as num?)?.toInt() ?? 0;
    s.streakLastDay = st['lastDay'] as String?;
    final td = (j['today'] as Map?) ?? const {};
    s.todayDay = td['day'] as String?;
    s.todayNew = (td['newDone'] as num?)?.toInt() ?? 0;
    s.todayReview = (td['reviewDone'] as num?)?.toInt() ?? 0;
    return s;
  }

  int get newGoal => goalNew[dailyGoal] ?? 2;

  void rollDay(String today) {
    if (todayDay == today) return;
    todayDay = today;
    todayNew = 0;
    todayReview = 0;
  }

  List<ReviewItem> dueOn(String today) => review.where((r) => r.due.compareTo(today) <= 0).toList();

  /// 연습한 편의 줄을 복습 대기열에(이미 있으면 그대로). 틀린 줄은 1일 뒤로 되돌린다.
  void enqueueLines(Iterable<String> lineIds, String today) {
    for (final id in lineIds) {
      if (review.any((r) => r.lineId == id)) continue;
      review.add(ReviewItem(id, addDays(today, reviewSteps[0]), 0));
    }
  }

  /// 간격 반복: 맞히면 다음 간격(마지막 7일 뒤도 맞히면 대기열에서 뺀다), 틀리면 1일로.
  void answerReview(String lineId, bool correct, String today) {
    final i = review.indexWhere((r) => r.lineId == lineId);
    if (!correct) {
      if (i < 0) {
        review.add(ReviewItem(lineId, addDays(today, reviewSteps[0]), 0));
      } else {
        review[i]
          ..step = 0
          ..due = addDays(today, reviewSteps[0]);
      }
      return;
    }
    if (i < 0) return;
    final next = review[i].step + 1;
    if (next >= reviewSteps.length) {
      review.removeAt(i);
    } else {
      review[i]
        ..step = next
        ..due = addDays(today, reviewSteps[next]);
    }
  }

  /// 오늘 분량을 다 했으면 연속 일수를 올린다(하루 한 번).
  bool markDoneIfComplete(String today, {required int newLeft}) {
    final done = dueOn(today).isEmpty && (todayNew >= newGoal || newLeft == 0) && (todayNew + todayReview) > 0;
    if (!done || streakLastDay == today) return done;
    streakCount = streakLastDay == addDays(today, -1) ? streakCount + 1 : 1;
    streakLastDay = today;
    return true;
  }

  /// 시험 결과 반영. 통과면 코스 완료·편 통과, 아니면 틀린 편의 연습 표시를 지운다.
  void applyExam(int score, Set<String> wrongDialogues, String today) {
    final c = course;
    if (c == null) return;
    c.examScores.add(score);
    if (passed(score)) {
      c.passedAt = today;
      passedDialogues.addAll(c.dialogueIds);
    } else {
      c.practiced.removeWhere(wrongDialogues.contains);
    }
  }
}

/// 확인 문제 한 개 — 뜻 고르기(인니어 줄 → 한국어 뜻) 또는 빈칸 낱말 고르기.
class Question {
  final String lineId, dialogueId, kind; // kind: meaning | blank
  final int turn;
  final String prompt;
  final List<String> choices;
  final int answer;
  const Question({required this.lineId, required this.dialogueId, required this.turn, required this.kind, required this.prompt, required this.choices, required this.answer});
}

String _clean(String s) => s.replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'\{name\}'), '…').replaceAll(RegExp(r'\{[a-z_]+\}'), '').trim();
List<String> _words(String s) => RegExp(r"[A-Za-z][A-Za-z'-]{2,}").allMatches(_clean(s)).map((m) => m.group(0)!).toList();

/// 편의 줄로 문제를 만든다. [pool] = 오답 보기를 뽑을 다른 편들. 최대 [max] 문제.
List<Question> questionsFor(Dialogue d, {required List<Dialogue> pool, int max = 10, Random? rnd, Iterable<int>? onlyTurns}) {
  final r = rnd ?? Random();
  final otherKo = <String>{for (final o in [d, ...pool]) for (final t in o.turns) if (t.ko.trim().isNotEmpty) t.ko.trim()}.toList();
  final otherWords = <String>{for (final o in [d, ...pool]) for (final t in o.turns) ..._words(t.tl).map((w) => w.toLowerCase())}.toList();
  final turns = d.turns.where((t) => t.ko.trim().isNotEmpty && _clean(t.tl).isNotEmpty && (onlyTurns == null || onlyTurns.contains(t.num))).toList()..shuffle(r);
  final out = <Question>[];
  for (final t in turns) {
    if (out.length >= max) break;
    final words = _words(t.tl);
    final blank = out.length.isOdd && words.isNotEmpty && otherWords.length >= 4;
    if (blank) {
      final w = words[r.nextInt(words.length)];
      final wrong = (otherWords.where((x) => x != w.toLowerCase()).toList()..shuffle(r)).take(3).toList();
      final choices = [w.toLowerCase(), ...wrong]..shuffle(r);
      out.add(Question(
        lineId: '${d.id}#${t.num}', dialogueId: d.id, turn: t.num, kind: 'blank',
        prompt: '${_clean(t.tl).replaceFirst(RegExp('\\b${RegExp.escape(w)}\\b'), '_____')}\n${t.ko.trim()}',
        choices: choices, answer: choices.indexOf(w.toLowerCase()),
      ));
    } else {
      if (otherKo.length < 4) continue;
      final ko = t.ko.trim();
      final wrong = (otherKo.where((x) => x != ko).toList()..shuffle(r)).take(3).toList();
      final choices = [ko, ...wrong]..shuffle(r);
      out.add(Question(lineId: '${d.id}#${t.num}', dialogueId: d.id, turn: t.num, kind: 'meaning', prompt: _clean(t.tl), choices: choices, answer: choices.indexOf(ko)));
    }
  }
  return out;
}

/// 코스 시험 문제 수: 편당 최소 3, 합계 최대 30.
int examPerDialogue(int n) => n == 0 ? 0 : max(3, min(10, 30 ~/ n));

/// 「추천으로 채우기」 — 아직 통과하지 않은 편에서 주제가 겹치지 않게 먼저 고르고, 모자라면 나머지에서.
List<String> recommend(List<Dialogue> level, Set<String> passed, int n, {List<String> keep = const []}) {
  final out = [...keep];
  final fresh = level.where((d) => !passed.contains(d.id) && !out.contains(d.id)).toList();
  final seen = <String>{for (final id in out) level.firstWhere((d) => d.id == id, orElse: () => level.first).island};
  for (final d in fresh) {
    if (out.length >= n) break;
    if (seen.add(d.island)) out.add(d.id);
  }
  for (final d in fresh) {
    if (out.length >= n) break;
    if (!out.contains(d.id)) out.add(d.id);
  }
  return out.take(n).toList();
}

class Curriculum {
  Curriculum._();
  static final Curriculum instance = Curriculum._();
  static const key = 'curriculum_v1';

  CurriculumState? _s;
  Future<CurriculumState> load() async {
    if (_s != null) return _s!;
    final raw = (await Prefs.getInstance()).getString(key);
    try {
      _s = raw == null ? CurriculumState() : CurriculumState.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      _s = CurriculumState();
    }
    _s!.rollDay(dayOf(DateTime.now()));
    return _s!;
  }

  Future<void> save() async {
    final s = _s;
    if (s == null) return;
    await (await Prefs.getInstance()).setString(key, json.encode(s.toJson()));
  }

  /// 테스트용.
  void resetForTest() => _s = null;
}
