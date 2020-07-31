import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';

/// Класс предназначен для выполения моделирования
class Solver{
  double T = 1e-6;
  double startTime = 0.0;
  double endTime = 10.0;
  double modelingTime = 0;
  List<Block> model;

  /// Делает один шаг моделирования TODO: нужен тип для моделирования (блок)
  void step(double nowTime, double nowValue){
    if (nowTime == endTime){
      evaluate(model);
      stop();
      return;
    }
  }

  /// Выполняет полное решение системы
  void evaluate(List<Block> blocks)
  {
//    var inputs = blocks.where((element) => element.Outputs == null).toList();
//    inputs.forEach((element) {
//      element.IO.forEach((port) {
//        port.Input.value = port.value;
//        if (port.blockIn.numIn == 1) port.blockIn.evaluate(T);
//      });
//    });
  }

  ///Останавливает моделирование TODO
  void stop(){

  }
}
