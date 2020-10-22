import 'package:fluttermatlab/models/Block.dart';

class Scope extends Block{

  @override
  int numIn;
  @override
  int numOut = 0;
  @override
  String name;
  Map<int, Map<double, List<double>>> stateInputs = {};

  double T;

  Scope({this.numIn = 1, this.name = 'Scope'}){
    for(int i = 0; i < numIn; i++){
      stateInputs[i] = {};
    }
    setDefaultIO();
  }


  @override
  Map<String, dynamic> getPreference() {
    var temp = super.getPreference();
    temp.addAll({'numIn': numIn});
    return temp;
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    super.setPreference(preference);
    numIn = int.parse(preference['numIn']);
  }

  @override
  List<String> getDisplay() {
    return ['Scope'];
  }

  @override
  List<double> evaluate(double T) {
    var _inputs = Inputs;
    for(int i = 0; i < _inputs.length; i++){
      stateInputs[i].addEntries([new MapEntry(time, [_inputs[i].value])]);
    }
    super.evaluate(T);
  }
}