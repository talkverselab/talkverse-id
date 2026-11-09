import 'dart:convert';
import '../core/embed_env.dart';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../core/platform.dart';
import '../core/theme.dart';
import '../services/art_service.dart';
import '../services/memorized_store.dart';
import '../services/tts_service.dart';
import '../widgets/indo_decor.dart';

/// 절벽 단어 — 빈도 1~2,000위를 절벽구간(R1~R5)별 **20어 단원**으로, 단어는 **네모 타일**로 보여 준다(사용자 지시 2026-11-07, 일본어앱과 같은 구조).
/// 위 버튼 「절벽구간 단어만 / 회화 단어 포함」 — 포함이면 회화에 나오지만 2,000위 밖인 말(assets/data/freq/conv_words_id.json)이
/// 「회화」 구간으로 뒤에 붙는다. DB 는 합치지 않고 화면에서만 합친다. 탭 = 발음, 길게 누름 = 외움 표시.
class WordFreqScreen extends StatefulWidget {
  const WordFreqScreen({super.key});

  @override
  State<WordFreqScreen> createState() => _WordFreqScreenState();
}

/// 절벽 v2 절대 기준(누적 55/60/70/80%) · R5 는 2,000위에서 끊음(2,000위 누적 91.6%).
const int kWordCap = 2000;
const int kUnit = 20;

class _WordFreqScreenState extends State<WordFreqScreen> {
  List<WordEntry> _words = [];
  List<WordEntry> _conv = [];
  bool _loading = true;
  bool _withConv = false;
  String _filter = 'ALL';

  static const Map<String, _Region> _regions = {
    'ALL': _Region('전체', AppColors.sumi),
    'R1': _Region('R1 · 1-104', AppColors.beni),
    'R2': _Region('R2 · 105-139', AppColors.beniLight),
    'R3': _Region('R3 · 140-249', AppColors.kinDeep),
    'R4': _Region('R4 · 250-523', AppColors.matcha),
    'R5': _Region('R5 · 524-2000', AppColors.muted),
    'C': _Region('회화', AppColors.ai),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await MemorizedStore.load();
    final raw = await rootBundle.loadString(assetPath('assets/data/freq/lang_id_cliff2000.csv'));
    final rows = const CsvToListConverter(eol: '\n', shouldParseNumbers: false).convert(raw);
    final entries = <WordEntry>[];
    for (var i = 1; i < rows.length; i++) {
      final r = rows[i];
      if (r.length < 8) continue;
      entries.add(WordEntry(rank: int.tryParse('${r[0]}') ?? 0, word: '${r[1]}', region: '${r[4]}', ko: '${r[6]}', speakable: '${r[7]}' == 'root'));
    }
    final conv = <WordEntry>[];
    try {
      final j = json.decode(await rootBundle.loadString(assetPath('assets/data/freq/conv_words_id.json'))) as Map<String, dynamic>;
      var n = 0;
      for (final w in (j['words'] as List).cast<Map<String, dynamic>>()) {
        conv.add(WordEntry(rank: ++n, word: w['word'] as String, region: 'C', ko: (w['ko'] as String?) ?? ''));
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _words = entries;
      _conv = conv;
      _loading = false;
    });
    await ArtService.instance.urlFor('makan'); // 그림 목록을 받아 두면 타일이 바로 조회한다(실패해도 글자만 나온다)
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pool = _withConv ? [..._words, ..._conv] : _words;
    final filtered = _filter == 'ALL' ? pool : pool.where((w) => w.region == _filter).toList();
    final units = <List<WordEntry>>[];
    for (var i = 0; i < filtered.length; i += kUnit) {
      units.add(filtered.sublist(i, (i + kUnit).clamp(0, filtered.length)));
    }
    final chips = _regions.entries.where((e) => e.key != 'C' || _withConv).toList();

    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('절벽 단어', style: TextStyle(color: AppColors.sumi, fontSize: 16, fontWeight: FontWeight.w800)),
            SizedBox(height: 2),
            Text('회화 빈도 2,000위 · 20어 단원 · 탭하면 발음', style: TextStyle(color: AppColors.sumiLight, fontSize: 10, letterSpacing: 1)),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.beni))
          : Column(
              children: [
                Container(
                  color: AppColors.washiDeep,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _ModeButton(
                            label: '절벽구간 단어만',
                            selected: !_withConv,
                            onTap: () => setState(() {
                              _withConv = false;
                              if (_filter == 'C') _filter = 'ALL';
                            }),
                          ),
                          const SizedBox(width: 8),
                          _ModeButton(label: '회화 단어 포함 (+${_conv.length})', selected: _withConv, onTap: () => setState(() => _withConv = true)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final e in chips)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () => setState(() => _filter = e.key),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _filter == e.key ? e.value.color : AppColors.washi,
                                      border: Border.all(color: e.value.color, width: _filter == e.key ? 1.5 : 0.8),
                                    ),
                                    child: Text(e.value.label,
                                        style: TextStyle(color: _filter == e.key ? AppColors.washi : e.value.color, fontWeight: FontWeight.w700, fontSize: 12)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const ParangDivider(height: 8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, box) {
                      final cols = (box.maxWidth / 112).floor().clamp(3, 8); // 두 화면에서는 오른쪽 칸 너비 기준
                      return ListView.builder(
                        padding: EdgeInsets.fromLTRB(12, 8, 12, 16 + bottomInset(context)),
                        itemCount: units.length,
                        itemBuilder: (context, i) => _UnitBlock(index: i + 1, words: units[i], cols: cols),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ModeButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.sumi : AppColors.washi,
              border: Border.all(color: selected ? AppColors.sumi : AppColors.line),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label, style: TextStyle(color: selected ? AppColors.washi : AppColors.sumi, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ),
      );
}

/// 한 단원 = 20어. 머리줄(단원 번호·순위 범위·구간) + 네모 타일 격자.
class _UnitBlock extends StatelessWidget {
  final int index;
  final List<WordEntry> words;
  final int cols;
  const _UnitBlock({required this.index, required this.words, required this.cols});

  @override
  Widget build(BuildContext context) {
    final first = words.first;
    final isConv = first.region == 'C';
    final region = _WordFreqScreenState._regions[first.region];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 6, 2, 6),
            child: Row(
              children: [
                Text('$index단원', style: const TextStyle(color: AppColors.sumi, fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                Text(isConv ? '회화 ${first.rank}-${words.last.rank}' : '#${first.rank}-${words.last.rank}',
                    style: const TextStyle(color: AppColors.sumiLight, fontSize: 11)),
                const Spacer(),
                if (region != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: region.color, borderRadius: BorderRadius.circular(2)),
                    child: Text(isConv ? '회화' : first.region, style: const TextStyle(color: AppColors.washi, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: 6, crossAxisSpacing: 6),
            itemCount: words.length,
            itemBuilder: (context, i) => _WordTile(w: words[i], color: region?.color ?? AppColors.sumi),
          ),
        ],
      ),
    );
  }
}

/// 네모 타일 — 순위 · 그림(있으면) · 단어 · 뜻 한 줄. 탭 = 발음(접사·중첩 표지는 소리 없음), 길게 누름 = 외움 표시.
class _WordTile extends StatelessWidget {
  final WordEntry w;
  final Color color;
  const _WordTile({required this.w, required this.color});

  @override
  Widget build(BuildContext context) {
    final url = ArtService.instance.urlForSync(w.word); // 순위로 찾지 않는다 — 그림 목록의 순위는 옛 빈도표 기준
    return InkWell(
      onTap: w.speakable ? () => TtsService.instance.speak(w.word) : null,
      onLongPress: () => MemorizedStore.toggle(w.word),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.washi,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(6),
        child: LayoutBuilder(
          builder: (context, c) {
            final art = (c.maxHeight * 0.42).clamp(24.0, 72.0);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(w.region == 'C' ? '회화' : '#${w.rank}', style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    ValueListenableBuilder<int>(
                      valueListenable: MemorizedStore.version,
                      builder: (context, _, _) =>
                          MemorizedStore.contains(w.word) ? const Icon(Icons.check_circle, size: 11, color: AppColors.merah) : const SizedBox(height: 11),
                    ),
                  ],
                ),
                if (url != null) ...[
                  const SizedBox(height: 2),
                  SizedBox(width: art, height: art, child: artImage(url, fallback: () => const SizedBox.shrink())),
                ],
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(w.word == 'RED' ? '중첩' : w.word, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.sumi)),
                ),
                if (w.ko.isNotEmpty)
                  Text(w.ko, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10, color: AppColors.sumiLight)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WordEntry {
  final int rank;
  final String word;
  final String region; // R1~R5 · C(회화 단어)
  final String ko;
  final bool speakable;
  WordEntry({required this.rank, required this.word, required this.region, required this.ko, this.speakable = true});
}

class _Region {
  final String label;
  final Color color;
  const _Region(this.label, this.color);
}
