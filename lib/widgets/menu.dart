import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/pages/BlockLibrary.dart';
import 'package:fluttermatlab/pages/chart.dart';
import 'package:fluttermatlab/pages/login.dart';
import 'package:fluttermatlab/pages/model_constuctor.dart';
import 'package:fluttermatlab/pages/workspace.dart';

class MainMenu{
  static Menu menu;
  static init(){
    menu = Menu();
  }
}

class Menu extends StatefulWidget{
  @override
  State createState() {
    return _MenuState();
  }
}

class _MenuState extends State<Menu>{

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    var drawer = _buildDrawer();
    return drawer;
  }

  Drawer _buildDrawer(){
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
            child: Column(
              children: <Widget>[
                Text('Text 1'),
                Text('Text 2'),
              ],
            ),
          ),
          ListTile(title: Text('Login'), onTap: (){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));},),
          ListTile(title: Text('Model'), onTap: (){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context)=> ModelPage()));}),
          ListTile(title: Text('ChartPage'), onTap: (){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context)=>ChartPage()));},),
          ListTile(title: Text('Workspace'), onTap: (){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => WorkspacePage()));},),
          ListTile(title: Text('Block library'), onTap: (){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => BlockLibrary()));},),
        ],
      ),
    );
  }
}