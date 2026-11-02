import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'update_screen.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/account.dart';
import '../data/entitlement.dart';
import '../data/purchase.dart';
import '../services/tts_service.dart';
import '../widgets/indo_decor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LangVariant _variant = TtsService.instance.variant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gading,
      appBar: AppBar(title: const Text('프로필 · 설정')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const UpdateEntryTile(),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.merahDeep, AppColors.merah],
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.emas, width: 1.5),
            ),
            child: const Row(
              children: [
                BadgeStamp(text: 'ID', size: 60),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('학습자',
                          style: TextStyle(
                            color: AppColors.gading,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          )),
                      SizedBox(height: 4),
                      Text('Hari 1 · 입문',
                          style: TextStyle(
                            color: AppColors.emasBright,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _SectionTitle('계정'),
          const SizedBox(height: 8),
          _account(),
          const SizedBox(height: 8),
          Container(
            decoration: _boxDeco(),
            child: Column(
              children: [
                ListTile(
                  leading: _leadIcon(Icons.workspace_premium_outlined),
                  title: const Text('평생 이용권', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(Entitlement.premium ? '사용 중' : '한 번 결제 · 구독 아님',
                      style: const TextStyle(fontSize: 11, color: AppColors.kayuLight)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.merah, size: 18),
                  onTap: () => Entitlement.showPaywall(context),
                ),
                Container(height: 0.5, color: AppColors.emas.withValues(alpha: 0.3)),
                ListTile(
                  leading: _leadIcon(Icons.restore),
                  title: const Text('구매 복원', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: ValueListenableBuilder<String?>(
                    valueListenable: Purchase.status,
                    builder: (_, st, _) => Text(
                        switch (st) {
                          'pending' => '확인 중…',
                          'restored' => '복원했습니다',
                          'nothing' => '복원할 구매가 없습니다',
                          _ => '이전에 산 평생 이용권을 이 기기에서 다시 엽니다',
                        },
                        style: const TextStyle(fontSize: 11, color: AppColors.kayuLight)),
                  ),
                  onTap: () => Purchase.restore(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _SectionTitle('설정'),
          const SizedBox(height: 8),
          Container(
            decoration: _boxDeco(),
            child: Column(
              children: [
                ListTile(
                  leading: _leadIcon(Icons.record_voice_over),
                  title: const Text('TTS 언어', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${_variant.labelKo} · ${_variant.ttsLocale}',
                      style: const TextStyle(fontSize: 11, color: AppColors.kayuLight)),
                  trailing: SegmentedButton<LangVariant>(
                    segments: const [
                      ButtonSegment(value: LangVariant.id, label: Text('ID')),
                      ButtonSegment(value: LangVariant.ms, label: Text('MS')),
                    ],
                    selected: {_variant},
                    showSelectedIcon: false,
                    style: const ButtonStyle(visualDensity: VisualDensity.compact),
                    onSelectionChanged: (s) async {
                      await TtsService.instance.setVariant(s.first);
                      setState(() => _variant = s.first);
                    },
                  ),
                ),
                Container(height: 0.5, color: AppColors.emas.withValues(alpha: 0.3)),
                ListTile(
                  leading: _leadIcon(Icons.palette),
                  title: const Text('테마', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text('talkverse.uk 톤 · 흰 바탕 + 인디고',
                      style: TextStyle(fontSize: 11, color: AppColors.kayuLight)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.merah, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('정보'),
          const SizedBox(height: 8),
          Container(
            decoration: _boxDeco(),
            child: Column(
              children: [
                _infoTile(Icons.info_outline, '앱 버전', '0.1.0 · scaffold'),
                Container(height: 0.5, color: AppColors.emas.withValues(alpha: 0.3)),
                _infoTile(Icons.code, 'Stack', 'Flutter 3.41 · Material 3 · Drift SQLite'),
                Container(height: 0.5, color: AppColors.emas.withValues(alpha: 0.3)),
                _infoTile(Icons.copyright, '저작권', '${AppInfo.appName} · ${AppInfo.year}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SoftDivider(),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Sedikit demi sedikit, lama-lama menjadi bukit',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.kayuLight, fontSize: 11, letterSpacing: 1.5),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('티끌 모아 태산',
                style: TextStyle(color: AppColors.kayuLight, fontSize: 11, letterSpacing: 4)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Talkverse 계정 — 로그인 전: 로그인 칸 / 로그인 후: 이름·이메일, 로그아웃, 계정 삭제(스토어 심사 요구). 로그인은 선택.
  Widget _account() => ValueListenableBuilder<Map<String, dynamic>?>(
        valueListenable: Account.user,
        builder: (context, u, _) => Container(
          decoration: _boxDeco(),
          child: u == null
              ? ListTile(
                  leading: _leadIcon(Icons.account_circle_outlined),
                  title: const Text('로그인', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text('Talkverse 계정 하나로 모든 앱에서 (선택)',
                      style: TextStyle(fontSize: 11, color: AppColors.kayuLight)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.merah, size: 18),
                  onTap: () => LoginScreen.open(context),
                )
              : Column(children: [
                  ListTile(
                    leading: _leadIcon(Icons.account_circle),
                    title: Text((u['display_name'] as String?) ?? '이름 없음', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: u['email'] == null
                        ? null
                        : Text(u['email'] as String, style: const TextStyle(fontSize: 11, color: AppColors.kayuLight)),
                  ),
                  Container(height: 0.5, color: AppColors.emas.withValues(alpha: 0.3)),
                  ListTile(
                    leading: _leadIcon(Icons.logout),
                    title: const Text('로그아웃'),
                    onTap: () => Account.signOut(),
                  ),
                  ListTile(
                    leading: _leadIcon(Icons.person_remove_outlined),
                    title: const Text('계정 삭제'),
                    onTap: () => _confirmDelete(context),
                  ),
                ]),
        ),
      );

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('계정을 삭제할까요?'),
        content: const Text(
            'Talkverse 계정과 이름·이메일·로그인 정보가 지워지고 모든 기기에서 로그아웃됩니다. 이 기기의 학습 기록은 그대로 남습니다. 되돌릴 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('삭제', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await Account.deleteAccount();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제하지 못했습니다. 네트워크를 확인하고 다시 시도해 주세요.')));
      }
    }
  }

  BoxDecoration _boxDeco() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.emas.withValues(alpha: 0.5)),
      );

  Widget _leadIcon(IconData icon) => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.merah.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.merah, width: 0.8),
        ),
        child: Icon(icon, color: AppColors.merah, size: 18),
      );

  Widget _infoTile(IconData icon, String title, String subtitle) => ListTile(
        leading: _leadIcon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.kayu)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.kayuLight, fontSize: 11)),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 15,
        color: AppColors.kayu,
        letterSpacing: 2,
      ));
}
