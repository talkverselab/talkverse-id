import 'package:flutter/material.dart';

import '../core/platform.dart';
import '../core/theme.dart';
import '../services/id_phonetics.dart';
import '../services/tts_service.dart';
import '../widgets/letter_sound_sheet.dart';

/// 알파벳과 발음 — 일본어앱 「50음도와 발음」과 같은 틀(사용자 지시 2026-11-08, 모든 언어앱).
/// 묶음 칩(모음·자음·겹글자·이중모음·끝소리) + 격자 + 한글 표기 토글. 글자 탭 → 발음 상세 시트.
class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});
  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  int _set = 0;
  bool _showRd = true;

  static const _colors = [AppColors.beni, AppColors.ai, AppColors.laut, AppColors.affixBer, AppColors.affixDi];

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final g = soundGroups[_set];
    final color = _colors[_set % _colors.length];
    return Scaffold(
      backgroundColor: AppColors.washi,
      appBar: AppBar(
        title: const Column(mainAxisSize: MainAxisSize.min, children: [
          Text('알파벳과 발음', style: TextStyle(color: AppColors.sumi, fontSize: 16, fontWeight: FontWeight.w800)),
          SizedBox(height: 2),
          Text('탭하면 발음·IPA 상세', style: TextStyle(color: AppColors.sumiLight, fontSize: 10, letterSpacing: 2)),
        ]),
        actions: [
          IconButton(
            tooltip: '한글 표기',
            icon: Text('가', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: _showRd ? AppColors.beni : AppColors.sumiLight)),
            onPressed: () => setState(() => _showRd = !_showRd),
          ),
        ],
      ),
      body: Column(children: [
        Container(
          color: AppColors.washiDeep,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            for (var i = 0; i < soundGroups.length; i++)
              GestureDetector(
                onTap: () => setState(() => _set = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _set == i ? _colors[i] : AppColors.washi,
                    border: Border.all(color: _colors[i], width: _set == i ? 1.5 : 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(soundGroups[i].label, style: TextStyle(color: _set == i ? AppColors.washi : _colors[i], fontWeight: FontWeight.w800, fontSize: 12)),
                ),
              ),
          ]),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            final cols = (c.maxWidth / 96).floor().clamp(3, 8);
            return GridView.builder(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 80 + bottomInset(context)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1),
              itemCount: g.items.length,
              itemBuilder: (context, i) => _cell(g.items[i], color),
            );
          }),
        ),
      ]),
    );
  }

  Widget _cell(IdSound s, Color color) => InkWell(
        onTap: () => showLetterSoundSheet(context, s, color),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.washi,
            border: Border.all(color: color.withValues(alpha: 0.7)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 4, offset: const Offset(1, 2))],
          ),
          padding: const EdgeInsets.all(4),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FittedBox(child: Text(s.unit, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.sumi, height: 1.1))),
            if (_showRd) FittedBox(child: Text(s.rd, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w700))),
            Text('[${s.ipa}]', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.sumiLight)),
          ]),
        ),
      );
}
