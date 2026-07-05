import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The "Cerca" brand mark: an open bracket/arrow shape with a small
/// diamond accent, matching the SVG path used across Splash, Login,
/// Register and Welcome in the source design.
class CercaLogoMark extends StatelessWidget {
  const CercaLogoMark({
    super.key,
    this.size = 84,
    this.darkStroke = const Color(0xFF5C1720),
    this.lightStroke = const Color(0xFFA3323F),
    this.accent = const Color(0xFFC1414F),
  });

  final double size;
  final Color darkStroke;
  final Color lightStroke;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CercaMarkPainter(darkStroke: darkStroke, lightStroke: lightStroke, accent: accent),
    );
  }
}

class _CercaMarkPainter extends CustomPainter {
  _CercaMarkPainter({required this.darkStroke, required this.lightStroke, required this.accent});

  final Color darkStroke;
  final Color lightStroke;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 100;

    final path = Path()
      ..moveTo(76.04 * scale, 34.04 * scale)
      ..lineTo(50 * scale, 8 * scale)
      ..lineTo(8 * scale, 50 * scale)
      ..lineTo(50 * scale, 92 * scale)
      ..lineTo(76.04 * scale, 65.96 * scale);

    final darkPaint = Paint()
      ..color = darkStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final lightPaint = Paint()
      ..color = lightStroke.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, darkPaint);
    canvas.drawPath(path, lightPaint);

    canvas.save();
    canvas.translate(83 * scale, 50 * scale);
    canvas.rotate(math.pi / 4);
    final accentRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 16 * scale, height: 16 * scale),
      Radius.circular(3 * scale),
    );
    canvas.drawRRect(accentRect, Paint()..color = accent);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CercaMarkPainter oldDelegate) =>
      oldDelegate.darkStroke != darkStroke ||
      oldDelegate.lightStroke != lightStroke ||
      oldDelegate.accent != accent;
}

/// The "CodeCraftPeru" studio mark: a hexagon with inward chevrons and a
/// gold center dot, shown briefly on the splash screen as a developer
/// credit before it hands off to the Cerca mark.
class CodeCraftLogoMark extends StatelessWidget {
  const CodeCraftLogoMark({super.key, this.size = 82});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _CodeCraftMarkPainter());
  }
}

class _CodeCraftMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 128;
    Offset p(double x, double y) => Offset(x * scale, y * scale);

    final hexPoints = [
      p(64, 10),
      p(116, 40),
      p(116, 96),
      p(64, 126),
      p(12, 96),
      p(12, 40),
    ];
    final hexPath = Path()..addPolygon(hexPoints, true);

    canvas.drawPath(
      hexPath,
      Paint()
        ..color = const Color(0xFF160F0E)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      hexPath,
      Paint()
        ..color = const Color(0xFF6B1F28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7 * scale,
    );
    canvas.drawPath(
      hexPath,
      Paint()
        ..color = const Color(0xFFA3323F).withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * scale,
    );

    final dashedPaint = Paint()
      ..color = const Color(0xFFE8DFD9).withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    for (final segment in [
      [p(64, 10), p(64, 40)],
      [p(12, 40), p(42, 58)],
      [p(116, 40), p(86, 58)],
      [p(12, 96), p(42, 78)],
      [p(116, 96), p(86, 78)],
    ]) {
      _drawDashedLine(canvas, segment[0], segment[1], dashedPaint, scale);
    }

    final chevronPaint = Paint()
      ..color = const Color(0xFFC1414F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(
      Path()
        ..moveTo(46 * scale, 44 * scale)
        ..lineTo(28 * scale, 64 * scale)
        ..lineTo(46 * scale, 84 * scale),
      chevronPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(82 * scale, 44 * scale)
        ..lineTo(100 * scale, 64 * scale)
        ..lineTo(82 * scale, 84 * scale),
      chevronPaint,
    );

    canvas.drawCircle(
      p(64, 64),
      13 * scale,
      Paint()
        ..color = const Color(0xFFC9A24B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * scale,
    );
    canvas.drawCircle(p(64, 64), 5.5 * scale, Paint()..color = const Color(0xFFC9A24B));
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint, double scale) {
    const dashLength = 3.0;
    const gapLength = 3.0;
    final distance = (end - start).distance;
    final direction = (end - start) / distance;
    var covered = 0.0;
    while (covered < distance) {
      final segStart = start + direction * covered;
      final segEnd = start + direction * math.min(covered + dashLength * scale, distance);
      canvas.drawLine(segStart, segEnd, paint);
      covered += (dashLength + gapLength) * scale;
    }
  }

  @override
  bool shouldRepaint(covariant _CodeCraftMarkPainter oldDelegate) => false;
}
