import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

class Coef extends Block{
  double coef;
  @override
  String name;
  @override
  int numOut = 1;
  @override
  int numIn = 1;

  Coef({this.coef = 1, this.name = "Coef"}){
    setDefaultIO();
  }

  @override
  List<String> getDisplay() {
    return [coef.toString()];
  }
  @override
  List<double> evaluate(double T) {
    super.evaluate(T);
    if (state.length == 0) state.add(0);
    var _in = Inputs[0].value;
    var _out = _in * coef;
    state[0] = _out;
    (Outputs[0] as PortOutput).setValue(_out);
    return [_out];
  }

  @override
  Map<String, dynamic> getPreference() {
    return {'coef': coef};
  }

  @override
  void setPreference(Map<String, dynamic> preference) {
    super.setPreference(preference);
    coef = preference['coef'] == null ? coef : double.parse(preference['coef']);
  }
}
