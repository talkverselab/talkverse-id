import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/db/app_database.dart';
import '../main.dart';
import '../services/affix_util.dart';
import '../services/tts_service.dart';
import '../widgets/affix_text.dart';
import '../widgets/indo_decor.dart';

/// 접사 체계 — zh 의 발음부(声旁) 화면에 대응.
/// 접사 목록 + 예시 + 자유 입력 분해기.
class AffixScreen extends StatefulWidget {
  const AffixScreen({super.key});

  @override
  State<AffixScreen> createState() => _AffixScreenState();
}

class _AffixScreenState extends State<AffixScreen> {
  List<AffixRow> _affixes = [];
  final _ctrl = TextEditingController(text: 'Saya belajar bahasa Indonesia di perpustakaan.');
  String _input = 'Saya belajar bahasa Indonesia di perpustakaan.';

  @override
  void initState() {
    super.initState();
    rootRepo.allAffixes().then((v) {
      if (mounted) setState(() => _affixes = v);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<AffixRow>>{};
    for (final a in _affixes) {
      grouped.putIfAbsent(a.position, () => []).add(a);
    }
    const order = ['prefix', 'suffix', 'circumfix'];
    const titles = {'prefix': '접두사 (awalan)', 'suffix': '접미사 (akhiran)', 'circumfix': '접환사 (konfiks)'};

    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: const Text('접사 · Afiks')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          IndoCard(
            title: '분해기',
            subtitle: 'parser',
            headerColor: AppColors.affixMe,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _ctrl,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: '문장이나 단어 입력',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _input = v),
                ),
                const SizedBox(height: 10),
                AffixText(_input, fontSize: 18,
                    onWordTap: (p) => TtsService.instance.speak(p.word)),
                const SizedBox(height: 8),
                const AffixLegend(),
                const SizedBox(height: 8),
                for (final p in AffixUtil.parseSentence(_input))
                  if (p.hasAffix)
                    Text(
                      '${p.word} → ${p.segments.map((s) => s.text).join(' + ')}   (${p.pattern}${p.rootKnown ? ' ✓' : ''})',
                      style: const TextStyle(fontSize: 12, color: AppColors.kayuLight),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (final pos in order)
            if (grouped[pos] != null) ...[
              Row(
                children: [
                  BadgeStamp(text: pos.substring(0, 3).toUpperCase(), size: 26,
                      color: pos == 'prefix' ? AppColors.affixMe : pos == 'suffix' ? AppColors.affixKan : AppColors.affixCircum),
                  const SizedBox(width: 8),
                  Text(titles[pos]!,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 1)),
                ],
              ),
              const SizedBox(height: 8),
              for (final a in grouped[pos]!) _AffixTile(affix: a),
              const SizedBox(height: 16),
            ],
          if (_affixes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('접사 데이터 없음 — assets/data/grammar/affixes.json')),
            ),
        ],
      ),
    );
  }
}

class _AffixTile extends StatelessWidget {
  final AffixRow affix;
  const _AffixTile({required this.affix});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> examples = const [];
    if (affix.examplesJson != null) {
      try {
        examples = (json.decode(affix.examplesJson!) as List).cast<Map<String, dynamic>>();
      } catch (_) {}
    }
    final c = affixColor(affix.kind);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Container(
          width: 52,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(affix.form,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
        ),
        title: Text(affix.meaningKo ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: affix.allomorphs != null
            ? Text('변이형: ${affix.allomorphs}', style: const TextStyle(fontSize: 11))
            : null,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          for (final e in examples)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: AffixText(e['word'] as String, fontSize: 16),
              subtitle: Text('${e['root'] ?? ''}  →  ${e['ko'] ?? ''}',
                  style: const TextStyle(fontSize: 12)),
              trailing: IconButton(
                icon: const Icon(Icons.volume_up, size: 18, color: AppColors.merah),
                onPressed: () => TtsService.instance.speak(e['word'] as String),
              ),
            ),
        ],
      ),
    );
  }
}
