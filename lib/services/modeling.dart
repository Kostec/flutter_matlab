/// Класс предназначен для выполения моделирования
class solver{
  double T = 1e-6;
  double startTime = 0.0;
  double endTime = 10.0;

  /// Делает один шаг моделирования TODO: нужен тип для моделирования (блок)
  void step(double nowTime, double nowValue){
    if (nowTime == endTime){
      stop();
      return;
    }
  }

  /// Решатель, выполняет полное моделирование TODO
  void sove(){

  }

  ///Останавливает моделирование TODO
  void stop(){

  }
}