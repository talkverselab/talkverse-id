import 'package:flutter/material.dart';

/// 인도네시아·말레이풍 컬러 팔레트 — "Merah Putih × Batik".
///
/// 국기의 붉은색(merah)을 메인으로, 바틱 소간(sogan) 갈색,
/// 사원·왕궁의 금(emas), 열대 바다의 틸(laut)을 조합한다.
/// 배경은 상아색(gading), 텍스트는 짙은 목재색(kayu).
class AppColors {
  // 主色 — 메라 (merah, 국기 빨강 / 사룽·바틱의 강조색)
  static const Color merah = Color(0xFFCE1126);
  static const Color merahDeep = Color(0xFF8E0B1A);
  static const Color merahLight = Color(0xFFE8455A);

  // 副色 — 에마스 (emas, 금박·왕궁·크바야 자수)
  static const Color emas = Color(0xFFD4A12C);
  static const Color emasBright = Color(0xFFF5C842);
  static const Color emasDeep = Color(0xFF8B6914);

  // 소간 (sogan, 바틱 솔로·족자의 갈색)
  static const Color sogan = Color(0xFF7B4B2A);
  static const Color soganLight = Color(0xFFA9754C);

  // 카유 (kayu, 짙은 목재 — 텍스트)
  static const Color kayu = Color(0xFF2A1F16);
  static const Color kayuLight = Color(0xFF5C4A3B);

  // 가딩 (gading, 상아색 배경)
  static const Color gading = Color(0xFFFBF6EA);
  static const Color gadingDeep = Color(0xFFF1E7D0);

  // 라웃 (laut, 열대 바다 틸 — 보조 강조)
  static const Color laut = Color(0xFF00897B);

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
        onPrimary: AppColors.gading,
        primaryContainer: AppColors.merahLight,
        onPrimaryContainer: AppColors.kayu,
        secondary: AppColors.emas,
        onSecondary: AppColors.kayu,
        secondaryContainer: AppColors.emasBright,
        onSecondaryContainer: AppColors.kayu,
        tertiary: AppColors.laut,
        onTertiary: AppColors.gading,
        tertiaryContainer: const Color(0xFFB2DFDB),
        onTertiaryContainer: AppColors.kayu,
        error: const Color(0xFFB00020),
        onError: Colors.white,
        surface: AppColors.gading,
        onSurface: AppColors.kayu,
        surfaceContainerHighest: AppColors.gadingDeep,
        onSurfaceVariant: AppColors.kayuLight,
        outline: AppColors.emasDeep,
        outlineVariant: const Color(0xFFDCCBA8),
      ),
      scaffoldBackgroundColor: AppColors.gading,
      fontFamily: 'Pretendard',
      fontFamilyFallback: fontFallback,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.merah,
        foregroundColor: AppColors.gading,
        titleTextStyle: TextStyle(
          color: AppColors.gading,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.gading,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: AppColors.emas, width: 0.8),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.kayu,
        indicatorColor: AppColors.merah,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? AppColors.emasBright : AppColors.gadingDeep,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.gading : AppColors.gadingDeep,
            size: 24,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gadingDeep,
        labelStyle:
            const TextStyle(color: AppColors.kayu, fontWeight: FontWeight.w600),
        side: const BorderSide(color: AppColors.emas),
        selectedColor: AppColors.merah,
        secondaryLabelStyle: const TextStyle(color: AppColors.gading),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.emas,
        thickness: 0.5,
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
