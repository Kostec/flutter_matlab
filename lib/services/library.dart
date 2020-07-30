
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/Derivative.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/models/Integrator.dart';

class Library
{
  static Map<String, Block> blocks = {
      'Constant': new Constant(value: 1),
      'Transfer': new TransferFcn(nums: [1], dens: [1, 1]),
      'Integrator': new Integrator(coef: 1),
      'Derivative': new Derivative(),
  };

  static Map<String, dynamic> constants = {
    'PI' : 3.14,
  };
}