import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/db/app_database.dart';
import '../main.dart';
import '../services/tts_service.dart';
import '../widgets/affix_text.dart';
import '../widgets/indo_decor.dart';

/// 어근(kata dasar) 카드 — zh 의 한자 단계 화면에 대응.
/// Phase 별 탭 + 어근 → 파생어 가족.
class RootsScreen extends StatefulWidget {
  const RootsScreen({super.key});

  @override
  State<RootsScreen> createState() => _RootsScreenState();
}

class _RootsScreenState extends State<RootsScreen> {
  List<RootRow> _roots = [];
  Set<String> _known = {};
  int? _phase; // null = 전체

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final roots = await rootRepo.allRoots();
    final known = await rootRepo.knownRoots();
    if (!mounted) return;
    setState(() {
      _roots = roots;
      _known = known;
    });
  }

  @override
  Widget build(BuildContext context) {
    final phases = _roots.map((r) => r.phase).whereType<int>().toSet().toList()..sort();
    final list = _phase == null ? _roots : _roots.where((r) => r.phase == _phase).toList();
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: Text('어근 · Kata Dasar (${_known.length}/${_roots.length})')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                ChoiceChip(
                  label: const Text('전체'),
                  selected: _phase == null,
                  onSelected: (_) => setState(() => _phase = null),
                ),
                for (final p in phases) ...[
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: Text('Phase $p'),
                    selected: _phase == p,
                    onSelected: (_) => setState(() => _phase = p),
                  ),
                ],
              ],
            ),
          ),
          const ParangDivider(height: 8),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('어근 데이터 없음 — assets/data/roots/kata_dasar_core.json'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _RootCard(
                      root: list[i],
                      known: _known.contains(list[i].root),
                      onToggle: () async {
                        final r = list[i].root;
                        final now = !_known.contains(r);
                        await rootRepo.markKnown(r, now);
                        setState(() => now ? _known.add(r) : _known.remove(r));
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RootCard extends StatelessWidget {
  final RootRow root;
  final bool known;
  final VoidCallback onToggle;
  const _RootCard({required this.root, required this.known, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final family = rootRepo.familyOf(root);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: BadgeStamp(
          text: '${root.rank ?? '·'}',
          size: 36,
          color: known ? AppColors.laut : AppColors.sogan,
        ),
        title: Row(
          children: [
            Text(root.root,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.kayu)),
            const SizedBox(width: 8),
            if (root.pos != null)
              Text(root.pos!, style: const TextStyle(fontSize: 11, color: AppColors.kayuLight)),
          ],
        ),
        subtitle: Text(
          '${root.meaningKo ?? ''}${root.msForm != null ? '   ·  MS: ${root.msForm}' : ''}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up, color: AppColors.merah, size: 20),
              onPressed: () => TtsService.instance.speak(root.root),
            ),
            IconButton(
              icon: Icon(known ? Icons.check_circle : Icons.check_circle_outline,
                  color: known ? AppColors.laut : AppColors.kayuLight, size: 20),
              onPressed: onToggle,
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          if (family.isEmpty)
            const Text('파생어 미등록', style: TextStyle(fontSize: 12, color: AppColors.kayuLight))
          else
            for (final f in family)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(f.affix,
                          style: const TextStyle(fontSize: 11, color: AppColors.kayuLight, fontWeight: FontWeight.w700)),
                    ),
                    Expanded(child: AffixText(f.word, fontSize: 15)),
                    Text(f.ko, style: const TextStyle(fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.volume_up, size: 16, color: AppColors.merah),
                      onPressed: () => TtsService.instance.speak(f.word),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
