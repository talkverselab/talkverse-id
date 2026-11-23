import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/data/entitlement.dart';
import 'package:indo_universe/data/purchase.dart';
import 'package:indo_universe/screens/paywall_screen.dart';
import 'package:indo_universe/services/curriculum_service.dart';
import 'package:indo_universe/services/dialogue_service.dart';
import 'package:indo_universe/widgets/lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dialogue _d(String region) => Dialogue(id: 'x_$region', region: region, island: 'life', title: 't', emoji: '', scene: '', speakers: const {}, genders: const {}, expressions: const [], turns: const []);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Purchase.queried.value = false;
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
    testWidgets('이용권 시트 폭 $w: 6개 상품·코드 원화 없음·미선택·약관·복원', (t) async {
      t.view.physicalSize = Size(w, 1800);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: Scaffold(body: PaywallScreen())));
      await t.pump();
      expect(t.takeException(), isNull);
      for (final v in ['1개월', '3개월', '1년', '평생 이용권(서비스 운영 기간 동안)', '종합 패키지 1년 — 모든 언어']) {
        expect(find.text(v), findsOneWidget, reason: v);
      }
      expect(find.textContaining('₩'), findsNothing); // 가격은 스토어 값만
      expect(find.text('이용권을 골라 주세요'), findsOneWidget);
      expect(find.text('이용약관'), findsOneWidget);
      expect(find.text('개인정보처리방침'), findsOneWidget);
      expect(find.text('이전 구매 복원'), findsOneWidget);
      expect(find.text('토크버스 커리큘럼 2단계 이상'), findsOneWidget);
    });
  }

  testWidgets('스토어를 못 부르면 「잠시 뒤 다시 시도」와 닫기', (t) async {
    t.view.physicalSize = const Size(400, 1800);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const MaterialApp(home: Scaffold(body: PaywallScreen())));
    Purchase.queried.value = true;
    await t.pump();
    expect(find.byKey(const ValueKey('paywall-nostore')), findsOneWidget);
    expect(find.text('닫기'), findsOneWidget);
  });

  test('잠금 경계 — 1단계 열림·2단계 잠김·이용권 있으면 열림', () async {
    await Entitlement.set(false);
    Purchase.owned.value = const {};
    expect(dialogueLocked(_d('R0')), isFalse);
    expect(dialogueLocked(_d('R1')), isFalse);
    expect(dialogueLocked(_d('R2')), isTrue);
    final svc = CurriculumService.instance..stages = const [CurStage('1', '1단계', '', ['a']), CurStage('2', '2단계', '', ['b'], free: false)];
    expect(svc.stageLocked('1'), isFalse);
    expect(svc.stageLocked('2'), isTrue);
    Purchase.owned.value = {'lang_id_life': 0};
    expect(dialogueLocked(_d('R2')), isFalse);
    expect(svc.stageLocked('2'), isFalse);
    Purchase.owned.value = {'all_1y': DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch};
    expect(dialogueLocked(_d('R3')), isFalse);
    Purchase.owned.value = {'lang_ja_life': 0}; // 다른 언어 이용권은 안 열림
    expect(dialogueLocked(_d('R3')), isTrue);
  });

  test('단계 JSON 의 free — 없으면 1단계만 무료', () {
    final st = parseStages({
      'stages': [
        {'n': 1, 'dialogueIds': ['a']},
        {'n': 2, 'dialogueIds': ['a']},
        {'n': 3, 'dialogueIds': ['a'], 'free': true},
      ]
    }, (id) => _d('R1'));
    expect(st.map((s) => s.free), [true, false, true]);
  });
}
