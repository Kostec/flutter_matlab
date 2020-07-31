import 'package:fluttermatlab/models/Block.dart';

class Constant extends Block{
  double value = 1;
  int numOut = 1;
  String name;
  Constant({this.value = 1, this.name = "Constant"});

  @override
  List<double> evaluate(double T) {
    super.evaluate(T);
    state.addEntries([new MapEntry(time, [value])]);
    return [value];
  }

  @override
  List<String> getDisplay() {
    return [toString()];
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