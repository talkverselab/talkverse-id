import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/pane.dart';
import '../core/platform.dart';
import '../core/theme.dart';
import '../services/dialogue_service.dart';
import '../widgets/indo_decor.dart';
import 'about_screen.dart';
import 'affix_screen.dart';
import 'dialogue_screen.dart';
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

  final _pane = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final stack = IndexedStack(index: _index, children: _screens);
    // 폰(한 화면): 하단 탭 + 내용 전체 화면
    if (!isWide(context)) {
      return Scaffold(
        body: stack,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: _tabs,
        ),
      );
    }
    // 넓은 화면(아이패드·태블릿·폴드 펼침): 레일 + 왼쪽 칸(탭 화면) | 오른쪽 칸(연 화면) — 일본어앱 main_screen 과 같은 구조(2026-11-02).
    // 회화 재생·카드 같은 학습은 openFull 로 전체 화면.
    final w = MediaQuery.sizeOf(context).width;
    final left = (w * 0.34).clamp(300.0, 440.0);
    return Pane(
      navKey: _pane,
      child: NavigatorPopHandler(
        onPopWithResult: (_) => _pane.currentState?.maybePop(),
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  onDestinationSelected: (i) => setState(() => _index = i),
                  labelType: w >= 900 ? NavigationRailLabelType.all : NavigationRailLabelType.selected,
                  backgroundColor: AppColors.washiDeep,
                  indicatorColor: AppColors.beni.withValues(alpha: 0.12),
                  selectedIconTheme: const IconThemeData(color: AppColors.beniDeep),
                  unselectedIconTheme: const IconThemeData(color: AppColors.muted),
                  selectedLabelTextStyle: const TextStyle(color: AppColors.beni, fontSize: 11, fontWeight: FontWeight.w600),
                  unselectedLabelTextStyle: const TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600),
                  destinations: [
                    for (final t in _tabs)
                      NavigationRailDestination(icon: t.icon, selectedIcon: t.selectedIcon, label: Text(t.label)),
                  ],
                  // 맨 아래 「앱 소개」 — 절벽구간 설명(사용자 지시 2026-11-07, 일본어앱과 같은 자리)
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () => openPane(context, (_) => const AboutScreen()),
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.info_outline, color: AppColors.muted, size: 22),
                                SizedBox(height: 4),
                                Text('앱 소개', style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: AppColors.line),
                SizedBox(width: left, child: stack),
                const VerticalDivider(width: 1, thickness: 1, color: AppColors.line),
                Expanded(
                  child: ClipRect(
                    child: Navigator(
                      key: _pane,
                      onGenerateInitialRoutes: (_, _) => [MaterialPageRoute(builder: (_) => const DialogueHomeScreen())], // 시안 02-1: 오른쪽 칸 첫 화면 = 회화 홈
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          const Positioned(top: 0, left: 0, right: 0, height: 260, child: MeshBackdrop()),
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
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.kayu,
                                  letterSpacing: -1,
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
                    fontWeight: FontWeight.w600,
                    color: AppColors.merah,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 8),
                const _HomeTodayCut(),
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

class _MenuGrid extends StatelessWidget {
  const _MenuGrid();

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem(icon: Icons.chat_bubble_rounded, label: '회화', sub: 'Percakapan', seal: 'L1', color: AppColors.merah,
          builder: (_) => const DialogueHomeScreen()),
      _MenuItem(icon: Icons.extension_rounded, label: '접사', sub: 'Afiks meN-/ber-/-kan', seal: 'AFX', color: AppColors.affixMe,
          builder: (_) => const AffixScreen()),
      _MenuItem(icon: Icons.account_tree_rounded, label: '어근', sub: 'Kata dasar', seal: '√', color: AppColors.sogan,
          builder: (_) => const RootsScreen()),
      _MenuItem(icon: Icons.layers_rounded, label: '단어', sub: 'Frekuensi', seal: 'TOP', color: AppColors.laut,
          builder: (_) => const WordFreqScreen()),
      _MenuItem(icon: Icons.compare_arrows_rounded, label: 'ID ↔ MS', sub: '인니어·말레이어 차이', seal: 'MS', color: AppColors.biruMs,
          builder: (_) => const VariantsScreen()),
      _MenuItem(icon: Icons.style_rounded, label: '복습', sub: 'Flashcard', seal: 'ULG', color: AppColors.emasDeep,
          builder: (_) => const FlashcardScreen()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 150, // 고정 높이 — 아이패드 왼쪽 좁은 칸(300~440)에서 비율로 잡으면 아래가 넘친다
      ),
      itemCount: items.length,
      itemBuilder: (context, i) => _MenuTile(item: items[i]),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String sub;
  final String seal;
  final Color color;
  final WidgetBuilder builder;
  _MenuItem({
    required this.icon,
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
      onTap: () => openPane(context, item.builder),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gading,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.emas),
          boxShadow: const [
            BoxShadow(color: Color(0x1A32325D), blurRadius: 5, offset: Offset(0, 2), spreadRadius: -1),
            BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1), spreadRadius: -1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 34, color: item.color), // 시안 02-1: 도장 대신 아이콘
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

/// 학습 — 기초 → 문법 → 회화 → 단어 → 복습 → 참고(맨 아래). 일본어앱 메뉴 정리(사용자 지시 2026-11-07)와 같은 순서.
class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  static final List<_LessonItem> _lessons = [
    _LessonItem('기초', '어근 core', 'kata dasar → 파생어 가족', Icons.spa_outlined,
        AppColors.sogan, (_) => const RootsScreen()),
    _LessonItem('문법', '접사 체계', 'meN- / ber- / di- / ter- / -kan / -i / -an / ke-an', Icons.account_tree_outlined,
        AppColors.affixMe, (_) => const AffixScreen()),
    _LessonItem('회화', '만화책 읽기 회화', '장면 컷 + 대화 스크립트 · 모든 문장 듣기 · 그림 카드', Icons.auto_stories_outlined,
        AppColors.beni, (_) => const DialogueHomeScreen()),
    _LessonItem('단어', '절벽 단어 R1~R5', '빈도 2,000 · 20어 단원 · 회화 단어 포함', Icons.format_list_numbered,
        AppColors.laut, (_) => const WordFreqScreen()),
    _LessonItem('복습', '복습 플래시카드', '학습한 문장 랜덤 복습', Icons.style_outlined,
        AppColors.emasDeep, (_) => const FlashcardScreen()),
    _LessonItem('참고', '인니어 ↔ 말레이어', '어휘·철자·대명사 차이', Icons.compare_arrows,
        AppColors.biruMs, (_) => const VariantsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: const Text('학습')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
        children: [
          for (final l in _lessons) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
              child: Text(l.category, style: const TextStyle(color: AppColors.kayu, fontSize: 14, fontWeight: FontWeight.w800)),
            ),
            _LessonRow(item: l),
          ],
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
        onTap: () => openPane(context, item.builder),
      ),
    );
  }
}

/// 홈 「오늘의 컷 / 이어서 읽기」(시안 02-1) — 회화 서비스를 불러온 뒤 그린다.
class _HomeTodayCut extends StatefulWidget {
  const _HomeTodayCut();
  @override
  State<_HomeTodayCut> createState() => _HomeTodayCutState();
}

class _HomeTodayCutState extends State<_HomeTodayCut> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    DialogueService.instance.ensureLoaded().then((_) => mounted ? setState(() => _loaded = true) : null);
  }

  // const 로 두면 불러온 뒤에도 다시 그려지지 않는다 → 불러온 상태를 키로
  @override
  Widget build(BuildContext context) => TodayCutCard(key: ValueKey(_loaded));
}
