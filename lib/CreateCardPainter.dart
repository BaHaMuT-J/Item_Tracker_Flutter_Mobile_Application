import 'package:flutter/material.dart';
import 'package:item_tracker/constant.dart';

class CreateCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = brownColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 5.0;

    final path = Path();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final radius = Radius.circular(12);

    // Draw rounded rect path
    path.addRRect(RRect.fromRectAndRadius(rect, radius));

    // Use PathMetrics to dash the path
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, distance + length),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}