import 'package:flutter/foundation.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/models/Blocks/Input.dart';
import 'package:fluttermatlab/models/Blocks/MathModel.dart';
import 'package:fluttermatlab/models/Blocks/Output.dart';

class Submodel extends Block {
  MathModel mathModel;

  double previousValue;
  @override
  String name;
  @override
  int numOut = 1;
  @override
  int numIn = 1;

  List<Input> _inputs = []; // виртуальные входы внутри
  List<Output> _outputs = []; // виртуальные выходы внутри

  Submodel(this.mathModel, {this.name = 'Submodel'}){
    setIO();
    setDefaultIO();
  }

  void setIO(){
    var _in = mathModel.blocks.where((element) => element is Input);
    _inputs.addAll(_in);
    numIn = _inputs.length;
    var _out = mathModel.blocks.where((element) => element is Output);
    _outputs.addAll(_out);
    numOut = _outputs.length;
  }

  @override
  List<String> getDisplay() {
    return [name.toString()];
  }

  @override
  Map<String, dynamic> getPreference() {
    return super.getPreference();
  }

  @override
  List<double> evaluate(double T) {
    var inputs = Inputs;
    var outputs = Outputs;
    for (int i = 0; i < numIn; i++){
      _inputs[i].value = inputs[i].value;
    }

    state.clear();
    state.addAll(outputs.map((e) => e.value));
    super.evaluate(T);
    return state;
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    super.setPreference(preference);
  }

  @override
  void setDefaultIO(){
    super.setDefaultIO();
  }
}