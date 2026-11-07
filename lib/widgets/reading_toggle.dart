import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/learner_prefs.dart';

/// 독음(한글 읽기 보조) 전역 토글 — 앱바 「독」(사용자 지시 2026-11-07, 일본어앱 후리가나 토글과 같은 구조).
/// 기본 미표시. 켤 때만 격려 안내를 띄운다.
class ReadingToggle extends StatelessWidget {
  const ReadingToggle({super.key});

  static Future<void> toggle(BuildContext context) async {
    final on = !LearnerPrefs.reading.value;
    await LearnerPrefs.setReading(on);
    if (on && context.mounted) {
      ScaffoldMessenger.maybeOf(context)
        ?..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('힘들어도 독음을 보지 않고 익혀보세요'), duration: Duration(seconds: 2)));
    }
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: LearnerPrefs.reading,
        builder: (context, on, _) => IconButton(
          tooltip: on ? '독음 끄기' : '독음 보기',
          onPressed: () => toggle(context),
          icon: Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: on ? AppColors.ai : Colors.transparent,
              border: Border.all(color: on ? AppColors.ai : AppColors.muted),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('독', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: on ? AppColors.washi : AppColors.muted)),
          ),
        ),
      );
}
