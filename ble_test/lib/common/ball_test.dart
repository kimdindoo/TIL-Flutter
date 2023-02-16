import 'package:flutter/material.dart';

class MyPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(10, 50);


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}
