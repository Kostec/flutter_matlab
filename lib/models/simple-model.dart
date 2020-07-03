class SimpleModel{
  List<double> nums = [];
  List<double> dens = [];

  String numsToString(){
    String str = '';
    for (int i = 0; i < nums.length; i++){
      var num = nums[i];
      if (num == 0) continue;
      if((num > 0) && (i != 0)) str += '+';
      str += num.toStringAsFixed(2);
      if(num > 1) str += num > 1 ? 's^$i' : 's';
    }
    return str;
  }
}