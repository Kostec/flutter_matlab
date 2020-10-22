import 'package:fluttermatlab/models/Block.dart';
import 'BlockIO.dart';

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
    int _numIn = int.parse(preference['numIn']);

    if (_numIn > numIn) {
      for (int i = numIn; i < _numIn; i++) {
        stateInputs[i] = {};
        IO.add(PortInput(num: i));
      }
    }
    else{
      List<BlockIO> toRemove = [];
      for (int i = _numIn; i < numIn; i++) {
        stateInputs.remove(i);
        toRemove.add(IO[i]);
      }
      toRemove.forEach((element) {
        IO.remove(element);
      });
    }
    numIn = _numIn;
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