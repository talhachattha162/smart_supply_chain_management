import 'package:flutter/material.dart';

class WavyBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the bottom-left
    path.lineTo(0, size.height);

    // Define wave parameters
    final double waveWidth = size.width / 5;
    final double waveHeight = 25;
    double x = 0;
    double y = size.height;

    // Create waves
    while (x < size.width) {
      path.relativeQuadraticBezierTo(
        waveWidth / 1.5,
        -waveHeight,
        waveWidth,
        0,
      );
      path.relativeQuadraticBezierTo(
        waveWidth / 2,
        waveHeight,
        waveWidth,
        0,
      );
      x += waveWidth;
    }

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

