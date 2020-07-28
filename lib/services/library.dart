
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';

class Library
{
  static Map<String, Block> blocks = {
    'Constant' : Constant(value: 1),
    'Transfer' : TransferFcn(nums: [1], dens: [1, 1]),
  };

  static Map<String, dynamic> constants = {
    'PI' : 3.14,
  };
}