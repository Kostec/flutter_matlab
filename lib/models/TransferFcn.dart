import 'Block.dart';

class TransferFcn extends Block{
  List<double> nums = [1];
  List<double> dens = [1,1];

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


}