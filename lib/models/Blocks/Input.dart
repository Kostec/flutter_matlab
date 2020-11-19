import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Blocks/Output.dart';

/// Объект этого класса используется для создания входного порта для при создании собственного блока
class Input extends Block{
    int num;
    double _value;
    set value (val) {
      _value = val;
      Outputs[0].setValue(_value);
    }
    get value => _value;

    @override
    String name;
    @override
    int numOut = 1;
    @override
    int numIn = 0;

    Input({this.name = 'Input', this.num = 0});

    @override
    List<String> getDisplay() {
      return [num.toString()];
    }

    @override
    Map<String, dynamic> getPreference() {
      return {'num': num};
    }

    @override
    void setPreference(Map<String, dynamic> preference) {
      super.setPreference(preference);
      num = preference['num'] == null ? num : double.parse(preference['num']);
    }

    @override
    List<double> evaluate(double T) {
      super.evaluate(T);
    }
}