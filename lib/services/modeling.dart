import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/services/workspace.dart';

typedef TimeChangeCallback = Function(double currentTime, double startTime, double endTime);

/// Класс предназначен для выполения моделирования
class Solver{
  double T = 1e-3;
  double startTime = 0.0;
  double endTime = 5.0;
  double _modelingTime = 0;

  double get ModelingTime => _modelingTime;

  TimeChangeCallback onTimeChange;

  set ModelingTime(value){
    _modelingTime = value;
    if (onTimeChange != null){
      onTimeChange(value, startTime, endTime);
    }
  }

  List<Block> model;

  /// Делает один шаг моделирования TODO: нужен тип для моделирования (блок)
  void step(double nowTime, double nowValue){
    if (nowTime == endTime){
      evaluate(model);
      stop();
      return;
    }
  }

  void start_evaluate() async {
    ModelingTime = startTime;
    workspace.selectedMathModel.mathModel.blocks.forEach((element) => element.resetState());
    evaluate(workspace.selectedMathModel.mathModel.blocks);
  }

  /// Выполняет полное решение системы
  void evaluate(List<Block> blocks) {
    if (ModelingTime == startTime) {
      blocks.forEach((block) {
        block.resetState();
      });
      first_evaluate(blocks);
    }
    else {
      blocks.forEach((block) {
        block.evaluate(T);
      });
      var next = getNext(blocks);
      if (next.length != 0) evaluate(next);
    }
  }

  void first_evaluate(List<Block> blocks){
    // поиск источников сигнала (они не имеют входов)
    var inputs = blocks.where((element) => element.Inputs.length == 0).toList();
    inputs.forEach((input) {
      input.evaluate(T);
      List<Block> outs = [];
      input.Outputs.forEach((io) {
        var out = io as PortOutput;
        out.connections.forEach((connection) {
          var temp = workspace.selectedMathModel.mathModel.blocks.where((block) => block.Inputs.contains(connection));
          outs.addAll(temp);
        });
      });
      ModelingTime += T;
      print('modeling time: $ModelingTime');
      evaluate(outs);
    });
    if (ModelingTime <= endTime)
      first_evaluate(blocks);
    else
      print('end modeling');
  }

  List<Block> getNext(List<Block> blocks){
    List<Block> res = [];
    blocks.forEach((block) {
      block.Outputs.forEach((io) {
        var out = io as PortOutput;
        out.connections.forEach((connection) {
          var temp = workspace.selectedMathModel.mathModel.blocks.where((block) => block.Inputs.contains(connection));
          res.addAll(temp);
        });
      });
    });
    return res;
  }

  ///Останавливает моделирование TODO
  void stop(){

  }
}
