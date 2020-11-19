import 'package:fluttermatlab/models/Block.dart';

/// Объект этого класса используется для создания выходного порта для при создании собственного блока
class Output extends Block{
  int num;
  double _value;
  get value => Inputs[0].value;
  @override
  String name;
  @override
  int numOut = 0;
  @override
  int numIn = 1;

  Output({this.name = 'Output', this.num = 0});

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