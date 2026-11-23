import 'package:flutter/material.dart';
import '../core/prefs.dart';

import 'account.dart';
import 'purchase.dart';
import '../screens/paywall_screen.dart';

/// 이용권(lang 'id') — 1개월·3개월·1년(자동 갱신)·평생, 종합 1년·평생(2026-11-09 가격 확정).
/// `premium` = 기기 제작용 스위치 OR Talkverse 계정 이용권(auth.talkverse.uk) OR 이 기기에서 산·복원한 이용권(스토어).
/// 잠금(2026-11-23, 사용자 「1 2 모두 진행」 → uk ~/talkverse/PAYWALL_SPEC.md): 회화 2단계(R2) 이상·커리큘럼 2단계 이상·언어감각 2급 이상은 이용권, 나머지 무료 — lib/widgets/lock.dart.
/// 결제 시트는 프로필 → 이용권, 또는 잠긴 곳을 누를 때.
class Entitlement {
  Entitlement._();
  static const lang = 'id';
  static bool _local = false;
  static bool get premium => _local || Account.has(lang) || Purchase.owns(lang);

  static Future<void> load() async => _local = (await Prefs.getInstance()).getBool('premium') ?? false;
  static Future<void> set(bool v) async {
    _local = v;
    (await Prefs.getInstance()).setBool('premium', v);
  }

  static Future<void> showPaywall(BuildContext context) => PaywallScreen.show(context);
}
