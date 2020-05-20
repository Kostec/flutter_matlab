import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Block{
  String name;
  Block({this.name = 'Block'});
}

class BlockWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlockWidgetState();
  }

}

class Position{
  double x;
  double y;

  Position({this.x, this.y});
}

class BlockWidgetState extends State<BlockWidget>{

  Block block;

  double x;
  double y;
  double dx = 0, dy = 0;

  double width, height;
  double tapX, tapY;

  Color border_color = Colors.black;

  Border border;
  BoxDecoration decoration;

  @override
  void initState() {
    block = Block(name: 'Block');
    x = 25.0; y = 25.0;

    width = 100;
    height = 50;

    border = Border.all(color: Colors.black);
    decoration = BoxDecoration(border: border);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(top: y, left: x ,child:
      Column(
        children: [
          Row(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
          ),
          GestureDetector(
            onTapDown: (details){
              setState(() {
                border_color = Colors.red;
//                dx = 0;
//                dy = 0;
                dx = details.localPosition.dx;
                dy = details.localPosition.dy;
              });
            },
            onPanUpdate: (details){
              x += details.localPosition.dx - dx;
              y += details.localPosition.dy - dy;

              dx = details.localPosition.dx;
              dy = details.localPosition.dy;

              setState(() {
              });
            },
            onPanEnd: (details){
              print('PanCancel');
              setState(() {
                border_color = Colors.black;
                dx = 0;
                dy = 0;
              });
            },
            child:Container(
              decoration: BoxDecoration(border: Border.all(color: border_color)),
              width: width, height: height,
              child: Align(
                alignment: Alignment.center,
                child: Text('num'),
              )
          ),),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
          ),
        ]),
          Text('${block.name}'),
      ]),
    );
  }
}