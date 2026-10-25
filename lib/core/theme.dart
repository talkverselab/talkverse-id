import 'package:flutter/material.dart';

/// 컬러 팔레트 — talkverse.uk 톤(2026-10-25).
///
/// 흰 바탕 + 남색 글자 + 인디고 포인트 하나, 그 밖의 색은 절제한다.
/// 이름(merah·emas·sogan…)은 옛 "Merah Putih × Batik" 팔레트에서 온 것이라
/// 화면 코드가 그대로 쓰고, 값만 사이트 토큰(`--ink`·`--body`·`--accent`…)에 맞췄다.
class AppColors {
  // 주색 — 사이트 `--accent` 인디고
  static const Color merah = Color(0xFF635BFF);
  static const Color merahDeep = Color(0xFF4B44D6); // `--accent-ink`
  static const Color merahLight = Color(0xFFA9A4FF);

  // 보조 — 옛 금색 자리. 테두리는 사이트 `--line` 계열, 밝은 강조는 히어로 피치
  static const Color emas = Color(0xFFDDE3EC);
  static const Color emasBright = Color(0xFFFFD39B);
  static const Color emasDeep = Color(0xFF6B7C93); // `--muted`

  // 옛 바틱 갈색 자리 — 짙은 남색 계열
  static const Color sogan = Color(0xFF1B3A5C);
  static const Color soganLight = Color(0xFF6B7C93);

  // 글자 — `--ink` / `--body`
  static const Color kayu = Color(0xFF0A2540);
  static const Color kayuLight = Color(0xFF425466);

  // 바탕 — 흰색 / `--soft`
  static const Color gading = Color(0xFFFFFFFF);
  static const Color gadingDeep = Color(0xFFF6F9FC);

  // 보조 강조 — 차분한 청록(완료·학습됨)
  static const Color laut = Color(0xFF0E7C8C);

  // 인도네시아어 카드색 — talkverse.uk 언어 카드의 `--c`
  static const Color bahasa = Color(0xFFD04A4A);

  // 말레이 변이(ms) 강조 — 말레이시아 국기 파랑/노랑
  static const Color biruMs = Color(0xFF003F87);
  static const Color kuningMs = Color(0xFFFFCC00);

  // 접사(afiks) 컬러 (시각 학습용) — zh 의 성조 컬러에 대응
  static const Color affixMe = Color(0xFF1E88E5); // meN- (능동 동사)  — 파랑
  static const Color affixBer = Color(0xFF43A047); // ber- (자동사·소유) — 초록
  static const Color affixDi = Color(0xFF6A1B9A); // di- (수동)        — 보라
  static const Color affixTer = Color(0xFF8E24AA); // ter- (비의도·최상급) — 자주
  static const Color affixKan = Color(0xFFFB8C00); // -kan (사역·수혜)  — 주황
  static const Color affixI = Color(0xFFE53935); // -i (장소·반복)   — 빨강
  static const Color affixAn = Color(0xFF00897B); // -an (명사화)     — 틸
  static const Color affixCircum = Color(0xFFC62828); // ke-an / pe-an 접환사 — 진빨강
  static const Color affixRoot = Color(0xFF2A1F16); // 어근(kata dasar) — 검정
  static const Color affixNeutral = Color(0xFF8E8579); // 기타/불명 — 회색

  // brand alias
  static const Color brand = merah;
}

class AppTheme {
  static const fontFallback = <String>[
    'Pretendard',
    'Noto Sans',
    'Noto Sans KR',
  ];

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.merah,
        onPrimary: Colors.white,
        primaryContainer: AppColors.merahLight,
        onPrimaryContainer: AppColors.kayu,
        secondary: AppColors.sogan,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.emasBright,
        onSecondaryContainer: AppColors.kayu,
        tertiary: AppColors.laut,
        onTertiary: AppColors.gading,
        tertiaryContainer: const Color(0xFFCDEFF2),
        onTertiaryContainer: AppColors.kayu,
        error: const Color(0xFFB00020),
        onError: Colors.white,
        surface: AppColors.gading,
        onSurface: AppColors.kayu,
        surfaceContainerHighest: AppColors.gadingDeep,
        onSurfaceVariant: AppColors.kayuLight,
        outline: AppColors.emasDeep,
        outlineVariant: AppColors.emas,
      ),
      scaffoldBackgroundColor: AppColors.gading,
      fontFamily: 'Pretendard',
      fontFamilyFallback: fontFallback,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.kayuLight,
        displayColor: AppColors.kayu,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.gading,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.kayu,
        shape: Border(bottom: BorderSide(color: AppColors.emas, width: 1)),
        titleTextStyle: TextStyle(
          color: AppColors.kayu,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.gading,
        shadowColor: const Color(0x1A32325D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.emas, width: 1),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.gading,
        surfaceTintColor: Colors.transparent,
        indicatorColor: const Color(0xFFEFEEFE),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppColors.merah : AppColors.emasDeep,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.merah : AppColors.emasDeep,
            size: 24,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.kayu,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.kayu,
          side: const BorderSide(color: AppColors.emas),
          shape: const StadiumBorder(),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gadingDeep,
        labelStyle:
            const TextStyle(color: AppColors.kayu, fontWeight: FontWeight.w600),
        side: const BorderSide(color: AppColors.emas),
        shape: const StadiumBorder(),
        selectedColor: AppColors.merah,
        secondaryLabelStyle: const TextStyle(color: AppColors.gading),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.emas,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.merah,
        textColor: AppColors.kayu,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.merah,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Pretendard',
      fontFamilyFallback: fontFallback,
    );
  }
}

/// 접사 종류 → 컬러. 키는 core/constants.dart 의 [AffixKind] 참조.
Color affixColor(String? kind) {
  switch (kind) {
    case 'me':
      return AppColors.affixMe;
    case 'ber':
      return AppColors.affixBer;
    case 'di':
      return AppColors.affixDi;
    case 'ter':
      return AppColors.affixTer;
    case 'kan':
      return AppColors.affixKan;
    case 'i':
      return AppColors.affixI;
    case 'an':
      return AppColors.affixAn;
    case 'circum':
      return AppColors.affixCircum;
    case 'root':
      return AppColors.affixRoot;
    default:
      return AppColors.affixNeutral;
  }
}
