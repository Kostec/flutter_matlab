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
  Map<String,TextEditingController> _contollers = {};
  @override
  void initState() {
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
  AppBar _buildAppBar(){
    return AppBar(
      title: Text('Workspace'),
    );
  }
  Widget _buildBody(){
    _contollers = {};
    List<DataRow> vars = [];
    workspace.variables.forEach((key, value) {
      vars.add(_buildVariable(key, value));
    });
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:
        Column(
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text("Name"), tooltip: 'name'),
                  DataColumn(label: Text("Value"), tooltip: 'value'),
                  DataColumn(label: Text("Type"), tooltip: 'type'),
                ],
                rows: vars,
              )
            ])
    );
  }
  void addVariable(){
    var n = workspace.variables.length;
    var name = 'name_$n';
    while (workspace.variables.containsKey(name)){
      name = 'name_$n';
      n++;
    }
    workspace.variables[name] = 0;
    setState(() { });
  }
  DataRow _buildVariable(String key, dynamic value){
    print('build var');
    var valueType = value.runtimeType;
    TextInputType textType = valueType == int || valueType == double ?  TextInputType.number : TextInputType.text;
    var controller = new TextEditingController(text: '$key');
    _contollers['key'] = controller;
    return DataRow(
      cells: [
//        DataCell(TextFormField(initialValue: '$key', keyboardType: TextInputType.text, onFieldSubmitted: (val){ editVariableName(key, val);}), showEditIcon: true),
        DataCell(TextFormField(controller: controller, keyboardType: TextInputType.text, onFieldSubmitted: (val){ editVariableName(key, val, controller: controller);}), showEditIcon: true),
        DataCell(TextFormField(initialValue: '$value', keyboardType: textType, onFieldSubmitted: (val){ editVariableValue(key, val);}), showEditIcon: true),
        DataCell(Text('${value.runtimeType.toString()}')),
      ],
    );
  }
  void editVariableName(String oldName, String newName, {TextEditingController controller = null}){
    if (!workspace.variables.containsKey(newName)) {
      var value = workspace.variables[oldName];
      workspace.variables.remove(oldName);
      workspace.variables[newName] = value;
    }
    else{
        controller = new TextEditingController(text: '$workspace.variables[oldName]');
    }
    print('');
    setState((){});
  }
  void editVariableValue(String key, String value){
    print('edit $key, $value');
    Type type = workspace.variables[key].runtimeType;
    workspace.variables.remove(key);
    workspace.variables[key] = type == double ? double.parse(value) : value;
  }
  void removeWorkspace(){
    workspace.variables.clear();
  }
}