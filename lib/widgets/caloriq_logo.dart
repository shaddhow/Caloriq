import 'dart:math' as math;
import 'package:flutter/material.dart';

class CaloriqLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? veinColor;
  final bool? isDark;

  const CaloriqLogo({
    super.key,
    this.size = 64,
    this.backgroundColor,
    this.foregroundColor,
    this.veinColor,
    this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bool darkMode =
        isDark ?? (Theme.of(context).brightness == Brightness.dark);

    // Official logo colors from logo (1).html:
    // Normal/Light Mode: Dark tile (#17171D), Lime Q (#A8E84F), Dark vein (#17171D)
    // Dark Mode: Lime tile (#A8E84F), Dark Q (#17171D), Lime vein (#A8E84F)
    final Color tileColor = backgroundColor ??
        (darkMode ? const Color(0xFFA8E84F) : const Color(0xFF17171D));

    final Color markColor = foregroundColor ??
        (darkMode ? const Color(0xFF17171D) : const Color(0xFFA8E84F));

    final Color leafVeinColor = veinColor ??
        (backgroundColor ??
            (darkMode ? const Color(0xFFA8E84F) : const Color(0xFF17171D)));

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _QLogoPainter(
          tileColor: tileColor,
          markColor: markColor,
          veinColor: leafVeinColor,
        ),
      ),
    );
  }
}

class _QLogoPainter extends CustomPainter {
  final Color tileColor;
  final Color markColor;
  final Color veinColor;

  _QLogoPainter({
    required this.tileColor,
    required this.markColor,
    required this.veinColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 512.0;

    // 1. Background Rounded Tile: rect 512x512 rx 120
    final tilePaint = Paint()
      ..color = tileColor
      ..style = PaintingStyle.fill;

    final tileRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(120.0 * scale),
    );
    canvas.drawRRect(tileRRect, tilePaint);

    // Outer group translation: translate(12, 20)
    canvas.save();
    canvas.translate(12.0 * scale, 20.0 * scale);

    // 2. Q Circle: cx 240, cy 232, r 108, stroke-width 44
    final ringPaint = Paint()
      ..color = markColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 44.0 * scale;

    canvas.drawCircle(
      Offset(240.0 * scale, 232.0 * scale),
      108.0 * scale,
      ringPaint,
    );

    // Leaf/Tail group transform: translate(282, 274) rotate(45 deg)
    canvas.save();
    canvas.translate(282.0 * scale, 274.0 * scale);
    canvas.rotate(45.0 * math.pi / 180.0);

    // 3. Leaf Body: M0 0 C30 -28 92 -28 132 0 C92 28 30 28 0 0 Z
    final leafPath = Path();
    leafPath.moveTo(0, 0);
    leafPath.cubicTo(
      30.0 * scale,
      -28.0 * scale,
      92.0 * scale,
      -28.0 * scale,
      132.0 * scale,
      0,
    );
    leafPath.cubicTo(
      92.0 * scale,
      28.0 * scale,
      30.0 * scale,
      28.0 * scale,
      0,
      0,
    );
    leafPath.close();

    // Fill leaf body
    final leafFillPaint = Paint()
      ..color = markColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(leafPath, leafFillPaint);

    // Stroke leaf outline: stroke tileColor, stroke-width 10, stroke-linejoin round
    final leafStrokePaint = Paint()
      ..color = tileColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0 * scale
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(leafPath, leafStrokePaint);

    // 4. Leaf Vein: M14 0 H104 (line from 14 to 104)
    final veinPaint = Paint()
      ..color = veinColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0 * scale
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(14.0 * scale, 0),
      Offset(104.0 * scale, 0),
      veinPaint,
    );

    // Restore transforms
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QLogoPainter oldDelegate) {
    return oldDelegate.tileColor != tileColor ||
        oldDelegate.markColor != markColor ||
        oldDelegate.veinColor != veinColor;
  }
}
