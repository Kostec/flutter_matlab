import 'package:fluttermatlab/models/Block.dart';

class Sum extends Block{

  @override
  int numOut = 1;
  @override
  int numIn = 2;

  String operators;
  @override
  String name;
  Sum({this.numIn = 2, this.name = 'Sum'}){
    _setOperators();
    setDefaultIO();
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
    name = preference['name'];
    operators = preference['operators'];
    numIn = operators.length;
  }
}