import 'package:flutter/cupertino.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

class Integrator extends Block{
  double coef;
  double initValue;
  String name;
  int numOut = 1;
  int numIn = 1;

  double previousValue;

  Integrator({@required this.coef, this.initValue = 0, this.name = 'Integrator'}){
    previousValue = initValue;
  }

  @override
  List<String> getDisplay() {
    return [coef.toString(), 's'];
  }

  @override
  Map<String, dynamic> getPreference() {
    return {'coef': coef, 'initValue': initValue};
  }

  @override
  List<double> evaluate(double T) {
    print('Evaluate Integrator');
    super.evaluate(T);
    var _in = IO.firstWhere((io) => io.type == IOtype.input)?.value;
    var _out = IO.firstWhere((io) => io.type == IOtype.output)?.value;
    if (state.length == 0) _out = initValue;
    _out += (_in - previousValue) * T;
    previousValue = _in;
    state.addEntries([new MapEntry(time, [_out])]);
    return [_out];
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    coef = preference['coef'] == null ? coef : double.parse(preference['coef']);
    initValue = preference['initValue'] == null ? initValue : double.parse(preference['initValue']);
  }
}