import 'package:flutter/material.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'data/db/app_database.dart';
import 'data/db/seed_loader.dart';
import 'data/account.dart';
import 'data/entitlement.dart';
import 'data/purchase.dart';
import 'services/achievement_service.dart';
import 'services/learner_prefs.dart';
import 'data/repositories/dialogue_repository.dart';
import 'data/repositories/root_repository.dart';
import 'screens/main_screen.dart';
import 'screens/sync_screen.dart';
import 'services/content_sync.dart';

late final AppDatabase appDb;
late final DialogueRepository dialogueRepo;
late final RootRepository rootRepo;

void main() async {
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
  // 가격·상품 ID = Talkverse 공통(~/talkverse/PRICING.md, 사용자 확정 2026-11-09). 앱 할인가(30%) / 앱 정가. 스토어 등록은 사용자(docs/STORE_PRODUCTS.md).
  Purchase.configure(Entitlement.lang, const [
    Plan('lang_id_1m', 1, 3900, listKrw: 5500),
    Plan('lang_id_3m', 3, 9000, listKrw: 12900),
    Plan('lang_id_1y', 12, 19900, listKrw: 28500),
    Plan('lang_id_life', 0, 49000, listKrw: 69900),
    Plan('all_1y', 12, 79000, listKrw: 112900, bundle: true),
    Plan('all_life', 0, 329000, bundle: true), // 종합 평생은 할인 없음 — 정가 표시를 하지 않는다
  ]);
  // 그림(단어 그림·장면 컷) 기기 내려받기: 버전이 다르면 로딩 화면에서 받고 시작(사용자 지시 2026-11-04)
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final large = view.physicalSize.shortestSide / view.devicePixelRatio >= 600;
  final needSync = await ContentSync.instance.init(large: large, female: LearnerPrefs.isFemale);
  runApp(IndoUniverseApp(syncFirst: needSync));
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
