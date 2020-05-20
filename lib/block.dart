import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Block{
  String name;
  Block({this.name = 'Block'});
}

class BlockWidget extends StatefulWidget{
  double x; double y;
  BlockWidget({this.x, this.y});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlockWidgetState(x: x, y: y);
  }

}

class BlockWidgetState extends State<BlockWidget>{

  Block block;

  double x; double y;
  double dx = 0, dy = 0;

  double width, height;

  bool canTransmit = false;

  Color border_color = Colors.black;

  Border border;
  BoxDecoration decoration;

  BlockWidgetState({this.x, this.y});

  @override
  void initState() {
    block = Block(name: 'Block');

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
                dx = details.localPosition.dx;
                dy = details.localPosition.dy;
                canTransmit = true;
              });
            },
            onTapUp: (details){
              setState(() {
                border_color = Colors.black;
                canTransmit = false;
              });
            },
            onPanUpdate: (details){
              if (!canTransmit) return;

              x += details.localPosition.dx - dx;
              y += details.localPosition.dy - dy;

              dx = details.localPosition.dx;
              dy = details.localPosition.dy;

              setState(() {
              });
            },
            onPanEnd: (details){
              setState(() {
                border_color = Colors.black;
                canTransmit = false;
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