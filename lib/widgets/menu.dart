import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/pages/chart.dart';
import 'package:fluttermatlab/pages/model_constuctor.dart';

import '../main.dart';

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
          ListTile(title: Text('Model'), onTap: (){ModelPage.OpenPage(context);},),
          ListTile(title: Text('ChartPage'), onTap: (){ChartPage.OpenPage(context);},),
          ListTile(title: Text('Item 3'), onTap: (){print('Item 3');},),
          ListTile(title: Text('Item 4'), onTap: (){print('Item 4');},),
        ],
      ),
    );
  }
}