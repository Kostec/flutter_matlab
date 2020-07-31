import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

class Derivative extends Block{
  @override
  String name;
  @override
  int numOut = 1;
  @override
  int numIn = 1;

  double previousValue;

  Derivative({this.name = 'Derivative'});

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
    print('Evaluate Integrator');
    super.evaluate(T);
    var _in = IO.firstWhere((io) => io.type == IOtype.input)?.value;
    var _out = IO.firstWhere((io) => io.type == IOtype.output)?.value;
    _out += (_in - previousValue) / T;
    previousValue = _in;
    state.addEntries([new MapEntry(time, [_out])]);
    return [_out];
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    name = preference['name'];
  }
}
