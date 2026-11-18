import 'dart:math';

import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/platform.dart';
import '../core/prefs.dart';
import '../core/theme.dart';
import '../services/tts_service.dart';

/// 외국어에서 온 말(kata serapan) 퀴즈 복습 — 일본어앱 빌드 110 `gairaigo_quiz_screen.dart` 와 같은 꼴(2026-11-18 이식).
/// 두 꼴 — 표기(바르게 쓴 인도네시아어 철자 고르기)와 뜻 고르기, 보기 1~4, 10문제. 틀린 단어는 다음 복습에 먼저.
/// 표기 문제의 틀린 보기는 규칙을 되돌린 꼴(k→c, -si→-tion, f→ph, ks→x, -tas→-ty …)로 만든다.
const int kLoanQuizSize = 10;
const String _kWrong = 'loanword_quiz_wrong';

class LQWord {
  final String id, en, ko;
  const LQWord(this.id, this.en, this.ko);
}

/// 규칙을 어긴 꼴들(실제 단어와 겹치는 것은 뺀다).
List<String> loanMisspellings(String w, Set<String> real) {
  final out = <String>{};
  void sub(Pattern a, String b) {
    final s = w.replaceFirst(a, b);
    if (s != w) out.add(s);
  }

  sub(RegExp(r'si$'), 'tion');
  sub(RegExp(r'si$'), 'sie');
  sub(RegExp(r'tas$'), 'ty');
  sub(RegExp(r'tas$'), 'tet');
  sub(RegExp(r'ik$'), 'ic');
  sub(RegExp(r'is$'), 'ic');
  sub(RegExp(r'if$'), 'ive');
  sub(RegExp(r'ur$'), 'ure');
  sub(RegExp(r'en$'), 'ent');
  sub(RegExp(r'an$'), 'ant');
  sub('k', 'c');
  sub('ks', 'x');
  sub('f', 'ph');
  sub('sy', 'sh');
  sub('u', 'oe'); // 옛 철자
  sub('i', 'y');
  // 자음 겹치기(영어식)
  final m = RegExp(r'[bcdfglmnprst](?=[aeiou])').firstMatch(w.length > 2 ? w.substring(1) : '');
  if (m != null) {
    final i = m.start + 1;
    out.add('${w.substring(0, i + 1)}${w[i]}${w.substring(i + 1)}');
  }
  return out.where((s) => s != w && s.isNotEmpty && !real.contains(s)).toList();
}

class _Q {
  final LQWord w;
  final bool spelling;
  final List<String> options;
  const _Q(this.w, this.spelling, this.options);
  String get answer => spelling ? w.id : w.ko;
}

class LoanwordQuizScreen extends StatefulWidget {
  final List<LQWord> words;
  final int? seed;
  const LoanwordQuizScreen({super.key, required this.words, this.seed});
  @override
  State<LoanwordQuizScreen> createState() => _LoanwordQuizScreenState();
}

class _LoanwordQuizScreenState extends State<LoanwordQuizScreen> {
  late final _rnd = Random(widget.seed);
  List<_Q>? _qs;
  int _i = 0;
  String? _picked;
  int _right = 0;
  final List<LQWord> _missed = [];

  @override
  void initState() {
    super.initState();
    _build();
  }

  Future<void> _build() async {
    final p = await Prefs.getInstance();
    final wrong = (p.getStringList(_kWrong) ?? const []).toSet();
    final uniq = <String, LQWord>{for (final w in widget.words) w.id: w}.values.toList()..shuffle(_rnd);
    uniq.sort((a, b) => (wrong.contains(b.id) ? 1 : 0) - (wrong.contains(a.id) ? 1 : 0));
    final picked = uniq.take(kLoanQuizSize).toList()..shuffle(_rnd);
    final real = {for (final w in widget.words) w.id};
    final qs = <_Q>[];
    for (var k = 0; k < picked.length; k++) {
      final w = picked[k];
      final miss = (loanMisspellings(w.id, real)..shuffle(_rnd)).take(3).toList();
      if (k.isEven && miss.length == 3) {
        qs.add(_Q(w, true, [w.id, ...miss]..shuffle(_rnd)));
      } else {
        final others = ({for (final o in uniq) if (o.ko != w.ko) o.ko}.toList()..shuffle(_rnd)).take(3);
        qs.add(_Q(w, false, [w.ko, ...others]..shuffle(_rnd)));
      }
    }
    if (mounted) setState(() => _qs = qs);
  }

  Future<void> _record(String id, bool ok) async {
    final p = await Prefs.getInstance();
    final s = (p.getStringList(_kWrong) ?? const []).toSet();
    ok ? s.remove(id) : s.add(id);
    await p.setStringList(_kWrong, s.toList());
  }

  void _again() => setState(() {
        _qs = null;
        _i = 0;
        _picked = null;
        _right = 0;
        _missed.clear();
        _build();
      });

  @override
  Widget build(BuildContext context) {
    final qs = _qs;
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(title: Text(tr('퀴즈 복습'))),
      body: qs == null
          ? const Center(child: CircularProgressIndicator())
          : _i >= qs.length
              ? _summary(qs.length)
              : _question(qs[_i], qs.length),
    );
  }

  Widget _summary(int n) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('🎉', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 10),
            Text(trf('{0}문제 중 {1}개 맞힘', [n, _right]), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.sumi)),
            if (_missed.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(tr('틀린 단어 — 다음 복습에 먼저 나와요'), style: const TextStyle(fontSize: 12, color: AppColors.sumiLight)),
              const SizedBox(height: 6),
              for (final w in _missed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${w.id}  ${w.en} · ${w.ko}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.sumi)),
                ),
            ],
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(key: const ValueKey('lq-again'), onPressed: _again, child: Text(tr('한 번 더'))),
              const SizedBox(width: 10),
              FilledButton(onPressed: () => Navigator.of(context).maybePop(), style: FilledButton.styleFrom(backgroundColor: AppColors.sumi), child: Text(tr('나가기'))),
            ]),
          ]),
        ),
      );

  Widget _question(_Q q, int n) {
    final w = q.w;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset(context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text('${tr(q.spelling ? '표기' : '뜻')} · ${_i + 1} / $n', style: const TextStyle(fontSize: 12, color: AppColors.sumiLight)),
        const SizedBox(height: 14),
        Text(
          q.spelling ? '${w.en} · ${w.ko}' : w.id,
          key: const ValueKey('lq-stem'),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.sumi, decoration: TextDecoration.underline, decorationColor: AppColors.sumiLight),
        ),
        const SizedBox(height: 8),
        Text(tr(q.spelling ? '인도네시아어로 바르게 쓴 것을 고르세요.' : '뜻으로 맞는 것을 고르세요.'), style: const TextStyle(fontSize: 14, color: AppColors.sumi)),
        if (_picked != null && !q.spelling) ...[
          const SizedBox(height: 4),
          Text(w.en, style: const TextStyle(fontSize: 13, color: AppColors.ai, fontWeight: FontWeight.w700)),
        ],
        const SizedBox(height: 14),
        for (var k = 0; k < q.options.length; k++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              key: ValueKey('lq-opt-$k'),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                backgroundColor: _picked == null ? null : (q.options[k] == q.answer ? const Color(0x3336A35B) : (q.options[k] == _picked ? const Color(0x33D83A3A) : null)),
                side: BorderSide(color: _picked != null && q.options[k] == q.answer ? AppColors.matcha : AppColors.line, width: 1.4),
              ),
              onPressed: _picked != null
                  ? null
                  : () {
                      final ok = q.options[k] == q.answer;
                      TtsService.instance.speak(w.id);
                      _record(w.id, ok);
                      setState(() {
                        _picked = q.options[k];
                        ok ? _right++ : _missed.add(w);
                      });
                    },
              child: Row(children: [
                SizedBox(width: 26, child: Text('${k + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.sumiLight))),
                Expanded(child: Text(q.options[k], style: TextStyle(fontSize: q.spelling ? 19 : 16, fontWeight: FontWeight.w800, color: AppColors.sumi))),
              ]),
            ),
          ),
        if (_picked != null)
          FilledButton(
            key: const ValueKey('lq-next'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.sumi, minimumSize: const Size.fromHeight(48)),
            onPressed: () => setState(() {
              _i++;
              _picked = null;
            }),
            child: Text(tr('다음 →')),
          ),
      ]),
    );
  }
}
