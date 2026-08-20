import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// 배지 스탬프 — zh 의 SealStamp 에 대응. 짧은 라틴 라벨(1-4자) 표시.
/// 바틱 카웅(kawung) 느낌의 둥근 사각.
class BadgeStamp extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;

  const BadgeStamp({
    super.key,
    required this.text,
    this.size = 56,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.merah;
    final n = text.runes.length;
    final fontSize = n <= 1 ? size * 0.55 : (n <= 2 ? size * 0.4 : size * 0.28);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: AppColors.emas, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: c.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.gading,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              height: 1,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// 바틱 카웅(kawung) 패턴 — 4엽 원형 반복 배경. zh 의 CloudPattern 에 대응.
class BatikPattern extends StatelessWidget {
  final double opacity;
  final Color? color;
  final double cell;
  const BatikPattern({super.key, this.opacity = 0.06, this.color, this.cell = 48});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _KawungPainter(
          color: (color ?? AppColors.sogan).withValues(alpha: opacity),
          cell: cell,
        ),
      ),
    );
  }
}

class _KawungPainter extends CustomPainter {
  final Color color;
  final double cell;
  _KawungPainter({required this.color, required this.cell});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final r = cell * 0.28;
    for (double y = 0; y < size.height + cell; y += cell) {
      for (double x = 0; x < size.width + cell; x += cell) {
        // 4엽: 셀 중심에서 상하좌우로 타원 4개
        final c = Offset(x, y);
        for (var k = 0; k < 4; k++) {
          final a = k * math.pi / 2;
          final center = c + Offset(math.cos(a), math.sin(a)) * r * 0.9;
          canvas.save();
          canvas.translate(center.dx, center.dy);
          canvas.rotate(a);
          canvas.drawOval(
              Rect.fromCenter(center: Offset.zero, width: r * 1.6, height: r * 0.9),
              paint);
          canvas.restore();
        }
        canvas.drawCircle(c, r * 0.18, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _KawungPainter old) =>
      old.color != color || old.cell != cell;
}

/// 파랑(parang) 사선 띠 — 디바이더. zh 의 GreekKeyDivider 에 대응.
class ParangDivider extends StatelessWidget {
  final double height;
  final Color? color;
  const ParangDivider({super.key, this.height = 10, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _ParangPainter(color ?? AppColors.emas)),
    );
  }
}

class _ParangPainter extends CustomPainter {
  final Color color;
  _ParangPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final step = size.height * 1.4;
    for (double x = -size.height; x < size.width + size.height; x += step) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + size.height * 0.7, 0)
        ..lineTo(x + size.height * 1.4, size.height);
      canvas.drawPath(path, p);
    }
    canvas.drawLine(Offset(0, size.height - 0.5),
        Offset(size.width, size.height - 0.5), p..strokeWidth = 0.6);
  }

  @override
  bool shouldRepaint(covariant _ParangPainter old) => old.color != color;
}

/// 부드러운 그라데이션 분리선 (zh 의 BrushDivider 대응).
class SoftDivider extends StatelessWidget {
  final double thickness;
  const SoftDivider({super.key, this.thickness = 1.5});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: thickness,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.emas,
            AppColors.merah,
            AppColors.emas,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

/// 인도풍 카드 — 빨간 헤더 + 금색 테두리. zh 의 ChineseCard 대응.
class IndoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Color? headerColor;
  final EdgeInsetsGeometry padding;

  const IndoCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.headerColor,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gading,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.emas, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: headerColor ?? AppColors.merah,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.gading,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppColors.emasBright,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}

/// 변이 뱃지 — 'ID' 빨강 / 'MS' 파랑.
class VariantChip extends StatelessWidget {
  final bool isMs;
  const VariantChip({super.key, required this.isMs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMs ? AppColors.biruMs : AppColors.merah,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isMs ? 'MS' : 'ID',
        style: TextStyle(
          color: isMs ? AppColors.kuningMs : AppColors.gading,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// 연속 학습 칩 (홈 상단).
class StreakChip extends StatelessWidget {
  final int days;
  const StreakChip({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gading,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.emas),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, size: 16, color: AppColors.merah),
          const SizedBox(width: 4),
          Text(
            '$days일',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.kayu,
            ),
          ),
        ],
      ),
    );
  }
}
