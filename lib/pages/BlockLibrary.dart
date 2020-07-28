import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      drawer: Menu(),
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
    return Container(
      child: ListView.builder(
        itemCount: Library.blocks.length,
        itemBuilder: (context, index){
          var key = Library.blocks.keys.toList()[index];
          var block = Library.blocks[key];
          var widget = BlockWidget(x: 0, y: 0, block: block);
          return ListTile(
            subtitle: Container(
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(100),
                borderRadius: new BorderRadius.all(new Radius.circular(20.0)),),
              height: 100,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              child: widget,
            ),
            onTap: () => print(key),
          );
        }),
    );
  }


}