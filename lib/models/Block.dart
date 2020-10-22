import 'package:fluttermatlab/other/enums.dart';
import 'package:fluttermatlab/services/workspace.dart';
import 'BlockIO.dart';

abstract class Block {
  int numOut = 0;
  int numIn = 0;
  String name;
  Block({this.name = 'Block'});
  List<PortIO> IO = [];
  double time = 0;
  List<double> state = [];

  List<PortIO> get Inputs{
    return IO.where((io) => io.type == IOtype.input).toList();
  }

  List<PortIO> get Outputs{
    return IO.where((io) => io.type == IOtype.output).toList();
  }

  void setDefaultIO(){
    for(int i = 0; i < numIn; i++){
      IO.add(PortInput(num: i));
    }
    for(int i = 0; i < numOut; i++){
      IO.add(PortOutput(num: i));
    }
  }

  void ResetIO(){
    Inputs.forEach((element){
      element.value = 0;
    });
    Outputs.forEach((element){
      (element as PortOutput).setValue(0);
    });
  }

  @override
  String toString() {
    return this.runtimeType.toString();
  }

  Map<String, dynamic> getPreference(){
    return {'name': name};
  }

  void setPreference(Map<String, dynamic> preference){

    Map<String, dynamic> map = {};

    preference.forEach((key, value) {
      if (workspace.variables.containsKey(value)){
        map[key] = workspace.variables[value];
      }
    });

    map.forEach((key, value) {
      preference.remove(key);
      preference[key] = value;
    });
    name = preference['name'];
  }

  List<String> getDisplay() {
    return [this.name];
  }

  List<double> evaluate(double T){
    time += T;
  }

  void resetState(){
    time = 0;
    state.clear();
    ResetIO();
  }
}