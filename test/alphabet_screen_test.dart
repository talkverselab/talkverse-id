import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/screens/alphabet_screen.dart';
import 'package:indo_universe/services/id_phonetics.dart';

void main() {
  test('발음 자료: 묶음 이름의 수와 항목 수가 같고 빈 칸이 없다', () {
    for (final g in soundGroups) {
      expect(int.parse(g.label.split(' ').last), g.items.length, reason: g.label);
      for (final s in g.items) {
        expect([s.unit, s.name, s.rd, s.ipa, s.place, s.korSim, s.korDiff, s.say].every((x) => x.isNotEmpty), isTrue, reason: s.unit);
        expect(s.examples, isNotEmpty, reason: s.unit);
        for (final n in s.nums) {
          expect(placeNames.containsKey(n), isTrue, reason: '${s.unit} $n');
        }
      }
    }
    expect(soundGroups.first.items.every((s) => s.vowel), isTrue);
  });

  for (final w in [320.0, 360.0, 800.0]) {
    testWidgets('알파벳 화면 폭 $w: 모든 묶음이 넘치지 않고 시트가 열린다', (t) async {
      t.view.physicalSize = Size(w, 760);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(const MaterialApp(home: AlphabetScreen()));
      for (final g in soundGroups) {
        await t.tap(find.text(g.label));
        await t.pumpAndSettle();
        expect(t.takeException(), isNull, reason: g.label);
        await t.tap(find.text(g.items.first.unit).first);
        await t.pumpAndSettle();
        expect(find.textContaining('IPA ['), findsOneWidget);
        await t.dragUntilVisible(find.textContaining('예시 낱말'), find.byType(ListView).last, const Offset(0, -200));
        await t.pumpAndSettle();
        expect(find.textContaining('한국어와 비교'), findsOneWidget);
        expect(t.takeException(), isNull, reason: '${g.label} 시트');
        await t.pump(const Duration(seconds: 2));
        Navigator.of(t.element(find.byType(AlphabetScreen))).pop();
        await t.pumpAndSettle();
      }
    });
  }
}
