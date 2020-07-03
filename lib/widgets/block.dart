import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/pages/block-preference.dart';

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

  final GlobalKey<ScaffoldState> _scaggoldKey = GlobalKey<ScaffoldState>();
  Block block;

  double x; double y;
  double dx = 0, dy = 0;
  double width, height;
  bool canTransmit = false;
  Color border_color = Colors.black;
  Border border;
  BoxDecoration decoration;

  List<Widget> display = [];

  BlockWidgetState({this.x, this.y});

  @override
  void initState() {
//    block = Block(name: 'Block');
    block = TransferFcn(nums: [1,2], dens: [3,4]);
    width = 100;
    height = 50;
    border = Border.all(color: Colors.black);
    decoration = BoxDecoration(border: border);

    var toDisplay = block.getDisplay();
    toDisplay.forEach((element) {
      display.add(Text(element));
      display.add(Divider(color: Colors.black,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(top: y, left: x,
      child: Column(
        children: [
          Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
            ),
            GestureDetector(
              onDoubleTap: (){
                print('Double Tap ${block.name}');
                Navigator.push(context, MaterialPageRoute(builder: (context) => BlockPreferencePage(block: block,)));
              },
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
                  child: Column(
                    children: display,
                  ),
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