import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/pages/block-preference.dart';
import 'package:fluttermatlab/services/workspace.dart';
import 'package:fluttermatlab/widgets/io.dart';
import 'package:fluttermatlab/other/enums.dart';

class PositionedBlockWidget extends StatefulWidget{
  double x; double y;
  Block block;
  bool canOpenPreference;
  List<Widget> inputs = [];
  List<Widget> outputs = [];
  ConnectionCallback connectionCallback;

  IOGestureCallback ioGestureCallback;

  PositionedBlockWidget({this.x, this.y, this.block, this.canOpenPreference = true});

  @override
  State<StatefulWidget> createState() {
    return _PositionedBlockWidgetState(x: x, y: y, block: block);
  }

}

typedef ConnectionCallback = void Function(Block);

class _PositionedBlockWidgetState extends State<PositionedBlockWidget>{
  Block block;

  double x; double y;
  double dx = 0, dy = 0;
  bool canTransmit = true;

  _PositionedBlockWidgetState({this.x, this.y, this.block});

  Map<String, Function> dialogItems;
  BlockWidget blockWidget;

  @override
  void initState() {
    dialogItems = {
      'Перенос' : transmitSwitch,
      'Подключить' : connectIt,
      'Параметры' : openPreference,
      'Удалить': remove,
    };
  }

  @override
  Widget build(BuildContext context) {
    blockWidget = BlockWidget(block: block,);
    widget.inputs = blockWidget.inputs;
    widget.outputs = blockWidget.outputs;

    blockWidget.inputs.forEach((input) {
      (input as IOWidget).gestureCallback = IOGestureCallBack;
    });
    blockWidget.outputs.forEach((output) {
      (output as IOWidget).gestureCallback = IOGestureCallBack;
    });

    return Positioned(top: y, left: x,
      child: GestureDetector(
        onLongPress: widget.canOpenPreference ? () async {showDialog(context);} : null,
        onTapDown:(details) => startTransmitting(details.localPosition.dx, details.localPosition.dy),
        onTapUp: (details) => endTransmitting(),
        onPanUpdate: (details) => transmitting(details.localPosition.dx, details.localPosition.dy),
        onPanEnd: (details) => endTransmitting(),
        child: blockWidget,
      )
    );
  }
  void startTransmitting(double dx, double dy){
    if (canTransmit)
      setState(() {
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
      widget.x = this.x;
      widget.y = this.y;
    });
  }
  void endTransmitting(){
    this.dx = 0;
    this.dy = 0;
    setState(() { });
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
    setState(() { });
    Navigator.pop(context);
  }
  void transmitSwitch (){
    print('transmit');
    canTransmit = !canTransmit;
    endTransmitting();
    Navigator.pop(context);
  }
  void connectIt() {
    if (widget.connectionCallback != null) widget.connectionCallback(block);
    print('connect');
  }
  void remove(){
    workspace.selectedMathModel.removeBlock(block);
    Navigator.of(context).pop();
  }

  void IOGestureCallBack(BlockIO io, GestureEnum type){
    print('IOGestureCallBack ${io.num} ${io.type}');
    if (widget.ioGestureCallback != null) widget.ioGestureCallback(io, type);
  }
}

class BlockWidget extends StatefulWidget{
  Block block;
  List<Widget> inputs = [];
  List<Widget> outputs = [];
  BlockWidget({this.block});

  @override
  State<StatefulWidget> createState() {
    return _BlockWidgetState();
  }
}

class _BlockWidgetState extends State<BlockWidget>{
  Block block;

  Color border_color = Colors.black;
  Border border;
  BoxDecoration decoration;
  List<Widget> display = [];
  List<Widget> inputs = [];
  List<Widget> outputs = [];
  List<Widget> inputNames = [];
  List<Widget> outputNames = [];
  Widget displayWidget;

  @override
  void initState() {
    block = widget.block;
    inputs = widget.inputs;
    outputs = widget.outputs;
    inputs = [];
    outputs = [];
  }
  @override
  Widget build(BuildContext context) {
    buildInputs();
    buildOutputs();
    buildDisplay();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(children: inputs, direction: Axis.vertical, spacing: 5,),
              Container (
                decoration: BoxDecoration(border: Border.all(color: border_color), color: Colors.white),
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Wrap(children: inputNames, direction: Axis.vertical, spacing: 7,),
                    Container(child: displayWidget,),
                    Wrap(children: outputNames, direction: Axis.vertical, spacing: 7,),
                  ]
                ),),
              Wrap(children: outputs, direction: Axis.vertical,),
              ]
          ),
          Text('${block.name}'),
        ]));
  }

  void buildInputs(){
    var _inputs = block.Inputs;
    inputs.clear();
    inputNames.clear();
    for (int i = 0; i < block.numIn; i++){
      inputs.add(IOWidget(_inputs[i]));
      inputNames.add(Container(
          padding: EdgeInsets.all(2),
          child: Center(child: Text('${_inputs[i].name}')),
        ),
      );
    }
  }
  void buildOutputs(){
    var _outputs = block.Outputs;
    outputs.clear();
    outputNames.clear();
    for (int i = 0; i < block.numOut; i++){
      outputs.add(IOWidget(_outputs[i]));
      outputNames.add(Container(
        padding: EdgeInsets.all(2),
        child: Center(child: Text('${_outputs[i].name}')),
      ),);
    }
  }
  void buildDisplay(){
    getDisplay();
    displayWidget = GestureDetector(
      onTap: () => print('Display Tap'),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.vertical,
          spacing: 10,
          children: display,
        ),
      ),
    );
  }
  void getDisplay(){
    display.clear();
    var toDisplay = block.getDisplay();
    for (int i = 0; i < toDisplay.length; i++){
      display.add(Text(toDisplay[i]));
//      if (toDisplay.length - i > 1) display.add(Divider(color: Colors.black,));
    }
  }
}