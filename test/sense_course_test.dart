import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/screens/sense_course_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> settle(WidgetTester t, Finder until) async {
  for (var i = 0; i < 100 && until.evaluate().isEmpty; i++) {
    await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await t.pump();
  }
  await t.pump(const Duration(milliseconds: 300));
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final w in const [320.0, 900.0]) {
    testWidgets('언어감각 목록 폭 $w — 10급, 급마다 외울 대화 1회, 넘침 없음', (t) async {
      t.view.physicalSize = Size(w, 6000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: SenseCourseScreen()));
      await settle(t, find.text('0/10회 마침'));
      expect(t.takeException(), isNull);
      expect(find.text('0/10회 마침'), findsOneWidget);
      for (var i = 1; i <= 10; i++) {
        expect(find.byKey(ValueKey('sense-L$i-talk')), findsOneWidget);
      }
      expect(find.byKey(const ValueKey('sense-L1-ref')), findsOneWidget); // 접사 화면 열기
      expect(find.byKey(const ValueKey('sense-L3-ref')), findsOneWidget);
    });
  }

  testWidgets('외울 대화 — 영상 없으면 칸 없음, 색 표시가 글자에 안 남음, 마침 → 다음 급', (t) async {
    t.view.physicalSize = const Size(320, 3000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: SenseLessonScreen(index: 0)));
    await settle(t, find.byKey(const ValueKey('sense-finish')));
    expect(t.takeException(), isNull);
    expect(find.byKey(const ValueKey('memorize-video')), findsNothing); // 영상 없는 회차는 칸을 숨김(심사 정리 2026-11-22)
    expect(find.textContaining('{', findRichText: true), findsNothing);
    expect(plainMarked('Aku {membaca|1} novel.'), 'Aku membaca novel.');
    await t.tap(find.byKey(const ValueKey('sense-finish')));
    await t.pump(const Duration(milliseconds: 500));
    await t.pump(const Duration(milliseconds: 500));
    expect(await SenseCourse.done(), contains('L1-talk'));
  });
}
