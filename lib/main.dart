import 'package:flutter/material.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/pages/chart.dart';
import 'package:fluttermatlab/services/modeling.dart';
import 'package:fluttermatlab/widgets/block.dart';

import 'widgets/menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  static void OpenPage(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHomePage(title: 'HomePage',)));
  }
}

class _MyHomePageState extends State<MyHomePage> {

  Path path;
  Paint paint;
  Canvas canvas;

  Block transfer;
  Block constant;

  @override
  void initState() {

    transfer = new TransferFcn(nums: [1], dens: [1,1]);
    constant = new Constant(value: 3);

    constant.addOutput(transfer, 0, 0);

    constant.removeOutput(constant.IO[0]);
//    constant.addIO(transfer, 1, 1, IOtype.output);

//    constant.removeIO(constant.IO[0]);

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
        onPressed: (){print('Float');},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text(widget.title),
    );
  }

  Widget _buildBody(){
    return Stack(
      children: <Widget>[
        BlockWidget(x: 20.0, y: 20.0, block: transfer),
        BlockWidget(x: 60.0, y: 80.0, block: constant),
      ],
    );
  }
}
