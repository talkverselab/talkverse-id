// 단어·메뉴 개편 확인 스크린샷 — 2026-11-07. 실행: python3 tools/pane_shots.py <UDID> <출력폴더> integration_test/menu_shots_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/main.dart';
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
    await wait(t, 2500);
    // ignore: avoid_print
    print('SHOT:$name');
    await wait(t, 2000);
  }

  testWidgets('menu', timeout: const Timeout(Duration(minutes: 8)), (t) async {
    await embedInit(standalone: true); // 단독 앱과 같은 초기화(lib/embed.dart)
    await t.pumpWidget(embedApp());
    await wait(t, 2000);
    // 새로 깐 기기는 그림 내려받기 화면이 먼저 — 「나중에」로 앱부터 연다
    final later = find.textContaining('나중에');
    if (later.evaluate().isNotEmpty) {
      print('SHOT:00_sync');
      await t.tap(later);
      await wait(t, 2000);
    }
    final wide = find.byType(NavigationRail).evaluate().isNotEmpty;
    Finder nav(String s) => find.descendant(of: find.byType(wide ? NavigationRail : NavigationBar), matching: find.text(s));

    await t.tap(nav('학습'));
    await shot(t, '01_learn');
    await t.tap(find.text('알파벳과 발음'));
    await shot(t, '01a_alphabet');
    await t.tap(find.text('끝소리 8'));
    await wait(t, 600);
    await t.tap(find.text('-k'));
    await shot(t, '01b_sound_sheet');
    await t.tapAt(const Offset(20, 60));
    await wait(t, 800);
    if (!wide) {
      await t.pageBack();
      await wait(t, 800);
    }
    await t.tap(find.text('절벽 단어 R1~R5'));
    await shot(t, '02_words');
    await t.tap(find.textContaining('회화 단어 포함 (+'));
    await wait(t, 500);
    await t.tap(find.text('회화').last);
    await shot(t, '03_conv');
    if (!wide) {
      await t.pageBack();
      await wait(t, 800);
    }
    if (wide) {
      await t.tap(nav('앱 소개'));
      await shot(t, '04_about');
    }
    await t.tap(nav('프로필'));
    await shot(t, '05_profile');
    await t.scrollUntilVisible(find.text('앱 소개').last, 200, scrollable: find.byType(Scrollable).last);
    await t.tap(find.text('앱 소개').last);
    await shot(t, '06_about_profile');
  });
}
