import 'package:fluttermatlab/services/modeling.dart';
import 'package:fluttermatlab/services/workspace.dart';
import 'package:fluttermatlab/widgets/block.dart';

import 'Block.dart';

class MathModel{

  TimeChangeCallback onTimeChange;

  Solver solver;

  List<Block> blocks;
  MathModel({ this.blocks}){
    this.blocks = this.blocks ?? [];
  }
  Future<void> Solve() async {
    solver = Solver();
    solver.onTimeChange = onTimeChange;
    solver.start_evaluate();
  }
  void addBlock(Block block){
    blocks.add(block);
  }
  void removeBlock(Block block){
    blocks.remove(block);
    print('was removed ${block.name}');
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

  List<Function(PositionedBlockWidget)> removeBlockCallback = [];
  List<Function(PositionedBlockWidget)> addBlockCallback = [];

  void addBlockWidget(PositionedBlockWidget blockWidget){
    blockWidgets.add(blockWidget);
    mathModel.blocks.add(blockWidget.block);
    if (this == workspace.selectedMathModel) addBlockCallback.forEach((element) { element(blockWidget); });
  }
  void removeBlockWidget(PositionedBlockWidget blockWidget){
    print('will be removed ${blockWidget.block.name}');
    if (blockWidgets.contains(blockWidget)) blockWidgets.remove(blockWidget);
    if (mathModel.blocks.contains(blockWidget.block)) mathModel.removeBlock(blockWidget.block);
    print('endRemove');
    if (this == workspace.selectedMathModel) removeBlockCallback.forEach((element) { element(blockWidget); });
  }
  void removeBlock(Block block){
    var widget = blockWidgets.firstWhere((element) => element.block == block, orElse: null);
    if (widget != null) removeBlockWidget(widget);
  }
}

