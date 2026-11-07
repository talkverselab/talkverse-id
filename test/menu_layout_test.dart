// 단어·메뉴 개편 화면이 폰·태블릿 폭에서 넘치지 않는지 — 2026-11-07.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/screens/about_screen.dart';
import 'package:indo_universe/screens/main_screen.dart';
import 'package:indo_universe/screens/word_freq_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    rootBundle.clear(); // 앞 테스트의 시간대에 묶인 캐시 Future 를 버린다
  });

  Future<void> open(WidgetTester t, Size size, Widget w) async {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(home: w));
  }

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 40 && find.text('1단원').evaluate().isEmpty; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 250)));
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  for (final size in const [Size(360, 740), Size(320, 640), Size(800, 1100)]) {
    testWidgets('절벽 단어 ${size.width}', (t) async {
      await open(t, size, const WordFreqScreen());
      await settle(t);
      expect(find.text('절벽구간 단어만'), findsOneWidget);
      expect(find.text('1단원'), findsOneWidget);
      expect(find.text('#1-20'), findsOneWidget);
      expect(find.text('능동 동사 접두사'), findsOneWidget); // 1위 meN- 의 뜻
      await t.tap(find.textContaining('회화 단어 포함 (+'));
      await t.pump();
      await t.dragUntilVisible(find.text('회화'), find.byType(ListView).first, const Offset(-150, 0)); // 구간 칩은 가로로 스크롤된다
      await t.pump(const Duration(milliseconds: 300));
      await t.tap(find.text('회화').first);
      await t.pump(const Duration(milliseconds: 300));
      expect(find.textContaining('회화 1-20'), findsOneWidget);
      expect(t.takeException(), isNull);
    });

    testWidgets('앱 소개 ${size.width}', (t) async {
      await open(t, size, const AboutScreen());
      await t.pump();
      expect(find.text('105-139'), findsOneWidget);
      expect(find.text('524-2000'), findsOneWidget);
      expect(t.takeException(), isNull);
    });

    testWidgets('학습 ${size.width}', (t) async {
      await open(t, size, const LearnScreen());
      await t.pump();
      expect(find.text('절벽 단어 R1~R5'), findsOneWidget);
      expect(find.text('회화 노트'), findsNothing);
      expect(t.takeException(), isNull);
    });
  }
}
