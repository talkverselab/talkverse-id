import 'dart:math';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/db/app_database.dart';
import '../main.dart';
import '../services/tts_service.dart';
import '../widgets/affix_text.dart';
import '../widgets/indo_decor.dart';

/// 문장 플래시카드 — 한국어 먼저 → 탭하면 인도네시아어 공개 → 3단계 평가.
class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  List<TurnRow> _cards = [];
  int _i = 0;
  bool _revealed = false;
  bool _loading = true;
  int _good = 0, _hard = 0, _again = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await appDb.select(appDb.turns).get();
    final learned = await dialogueRepo.learnedTurnIds();
    var pool = all.where((t) => learned.contains(t.id)).toList();
    if (pool.isEmpty) pool = all; // 학습 기록 없으면 전체에서
    pool.shuffle(Random());
    if (!mounted) return;
    setState(() {
      _cards = pool.take(20).toList();
      _loading = false;
    });
  }

  void _grade(int g) {
    setState(() {
      if (g == 0) _again++;
      if (g == 1) _hard++;
      if (g == 2) _good++;
      _revealed = false;
      _i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(appBar: AppBar(title: const Text('복습')), body: const Center(child: CircularProgressIndicator()));
    }
    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('복습')),
        body: const Center(child: Text('복습할 문장이 없습니다.')),
      );
    }
    if (_i >= _cards.length) {
      return Scaffold(
        backgroundColor: AppColors.gading,
        appBar: AppBar(title: const Text('복습 완료')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BadgeStamp(text: 'OK', size: 72, color: AppColors.laut),
              const SizedBox(height: 16),
              Text('${_cards.length}장  ·  잘함 $_good / 어려움 $_hard / 다시 $_again',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => setState(() {
                  _i = 0;
                  _good = _hard = _again = 0;
                  _loading = true;
                  _load();
                }),
                child: const Text('다시 섞기'),
              ),
            ],
          ),
        ),
      );
    }
    final t = _cards[_i];
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: Text('복습  ${_i + 1}/${_cards.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _revealed = true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.emas, width: 1.2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${t.level} · ${t.episodeId ?? ''} · #${t.num}',
                          style: const TextStyle(fontSize: 11, color: AppColors.kayuLight, letterSpacing: 1)),
                      const SizedBox(height: 16),
                      Text(t.ko ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.kayu)),
                      const SizedBox(height: 24),
                      if (_revealed) ...[
                        AffixText(t.body, fontSize: 22),
                        if (t.ms != null) ...[
                          const SizedBox(height: 8),
                          Text('MS: ${t.ms}', style: const TextStyle(color: AppColors.biruMs)),
                        ],
                        const SizedBox(height: 12),
                        IconButton.filled(
                          onPressed: () => TtsService.instance.speak(t.body),
                          icon: const Icon(Icons.volume_up),
                        ),
                        if (t.note != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(t.note!, textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12, color: AppColors.kayuLight)),
                          ),
                      ] else
                        const Text('탭하여 정답 보기', style: TextStyle(color: AppColors.kayuLight)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: _i > 0 ? () => setState(() { _i--; _revealed = false; }) : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(child: _gradeBtn('다시', AppColors.merah, () => _grade(0))),
                const SizedBox(width: 8),
                Expanded(child: _gradeBtn('어려움', AppColors.emasDeep, () => _grade(1))),
                const SizedBox(width: 8),
                Expanded(child: _gradeBtn('잘함', AppColors.laut, () => _grade(2))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradeBtn(String label, Color c, VoidCallback onTap) => FilledButton(
        style: FilledButton.styleFrom(backgroundColor: c),
        onPressed: _revealed ? onTap : null,
        child: Text(label),
      );
}
