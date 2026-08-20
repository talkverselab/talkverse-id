import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/db/app_database.dart';
import '../data/models/episode.dart';
import '../main.dart';
import '../services/affix_util.dart';
import '../services/tts_service.dart';
import '../widgets/affix_text.dart';
import '../widgets/indo_decor.dart';
import '../widgets/memo_toggle.dart';

/// 에피소드 학습 화면 — 턴 버블(접사 색상) + TTS + 한국어 토글 + 말레이어 변이 + 메모.
class EpisodeScreen extends StatefulWidget {
  final EpisodeMeta episode;
  const EpisodeScreen({super.key, required this.episode});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  List<TurnRow> _turns = [];
  Set<int> _learned = {};
  bool _showKo = true;
  bool _showMs = false;
  bool _colorize = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final turns = await dialogueRepo.turnsOf(widget.episode);
    final learned = await dialogueRepo.learnedTurnIds();
    if (!mounted) return;
    setState(() {
      _turns = turns;
      _learned = learned;
      _loading = false;
    });
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  Future<void> _toggleLearned(TurnRow t) async {
    final now = !_learned.contains(t.id);
    await dialogueRepo.markLearned(t.id, now);
    setState(() {
      if (now) {
        _learned.add(t.id);
      } else {
        _learned.remove(t.id);
      }
    });
  }

  void _showWord(AffixParse p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.gading,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _WordSheet(parse: p),
    );
  }

  @override
  Widget build(BuildContext context) {
    final speakers = dialogueRepo.speakers;
    final ep = widget.episode;
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(
        title: Text('${ep.level} · ${ep.emoji} ${ep.title}'),
        actions: [
          IconButton(
            tooltip: '한국어 뜻',
            icon: Icon(_showKo ? Icons.translate : Icons.translate_outlined,
                color: _showKo ? AppColors.emasBright : AppColors.gading),
            onPressed: () => setState(() => _showKo = !_showKo),
          ),
          IconButton(
            tooltip: '말레이어 변이',
            icon: Text('MS',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: _showMs ? AppColors.kuningMs : AppColors.gading,
                )),
            onPressed: () => setState(() => _showMs = !_showMs),
          ),
          IconButton(
            tooltip: '접사 색상',
            icon: Icon(Icons.palette,
                color: _colorize ? AppColors.emasBright : AppColors.gading),
            onPressed: () => setState(() => _colorize = !_colorize),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_colorize)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: AffixLegend(),
                  ),
                const ParangDivider(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
                    itemCount: _turns.length,
                    itemBuilder: (_, i) {
                      final t = _turns[i];
                      final sp = speakers[t.speaker] ?? Speaker.defaults[t.speaker]!;
                      return _TurnBubble(
                        turn: t,
                        speaker: sp,
                        showKo: _showKo,
                        showMs: _showMs,
                        colorize: _colorize,
                        learned: _learned.contains(t.id),
                        onToggleLearned: () => _toggleLearned(t),
                        onWordTap: _showWord,
                        onSpeak: () => setState(() {}),
                        episodeKey: ep.key,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _TurnBubble extends StatelessWidget {
  final TurnRow turn;
  final Speaker speaker;
  final bool showKo;
  final bool showMs;
  final bool colorize;
  final bool learned;
  final VoidCallback onToggleLearned;
  final void Function(AffixParse) onWordTap;
  final VoidCallback onSpeak;
  final String episodeKey;

  const _TurnBubble({
    required this.turn,
    required this.speaker,
    required this.showKo,
    required this.showMs,
    required this.colorize,
    required this.learned,
    required this.onToggleLearned,
    required this.onWordTap,
    required this.onSpeak,
    required this.episodeKey,
  });

  @override
  Widget build(BuildContext context) {
    final isA = turn.speaker == 'A';
    final bg = isA ? AppColors.gadingDeep : Colors.white;
    final accent = isA ? AppColors.laut : AppColors.merah;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isA ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isA) _avatar(accent),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isA ? 2 : 12),
                  bottomRight: Radius.circular(isA ? 12 : 2),
                ),
                border: Border.all(
                  color: learned ? AppColors.laut : AppColors.emas.withValues(alpha: 0.5),
                  width: learned ? 1.4 : 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${turn.num}. ${speaker.name}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: accent,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      _iconBtn(
                        Icons.volume_up,
                        () async {
                          await TtsService.instance.speakAs(turn.body, gender: speaker.gender);
                          onSpeak();
                        },
                      ),
                      _iconBtn(
                        learned ? Icons.check_circle : Icons.check_circle_outline,
                        onToggleLearned,
                        color: learned ? AppColors.laut : AppColors.kayuLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AffixText(
                    turn.body,
                    fontSize: 17,
                    colorize: colorize,
                    onWordTap: onWordTap,
                  ),
                  if (showMs && turn.ms != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VariantChip(isMs: true),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            turn.ms!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.biruMs,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (showKo && turn.ko != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      turn.ko!,
                      style: const TextStyle(fontSize: 13, color: AppColors.kayuLight),
                    ),
                  ],
                  if (turn.gloss != null && turn.gloss!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      turn.gloss!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.soganLight,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (turn.note != null && turn.note!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emasBright.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(4),
                        border: Border(left: BorderSide(color: AppColors.merah, width: 3)),
                      ),
                      child: Text(
                        turn.note!,
                        style: const TextStyle(fontSize: 11, color: AppColors.kayu),
                      ),
                    ),
                  ],
                  MemoToggle(patternId: episodeKey, idx: turn.num, sentence: turn.body),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (!isA) _avatar(accent),
        ],
      ),
    );
  }

  Widget _avatar(Color c) => CircleAvatar(
        radius: 16,
        backgroundColor: c,
        child: Text(
          speaker.name.isNotEmpty ? speaker.name[0] : speaker.code,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      );

  Widget _iconBtn(IconData icon, VoidCallback onTap, {Color? color}) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 18, color: color ?? AppColors.kayuLight),
        ),
      );
}

/// 단어 탭 시 하단 시트 — 접사 분해 + 어근 정보.
class _WordSheet extends StatelessWidget {
  final AffixParse parse;
  const _WordSheet({required this.parse});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RootRow?>(
      future: rootRepo.find(parse.root),
      builder: (context, snap) {
        final root = snap.data;
        final family = root == null ? const [] : rootRepo.familyOf(root);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        for (final s in parse.segments)
                          Text(
                            s.text,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: s.isRoot ? AppColors.kayu : affixColor(s.kind),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: AppColors.merah),
                    onPressed: () => TtsService.instance.speak(parse.word),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                parse.hasAffix ? '패턴 ${parse.pattern}  ·  어근 ${parse.root}' : '어근 ${parse.root}',
                style: const TextStyle(fontSize: 12, color: AppColors.kayuLight),
              ),
              const SizedBox(height: 10),
              if (root != null) ...[
                Text(
                  '${root.root}  —  ${root.meaningKo ?? ''}'
                  '${root.pos != null ? '  (${root.pos})' : ''}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                if (root.msForm != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text('MS: ${root.msForm}',
                        style: const TextStyle(fontSize: 12, color: AppColors.biruMs)),
                  ),
                if (family.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text('파생어 가족',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final f in family)
                        Chip(
                          label: Text('${f.word}  ${f.ko}', style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ],
              ] else
                const Text('사전에 없는 어근 — 추후 등록',
                    style: TextStyle(fontSize: 12, color: AppColors.kayuLight)),
            ],
          ),
        );
      },
    );
  }
}
