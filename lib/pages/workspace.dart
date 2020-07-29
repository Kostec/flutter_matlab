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
    _controller = TextEditingController();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    List<DataRow> vars = [];
    _workspace.forEach((key, value) {
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

  TextEditingController _controller;

  DataRow _buildVariable(String key, dynamic value){
    print('build var');
    var valueType = value.runtimeType;
    TextInputType textType = valueType == int || valueType == double ?  TextInputType.number : TextInputType.text;
    return DataRow(
      cells: [
        DataCell(TextFormField(initialValue: '$key', keyboardType: TextInputType.text, onFieldSubmitted: (val){print('onSubmited $key $val');}), showEditIcon: true),
        DataCell(TextFormField(initialValue: '$value', keyboardType: textType, onFieldSubmitted: (val){print('onSubmited $key $val');},), showEditIcon: true),
        DataCell(Text('${value.runtimeType.toString()}')),
      ],
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