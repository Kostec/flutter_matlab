import 'Block.dart';

class TransferFcn extends Block{
  static const int numOutput = 1;
  static const int numInput = 1;
  List<double> nums = [1];
  List<double> dens = [1,1];
  List<double> output = new List(numOutput);
  List<double> input = new List(numInput);

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
  List<double> evaluate() {
    print('Evaluate TransferFcn');
    return null;
  }
}