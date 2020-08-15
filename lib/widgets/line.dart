import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter { //         <-- CustomPainter class

  double start_x;
  double start_y;
  double end_x;
  double end_y;
  MyPainter(this.start_x, this.start_y, this.end_x, this.end_y);

  @override
  void paint(Canvas canvas, Size size) {
    //                                             <-- Insert your painting code here.
    final p1 = Offset(start_x, start_y);
    final p2 = Offset(end_x, end_y);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}