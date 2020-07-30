import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/services/library.dart';
import 'package:fluttermatlab/widgets/block.dart';
import 'package:fluttermatlab/widgets/menu.dart';

class BlockLibrary extends StatefulWidget{

  @override
  State createState() => _BlockLibraryState();

  static void OpenPage(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => BlockLibrary()));
  }
}

class _BlockLibraryState extends State<BlockLibrary>{

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainMenu.menu,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text('Библиотека'),
    );
  }

  Widget _buildBody(){
    List<Widget> blocks = [];

    Library.blocks.forEach((key, value) {
      var widget = _buildBlock(key, value);
      blocks.add(widget);
    });

    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        children: blocks,
      ),
    );
  }

  Widget _buildBlock(String key, Block value){
    var block = Library.blocks[key];
    var blockWidget = BlockWidget(block: block);
    return
    GestureDetector(
      onTap: () {print('block ${key} was tapped');},
      child: Container(
        decoration: BoxDecoration(
        color: Colors.blue.withAlpha(100),
        borderRadius: new BorderRadius.all(new Radius.circular(20.0)),),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        child: Center(child: blockWidget),
    ),);
  }
}