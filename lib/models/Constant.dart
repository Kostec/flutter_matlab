import 'package:fluttermatlab/models/Block.dart';

class Constant extends Block{
  double value = 1;
  int numOutput = 1;
  String name;
  Constant({this.value = 1, this.name = "Constant"});

  @override
  List<double> evaluate(double T) {
    super.evaluate(T);
    state.addEntries([new MapEntry(time, [value])]);
    return [value];
  }

  @override
  String toString() {
    return value.toString();
  }

  @override
  List<String> getDisplay() {
    return [toString()];
  }
}