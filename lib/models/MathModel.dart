import 'package:flutter/cupertino.dart';
import 'package:fluttermatlab/services/modeling.dart';
import 'package:fluttermatlab/widgets/block.dart';

import 'Block.dart';

class MathModel{
  List<Block> blocks = [];
  List<BlockWidget> widgets = [];
  MathModel({@required this.blocks, @required this.widgets});

  void Solve(){
    Solver solver = Solver();
    solver.evaluate(blocks);
  }
}

