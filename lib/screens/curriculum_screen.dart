import 'dart:math';

import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/pane.dart';
import '../core/theme.dart';
import '../services/curriculum.dart';
import '../services/dialogue_audio.dart';
import '../services/dialogue_service.dart';
import 'dialogue_screen.dart';

/// 토크버스 커리큘럼 — 전 언어 공통 기준 ~/talkverse/CURRICULUM_SPEC.md(2026-11-22).
/// 레벨 고르기 → 편 골라 코스 → 편마다 듣기·확인 문제 → 복습(1·3·7일) → 코스 시험 80% 이상 통과.
class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});
  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

String _today() => dayOf(DateTime.now());

class _CurriculumScreenState extends State<CurriculumScreen> {
  CurriculumState? _s;
  final _svc = DialogueService.instance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _svc.ensureLoaded();
    final s = await Curriculum.instance.load();
    s.rollDay(_today());
    if (mounted) setState(() => _s = s);
  }

  List<String> get _levels => _svc.regions.where((r) => r.startsWith('R')).toList();
  List<Dialogue> _levelDialogues(String lv) => _svc.list(region: lv);

  int _newLeft(CurriculumState s) {
    final c = s.course;
    if (c == null || c.passedAt != null) return 0;
    return c.dialogueIds.where((id) => !c.practiced.contains(id)).length;
  }

  Future<void> _save() async {
    await Curriculum.instance.save();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    return Scaffold(
      backgroundColor: AppColors.gadingDeep,
      appBar: AppBar(title: Text(tr('토크버스 커리큘럼')), backgroundColor: AppColors.gading, foregroundColor: AppColors.kayu, elevation: 0),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : s.level == null
              ? _levelPick(s)
              : _main(s),
    );
  }

  // ── 레벨 고르기(처음) ──
  Widget _levelPick(CurriculumState s) {
    final lv = _levels;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text(tr('어느 회화 레벨부터 할까요?'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.kayu)),
      const SizedBox(height: 6),
      Text(tr('처음이라면 가장 낮은 레벨을 권해요. 레벨은 나중에 바꿀 수 있어요.'), style: const TextStyle(fontSize: 13, color: AppColors.kayuLight)),
      const SizedBox(height: 14),
      for (final (i, r) in lv.indexed)
        Card(
          key: ValueKey('cur-level-$r'),
          elevation: 0,
          color: AppColors.gading,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.line)),
          child: ListTile(
            title: Text('$r · ${tr(DialogueService.levelKo[r] ?? r)}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.kayu)),
            subtitle: Text(trf('회화 {0}편', [_svc.count(r)])),
            trailing: i == 0 ? Chip(label: Text(tr('추천')), backgroundColor: AppColors.merah.withValues(alpha: 0.12)) : const Icon(Icons.chevron_right),
            onTap: () {
              s.level = r;
              _save();
            },
          ),
        ),
    ]);
  }

  // ── 메인 ──
  Widget _main(CurriculumState s) {
    final today = _today();
    final due = s.dueOn(today);
    final c = s.course;
    final newLeft = _newLeft(s);
    final newTarget = min(s.newGoal, s.todayNew + newLeft);
    final total = due.length + s.todayReview + newTarget;
    final doneN = s.todayReview + min(s.todayNew, newTarget);
    final finished = s.markDoneIfComplete(today, newLeft: newLeft);
    final lvAll = _levelDialogues(s.level!);
    final lvPassed = lvAll.where((d) => s.passedDialogues.contains(d.id)).length;
    final levels = _levels;
    final li = levels.indexOf(s.level!);
    final nextLevel = (lvAll.isNotEmpty && lvPassed == lvAll.length && li >= 0 && li + 1 < levels.length) ? levels[li + 1] : null;

    return ListView(padding: const EdgeInsets.all(16), children: [
      // 오늘 분량
      _box(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(trf('오늘: 복습 {0} · 새 편 {1}', [due.length, max(0, newTarget - s.todayNew)]), key: const ValueKey('cur-today'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.kayu))),
          if (s.streakCount > 0) Text(trf('🔥 {0}일 연속', [s.streakCount]), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.beni)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: total == 0 ? 0 : doneN / total, minHeight: 8, backgroundColor: AppColors.line, color: AppColors.merah)),
        if (finished) ...[const SizedBox(height: 8), Text(tr('오늘 분량 끝 🎉'), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.matcha))],
        const SizedBox(height: 10),
        Wrap(spacing: 6, children: [
          for (final g in const ['light', 'normal', 'focus'])
            ChoiceChip(
              key: ValueKey('cur-goal-$g'),
              label: Text(trf({'light': '가볍게 {0}편', 'normal': '보통 {0}편', 'focus': '집중 {0}편'}[g]!, [goalNew[g]!])),
              selected: s.dailyGoal == g,
              onSelected: (_) {
                s.dailyGoal = g;
                _save();
              },
            ),
        ]),
        if (due.isNotEmpty) ...[
          const SizedBox(height: 10),
          FilledButton.icon(key: const ValueKey('cur-review'), onPressed: () => _review(s, due), icon: const Icon(Icons.replay), label: Text(trf('복습 {0}줄 하기', [min(due.length, 20)]))),
        ],
      ])),
      const SizedBox(height: 14),
      // 레벨
      Row(children: [
        Text(tr('레벨'), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.kayu)),
        const SizedBox(width: 10),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final r in levels)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text('$r ${tr(DialogueService.levelKo[r] ?? '')}'),
                    selected: s.level == r,
                    onSelected: (_) {
                      s.level = r;
                      _save();
                    },
                  ),
                ),
            ]),
          ),
        ),
      ]),
      const SizedBox(height: 4),
      Text(trf('이 레벨 통과 {0} / {1}편', [lvPassed, lvAll.length]), style: const TextStyle(fontSize: 12, color: AppColors.kayuLight)),
      if (nextLevel != null) ...[
        const SizedBox(height: 8),
        _box(Row(children: [
          Expanded(child: Text(trf('{0} 레벨을 모두 통과했어요. {1} 레벨이 열렸어요.', [s.level!, nextLevel]), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.matcha))),
          TextButton(
            onPressed: () {
              s.level = nextLevel;
              _save();
            },
            child: Text(tr('다음 레벨로')),
          ),
        ])),
      ],
      const SizedBox(height: 14),
      // 코스
      if (c == null || c.passedAt != null || !c.dialogueIds.every((id) => _svc.byId(id) != null)) ...[
        if (c != null && c.passedAt != null) _box(Text(trf('지난 코스 통과 — 시험 {0}점', [c.examScores.isEmpty ? 0 : c.examScores.last]), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.matcha))),
        const SizedBox(height: 10),
        FilledButton.icon(key: const ValueKey('cur-new-course'), onPressed: () => _setup(s), icon: const Icon(Icons.add), label: Text(tr('코스 만들기 — 회화 고르기'))),
      ] else
        _courseView(s, c),
    ]);
  }

  Widget _courseView(CurriculumState s, Course c) {
    final ds = [for (final id in c.dialogueIds) _svc.byId(id)!];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        Expanded(child: Text(trf('지금 코스 · {0}편', [ds.length]), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.kayu))),
        TextButton(onPressed: () => _setup(s), child: Text(tr('새 코스'))),
      ]),
      for (final d in ds)
        Card(
          elevation: 0,
          color: AppColors.gading,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.line)),
          child: ListTile(
            leading: Text(d.emoji, style: const TextStyle(fontSize: 22)),
            title: Text(d.title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.kayu)),
            subtitle: Text(c.practiced.contains(d.id) ? tr('연습 끝') : tr('연습 전')),
            trailing: c.practiced.contains(d.id) ? const Icon(Icons.check_circle, color: AppColors.matcha) : const Icon(Icons.play_circle_outline, color: AppColors.merah),
            onTap: () => _practice(s, d),
          ),
        ),
      const SizedBox(height: 10),
      if (c.examScores.isNotEmpty) Text(trf('지난 시험 {0}점 — 80점 넘으면 통과', [c.examScores.last]), style: const TextStyle(fontSize: 12, color: AppColors.kayuLight)),
      const SizedBox(height: 6),
      FilledButton.icon(
        key: const ValueKey('cur-exam'),
        onPressed: c.allPracticed ? () => _exam(s, c, ds) : null,
        icon: const Icon(Icons.flag),
        label: Text(c.allPracticed ? tr('코스 시험 보기') : tr('모든 편을 연습하면 시험이 열려요')),
      ),
    ]);
  }

  Widget _box(Widget child) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.gading, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.line)),
        child: child,
      );

  // ── 동작 ──
  Future<void> _setup(CurriculumState s) async {
    final ids = await openPane<List<String>>(context, (_) => CourseSetupScreen(level: s.level!, state: s));
    if (ids == null || ids.isEmpty) return;
    s.course = Course(DateTime.now().millisecondsSinceEpoch.toString(), ids);
    await _save();
  }

  Future<void> _practice(CurriculumState s, Dialogue d) async {
    final res = await openPane<QuizResult>(context, (_) => PracticeScreen(dialogue: d));
    if (res == null) return;
    final c = s.course!;
    final today = _today();
    if (!c.practiced.contains(d.id)) {
      c.practiced.add(d.id);
      s.todayNew++;
    }
    s.enqueueLines([for (final t in d.turns) '${d.id}#${t.num}'], today);
    for (final e in res.answers.entries) {
      if (!e.value) s.answerReview(e.key, false, today);
    }
    await _save();
  }

  Future<void> _review(CurriculumState s, List<ReviewItem> due) async {
    final pick = due.take(20).toList();
    final byDialogue = <String, List<int>>{};
    for (final r in pick) {
      final p = r.lineId.split('#');
      if (p.length != 2) continue;
      byDialogue.putIfAbsent(p[0], () => []).add(int.tryParse(p[1]) ?? -1);
    }
    final qs = <Question>[];
    final today = _today();
    for (final e in byDialogue.entries) {
      final d = _svc.byId(e.key);
      if (d == null) {
        s.review.removeWhere((r) => r.lineId.startsWith('${e.key}#')); // 원고에서 빠진 편
        continue;
      }
      final got = questionsFor(d, pool: _svc.list(region: d.region), max: e.value.length, onlyTurns: e.value);
      qs.addAll(got);
      final has = got.map((q) => q.turn).toSet();
      for (final t in e.value.where((t) => !has.contains(t))) {
        s.review.removeWhere((r) => r.lineId == '${e.key}#$t'); // 문제로 만들 수 없는 줄(뜻 없음)
      }
    }
    if (qs.isEmpty) {
      await _save();
      return;
    }
    qs.shuffle();
    if (!mounted) return;
    final res = await openPane<QuizResult>(context, (_) => QuizScreen(title: tr('복습'), questions: qs));
    if (res == null) return;
    for (final e in res.answers.entries) {
      s.answerReview(e.key, e.value, today);
    }
    s.todayReview += res.answers.length;
    await _save();
  }

  Future<void> _exam(CurriculumState s, Course c, List<Dialogue> ds) async {
    final per = examPerDialogue(ds.length);
    final qs = <Question>[for (final d in ds) ...questionsFor(d, pool: _svc.list(region: d.region), max: per)]..shuffle();
    final res = await openPane<QuizResult>(context, (_) => QuizScreen(title: tr('코스 시험'), questions: qs));
    if (res == null) return;
    final correct = res.answers.values.where((v) => v).length;
    final score = scoreOf(correct, res.answers.length);
    final wrongD = <String>{for (final q in qs) if (res.answers[q.lineId] == false) q.dialogueId};
    final today = _today();
    s.applyExam(score, wrongD, today);
    for (final e in res.answers.entries) {
      if (!e.value) s.answerReview(e.key, false, today);
    }
    await _save();
    if (!mounted) return;
    await openPane<void>(context, (_) => ExamResultScreen(score: score, passed: passed(score), wrong: [for (final id in wrongD) _svc.byId(id)?.title ?? id]));
  }
}

/// 코스 만들기 — 개수(3·5·10) 고르기, 회화 고르기, 추천으로 채우기. 지금 코스가 있으면 버릴지 화면 안에서 묻는다.
class CourseSetupScreen extends StatefulWidget {
  final String level;
  final CurriculumState state;
  const CourseSetupScreen({super.key, required this.level, required this.state});
  @override
  State<CourseSetupScreen> createState() => _CourseSetupScreenState();
}

class _CourseSetupScreenState extends State<CourseSetupScreen> {
  int _n = 5;
  final List<String> _picked = [];
  bool _asking = false;

  List<Dialogue> get _all => DialogueService.instance.list(region: widget.level);

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final active = s.course != null && s.course!.passedAt == null;
    return Scaffold(
      backgroundColor: AppColors.gadingDeep,
      appBar: AppBar(title: Text(trf('{0} 코스 만들기', [widget.level])), backgroundColor: AppColors.gading, foregroundColor: AppColors.kayu, elevation: 0),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(children: [
            Text(tr('몇 편?'), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.kayu)),
            const SizedBox(width: 10),
            for (final n in const [3, 5, 10])
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text('$n'),
                  selected: _n == n,
                  onSelected: (_) => setState(() {
                    _n = n;
                    while (_picked.length > n) {
                      _picked.removeLast();
                    }
                  }),
                ),
              ),
            const Spacer(),
            TextButton(
              key: const ValueKey('cur-recommend'),
              onPressed: () => setState(() {
                final r = recommend(_all, s.passedDialogues, _n, keep: _picked);
                _picked
                  ..clear()
                  ..addAll(r);
              }),
              child: Text(tr('추천으로 채우기')),
            ),
          ]),
        ),
        Expanded(
          child: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
            for (final d in _all)
              CheckboxListTile(
                value: _picked.contains(d.id),
                onChanged: (v) => setState(() {
                  if (v == true && _picked.length < _n) _picked.add(d.id);
                  if (v == false) _picked.remove(d.id);
                }),
                secondary: Text(d.emoji, style: const TextStyle(fontSize: 20)),
                title: Text(d.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text('${tr(DialogueService.islandKo[d.island] ?? d.island)}${s.passedDialogues.contains(d.id) ? ' · ${tr('통과')}' : ''}'),
              ),
          ]),
        ),
        if (_asking)
          Container(
            key: const ValueKey('cur-replace-ask'),
            color: AppColors.gading,
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(tr('지금 코스를 버리고 새로 시작할까요? 연습 표시는 지워지고, 복습할 줄은 남아요.'), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.kayu)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () => setState(() => _asking = false), child: Text(tr('취소')))),
                const SizedBox(width: 10),
                Expanded(child: FilledButton(onPressed: () => Navigator.of(context).pop(List<String>.from(_picked)), child: Text(tr('버리고 시작')))),
              ]),
            ]),
          )
        else
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const ValueKey('cur-start'),
                  onPressed: _picked.isEmpty
                      ? null
                      : () {
                          if (active) {
                            setState(() => _asking = true);
                          } else {
                            Navigator.of(context).pop(List<String>.from(_picked));
                          }
                        },
                  child: Text(trf('{0}편으로 시작 ({1}/{2})', [_picked.length, _picked.length, _n])),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}

/// 편 연습 — 1. 듣기·읽기(회화 화면: 줄마다 뜻·다시 듣기) 2. 따라 말하기(같은 화면에서 줄 반복) 3. 확인 문제.
class PracticeScreen extends StatelessWidget {
  final Dialogue dialogue;
  const PracticeScreen({super.key, required this.dialogue});

  @override
  Widget build(BuildContext context) {
    final d = dialogue;
    Widget step(String n, String title, String sub, VoidCallback onTap, {Key? key}) => Card(
          key: key,
          elevation: 0,
          color: AppColors.gading,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.line)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.merah.withValues(alpha: 0.12), child: Text(n, style: const TextStyle(color: AppColors.merah, fontWeight: FontWeight.w800))),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.kayu)),
            subtitle: Text(sub),
            onTap: onTap,
          ),
        );
    return Scaffold(
      backgroundColor: AppColors.gadingDeep,
      appBar: AppBar(title: Text(d.title), backgroundColor: AppColors.gading, foregroundColor: AppColors.kayu, elevation: 0),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        step('1', tr('듣기·읽기'), tr('회화 전체를 듣고 줄마다 뜻을 봐요'), () => openFull(context, (_) => DialogueScreen(dialogue: d))),
        step('2', tr('따라 말하기 (선택)'), tr('회화 화면에서 줄을 눌러 반복해 들어요 — 점수에는 안 들어가요'), () => openFull(context, (_) => DialogueScreen(dialogue: d))),
        step('3', tr('확인 문제'), tr('줄 뜻·빈칸 낱말 고르기, 최대 10문제'), () async {
          final qs = questionsFor(d, pool: DialogueService.instance.list(region: d.region));
          final res = await openPane<QuizResult>(context, (_) => QuizScreen(title: d.title, questions: qs, dialogue: d));
          if (res != null && context.mounted) Navigator.of(context).pop(res);
        }, key: const ValueKey('cur-quiz')),
      ]),
    );
  }
}

class QuizResult {
  final Map<String, bool> answers; // lineId → 맞음
  const QuizResult(this.answers);
}

/// 4지선다 문제 화면. 끝나면 결과를 돌려준다.
class QuizScreen extends StatefulWidget {
  final String title;
  final List<Question> questions;
  final Dialogue? dialogue;
  const QuizScreen({super.key, required this.title, required this.questions, this.dialogue});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _i = 0;
  int? _chosen;
  final Map<String, bool> _ans = {};

  @override
  void dispose() {
    DialogueAudio.instance.stop();
    super.dispose();
  }

  void _speak(Question q) {
    final d = widget.dialogue ?? DialogueService.instance.byId(q.dialogueId);
    final t = d?.turns.where((t) => t.num == q.turn).firstOrNull;
    if (d != null && t != null) speakTurn(d, t);
  }

  @override
  Widget build(BuildContext context) {
    final qs = widget.questions;
    if (qs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(tr('이 편으로는 문제를 만들 수 없어요.')),
            const SizedBox(height: 10),
            FilledButton(onPressed: () => Navigator.of(context).pop(const QuizResult({})), child: Text(tr('연습 끝으로 표시'))),
          ]),
        ),
      );
    }
    final q = qs[_i];
    final answered = _chosen != null;
    return Scaffold(
      backgroundColor: AppColors.gadingDeep,
      appBar: AppBar(title: Text('${widget.title}  ${_i + 1}/${qs.length}'), backgroundColor: AppColors.gading, foregroundColor: AppColors.kayu, elevation: 0),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(q.kind == 'blank' ? tr('빈칸에 들어갈 낱말은?') : tr('이 줄의 뜻은?'), style: const TextStyle(fontSize: 13, color: AppColors.kayuLight, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.gading, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.line)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Text(q.prompt, key: const ValueKey('cur-q-prompt'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.kayu, height: 1.4))),
            if (q.kind == 'meaning') IconButton(onPressed: () => _speak(q), icon: const Icon(Icons.volume_up, color: AppColors.merah)),
          ]),
        ),
        const SizedBox(height: 14),
        for (final (k, c) in q.choices.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              key: ValueKey('cur-choice-$k'),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(14),
                backgroundColor: !answered
                    ? AppColors.gading
                    : k == q.answer
                        ? AppColors.matcha.withValues(alpha: 0.12)
                        : k == _chosen
                            ? AppColors.bahasa.withValues(alpha: 0.12)
                            : AppColors.gading,
              ),
              onPressed: answered
                  ? null
                  : () => setState(() {
                        _chosen = k;
                        _ans[q.lineId] = (_ans[q.lineId] ?? true) && k == q.answer;
                      }),
              child: Text(c, style: const TextStyle(fontSize: 15, color: AppColors.kayu)),
            ),
          ),
        if (answered) ...[
          const SizedBox(height: 6),
          Text(_chosen == q.answer ? tr('맞았어요!') : tr('아쉬워요 — 초록이 정답이에요'), style: TextStyle(fontWeight: FontWeight.w800, color: _chosen == q.answer ? AppColors.matcha : AppColors.bahasa)),
          const SizedBox(height: 10),
          FilledButton(
            key: const ValueKey('cur-next'),
            onPressed: () {
              if (_i + 1 >= qs.length) {
                Navigator.of(context).pop(QuizResult(Map.of(_ans)));
              } else {
                setState(() {
                  _i++;
                  _chosen = null;
                });
              }
            },
            child: Text(_i + 1 >= qs.length ? tr('끝') : tr('다음')),
          ),
        ],
      ]),
    );
  }
}

class ExamResultScreen extends StatelessWidget {
  final int score;
  final bool passed;
  final List<String> wrong;
  const ExamResultScreen({super.key, required this.score, required this.passed, required this.wrong});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gadingDeep,
      appBar: AppBar(title: Text(tr('코스 시험 결과')), backgroundColor: AppColors.gading, foregroundColor: AppColors.kayu, elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(trf('{0}점', [score]), key: const ValueKey('cur-score'), style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: passed ? AppColors.matcha : AppColors.bahasa)),
            const SizedBox(height: 8),
            Text(passed ? tr('통과! 다음 코스를 만들어 보세요.') : tr('80점이 넘어야 통과예요. 틀린 편만 다시 연습하고 시험을 다시 봐요.'), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.kayu)),
            if (!passed && wrong.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(trf('다시 연습할 편: {0}', [wrong.join(', ')]), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.kayuLight)),
            ],
            const SizedBox(height: 18),
            FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(tr('확인'))),
          ]),
        ),
      ),
    );
  }
}
