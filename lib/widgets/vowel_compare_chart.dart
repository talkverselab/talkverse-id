import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../services/id_phonetics.dart';

/// IPA 모음 사다리꼴 한 장에 인도네시아어 모음(강조색 ●)과 가까운 한국어 모음(인디고 ●)을 함께 찍는다 — 일본어앱 vowel_compare_chart 와 같은 그림.
class VowelCompareChart extends StatelessWidget {
  final VowelChartData data;
  const VowelCompareChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.45,
          child: Container(
            decoration: BoxDecoration(color: AppColors.washi, border: Border.all(color: AppColors.line)),
            padding: const EdgeInsets.fromLTRB(30, 22, 12, 12),
            child: CustomPaint(painter: _TrapezoidPainter(data), size: Size.infinite),
          ),
        ),
        const SizedBox(height: 6),
        Row(children: [_dot(AppColors.beni, '인도네시아어'), const SizedBox(width: 12), _dot(AppColors.ai, '한국어')]),
        const SizedBox(height: 4),
        Text(data.note, style: const TextStyle(fontSize: 11.5, color: AppColors.sumi, height: 1.45)),
      ],
    );
  }

  Widget _dot(Color c, String label) => Row(children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: c)),
      ]);
}

class _TrapezoidPainter extends CustomPainter {
  final VowelChartData data;
  _TrapezoidPainter(this.data);

  Offset _map(double x, double y, Size s) {
    final left = 0.38 * s.width * y; // 저모음일수록 전설 경계가 오른쪽으로
    return Offset(left + (s.width - left) * x, y * s.height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.sumiLight.withValues(alpha: 0.45)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(_map(0, 0, size).dx, 0)
      ..lineTo(_map(1, 0, size).dx, 0)
      ..lineTo(_map(1, 1, size).dx, size.height)
      ..lineTo(_map(0, 1, size).dx, size.height)
      ..close();
    canvas.drawPath(path, grid);
    for (final y in [1 / 3, 2 / 3]) {
      canvas.drawLine(_map(0, y, size), _map(1, y, size), grid);
    }
    canvas.drawLine(_map(0.5, 0, size), _map(0.5, 1, size), grid);
    _text(canvas, '전설', Offset(_map(0, 0, size).dx - 2, -18), 9);
    _text(canvas, '중설', Offset(_map(0.5, 0, size).dx - 10, -18), 9);
    _text(canvas, '후설', Offset(size.width - 22, -18), 9);
    _text(canvas, '고', Offset(-24, -5), 9);
    _text(canvas, '중', Offset(-24, size.height / 2 - 5), 9);
    _text(canvas, '저', Offset(-24, size.height - 10), 9);

    final id = _map(data.id.x, data.id.y, size);
    final dash = Paint()
      ..color = AppColors.sumiLight.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (final k in data.ko) {
      _dashed(canvas, id, _map(k.x, k.y, size), dash);
    }
    for (final k in data.ko) {
      final p = _map(k.x, k.y, size);
      canvas.drawCircle(p, 5, Paint()..color = AppColors.ai);
      _label(canvas, size, p, '${k.label} [${k.ipa}]', AppColors.ai);
    }
    canvas.drawCircle(id, 7, Paint()..color = AppColors.beni);
    canvas.drawCircle(
        id,
        7,
        Paint()
          ..color = AppColors.washi
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    _label(canvas, size, id, '${data.id.label} [${data.id.ipa}]', AppColors.beni, bold: true);
  }

  void _label(Canvas canvas, Size size, Offset p, String s, Color c, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: TextStyle(fontSize: bold ? 12 : 10.5, fontWeight: bold ? FontWeight.w900 : FontWeight.w700, color: c)),
      textDirection: TextDirection.ltr,
    )..layout();
    var dx = p.dx + 9;
    if (dx + tp.width > size.width) dx = p.dx - tp.width - 9;
    final dy = (p.dy - tp.height / 2).clamp(0.0, size.height - tp.height);
    tp.paint(canvas, Offset(dx, dy));
  }

  void _text(Canvas canvas, String s, Offset o, double fs) {
    final tp = TextPainter(
      text: TextSpan(text: s, style: TextStyle(fontSize: fs, color: AppColors.sumiLight, fontWeight: FontWeight.w700)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, o);
  }

  void _dashed(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 4.0, gap = 3.0;
    final d = (b - a).distance;
    if (d == 0) return;
    final dir = (b - a) / d;
    for (var t = 0.0; t < d; t += dash + gap) {
      canvas.drawLine(a + dir * t, a + dir * (t + dash).clamp(0.0, d), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrapezoidPainter old) => old.data != data;
}
