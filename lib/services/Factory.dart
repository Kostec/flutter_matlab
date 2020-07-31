import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/Derivative.dart';
import 'package:fluttermatlab/models/Integrator.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';

class Factory{
  Block CreateBlock(Type type, String name){
    Block block;
    switch (type){
      case Constant: block = Constant(name: name); break;
      case TransferFcn: block = TransferFcn(nums: [1], dens: [1,1],name: name); break;
      case Derivative: block = Derivative(name: name); break;
      case Integrator: block = Integrator(coef: 1, name: name); break;
    }
    return block;
  }

}