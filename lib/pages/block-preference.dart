import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttermatlab/models/Block.dart';

class BlockPreferencePage extends StatefulWidget{

  Block block;

  BlockPreferencePage({this.block});

  @override
  State createState() {
    return _BlockPreferencePageState();
  }
}

class _BlockPreferencePageState extends State<BlockPreferencePage>{

  GlobalKey<FormBuilderState> _formKey = GlobalKey();

  Block block;
  List<Widget> preferences = [];

  List<Widget> form = [];

  @override
  void initState() {
    block = widget.block;
  }

  @override
  Widget build(BuildContext context) {
    buildForm();
    return Scaffold(
      appBar: AppBar(title: Text(block.name),),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            FormBuilder(key: _formKey,child: Column(children: form)),
            Container(
              width: double.infinity,
              height: 52.0,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('Сохранить', style: Theme.of(context).textTheme.button,),
                onPressed: save,
              )),
          ]
        )
      ),
    );
  }

  Widget buildForm(){
    form = [];
    var blockPreference = block.getPreference();

    blockPreference.forEach((key, value) {
      form.add(FormBuilderTextField(
        decoration: InputDecoration(labelText: key, labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        attribute: key,
        initialValue: value.toString(),
      ));
    });
  }

  void save(){
    _formKey.currentState.save();
    var values = _formKey.currentState.value;
    block.setPreference(values);
    Navigator.pop(context, true);
  }
}