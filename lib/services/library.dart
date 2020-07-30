
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';

class Library
{
  static Map<String, Block> blocks = {
    'Constant' : new Constant(value: 1),
    'Transfer' : new TransferFcn(nums: [1], dens: [1, 1]),
    'Constant1' : new Constant(value: 2),
    'Transfer1' : new TransferFcn(nums: [2], dens: [1, 1]),
    'Constant2' : new Constant(value: 2),
    'Transfer2' : new TransferFcn(nums: [2], dens: [1, 1]),
    'Constant3' : new Constant(value: 2),
    'Transfer3' : new TransferFcn(nums: [2], dens: [1, 1]),
  };

  static Map<String, dynamic> constants = {
    'PI' : 3.14,
  };
}