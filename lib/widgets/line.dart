import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Line extends StatefulWidget{
  BuildContext startWidgetContext;
  BuildContext endWidgetContext;
  Line(this.startWidgetContext, this.endWidgetContext);

  @override
  State<StatefulWidget> createState() => _LineState();

}

class _LineState extends State<Line>{

  double start_y, start_x, end_x, end_y;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Positioned(top: start_y, left: start_x,child: CustomPaint(painter: MyPainter(start_x, start_y, end_x, end_y),));
  }

  void calculatePoints(){

  }

}



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