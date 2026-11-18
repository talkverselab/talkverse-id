import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/screens/loanword_quiz_screen.dart';

void main() {
  test('틀린 보기 — 규칙을 되돌린 꼴, 정답·실제 단어와 겹치지 않음, 단어마다 셋 이상이면 표기 문제', () {
    expect(loanMisspellings('informasi', {}), containsAll(['informastion'.replaceFirst('st', 't'), 'informasie']));
    expect(loanMisspellings('universitas', {}), contains('universitety'.replaceFirst('tety', 'ty')));
    expect(loanMisspellings('komputer', {}), contains('computer'));
    final j = json.decode(File('assets/data/vocab/loanwords.json').readAsStringSync()) as Map<String, dynamic>;
    final words = [for (final b in j['branches'] as List) for (final w in (b as Map)['words'] as List) (w as Map)['id'] as String];
    expect(words.length, greaterThanOrEqualTo(100));
    expect(words.toSet().length, words.length);
    final real = words.toSet();
    for (final w in words) {
      expect(loanMisspellings(w, real), isNot(contains(w)));
    }
    expect(words.where((w) => loanMisspellings(w, real).length >= 3).length, greaterThan(words.length ~/ 2));
  });
}
