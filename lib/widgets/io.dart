import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

class IOWidget extends StatefulWidget{
  BlockIO io;
  IOWidget(this.io);
  @override
  State<StatefulWidget> createState() => IOWidgetState();
}

class IOWidgetState extends State<IOWidget>{
  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return widget.io is PortInput ? _buildInput() : _buildOutput();
  }

  Widget _buildInput(){
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(border: Border.all(color: Colors.black), color: widget.io.connectedTo == null ? Colors.grey : Colors.green),
      child: Center(child: Text('${widget.io.num}')),
    );
  }

  Widget _buildOutput(){
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(border: Border.all(color: Colors.black), color: (widget.io as PortOutput).connections.length == 0 ? Colors.grey : Colors.blue,),
      child: Center(child: Text('${widget.io.num}')),
    );
  }
}