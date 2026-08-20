import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/affix_util.dart';

/// 접사 색상 문장 — zh 의 SelectableHanzi(성조 컬러) 에 대응.
/// 단어를 접두사/어근/접미사로 분해해 색을 입히고, 단어 탭 시 콜백.
class AffixText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final bool colorize;
  final void Function(AffixParse parse)? onWordTap;

  const AffixText(
    this.text, {
    super.key,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w600,
    this.colorize = true,
    this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    final parses = AffixUtil.parseSentence(text);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 0,
      runSpacing: 4,
      children: [
        for (var i = 0; i < parses.length; i++) ...[
          _WordSpan(
            parse: parses[i],
            fontSize: fontSize,
            fontWeight: fontWeight,
            colorize: colorize,
            onTap: onWordTap,
          ),
          if (i < parses.length - 1 && _needsSpace(parses, i))
            SizedBox(width: fontSize * 0.28),
        ],
      ],
    );
  }

  // 문장부호 앞에는 공백 없이 붙인다.
  bool _needsSpace(List<AffixParse> ps, int i) {
    final next = ps[i + 1].word;
    return !RegExp(r'^[,.!?;:)]').hasMatch(next) &&
        !RegExp(r'[(]$').hasMatch(ps[i].word);
  }
}

class _WordSpan extends StatelessWidget {
  final AffixParse parse;
  final double fontSize;
  final FontWeight fontWeight;
  final bool colorize;
  final void Function(AffixParse parse)? onTap;

  const _WordSpan({
    required this.parse,
    required this.fontSize,
    required this.fontWeight,
    required this.colorize,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    for (final seg in parse.segments) {
      final isRoot = seg.isRoot;
      Color color;
      if (!colorize) {
        color = AppColors.kayu;
      } else if (isRoot) {
        color = AppColors.kayu;
      } else {
        color = affixColor(seg.kind);
      }
      spans.add(TextSpan(
        text: seg.text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isRoot ? fontWeight : FontWeight.w800,
          decoration: (!isRoot && colorize) ? TextDecoration.underline : null,
          decorationColor: color,
          decorationThickness: 1.5,
          height: 1.35,
        ),
      ));
    }
    final child = RichText(text: TextSpan(children: spans));
    if (onTap == null || parse.segments.length == 1 && parse.segments.first.kind == 'other') {
      return child;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap!(parse),
      child: child,
    );
  }
}

/// 접사 범례 (파랑 meN- / 초록 ber- / 주황 -kan / ...).
class AffixLegend extends StatelessWidget {
  const AffixLegend({super.key});

  static const _items = [
    ('meN-', 'me'),
    ('ber-', 'ber'),
    ('di-', 'di'),
    ('ter-', 'ter'),
    ('-kan', 'kan'),
    ('-i', 'i'),
    ('-an', 'an'),
    ('ke-an', 'circum'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final (label, kind) in _items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: affixColor(kind),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 3),
              Text(label,
                  style: TextStyle(
                    fontSize: 11,
                    color: affixColor(kind),
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
      ],
    );
  }
}
