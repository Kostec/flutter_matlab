import 'Block.dart';
import 'BlockIO.dart';

class TransferFcn extends Block{
  int numOutput = 1;
  int numInput = 1;
  List<double> nums = [1];
  List<double> dens = [1,1];
  List<BlockIO> IO;

  TransferFcn({this.nums, this.dens});

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
  String toString() {
    return numsToString();
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
    var temp = {'nums': nums, 'dens': dens};
    return temp;
  }

  @override
  List<double> evaluate(double T) {
    print('Evaluate TransferFcn');
    super.evaluate(T);
    var _out = IO.firstWhere((io) => io.type == IOtype.input)?.value;
    var _in = IO.firstWhere((io) => io.type == IOtype.output)?.value;
    if (_in == null || _out == null) return [0];
    double up = 0;
    double down = 0;
    for(int i = 0; i < nums.length; i++){
      up += nums[i] / (T * i);
    }
    for(int i = 0; i < dens.length; i++){
      down += dens[i] / (T * i);
    }
    _out = _in * up / down;
    state.addEntries([new MapEntry(time, [_out])]);
    return [_out];
  }
}