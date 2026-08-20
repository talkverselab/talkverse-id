import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/models/episode.dart';
import '../main.dart';
import '../widgets/indo_decor.dart';
import 'episode_screen.dart';

/// 회화 — 레벨별 에피소드/대화 목록 + 진행도.
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Map<String, (int, int)> _progress = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await dialogueRepo.progressByEpisode();
    if (!mounted) return;
    setState(() {
      _progress = p;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalog = dialogueRepo.catalog;
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: const Text('회화 · Percakapan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : catalog.isEmpty
              ? const _EmptyHint()
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    for (final level in Levels.all)
                      if (dialogueRepo.byLevel(level).isNotEmpty) ...[
                        _LevelHeader(level: level),
                        const SizedBox(height: 8),
                        for (final ep in dialogueRepo.byLevel(level))
                          _EpisodeTile(
                            meta: ep,
                            done: _progress[ep.key]?.$1 ?? 0,
                            total: _progress[ep.key]?.$2 ?? ep.turnCount,
                            onOpen: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EpisodeScreen(episode: ep)),
                            ).then((_) => _load()),
                          ),
                        const SizedBox(height: 16),
                      ],
                  ],
                ),
    );
  }
}

class _LevelHeader extends StatelessWidget {
  final String level;
  const _LevelHeader({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BadgeStamp(text: level, size: 28),
        const SizedBox(width: 8),
        Text(
          Levels.titles[level] ?? level,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.kayu,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(child: ParangDivider(height: 8)),
      ],
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final EpisodeMeta meta;
  final int done;
  final int total;
  final VoidCallback onOpen;
  const _EpisodeTile({
    required this.meta,
    required this.done,
    required this.total,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? done / total : 0.0;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text(meta.emoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${meta.id.toUpperCase()} · ${meta.title}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    if (meta.scenario.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        meta.scenario,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.kayuLight),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 6,
                        backgroundColor: AppColors.gadingDeep,
                        color: pct >= 1 ? AppColors.laut : AppColors.merah,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$done/$total',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kayuLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          '대화 데이터가 없습니다.\nassets/data/dialogues/id/L1.json 을 확인하세요.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.kayuLight),
        ),
      ),
    );
  }
}
