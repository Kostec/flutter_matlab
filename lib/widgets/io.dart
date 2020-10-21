import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/other/enums.dart';

typedef IOGestureCallback = Function(IOWidget io, GestureEnum gesture);

class IOWidget extends StatefulWidget{
  static int count = 0;

  BuildContext context;

  BlockIO io;
  IOWidget(this.io,);

  IOGestureCallback gestureCallback;

  @override
  State<StatefulWidget> createState() => IOWidgetState();
}

class IOWidgetState extends State<IOWidget>{
  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    return widget.io is PortInput ? _buildInput() : _buildOutput();
  }

  Widget _buildInput(){
    return GestureDetector(
      onTap: (){
        if (widget.gestureCallback != null) widget.gestureCallback(widget, GestureEnum.tap);
        print('input tap');
      },
      child: Container(
        width: 40,
        height: 20,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border.all(color: Colors.black), color: widget.io.connectedTo == null ? Colors.grey : Colors.green),
        child: Center(child: Text('${widget.io.num}')),
      ),
    );
  }

  Widget _buildOutput(){
    return GestureDetector(
        onTap: () {
        if (widget.gestureCallback != null) widget.gestureCallback(widget, GestureEnum.tap);
        print('output tap');
      },
      child: Container(
        width: 40,
        height: 20,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border.all(color: Colors.black), color: (widget.io as PortOutput).connections.length == 0 ? Colors.grey : Colors.blue,),
        child: Center(child: Text('${widget.io.num}')),
      )
    );
  }
}