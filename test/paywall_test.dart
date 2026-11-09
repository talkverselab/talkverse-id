import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/data/purchase.dart';
import 'package:indo_universe/screens/paywall_screen.dart';

void main() {
  setUp(() {
    Purchase.plans = const [
      Plan('lang_id_1m', 1, 3900, listKrw: 5500),
      Plan('lang_id_3m', 3, 9000, listKrw: 12900),
      Plan('lang_id_1y', 12, 19900, listKrw: 28500),
      Plan('lang_id_life', 0, 49000, listKrw: 69900),
      Plan('all_1y', 12, 79000, listKrw: 112900, bundle: true),
      Plan('all_life', 0, 329000, bundle: true),
    ];
  });

  for (final w in [320.0, 800.0]) {
    testWidgets('이용권 시트 폭 $w: 6개 상품·정가·미선택·약관 링크', (t) async {
      t.view.physicalSize = Size(w, 1600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: Scaffold(body: PaywallScreen())));
      await t.pump();
      expect(t.takeException(), isNull);
      for (final v in ['₩3,900', '₩9,000', '₩19,900', '₩49,000', '₩79,000', '₩329,000']) {
        expect(find.text(v), findsOneWidget, reason: v);
      }
      expect(find.textContaining('₩5,500'), findsOneWidget);
      expect(find.textContaining('₩469,000'), findsNothing); // 종합 평생은 할인 표시 없음
      expect(find.text('이용권을 골라 주세요'), findsOneWidget); // 미리 고르지 않는다
      expect(find.text('평생 이용권(서비스 운영 기간 동안)'), findsOneWidget);
      expect(find.text('이용약관'), findsOneWidget);
      expect(find.text('개인정보처리방침'), findsOneWidget);
      expect(find.text('이전 구매 복원'), findsOneWidget);
      await t.tap(find.text('1개월'));
      await t.pump();
      expect(find.textContaining('자동 갱신됩니다'), findsOneWidget);
      expect(find.textContaining('해지'), findsWidgets);
    });
  }
}
