import 'dart:math';

import 'Block.dart';
import 'BlockIO.dart';

class TransferFcn extends Block{
  @override
  int numOut = 1;
  @override
  int numIn = 1;
  List<double> nums = [1];
  List<double> dens = [1,1];
  @override
  String name;

  TransferFcn({this.nums, this.dens, this.name = 'TransferFcn'}){
    setDefaultIO();
  }

  String arrayToString(List<double> nums){
    String str = '';
    for (int i = 0; i < nums.length; i++){
      var num = nums[i];
      if (num == 0) continue;
      if((num > 0) && (i != 0)) str += '+';
      str += num.toStringAsFixed(2);
      if (i > 0){
        str += 's';
      }
      if (i > 1){
        str += '^$i';
      }
    }
    return str;
  }

  String numsToString(){
    return arrayToString(nums);
  }

  String densToString(){
    return arrayToString(dens);
  }

  @override
  List<String> getDisplay() {
    return [
      numsToString(),
      densToString(),
    ];
  }

  @override
  Map<String, dynamic> getPreference() {
    var temp = super.getPreference();
    temp.addAll({'nums': nums, 'dens': dens});
    return temp;
  }

  @override
  void setPreference(Map<String, dynamic> preference){
    super.setPreference(preference);
    var numsStr = preference['nums'].toString().replaceAll('[', '').replaceAll(']', '');
    var nums = numsStr.split(',');
    this.nums.clear();
    for(int i = 0; i < nums.length; i++){
      this.nums.add(double.parse(nums[i]));
    }
    var densStr = preference['dens'].toString().replaceAll('[', '').replaceAll(']', '');
    var dens = densStr.split(',');
    this.dens.clear();
    for(int i = 0; i < dens.length; i++){
      this.dens.add(double.parse(dens[i]));
    }
    print('set');
  }

  @override
  List<double> evaluate(double T) {
    print('Evaluate TransferFcn');
    super.evaluate(T);
    var _in = Inputs[0].value;
    var _out = Outputs[0].value;
    if (_in == null || _out == null) {
      Inputs[0].value = 0;
      (Outputs[0] as PortOutput).setValue(0);
      return [0];
    }
    double up = 0;
    double down = 0;
    for(int i = 0; i < nums.length; i++){
      up += nums[i] * pow(T, i);
    }
    for(int i = 0; i < dens.length; i++){
      down += dens[i] * pow(T, i);
    }
    _out = (_in - _out) * up / down;
    state[time] = [_out];//.addEntries([new MapEntry(time, [_out])]);
    (Outputs[0] as PortOutput).setValue(_out);
    print('Transfer: $_out');
    return [_out];
  }
}