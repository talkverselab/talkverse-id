import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../core/embed_env.dart';
import '../core/l10n.dart';
import '../core/pane.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../services/tts_service.dart';
import 'loanword_quiz_screen.dart';

/// 외국어에서 온 말(kata serapan) — 영어·네덜란드어가 인도네시아어 철자로 바뀌는 규칙 + 줄기별 단어.
/// 일본어앱 빌드 110(외국어 단어 3단계·퀴즈 복습)과 같은 구성(2026-11-18). 데이터 `assets/data/vocab/loanwords.json`.
class LoanwordScreen extends StatefulWidget {
  const LoanwordScreen({super.key});
  @override
  State<LoanwordScreen> createState() => _LoanwordScreenState();
}

class _W {
  final String id, en, ko;
  final String? note;
  final bool ex;
  final int st;
  const _W(this.id, this.en, this.ko, this.note, this.ex, this.st);
}

class _B {
  final String id, title, emoji, rule;
  final List<_W> words;
  const _B(this.id, this.title, this.emoji, this.rule, this.words);
}

class _LoanwordScreenState extends State<LoanwordScreen> {
  List<_B> _branches = [];
  String _intro = '';
  List<List<String>> _table = [];
  int _tab = -1; // -1 = 규칙 한눈에
  int _stage = 1; // 1 핵심 · 2 중급까지 · 3 전체

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final j = json.decode(utf8.decode((await rootBundle.load(assetPath('assets/data/vocab/loanwords.json'))).buffer.asUint8List())) as Map<String, dynamic>;
    if (!mounted) return;
    setState(() {
      _intro = j['intro'] as String? ?? '';
      _table = [for (final r in (j['rules_table'] as List? ?? const [])) (r as List).cast<String>()];
      _branches = [
        for (final b in (j['branches'] as List).cast<Map<String, dynamic>>())
          _B(b['id'] as String, b['title'] as String, b['emoji'] as String? ?? '', b['rule'] as String, [
            for (final w in (b['words'] as List).cast<Map<String, dynamic>>())
              _W(w['id'] as String, w['en'] as String, w['ko'] as String, w['note'] as String?, w['ex'] == true, (w['st'] as int?) ?? 1),
          ]),
      ];
    });
  }

  List<_W> _visible(_B b) => b.words.where((w) => w.st <= _stage).toList();

  void _quiz() {
    final words = [
      for (final b in _branches)
        for (final w in _visible(b)) LQWord(w.id, w.en, w.ko),
    ];
    openPane(context, (_) => LoanwordQuizScreen(words: words));
  }

  @override
  Widget build(BuildContext context) {
    final total = _branches.fold(0, (s, b) => s + _visible(b).length);
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(tr('외국어에서 온 말'), style: const TextStyle(color: AppColors.sumi, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(trf('kata serapan · {0}단계 · {1}어', [_stage, total]), style: const TextStyle(color: AppColors.sumiLight, fontSize: 10, letterSpacing: 1)),
        ]),
      ),
      body: _branches.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(children: [
                  Expanded(
                    child: SegmentedButton<int>(
                      key: const ValueKey('loan-stage'),
                      segments: [
                        ButtonSegment(value: 1, label: Text(tr('1단계'))),
                        ButtonSegment(value: 2, label: Text(tr('2단계'))),
                        ButtonSegment(value: 3, label: Text(tr('전체'))),
                      ],
                      selected: {_stage},
                      showSelectedIcon: false,
                      onSelectionChanged: (s) => setState(() => _stage = s.first),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    key: const ValueKey('loan-quiz'),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.ai),
                    onPressed: _quiz,
                    icon: const Icon(Icons.quiz_outlined, size: 18),
                    label: Text(tr('퀴즈')),
                  ),
                ]),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  children: [
                    _chip(-1, '📋 ${tr('규칙 한눈에')}'),
                    for (var i = 0; i < _branches.length; i++) _chip(i, '${_branches[i].emoji} ${_branches[i].title}'),
                  ],
                ),
              ),
              Expanded(child: _tab < 0 ? _rules() : _branch(_branches[_tab])),
            ]),
    );
  }

  Widget _chip(int i, String label) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: ChoiceChip(
          key: ValueKey('loan-tab-$i'),
          label: Text(label, style: const TextStyle(fontSize: 12.5)),
          selected: _tab == i,
          onSelected: (_) => setState(() => _tab = i),
        ),
      );

  Widget _rules() => ListView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset(context)),
        children: [
          Text(_intro, style: const TextStyle(fontSize: 13, color: AppColors.sumiLight, height: 1.45)),
          const SizedBox(height: 10),
          for (final r in _table)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.washi, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.line)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${r[0]}  →  ${r[1]}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.sumi)),
                if (r.length > 2) Text(r[2], style: const TextStyle(fontSize: 12.5, color: AppColors.ai, fontWeight: FontWeight.w600)),
              ]),
            ),
        ],
      );

  Widget _branch(_B b) {
    final ws = _visible(b);
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottomInset(context)),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.washiDeep, borderRadius: BorderRadius.circular(10)),
          child: Text('💡 ${b.rule}', style: const TextStyle(fontSize: 13, color: AppColors.sumi, height: 1.45)),
        ),
        const SizedBox(height: 8),
        for (final w in ws)
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            onTap: () => TtsService.instance.speak(w.id),
            title: Row(children: [
              Flexible(child: Text(w.id, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.sumi))),
              if (w.ex) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: AppColors.beni.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                  child: Text(tr('예외'), style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.beni)),
                ),
              ],
            ]),
            subtitle: Text('${w.en} · ${w.ko}${w.note == null ? '' : '\n${w.note}'}', style: const TextStyle(fontSize: 12, color: AppColors.sumiLight, height: 1.35)),
            trailing: const Icon(Icons.volume_up, size: 18, color: AppColors.beni),
          ),
      ],
    );
  }
}
