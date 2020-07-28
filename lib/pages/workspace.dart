import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/services/workspace.dart';

class WorkspacePage extends StatefulWidget{
  @override
  State createState() => _WorkspacePageState();

  static void OpenPage(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkspacePage()));
  }
}

class _WorkspacePageState extends State<WorkspacePage>{
  Map<String, dynamic> _workspace;
  @override
  void initState() {
    _workspace = workspace.variables;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text('Workspace'),
    );
  }

  Widget _buildBody(){
    return Container(
      child: Text('Body'),
    );
  }


  void loadWorkspace(){
    _workspace = workspace.variables;
  }

  void saveWorkspace(){
    workspace.addVariableRange(_workspace);
  }

  void removeWorkspace(){
    workspace.variables.clear();
    loadWorkspace();
  }
}