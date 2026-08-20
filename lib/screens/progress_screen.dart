import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../main.dart';
import '../services/memo_service.dart';
import '../widgets/indo_decor.dart';

/// 진행 탭 — 회화 턴 / 어근 / 메모 실데이터 요약.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _turnsTotal = 0, _turnsLearned = 0;
  int _rootsTotal = 0, _rootsKnown = 0;
  int _memos = 0;
  Map<String, (int, int)> _byEp = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final byEp = await dialogueRepo.progressByEpisode();
    final learned = await dialogueRepo.learnedTurnIds();
    final turns = await appDb.turns.count().getSingle();
    final roots = await appDb.roots.count().getSingle();
    final known = await rootRepo.knownRoots();
    final memos = await MemoService.instance.count();
    if (!mounted) return;
    setState(() {
      _byEp = byEp;
      _turnsTotal = turns;
      _turnsLearned = learned.length;
      _rootsTotal = roots;
      _rootsKnown = known.length;
      _memos = memos;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: const Text('진행')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Row(
                    children: [
                      Expanded(child: _Stat('회화 턴', _turnsLearned, _turnsTotal, AppColors.merah)),
                      const SizedBox(width: 8),
                      Expanded(child: _Stat('어근', _rootsKnown, _rootsTotal, AppColors.sogan)),
                      const SizedBox(width: 8),
                      Expanded(child: _Stat('메모', _memos, null, AppColors.laut)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  for (final level in Levels.all)
                    if (dialogueRepo.byLevel(level).isNotEmpty) ...[
                      IndoCard(
                        title: '$level · ${Levels.titles[level]}',
                        child: Column(
                          children: [
                            for (final ep in dialogueRepo.byLevel(level))
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      child: Text('${ep.emoji} ${ep.title}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                    ),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: (_byEp[ep.key]?.$2 ?? 0) == 0
                                              ? 0
                                              : _byEp[ep.key]!.$1 / _byEp[ep.key]!.$2,
                                          minHeight: 8,
                                          backgroundColor: AppColors.gadingDeep,
                                          color: AppColors.merah,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('${_byEp[ep.key]?.$1 ?? 0}/${_byEp[ep.key]?.$2 ?? 0}',
                                        style: const TextStyle(fontSize: 11, color: AppColors.kayuLight)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final int? total;
  final Color color;
  const _Stat(this.label, this.value, this.total, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.emas.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.kayuLight, letterSpacing: 1)),
          const SizedBox(height: 4),
          Text(
            total == null ? '$value' : '$value / $total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }
}
