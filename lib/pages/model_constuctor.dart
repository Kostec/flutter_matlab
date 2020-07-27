import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/services/modeling.dart';
import 'package:fluttermatlab/widgets/block.dart';
import 'package:fluttermatlab/widgets/menu.dart';

class ModelPage extends StatefulWidget{

  @override
  State createState() => _ModelPageState();
    static void OpenPage(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ModelPage()));
  }
}

class _ModelPageState extends State<ModelPage>{
  Path path;
  Paint paint;
  Canvas canvas;

  List<Block> blocks = [];

  List<BlockWidget> blockWidgets = [];

  @override
  void initState() {
    blocks.add(new Constant(value: 3));
    blocks.add(new TransferFcn(nums: [1], dens: [1,1]));

    double countX = 20;
    double countY = 20;
    blocks.forEach((block) {
      blockWidgets.add(BlockWidget(x: countX, y: countY, block: block));
      countX += 150;
    });

    Solver solver = new Solver();
  }
  @override
  Widget build(BuildContext context) {
    var drawer = Menu();
    var appBar = _buildAppBar();
    var body = _buildBody();
    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text('Model'),
    );
  }

  Widget _buildBody(){
    return Stack(
      children: blockWidgets,
    );
  }

}