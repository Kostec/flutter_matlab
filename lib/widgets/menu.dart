import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/pages/BlockLibrary.dart';
import 'package:fluttermatlab/pages/chart.dart';
import 'package:fluttermatlab/pages/model_constuctor.dart';
import 'package:fluttermatlab/pages/workspace.dart';

import '../main.dart';

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
          ListTile(title: Text('Model'), onTap: (){Navigator.pop(context); ModelPage.OpenPage(context);},),
          ListTile(title: Text('ChartPage'), onTap: (){ Navigator.pop(context); ChartPage.OpenPage(context);},),
          ListTile(title: Text('Workspace'), onTap: (){ Navigator.pop(context); WorkspacePage.OpenPage(context);},),
          ListTile(title: Text('Block library'), onTap: (){ Navigator.pop(context); BlockLibrary.OpenPage(context);},),
        ],
      ),
    );
  }
}