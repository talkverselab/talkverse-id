import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/db/app_database.dart';
import '../data/repositories/root_repository.dart';
import '../main.dart';
import '../services/affix_util.dart';
import '../services/tts_service.dart';

/// 「단어 분석」 시트 — Grok UXUI 시안 02-2(사용자 통과 2026-11-03, `data/review/uxui/sian_02_2.jpg`).
/// 회화 문장에서 단어를 누르면 아래에서 올라와 접사 분해(me- + baca → membaca)와 같은 어근 가족 칩을 보인다.
/// 어근 데이터 = assets/data/roots/kata_dasar_core.json(docs/ROOTS.md). 칩을 누르면 그 단어를 읽어 준다.
class WordAnalysisSheet extends StatelessWidget {
  final AffixParse parse;
  final RootRow? root;
  final List<RootFamilyItem> family;
  const WordAnalysisSheet({super.key, required this.parse, required this.root, required this.family});

  static Future<void> show(BuildContext context, AffixParse parse) async {
    final word = parse.word.toLowerCase().replaceAll(RegExp(r'[^a-z\-]'), '');
    if (word.isEmpty) return;
    // 어근: 분해기가 찾은 어근 → 없으면 그 단어 자체가 어근인지
    var row = await rootRepo.find(parse.root);
    row ??= await rootRepo.find(word);
    final fam = row == null ? <RootFamilyItem>[] : rootRepo.familyOf(row);
    if (!context.mounted) return;
    TtsService.instance.speak(word);
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.washi,
      builder: (_) => WordAnalysisSheet(parse: parse, root: row, family: fam),
    );
  }

  @override
  Widget build(BuildContext context) {
    final word = parse.word.toLowerCase().replaceAll(RegExp(r'[^a-z\-]'), '');
    final item = family.where((f) => f.word == word).firstOrNull;
    final meaning = item?.ko ?? (root != null && root!.root == word ? root!.meaningKo : null);
    final segs = parse.segments;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('단어 분석', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.sumi)),
          const SizedBox(height: 8),
          // me- + baca → membaca
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 4, children: [
            if (parse.hasAffix) ...[
              for (var i = 0; i < segs.length; i++) ...[
                if (i > 0) const Text('+', style: TextStyle(fontSize: 20, color: AppColors.muted)),
                Text(
                  segs[i].isRoot ? (root?.root ?? segs[i].text) : _affixLabel(segs[i], i, segs.length),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: segs[i].isRoot ? AppColors.ai : AppColors.beni),
                ),
              ],
              const Text('→', style: TextStyle(fontSize: 20, color: AppColors.muted)),
            ],
            Text(word, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.sumi)),
            if (meaning != null && meaning.isNotEmpty) Text('($meaning)', style: const TextStyle(fontSize: 14, color: AppColors.sumiLight)),
            IconButton(visualDensity: VisualDensity.compact, onPressed: () => TtsService.instance.speak(word), icon: const Icon(Icons.volume_up, size: 20, color: AppColors.beni)),
          ]),
          if (root != null) ...[
            const SizedBox(height: 6),
            Text('어근 ${root!.root}${root!.meaningKo != null ? ' · ${root!.meaningKo}' : ''}',
                style: const TextStyle(fontSize: 12, color: AppColors.muted)),
            const SizedBox(height: 10),
            const Text('어근 가족', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.muted)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _chip(root!.root, root!.meaningKo, root!.root == word),
              for (final f in family) _chip(f.word, f.ko, f.word == word),
            ]),
          ] else ...[
            const SizedBox(height: 8),
            const Text('이 단어는 아직 어근 목록에 없어요.', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ]),
      ),
    );
  }

  /// 접사 조각 표시: 앞 조각은 me-, 뒤 조각은 -kan.
  String _affixLabel(AffixSegment s, int i, int n) => i == 0 ? '${s.text}-' : '-${s.text}';

  Widget _chip(String w, String? ko, bool on) => Tooltip(
        message: ko ?? '',
        child: InkWell(
          onTap: () => TtsService.instance.speak(w),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: on ? AppColors.beni.withValues(alpha: 0.10) : AppColors.washiDeep,
              border: Border.all(color: on ? AppColors.beni : AppColors.line),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(w, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: on ? AppColors.beniDeep : AppColors.sumi)),
          ),
        ),
      );
}
