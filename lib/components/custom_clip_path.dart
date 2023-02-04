import 'package:flutter/material.dart';

// Create the curver quote background on homepage
class CustomClipperPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final path = Path();

    path.lineTo(0, height / 1.5);
    path.quadraticBezierTo(width * 0.5, height, width, height / 1.5);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
