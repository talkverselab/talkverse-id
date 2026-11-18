import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/screens/loanword_quiz_screen.dart';
import 'package:indo_universe/screens/loanword_screen.dart';
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

  testWidgets('외국어에서 온 말 — 규칙표 → 줄기 → 3단계, 폭 320 넘침 없음', (t) async {
    t.view.physicalSize = const Size(320, 3000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: LoanwordScreen()));
    await settle(t, find.byKey(const ValueKey('loan-tab-0')));
    expect(t.takeException(), isNull);
    expect(find.textContaining('information → informasi'), findsWidgets);
    await t.tap(find.byKey(const ValueKey('loan-tab-0')));
    await t.pump();
    expect(find.text('informasi'), findsOneWidget);
    expect(find.text('administrasi'), findsNothing);
    await t.tap(find.text('전체'));
    await t.pump();
    expect(find.text('administrasi'), findsOneWidget);
  });

  testWidgets('퀴즈 — 10문제, 고르면 정답 표시, 끝나면 점수', (t) async {
    t.view.physicalSize = const Size(320, 2000);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    final words = [for (var i = 0; i < 12; i++) LQWord('informasi$i'.replaceAll(RegExp(r'\d'), String.fromCharCode(97 + i)), 'w$i', '뜻$i')];
    await t.pumpWidget(MaterialApp(home: LoanwordQuizScreen(words: words, seed: 1)));
    await settle(t, find.byKey(const ValueKey('lq-opt-0')));
    for (var q = 0; q < kLoanQuizSize; q++) {
      await t.tap(find.byKey(const ValueKey('lq-opt-0')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('lq-next')));
      await t.pump();
    }
    expect(find.textContaining('10문제 중'), findsOneWidget);
    expect(t.takeException(), isNull);
  });
}
