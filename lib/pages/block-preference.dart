import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/models/Block.dart';

class BlockPreferencePage extends StatefulWidget{

  Block block;

  BlockPreferencePage({@required this.block});
  @override
  State createState() {
    return _BlockPreferencePageState();
  }
}

class _BlockPreferencePageState extends State<BlockPreferencePage>{

  Block block;
  List<Widget> preferences = [];

  @override
  void initState() {
    block = widget.block;
    var blockPreference = block.getPreference();

    preferences.add(Text('Name'));
    preferences.add(Text(block.name));

    blockPreference.forEach((key, value) {
      preferences.add(Text(key.toString()));
      preferences.add(Text(value.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(block.name),),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Column(children: preferences,)
          ],
        ),
      ),
    );
  }
}