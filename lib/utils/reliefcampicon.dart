import 'package:flutter/material.dart';

class ReliefCampPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw your custom icon here using Canvas operations
    Paint paint = Paint()
      ..color = Colors.blue // Set the color of the icon
      ..style = PaintingStyle.fill;

    // Draw a simple representation of a relief camp icon
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}