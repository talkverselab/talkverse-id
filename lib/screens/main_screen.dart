import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/models/episode.dart';
import '../main.dart';
import '../widgets/indo_decor.dart';
import '../widgets/today_mission.dart';
import 'affix_screen.dart';
import 'conversation_screen.dart';
import 'episode_screen.dart';
import 'flashcard_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'roots_screen.dart';
import 'variants_screen.dart';
import 'word_freq_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    LearnScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  static const List<NavigationDestination> _tabs = [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '홈'),
    NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: '학습'),
    NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: '진행'),
    NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '프로필'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _tabs,
      ),
    );
  }
}

// ────────── Home 탭 ──────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gading,
      body: Stack(
        children: [
          const Positioned.fill(child: BatikPattern(opacity: 0.05)),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Halo!',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.merah,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text('👋', style: TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '한국 학습자, 오늘도 시작해요',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.kayuLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const StreakChip(days: 1),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.gading,
                        border: Border.all(color: AppColors.emas),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: AppColors.merah, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  '오늘의 학습',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.kayu,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const _TodayMission(),
                const SizedBox(height: 22),
                const Row(
                  children: [
                    BadgeStamp(text: 'ID', size: 22),
                    SizedBox(width: 8),
                    Text(
                      '메인 메뉴',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.kayu,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const _MenuGrid(),
                const SizedBox(height: 28),
                const SoftDivider(),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    '${AppInfo.appName} · ${AppInfo.year}',
                    style: TextStyle(
                      color: AppColors.kayuLight,
                      fontSize: 11,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 홈 '오늘의 학습' — 첫 미완료 에피소드와 실제 진행도 연결.
class _TodayMission extends StatefulWidget {
  const _TodayMission();

  @override
  State<_TodayMission> createState() => _TodayMissionState();
}

class _TodayMissionState extends State<_TodayMission> {
  EpisodeMeta? _meta;
  int _learned = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final progress = await dialogueRepo.progressByEpisode();
    final all = dialogueRepo.catalog;
    if (all.isEmpty) return;
    EpisodeMeta pick = all.first;
    for (final meta in all) {
      final (done, total) = progress[meta.key] ?? (0, 0);
      if (total == 0 || done < total) {
        pick = meta;
        break;
      }
    }
    final (done, total) = progress[pick.key] ?? (0, 0);
    if (!mounted) return;
    setState(() {
      _meta = pick;
      _learned = done;
      _total = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meta = _meta;
    return TodayMissionCard(
      level: meta?.level ?? 'L1',
      lessonTitle: meta == null ? '준비 중' : '${meta.emoji} ${meta.title}',
      lessonSubtitle: meta?.scenario ?? '대화 데이터를 불러오는 중',
      progress: _learned,
      total: _total,
      onTap: meta == null
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EpisodeScreen(episode: meta)),
              ).then((_) => _load()),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(label: '회화', sub: 'Percakapan', seal: 'L1', color: AppColors.merah,
          builder: (_) => const ConversationScreen()),
      _MenuItem(label: '접사', sub: 'Afiks meN-/ber-/-kan', seal: 'AFX', color: AppColors.affixMe,
          builder: (_) => const AffixScreen()),
      _MenuItem(label: '어근', sub: 'Kata dasar', seal: '√', color: AppColors.sogan,
          builder: (_) => const RootsScreen()),
      _MenuItem(label: '단어', sub: 'Frekuensi', seal: 'TOP', color: AppColors.laut,
          builder: (_) => const WordFreqScreen()),
      _MenuItem(label: 'ID ↔ MS', sub: '인니어·말레이어 차이', seal: 'MS', color: AppColors.biruMs,
          builder: (_) => const VariantsScreen()),
      _MenuItem(label: '복습', sub: 'Flashcard', seal: 'ULG', color: AppColors.emas,
          builder: (_) => const FlashcardScreen()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _MenuTile(item: items[i]),
    );
  }
}

class _MenuItem {
  final String label;
  final String sub;
  final String seal;
  final Color color;
  final WidgetBuilder builder;
  _MenuItem({
    required this.label,
    required this.sub,
    required this.seal,
    required this.color,
    required this.builder,
  });
}

class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: item.builder)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gading,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.emas.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.kayu.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BadgeStamp(text: item.seal, size: 44, color: item.color),
              const SizedBox(height: 8),
              Text(
                item.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.kayu,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.sub,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.kayuLight,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────── Learn 탭 ──────────

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _filter = '전체';
  static const _filters = ['전체', '회화', '접사', '어근', '단어', '변이'];

  List<_LessonItem> get _lessons => [
        _LessonItem('회화', 'L1 매칭 narrative', 'Mark × Sari · 5 ep × 40 turn', Icons.chat_bubble_outline,
            AppColors.merah, (_) => const ConversationScreen()),
        _LessonItem('접사', '접사 체계', 'meN- / ber- / di- / ter- / -kan / -i / -an / ke-an', Icons.account_tree_outlined,
            AppColors.affixMe, (_) => const AffixScreen()),
        _LessonItem('어근', '어근 core', 'kata dasar → 파생어 가족', Icons.spa_outlined,
            AppColors.sogan, (_) => const RootsScreen()),
        _LessonItem('단어', '빈도 단어', 'Top 2500 · R1~R4 구간', Icons.format_list_numbered,
            AppColors.laut, (_) => const WordFreqScreen()),
        _LessonItem('변이', '인니어 ↔ 말레이어', '어휘·철자·대명사 차이', Icons.compare_arrows,
            AppColors.biruMs, (_) => const VariantsScreen()),
        _LessonItem('회화', '복습 플래시카드', '학습한 문장 랜덤 복습', Icons.style_outlined,
            AppColors.emasDeep, (_) => const FlashcardScreen()),
      ];

  @override
  Widget build(BuildContext context) {
    final list = _filter == '전체'
        ? _lessons
        : _lessons.where((l) => l.category == _filter).toList();
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: const Text('학습')),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final sel = f == _filter;
                return ChoiceChip(
                  label: Text(f),
                  selected: sel,
                  onSelected: (_) => setState(() => _filter = f),
                );
              },
            ),
          ),
          const ParangDivider(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _LessonRow(item: list[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonItem {
  final String category;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final WidgetBuilder builder;
  const _LessonItem(this.category, this.title, this.subtitle, this.icon, this.color, this.builder);
}

class _LessonRow extends StatelessWidget {
  final _LessonItem item;
  const _LessonRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, color: item.color),
        ),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(item.subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.kayuLight),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: item.builder)),
      ),
    );
  }
}
