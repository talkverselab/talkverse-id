import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/db/app_database.dart';
import '../main.dart';
import '../services/memorized_store.dart';
import '../services/tts_service.dart';
import '../widgets/affix_text.dart';

/// 빈도 단어 — Top N + R1~R4 구간 필터.
class WordFreqScreen extends StatefulWidget {
  const WordFreqScreen({super.key});

  @override
  State<WordFreqScreen> createState() => _WordFreqScreenState();
}

class _WordFreqScreenState extends State<WordFreqScreen> {
  List<WordRow> _words = [];
  String _region = '전체';
  static const _regions = ['전체', 'R1', 'R2', 'R3', 'R4'];

  @override
  void initState() {
    super.initState();
    MemorizedStore.load().then((_) {
      if (mounted) setState(() {});
    });
    rootRepo.topWords(limit: 2500).then((v) {
      if (mounted) setState(() => _words = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = _region == '전체' ? _words : _words.where((w) => w.region == _region).toList();
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: Text('빈도 단어 (${_words.length})')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _regions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(_regions[i]),
                selected: _region == _regions[i],
                onSelected: (_) => setState(() => _region = _regions[i]),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('단어 데이터 없음 — assets/data/freq/lang_id_top2500.csv'))
                : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final w = list[i];
                      return ListTile(
                        dense: true,
                        leading: SizedBox(
                          width: 40,
                          child: Text('${w.rank}',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.kayuLight)),
                        ),
                        title: AffixText(w.word, fontSize: 16),
                        subtitle: Text(
                          [
                            if (w.region != null) w.region!,
                            if (w.cumPct != null) '누적 ${w.cumPct!.toStringAsFixed(1)}%',
                            if (w.root != null) '√${w.root}',
                          ].join(' · '),
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ValueListenableBuilder<int>(
                              valueListenable: MemorizedStore.version,
                              builder: (context, _, _) {
                                final memorized =
                                    MemorizedStore.contains(w.word);
                                return IconButton(
                                  tooltip: memorized ? '외움 해제' : '외웠어요',
                                  icon: Icon(
                                    memorized
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    size: 18,
                                    color: memorized
                                        ? AppColors.merah
                                        : AppColors.kayuLight
                                            .withValues(alpha: 0.6),
                                  ),
                                  onPressed: () =>
                                      MemorizedStore.toggle(w.word),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up,
                                  size: 18, color: AppColors.merah),
                              onPressed: () =>
                                  TtsService.instance.speak(w.word),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
