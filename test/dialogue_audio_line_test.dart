import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/services/dialogue_audio.dart';

void main() {
  test('녹음 대사 ↔ 원고 줄 비교', () {
    expect(sameLine('Selamat pagi, Pak!', 'Selamat pagi, Pak.'), isTrue);
    expect(sameLine('Halo, Dewi.', 'Halo, {name}.'), isTrue);
    expect(sameLine('Selamat pagi, Pak!', 'Selamat siang, Pak.'), isFalse);
    expect(sameLine('', 'apa saja'), isTrue);
  });
}
