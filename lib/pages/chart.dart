import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/widgets/menu.dart';

class ChartPage extends StatefulWidget{

  @override
  State createState() {
    return _ChartPageState();
  }

  static void OpenPage(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChartPage()));
  }
}

class _ChartPageState extends State<ChartPage>{

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    var drawer = Menu();
    var body = _buildBody();

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(title: Text('ChartPage'),),
      body: body,
    );
  }

  Widget _buildBody(){
    return Column();
  }
}