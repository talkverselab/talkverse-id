import 'package:flutter_test/flutter_test.dart';
import 'package:indo_universe/core/constants.dart';
import 'package:indo_universe/services/affix_util.dart';

void main() {
  group('AffixUtil', () {
    setUp(() {
      AffixUtil.setKnownRoots(['baca', 'tulis', 'ajar', 'kerja', 'kenal', 'sapu', 'pakai', 'makan', 'sehat', 'jalan']);
    });

    test('meN- 비음 동화 복원', () {
      expect(AffixUtil.parse('membaca').root, 'baca');
      expect(AffixUtil.parse('menulis').root, 'tulis');
      expect(AffixUtil.parse('menyapu').root, 'sapu');
      expect(AffixUtil.parse('memakai').root, 'pakai');
    });

    test('ber- 변이형 bel-/be-', () {
      expect(AffixUtil.parse('belajar').root, 'ajar');
      expect(AffixUtil.parse('bekerja').root, 'kerja');
    });

    test('접환사 ke-an / ber-an', () {
      final p = AffixUtil.parse('kesehatan');
      expect(p.root, 'sehat');
      expect(p.segments.first.kind, AffixKind.circum);
      expect(AffixUtil.parse('berkenalan').root, 'kenal');
    });

    test('접미사 -an', () {
      final p = AffixUtil.parse('makanan');
      expect(p.root, 'makan');
      expect(p.segments.last.kind, AffixKind.an);
    });

    test('사전에 없는 단어는 과분해하지 않음', () {
      expect(AffixUtil.parse('saya').hasAffix, false);
      expect(AffixUtil.parse('nama').hasAffix, false);
    });

    test('표시 세그먼트를 이어붙이면 표면형과 같다', () {
      for (final w in ['menulis', 'membaca', 'menyapu', 'bekerja', 'kesehatan', 'mengambil']) {
        expect(AffixUtil.parse(w).segments.map((s) => s.text).join(), w);
      }
    });

    test('문장 파싱은 문장부호를 보존', () {
      final ps = AffixUtil.parseSentence('Halo! Apa kabar?');
      expect(ps.map((p) => p.word).toList(), ['Halo', '!', 'Apa', 'kabar', '?']);
    });
  });
}
