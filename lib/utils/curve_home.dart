import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firsStart = Offset(size.width / 5, size.height);
    var firsEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(firsStart.dx, firsStart.dy, firsEnd.dx, firsEnd.dy);
    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 100);
    var secondEnd = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
