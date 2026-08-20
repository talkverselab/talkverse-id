import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
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
                  subtitle: const Text('낮 · Merah Putih × Batik #CE1126',
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
