import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

/// Класс предназначен для выполения моделирования
class Solver{
  double T = 1e-6;
  double startTime = 0.0;
  double endTime = 10.0;
  double modelingTime = 0;

  /// Делает один шаг моделирования TODO: нужен тип для моделирования (блок)
  void step(double nowTime, double nowValue){
    if (nowTime == endTime){
      stop();
      return;
    }
  }

  /// Выполняет полное решение системы
  void evaluate(List<Block> blocks)
  {
    var inputs = blocks.where((block) => block.numInput == 0).toList();
    for (int i = 0; i < inputs.length; i++)
    {
      var nextBlocks = blocks.where((block) => block.IO.contains(inputs[i]))?.toList();
      nextBlocks.forEach((block) {
        if (block.time != modelingTime) {
          var temp = block.IO.where((element) => element.type == IOtype.input && element.blockIn.time == modelingTime);
          if (temp.toList().length == block.IO.length) {
            block.evaluate(T);
          }
        }
      });
    }
  }

  ///Останавливает моделирование TODO
  void stop(){

  }
}