import 'package:flutter/material.dart';

import 'core/constants.dart';
import 'core/embed_env.dart';
import 'core/theme.dart';
import 'data/account.dart';
import 'data/db/app_database.dart';
import 'data/db/seed_loader.dart';
import 'data/entitlement.dart';
import 'data/purchase.dart';
import 'data/repositories/dialogue_repository.dart';
import 'data/repositories/root_repository.dart';
import 'screens/main_screen.dart';
import 'screens/sync_screen.dart';
import 'services/achievement_service.dart';
import 'services/content_sync.dart';
import 'services/learner_prefs.dart';

export 'core/embed_env.dart' show embedded;

/// 통합 앱(Talkverse) 연결점 — 2026-11-09 EMBED_GUIDE(일본어앱 lib/embed.dart 와 같은 틀).
/// 단독 앱 `main()`: `await embedInit(standalone: true)` → `runApp(embedApp())`.
/// 통합 앱: `await embedInit()` → 이 언어 화면을 열 때 `embedApp(onSwitchLanguage: …)`.

late final AppDatabase appDb;
late final DialogueRepository dialogueRepo;
late final RootRepository rootRepo;
bool _inited = false;
bool _syncFirst = false;

/// 「다른 언어 배우기」 — 통합 앱이 넘긴 콜백(없으면 메뉴를 안 보인다).
VoidCallback? switchLanguage;

/// 초기화 전부(화면 방향·runApp 제외). 여러 번 불러도 한 번만 한다.
Future<void> embedInit({bool standalone = false}) async {
  if (_inited) return;
  _inited = true;
  embedded = !standalone;
  WidgetsFlutterBinding.ensureInitialized();
  appDb = AppDatabase();
  await SeedLoader(appDb).seedIfNeeded();
  dialogueRepo = DialogueRepository(appDb);
  rootRepo = RootRepository(appDb);
  await rootRepo.primeAffixUtil();
  await Entitlement.load();
  await LearnerPrefs.load();
  await AchievementService.instance.load();
  Account.load(); // 저장된 로그인 표시 + 뒤에서 토큰 갱신(기다리지 않음)
  Purchase.ownStream = standalone; // 통합 앱이면 결제 스트림은 공용 결제가 넘겨준다
  // 가격·상품 ID = Talkverse 공통(~/talkverse/PRICING.md, 사용자 확정 2026-11-09). 앱 할인가(30%) / 앱 정가. 스토어 등록은 사용자(docs/STORE_PRODUCTS.md).
  Purchase.configure(Entitlement.lang, const [
    Plan('lang_id_1m', 1, 3900, listKrw: 5500),
    Plan('lang_id_3m', 3, 9000, listKrw: 12900),
    Plan('lang_id_1y', 12, 19900, listKrw: 28500),
    Plan('lang_id_life', 0, 49000, listKrw: 69900),
    Plan('all_1y', 12, 79000, listKrw: 112900, bundle: true),
    Plan('all_life', 0, 329000, bundle: true), // 종합 평생은 할인 없음 — 정가 표시를 하지 않는다
  ]);
  // 그림(단어 그림·장면 컷)·회화 음성 기기 내려받기: 버전이 다르면 로딩 화면에서 받고 시작(사용자 지시 2026-11-04)
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final large = view.physicalSize.shortestSide / view.devicePixelRatio >= 600;
  _syncFirst = await ContentSync.instance.init(large: large, female: LearnerPrefs.isFemale);
}

/// runApp 에 넘기는 위젯(통합 앱은 이 언어 화면으로). [onSwitchLanguage] 가 있으면 프로필 → 설정 맨 위에 「다른 언어 배우기」.
Widget embedApp({VoidCallback? onSwitchLanguage}) {
  switchLanguage = onSwitchLanguage;
  return IndoUniverseApp(syncFirst: _syncFirst);
}

class IndoUniverseApp extends StatelessWidget {
  final bool syncFirst;
  const IndoUniverseApp({super.key, this.syncFirst = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      home: syncFirst ? const SyncScreen(next: MainScreen()) : const MainScreen(),
    );
  }
}
