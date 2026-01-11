import 'package:flutter/material.dart';

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double cornerSize = 50.0;

    path.lineTo(0, 0);

    path.lineTo(0, size.height - cornerSize);

    path.quadraticBezierTo(0, size.height, cornerSize, size.height);

    path.lineTo(size.width - cornerSize, size.height * 0.8);

    path.quadraticBezierTo(
      size.width,
      size.height * 0.7,
      size.width,
      size.height * 0.7 - cornerSize,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
