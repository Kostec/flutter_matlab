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
  bool canOpenPreference;
  BlockWidget({this.x, this.y, this.block, this.canOpenPreference = true});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BlockWidgetState(x: x, y: y, block: block);
  }

}

class _BlockWidgetState extends State<BlockWidget>{

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
  Widget displayWidget;
  _BlockWidgetState({this.x, this.y, this.block});

  Map<String, Function> dialogItems;

  @override
  void initState() {
    dialogItems = {
      'Перенос' : transmitSwitch,
      'Подключить' : connectIt,
      'Параметры' : openPreference,
    };
  }

  @override
  Widget build(BuildContext context) {
    width = 100;
    height = 50;
    border = Border.all(color: Colors.black);
    decoration = BoxDecoration(border: border);

    buildInputs();
    buildOutputs();
    buildDisplay();
    return Positioned(top: y, left: x,
      child: Column(
        children: [
          Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Column(children: inputs),
             GestureDetector(
               onLongPress: widget.canOpenPreference ? () async {showDialog(context);} : null,
               onTapDown:(details) => startTransmitting(details.localPosition.dx, details.localPosition.dy),
               onTapUp: (details) => endTransmitting(),
               onPanUpdate: (details) => transmitting(details.localPosition.dx, details.localPosition.dy),
               onPanEnd: (details) => endTransmitting(),
               child: displayWidget,
             ),
             Column(children: outputs),
           ]),
          Text('${block.name}'),
        ]),
    );
  }

  void buildInputs(){
    inputs.clear();
    for (int i = 0; i < block.numIn; i++){
      inputs.add(Container(
        width: 10,
        height: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      ),);
    }
  }
  void buildOutputs(){
    outputs.clear();
    for (int i = 0; i < block.numOut; i++){
      outputs.add(Container(
        width: 10,
        height: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
      ),);
    }
  }
  void buildDisplay(){
    getDisplay();
    displayWidget = Container(
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

  void startTransmitting(double dx, double dy){
    if (canTransmit)
      setState(() {
        border_color = Colors.red;
        this.dx = dx;
        this.dy = dy;
      });
  }
  void transmitting(double dx, double dy){
    if (!canTransmit) return;

    this.x += dx - this.dx;
    this.y += dy - this.dy;

    this.dx = dx;
    this.dy = dy;

    setState(() {
    });
  }
  void endTransmitting(){
    setState(() {
      border_color = Colors.black;
    });
  }

  void showDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            child: ListView.builder(
                    itemCount: dialogItems.length,
                    itemBuilder: (BuildContext context, int index){
                      var key = dialogItems.keys.toList()[index];
                      var func = dialogItems[key];

                      return Container(
                          child: FlatButton(child: Text(key, style: TextStyle(color: Colors.black, fontSize: 32),), onPressed: func,),
                      );
            }),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            padding: EdgeInsets.only(bottom: 12, top: 12, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
  void openPreference() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => BlockPreferencePage(block: block,)));
    setState(() {
    });
    Navigator.pop(context);
  }
  void transmitSwitch (){
    print('transmit');
    canTransmit = !canTransmit;
    endTransmitting();
    Navigator.pop(context);
  }
  void connectIt() {
    print('connect');
  }


}