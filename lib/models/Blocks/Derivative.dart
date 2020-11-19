import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/other/enums.dart';

class Derivative extends Block{
  @override
  String name;
  @override
  int numOut = 1;
  @override
  int numIn = 1;

  double previousValue;

  Derivative({this.name = 'Derivative'}){
    setDefaultIO();
  }

  @override
  List<String> getDisplay() {
    return ['d', 'dt'];
  }

  @override
  Map<String, dynamic> getPreference() {
    return {'name': name};
  }

  @override
  List<double> evaluate(double T) {
    if (state.length < 2) {
      state.add(0);
      state.add(0);
      previousValue = 0;
    }

    var _in = IO.firstWhere((io) => io.type == IOtype.input);
    var _out = IO.firstWhere((io) => io.type == IOtype.output);
    (_out as PortOutput).setValue((_in.value - state[1])/T);

    state[1] = _in.value;
    state[0] = _out.value;
    super.evaluate(T);
    return [_out.value];
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    name = preference['name'];
  }
}
