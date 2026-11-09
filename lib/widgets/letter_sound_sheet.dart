import 'dart:async';
import '../core/embed_env.dart';

import 'package:flutter/material.dart';

import '../core/platform.dart';
import '../core/theme.dart';
import '../services/id_phonetics.dart';
import '../services/tts_service.dart';
import 'vowel_compare_chart.dart';

/// 글자 탭 → 발음 상세 시트(일본어앱 kana_sound_sheet 와 같은 틀).
/// 열리면 1초 뒤 자동 재생 · 다시 듣기 · IPA · 소리 나는 곳(조음 위치 그림 번호) · 모음 위치 · 한국어 화자 비교 · 예시 낱말(누르면 듣기).
Future<void> showLetterSoundSheet(BuildContext context, IdSound s, Color color) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.washi,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _LetterSoundSheet(s: s, color: color),
    );

class _LetterSoundSheet extends StatefulWidget {
  final IdSound s;
  final Color color;
  const _LetterSoundSheet({required this.s, required this.color});
  @override
  State<_LetterSoundSheet> createState() => _LetterSoundSheetState();
}

class _LetterSoundSheetState extends State<_LetterSoundSheet> {
  Timer? _auto;
  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    _auto = Timer(const Duration(seconds: 1), _say);
  }

  void _say() => TtsService.instance.speak(widget.s.say);

  @override
  void dispose() {
    _auto?.cancel();
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s, color = widget.color;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (context, scroll) => SafeArea(
        top: false,
        child: ListView(
          controller: scroll,
          padding: EdgeInsets.fromLTRB(20, 12, 20, 32 + bottomInset(context)),
          children: [
            Center(
              child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.sumiLight.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                width: 84,
                height: 84,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(s.unit, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: AppColors.washi)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
                  const SizedBox(height: 4),
                  Text('IPA [${s.ipa}]', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.sumi)),
                  Text('한글 표기 ${s.rd}', style: const TextStyle(fontSize: 12, color: AppColors.sumiLight)),
                ]),
              ),
              IconButton(iconSize: 44, color: color, tooltip: '다시 듣기', icon: const Icon(Icons.play_circle_fill), onPressed: _say),
            ]),
            const SizedBox(height: 20),
            _section('👄 소리 나는 곳 · 입모양', s.place + (s.nums.isEmpty ? '' : '\n\n그림 번호: ${s.nums.map((n) => '$n ${placeNames[n]}').join(' · ')}'), color),
            if (s.chart != null) ...[
              const SizedBox(height: 14),
              _box(color, [
                Text('📍 모음 위치 — 인도네시아어 vs 한국어', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
                const SizedBox(height: 10),
                VowelCompareChart(data: s.chart!),
              ]),
            ],
            if (s.nums.isNotEmpty) ...[
              const SizedBox(height: 6),
              InkWell(
                onTap: () => setState(() => _showChart = !_showChart),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    Icon(_showChart ? Icons.expand_less : Icons.expand_more, size: 18, color: color),
                    Text('조음 위치 그림 보기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                  ]),
                ),
              ),
              if (_showChart) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(maxHeight: 420),
                    child: Image.asset(assetPath('assets/images/ipa/places_of_articulation.png'), fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 6),
                Text(placeNames.entries.map((e) => '${e.key} ${e.value}').join(' · '), style: const TextStyle(fontSize: 11, color: AppColors.sumiLight, height: 1.5)),
              ],
            ],
            const SizedBox(height: 14),
            _section('🇰🇷 한국어와 비교', '비슷한 소리: ${s.korSim}\n\n${s.korDiff}', color),
            const SizedBox(height: 14),
            _box(color, [
              Text('🔊 예시 낱말 — 누르면 듣기', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(height: 6),
              for (final (w, rd, ko) in s.examples)
                InkWell(
                  onTap: () => TtsService.instance.speak(w),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(children: [
                      Icon(Icons.volume_up, size: 18, color: color),
                      const SizedBox(width: 8),
                      Text(w, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.sumi)),
                      const SizedBox(width: 8),
                      Text(rd, style: const TextStyle(fontSize: 12, color: AppColors.sumiLight)),
                      const Spacer(),
                      Flexible(child: Text(ko, textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, color: AppColors.sumi))),
                    ]),
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _box(Color color, List<Widget> children) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.washiDeep, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.35))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _section(String title, String body, Color color) => _box(color, [
        Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 8),
        Text(body, style: const TextStyle(fontSize: 13.5, height: 1.55, color: AppColors.sumi)),
      ]);
}
