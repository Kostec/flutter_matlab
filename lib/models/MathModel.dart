import 'package:flutter/cupertino.dart';
import 'package:fluttermatlab/services/modeling.dart';
import 'package:fluttermatlab/widgets/block.dart';

import 'Block.dart';

class MathModel{
  List<Block> blocks;
  MathModel({ this.blocks}){
    this.blocks = this.blocks ?? [];
  }
  void Solve(){
    Solver solver = Solver();
    solver.evaluate(blocks);
  }
  void addBlock(Block block){
    blocks.add(block);
  }
  void removeBlock(Block block){
    block.Inputs.forEach((input) {
      block.removeInput(input);
    });

    block.Outputs.forEach((output) {
      block.removeInput(output);
    });
    blocks.remove(block);
  }
}

class ViewMathModel{
  MathModel mathModel;
  List<PositionedBlockWidget> blockWidgets;
  String name;
  ViewMathModel({this.mathModel, this.name = "Model"}){
    this.mathModel = this.mathModel ?? new MathModel();
    blockWidgets = [];
  }

  void addBlockWidget(PositionedBlockWidget blockWidget){
    blockWidgets.add(blockWidget);
    mathModel.blocks.add(blockWidget.block);
  }


}

