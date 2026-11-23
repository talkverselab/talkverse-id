import 'package:flutter/material.dart';

import '../core/l10n.dart';
import '../core/theme.dart';
import '../data/account.dart';
import '../data/entitlement.dart';
import '../data/purchase.dart';
import '../services/dialogue_service.dart';

/// 이용권 잠금(~/talkverse/PAYWALL_SPEC.md, 2026-11-23). 잠긴 곳은 숨기지 않고 자물쇠 → 결제 화면.
/// 무료 = 회화 1단계 편(R0·R1, 옛 이야기 L1 포함) · 커리큘럼 1단계 · 언어감각 1급 · 글자·발음·단어 기본. 유료 = 그 밖의 단계·편·급.
const paidRegions = {'R2', 'R3', 'R4', 'R5'};

bool dialogueLocked(Dialogue d) => !Entitlement.premium && paidRegions.contains(d.region);

/// 이용권이 바뀌면(구매·복원·로그인) 다시 그린다.
final Listenable premiumChanged = Listenable.merge([Purchase.owned, Account.user]);

/// 잠겨 있으면 결제 화면을 띄우고 false.
Future<bool> unlockOrPay(BuildContext context, bool locked) async {
  if (!locked || Entitlement.premium) return true;
  await Entitlement.showPaywall(context);
  return Entitlement.premium;
}

class LockIcon extends StatelessWidget {
  final double size;
  const LockIcon({super.key, this.size = 18});
  @override
  Widget build(BuildContext context) => Icon(Icons.lock_rounded, key: const ValueKey('lock'), size: size, color: AppColors.muted);
}

/// 잠긴 화면 자리 — 무엇이 잠겼는지와 이용권 단추.
class LockedView extends StatelessWidget {
  final String what;
  const LockedView({super.key, required this.what});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const LockIcon(size: 44),
            const SizedBox(height: 12),
            Text(what, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.sumi)),
            const SizedBox(height: 6),
            Text(tr('이용권이 있으면 열려요. 1단계 회화와 기본 메뉴는 무료예요.'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.sumiLight, height: 1.4)),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const ValueKey('lock-paywall'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.beni),
              onPressed: () => Entitlement.showPaywall(context),
              icon: const Icon(Icons.workspace_premium_outlined),
              label: Text(tr('이용권 보기')),
            ),
          ]),
        ),
      );
}
