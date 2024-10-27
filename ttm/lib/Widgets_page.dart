import 'package:flutter/material.dart';
class AppWidgets {
  // Method to return a Divider widget
  static Divider divider() {
    return const Divider(
      color: Colors.grey, // Color of the divider
      thickness: 1, // Thickness of the divider
      height: 20, // Space above and below the divider
    );
  }
}
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}