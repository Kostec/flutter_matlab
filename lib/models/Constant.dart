import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

class Constant extends Block{
  double value = 1;
  @override
  int numOut = 1;
  @override
  String name;
  Constant({this.value = 1, this.name = "Constant"}){
    setDefaultIO();
  }

  @override
  List<double> evaluate(double T) {
    super.evaluate(T);
    state.addEntries([new MapEntry(time, [value])]);
    (Outputs[0] as PortOutput).setValue(value);
    print('constant time: $time');
    return [value];
  }

  @override
  List<String> getDisplay() {
    return ['$value'];
  }

  @override
  Map<String, dynamic> getPreference() {
    var temp = super.getPreference();
    temp.addAll({'value': value});
    return temp;
  }

  @override
  void setPreference(Map<String, dynamic> preference){
    name = preference['name'];
    value = double.parse(preference['value']);
    print('set');
  }
}