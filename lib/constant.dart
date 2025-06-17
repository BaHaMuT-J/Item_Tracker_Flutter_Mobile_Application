import 'package:flutter/material.dart';

class Category {
  final String name;
  final List<String> children;

  Category({required this.name, required this.children});
}

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

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.title,
    required this.itemToDelete,
    this.onTap
  });

  final String title;
  final String itemToDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/bin.png',
        width: 30,
        height: 30,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: weakOrangeColor,
            title: Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: brownColor,
              ),
            ),
            content: Text(
              "Are you sure you want to delete '${itemToDelete}' ?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: brownColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white
                ),
                child: Text(
                  "cancel",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: brownColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white
                ),
                child: Text(
                  "delete",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

const brownColor = Color(0xFF7b4019);
const orangeColor = Color(0xFFFF7D29);
const weakOrangeColor = Color(0xFFFFBF78);
const creamColor = Color(0xFFFFEEA9);
