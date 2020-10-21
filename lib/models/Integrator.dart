import 'package:flutter/cupertino.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

class Integrator extends Block{
  double coef;
  double initValue;
  @override
  String name;
  @override
  int numOut = 1;
  @override
  int numIn = 1;

  double previousValue;

  Integrator({@required this.coef, this.initValue = 0, this.name = 'Integrator'}){
    previousValue = initValue;
    setDefaultIO();
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
//    print('Evaluate Integrator');
    super.evaluate(T);
    double _in = Inputs[0].value;
    double _out = Outputs[0].value;
    if (state.length == 0) {
      _out = initValue;
      state.add(initValue);
    }
    if (_in == null || _out == null) {
      Inputs[0].value = 0;
      (Outputs[0] as PortOutput).setValue(0);
      return [0];
    }
    _out += _in * T;
    previousValue = _in;
    state[0] = _out;
    (Outputs[0] as PortOutput).setValue(_out);
    return [_out];
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    coef = preference['name'] == null ? coef : double.parse(preference['name']);
    coef = preference['coef'] == null ? coef : double.parse(preference['coef']);
    initValue = preference['initValue'] == null ? initValue : double.parse(preference['initValue']);
  }
}