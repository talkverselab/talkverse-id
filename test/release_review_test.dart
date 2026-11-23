// 출시 심사 점검(uk 11-23): 앱 묶음 원고에 작업 기록 칸·작업 도구 이름이 없어야 한다.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('회화·언어감각 원고에 review·draft 칸과 작업 도구 이름이 없다', () {
    final files = Directory('assets/data').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.json'));
    final bad = <String>[];
    for (final f in files) {
      final s = f.readAsStringSync();
      if (RegExp('grok|claude|gemini', caseSensitive: false).hasMatch(s)) bad.add(f.path);
      if (f.path.contains('/dialogues/R')) {
        final j = json.decode(s) as Map<String, dynamic>;
        if (j.containsKey('review') || j.containsKey('draft')) bad.add('${f.path} (review/draft)');
      }
    }
    expect(bad, isEmpty);
  });
}
