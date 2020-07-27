import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/pages/block-preference.dart';
import 'package:fluttermatlab/widgets/io.dart';

class BlockWidget extends StatefulWidget{
  double x; double y;
  Block block;
  BlockWidget({this.x, this.y, this.block});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BlockWidgetState(x: x, y: y, block: block);
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
  List<Widget> inputs = [];
  List<Widget> outputs = [];
  BlockWidgetState({this.x, this.y, this.block});

  @override
  void initState() {
    width = 100;
    height = 50;
    border = Border.all(color: Colors.black);
    decoration = BoxDecoration(border: border);

    for (int i = 0; i < block.numIn; i++){
      inputs.add(Container(
        width: 10,
        height: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      ),);
    }
    for (int i = 0; i < block.numOut; i++){
      outputs.add(Container(
        width: 10,
        height: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      ),);
    }

  }

  @override
  Widget build(BuildContext context) {
    getDisplay();
    return Positioned(top: y, left: x,
      child: Column(
        children: [
          Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Column(children: inputs),
             GestureDetector(
              onDoubleTap: () async {
                print('Double Tap ${block.name}');
                await Navigator.push(context, MaterialPageRoute(builder: (context) => BlockPreferencePage(block: block,)));
                setState(() {
                });
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: display,
                  ),
                )
          ),),
//             Column(children: outputs),
             Column(children: outputs),
          ]),
          Text('${block.name}'),
      ]),
    );
  }

  void getDisplay(){
    display.clear();
    var toDisplay = block.getDisplay();
    for (int i = 0; i < toDisplay.length; i++){
      display.add(Text(toDisplay[i]));
      if (toDisplay.length - i > 1) display.add(Divider(color: Colors.black,));
    }
  }
}