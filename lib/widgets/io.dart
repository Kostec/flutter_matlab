import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IOWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw IOWidgetState();
  }
}

class IOWidgetState extends State<IOWidget>{
  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 20,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
    );
  }
}