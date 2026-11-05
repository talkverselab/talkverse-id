// 아이패드 두 화면 + 만화책 읽기형 회화 확인용 스크린샷 흐름 — 2026-11-02(일본어앱 dialogue_pane_test 를 옮김).
// 실행: python3 tools/pane_shots.py <아이패드 UDID> <출력폴더> integration_test/dialogue_pane_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/data/db/app_database.dart';
import 'package:indo_universe/data/db/seed_loader.dart';
import 'package:indo_universe/data/repositories/dialogue_repository.dart';
import 'package:indo_universe/data/repositories/root_repository.dart';
import 'package:indo_universe/main.dart';
import 'package:indo_universe/services/achievement_service.dart';
import 'package:indo_universe/services/art_service.dart';
import 'package:indo_universe/services/content_sync.dart';
import 'package:indo_universe/services/learner_prefs.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  Future<void> wait(WidgetTester t, int ms) async {
    final end = DateTime.now().add(Duration(milliseconds: ms));
    while (DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 100));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> shot(WidgetTester t, String name) async {
    await wait(t, 2000);
    // ignore: avoid_print
    print('SHOT:$name');
    await wait(t, 3000);
  }

  Finder rail(String label) => find.descendant(of: find.byType(NavigationRail), matching: find.text(label));

  testWidgets('dialogue pane', timeout: const Timeout(Duration(minutes: 10)), (t) async {
    appDb = AppDatabase();
    await SeedLoader(appDb).seedIfNeeded();
    dialogueRepo = DialogueRepository(appDb);
    rootRepo = RootRepository(appDb);
    await rootRepo.primeAffixUtil();
    await LearnerPrefs.load();
    await AchievementService.instance.load();
    await ContentSync.instance.init(large: true); // 저장소 장면 컷 쓰는지 확인
    print('SCENE_URL:${await sceneVariant('assets/images/scenes/r1_friends_a1_1.jpg')}');
    await t.pumpWidget(const IndoUniverseApp());
    await wait(t, 1500);
    await shot(t, '01_home_wide');

    await t.tap(rail('학습'));
    await wait(t, 1000);
    await t.tap(find.text('만화책 읽기 회화'));
    await wait(t, 2500);
    await shot(t, '02_dialogue_home_right');

    await t.tap(find.text('사랑').first);
    await wait(t, 1200);
    await shot(t, '03_topic_list');

    await t.tap(find.text('누구랑 왔어?').first);
    await wait(t, 1500);
    // 이름이 비어 있으면 이름·성별 창(2026-11-04)
    if (find.text('나중에').evaluate().isNotEmpty) {
      await shot(t, '04a_name_dialog');
      await t.enterText(find.byType(TextField).last, 'Mina');
      await t.tap(find.text('저장'));
      await wait(t, 1200);
    }
    await shot(t, '04_reader');

    // 시안 02-2: 캡션의 단어를 누르면 단어 분석 시트
    final w = find.text('kabar', findRichText: true);
    if (w.evaluate().isNotEmpty) {
      await t.tap(w.last);
      await wait(t, 1500);
      await shot(t, '04b_word_sheet');
      await t.tapAt(const Offset(400, 120));
      await wait(t, 800);
    }

    await t.tap(find.text('재생').first);
    await wait(t, 6000);
    await shot(t, '05_reader_playing');

    await t.tap(find.byTooltip('그림 카드(글자 없이)'));
    await wait(t, 1500);
    await shot(t, '06_card_front');
    await t.tap(find.text('탭해서 확인'));
    await wait(t, 800);
    await shot(t, '07_card_back');
    await t.pageBack();
    await wait(t, 1200);

    await t.tap(rail('진행'));
    await wait(t, 1500);
    await shot(t, '08_progress_achievements');

    await t.tap(rail('프로필'));
    await wait(t, 1500);
    await shot(t, '09_profile');
  });
}
