import 'package:flutter/material.dart';

class BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7); // Start at the top-left
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.7); // Bezier curve
    path.lineTo(size.width, 0); // Line to the top-right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Move to the starting point (bottom-left)
    path.lineTo(0, size.height);

    // Define the control points and endpoints for the wave shape
    final double controlPoint1X = size.width / 4;
    final double controlPoint1Y = size.height - 40;
    final double endPoint1X = size.width / 2;
    final double endPoint1Y = size.height - 60;

    final double controlPoint2X = size.width * 3 / 4;
    final double controlPoint2Y = size.height - 80;
    final double endPoint2X = size.width;
    final double endPoint2Y = size.height - 60;

    // Add the first wave
    path.quadraticBezierTo(
      controlPoint1X,
      controlPoint1Y,
      endPoint1X,
      endPoint1Y,
    );

    // Add the second wave
    path.quadraticBezierTo(
      controlPoint2X,
      controlPoint2Y,
      endPoint2X,
      endPoint2Y,
    );

    // Line to the bottom-right
    path.lineTo(size.width, size.height);

    // Line back to the starting point (bottom-left)
    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
