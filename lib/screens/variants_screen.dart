import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/repositories/variant_repository.dart';
import '../services/tts_service.dart';
import '../widgets/indo_decor.dart';

/// 인도네시아어 ↔ 말레이어 차이 — zh 의 north/south dialect 비교에 대응.
class VariantsScreen extends StatefulWidget {
  const VariantsScreen({super.key});

  @override
  State<VariantsScreen> createState() => _VariantsScreenState();
}

class _VariantsScreenState extends State<VariantsScreen> {
  String _cat = '전체';
  bool _loaded = false;

  static const _catLabels = {
    'vocab': '어휘',
    'spelling': '철자',
    'pronoun': '대명사',
    'idiom': '관용구',
  };

  @override
  void initState() {
    super.initState();
    VariantRepository.instance.ensureLoaded().then((_) {
      if (mounted) setState(() => _loaded = true);
    });
  }

  Future<void> _speak(String text, LangVariant v) async {
    final tts = TtsService.instance;
    final prev = tts.variant;
    await tts.setVariant(v);
    await tts.speak(text);
    // 다음 발화 전에 원래 변이로 복귀 (speak 은 비동기 재생 시작 후 반환)
    await tts.setVariant(prev);
  }

  @override
  Widget build(BuildContext context) {
    final repo = VariantRepository.instance;
    final cats = ['전체', ...repo.categories];
    final list = _cat == '전체' ? repo.all : repo.byCategory(_cat);
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: const Text('ID ↔ MS · 변이')),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: cats.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (_, i) => ChoiceChip(
                      label: Text(_catLabels[cats[i]] ?? cats[i]),
                      selected: _cat == cats[i],
                      onSelected: (_) => setState(() => _cat = cats[i]),
                    ),
                  ),
                ),
                const ParangDivider(height: 8),
                Expanded(
                  child: list.isEmpty
                      ? const Center(child: Text('변이 데이터 없음 — assets/data/variants/id_ms_diff.json'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: list.length,
                          itemBuilder: (_, i) => _PairCard(
                            pair: list[i],
                            onSpeakId: () => _speak(list[i].id, LangVariant.id),
                            onSpeakMs: () => _speak(list[i].ms, LangVariant.ms),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class _PairCard extends StatelessWidget {
  final VariantPair pair;
  final VoidCallback onSpeakId;
  final VoidCallback onSpeakMs;
  const _PairCard({required this.pair, required this.onSpeakId, required this.onSpeakMs});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _side(isMs: false, text: pair.id, onTap: onSpeakId)),
                const Icon(Icons.compare_arrows, color: AppColors.emasDeep),
                Expanded(child: _side(isMs: true, text: pair.ms, onTap: onSpeakMs)),
              ],
            ),
            const SizedBox(height: 4),
            Text(pair.ko, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            if (pair.note.isNotEmpty)
              Text(pair.note, style: const TextStyle(fontSize: 11, color: AppColors.kayuLight)),
          ],
        ),
      ),
    );
  }

  Widget _side({required bool isMs, required String text, required VoidCallback onTap}) {
    return Row(
      children: [
        VariantChip(isMs: isMs),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isMs ? AppColors.biruMs : AppColors.merah,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.volume_up, size: 16),
          color: isMs ? AppColors.biruMs : AppColors.merah,
          onPressed: onTap,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
