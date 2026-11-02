import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';
import 'purchase.dart';
import '../screens/paywall_screen.dart';

/// 평생 이용권(lang 'id') — 한자 앱과 같은 구성(2026-11-02).
/// `premium` = 기기 제작용 스위치 OR Talkverse 계정 이용권(auth.talkverse.uk) OR 이 기기에서 산·복원한 이용권(스토어).
/// 무료/유료 범위는 아직 정하지 않았다(사용자 결정 대기) — 지금은 어떤 기능도 잠그지 않는다.
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
