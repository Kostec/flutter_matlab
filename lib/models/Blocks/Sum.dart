import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

class Sum extends Block{

  @override
  int numOut = 1;
  @override
  int numIn = 2;

  String operators;
  @override
  String name;
  Sum({this.name = 'Sum', this.operators = '++'}){
//    _setOperators();
    numIn = operators.length;
    setDefaultIO();
  }

  @override
  void setDefaultIO(){
    IO.clear();
    for(int i = 0; i < operators.length; i++){
      IO.add(PortInput(num: i, name: operators[i]));
    }
    IO.add(PortOutput(num: 0,));
  }

  void _setOperators(){
    operators = '';
    for(int i = 0; i < numIn; i++){
      operators += '+';
    }
  }


  @override
  Map<String, dynamic> getPreference() {
    return {'name': name, 'operators': operators};
  }

  @override
  List<double> evaluate(double T) {
    var _in = Inputs;
    var _out = 0.0;
    for (int i = 0; i< _in.length; i++){
      switch(operators[i]){
        case '+':
          _out += _in[i].value;
          break;
        case '-':
          _out += _in[i].value;
          break;
        case '*':
          _out += _in[i].value;
          break;
        case '/':
          _out += _in[i].value;
          break;
      }
    }
    (Outputs[0] as PortOutput).setValue(_out);
    return [_out];
  }

  @override
  List<String> getDisplay() {
    List<String> list = [];
    for(int i = 0; i < operators.length; i++){
      list.add(operators[i]);
    }
    return list;
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    Inputs.forEach((io) {
      io.disconnect();
    });
    name = preference['name'];
    operators = preference['operators'];
    numIn = operators.length;
    setDefaultIO();
  }
}