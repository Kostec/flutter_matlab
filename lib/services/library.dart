
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Blocks/Coef.dart';
import 'package:fluttermatlab/models/Blocks/Constant.dart';
import 'package:fluttermatlab/models/Blocks/Derivative.dart';
import 'package:fluttermatlab/models/Blocks/Integrator.dart';
import 'package:fluttermatlab/models/Blocks/Scope.dart';
import 'package:fluttermatlab/models/Blocks/Sum.dart';
import 'package:fluttermatlab/models/Blocks/TransferFcn.dart';
import 'package:fluttermatlab/models/Blocks/Input.dart';
import 'package:fluttermatlab/models/Blocks/Output.dart';

class Library
{
  static Map<String, Block> blocks = {
    'Constant': new Constant(value: 1),
    'Transfer': new TransferFcn(nums: [1], dens: [1, 1]),
    'Integrator': new Integrator(coef: 1),
    'Derivative': new Derivative(),
    'Sum': new Sum(operators: '++'),
    'Scope': new Scope(),
    'Coef': new Coef(),
    'Input': new Input(),
    'Output': new Output(),
  };

  static Map<String, dynamic> constants = {
    'PI' : 3.14,
  };
}