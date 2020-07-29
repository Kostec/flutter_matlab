import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/services/workspace.dart';
import 'package:fluttermatlab/widgets/menu.dart';

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
      drawer: MainMenu.menu,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: addVariable,
        tooltip: 'Создать переменную',
        child: Icon(Icons.add),
      ),
    );
  }

  void addVariable(){
    var n = _workspace.length;
    workspace.addVariable('name_$n', 0);
    _workspace = workspace.variables;
    setState(() { });
  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text('Workspace'),
    );
  }

  Widget _buildBody(){
    List<DataRow> vars = [];
    _workspace.forEach((key, value) {
      vars.add(_buildVariable(key, value));
    });
    return Container(
      child: DataTable(
       columns: [
         DataColumn(label: Text("Name"), tooltip: 'name'),
         DataColumn(label: Text("val"), tooltip: 'name'),
        ],
          rows: vars,
      )
//      child: ListView.builder(
//        itemCount: _workspace.length,
//        itemBuilder: (context, i){
//          var key = _workspace.keys.toList()[i];
//          var value = _workspace[key];
//          return _buildVariable(key, value);
//        }
//      )
    );
  }

  DataRow _buildVariable(String key, dynamic value){
    print('build var');
    return DataRow(
      cells: [
        DataCell(Text(key)),
        DataCell(Text('$value')),
      ]
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