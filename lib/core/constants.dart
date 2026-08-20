/// 앱 전역 상수.
class AppInfo {
  static const appName = '인도네시아어유니버스';
  static const appNameLatin = 'IndoUniverse';
  static const packageId = 'com.talkverse.indo_universe';
  static const year = 2026;
}

/// 언어 변이 — 인도네시아어(id) / 말레이어(ms).
/// zh 앱의 dialect(north/south) 에 대응.
enum LangVariant {
  id('id', '인도네시아어', 'Bahasa Indonesia', 'id-ID'),
  ms('ms', '말레이어', 'Bahasa Melayu', 'ms-MY');

  final String code;
  final String labelKo;
  final String labelNative;
  final String ttsLocale;
  const LangVariant(this.code, this.labelKo, this.labelNative, this.ttsLocale);

  static LangVariant fromCode(String? code) =>
      code == 'ms' ? LangVariant.ms : LangVariant.id;
}

/// 학습 레벨 — zh 와 동일한 L1/L2/L3 3단.
class Levels {
  static const all = ['L1', 'L2', 'L3'];
  static const titles = {
    'L1': '매칭 narrative',
    'L2': '카오스 채팅',
    'L3': '사랑 narrative',
  };
}

/// 접사 종류 키 (theme.affixColor 와 1:1).
class AffixKind {
  static const me = 'me'; // meN- (mem-/men-/meng-/meny-/menge-)
  static const ber = 'ber'; // ber- (be-/bel-)
  static const di = 'di'; // di- 수동
  static const ter = 'ter'; // ter- 비의도/최상급
  static const kan = 'kan'; // -kan
  static const i = 'i'; // -i
  static const an = 'an'; // -an
  static const circum = 'circum'; // ke-an / pe-an / per-an / ber-an
  static const root = 'root'; // 어근
  static const other = 'other';
}
