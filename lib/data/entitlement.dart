import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';
import 'purchase.dart';
import '../screens/paywall_screen.dart';

/// 이용권(lang 'id') — 1개월·3개월·1년(자동 갱신)·평생, 종합 1년·평생(2026-11-09 가격 확정).
/// `premium` = 기기 제작용 스위치 OR Talkverse 계정 이용권(auth.talkverse.uk) OR 이 기기에서 산·복원한 이용권(스토어).
/// 출시 때는 잠금 없이 전부 무료(PRICING.md, 사용자 2026-11-09) — 지금은 어떤 기능도 잠그지 않는다. 결제 시트는 프로필 → 이용권.
class Entitlement {
  Entitlement._();
  static const lang = 'id';
  static bool _local = false;
  static bool get premium => _local || Account.has(lang) || Purchase.owns(lang);

  static Future<void> load() async => _local = (await SharedPreferences.getInstance()).getBool('premium') ?? false;
  static Future<void> set(bool v) async {
    _local = v;
    (await SharedPreferences.getInstance()).setBool('premium', v);
  }

  static Future<void> showPaywall(BuildContext context) => PaywallScreen.show(context);
}
