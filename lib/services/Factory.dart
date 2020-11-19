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

class Factory{
  Block CreateBlock(Type type, String name){
    Block block;
    switch (type){
      case Constant: block = Constant(name: name); break;
      case TransferFcn: block = TransferFcn(nums: [1], dens: [1,1],name: name); break;
      case Derivative: block = Derivative(name: name); break;
      case Integrator: block = Integrator(coef: 1, name: name); break;
      case Sum: block = Sum(); break;
      case Scope: block = Scope(); break;
      case Coef: block = Coef(); break;
      case Input: block = Input(); break;
      case Output: block = Output(); break;
    }
    return block;
  }

}