import 'BlockIO.dart';

abstract class Block {
  int numOutput = 0;
  int numInput = 0;
  String name;
  Block({this.name = 'Block'});
  List<BlockIO> IO;
  double time = 0;
  Map<double, List<double>> state;

  @override
  String toString() {
    return 'Block';
  }

  Map<String, dynamic> getPreference(){
    return {'name': name};
  }

  List<String> getDisplay() {
    return [this.name];
  }

  List<double> evaluate(double T){
    time += T;
  }
}