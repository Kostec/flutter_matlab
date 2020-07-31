import 'package:flutter/cupertino.dart';

import 'BlockIO.dart';

abstract class Block {
  int numOut = 0;
  int numIn = 0;
  String name;
  Block({this.name = 'Block'});
  List<BlockIO> IO = [];
  double time = 0;
  Map<double, List<double>> state;

  List<BlockIO> get Inputs{
    return IO.where((io) => io.type == IOtype.input).toList();
  }

  List<BlockIO> get Outputs{
    return IO.where((io) => io.type == IOtype.output).toList();
  }

  void setDefaultIO(){
    for(int i = 0; i < numIn; i++){
      IO.add(PortInput(num: i));
    }
    for(int i = 0; i < numOut; i++){
      IO.add(PortOutput(num: i));
    }
  }

  @override
  String toString() {
    return this.runtimeType.toString();
  }

  void addInput(Block connectTo, int portIn, int portOut){
    var blockIn = this;
    if (blockIn.numIn < portIn || connectTo.numOut < portOut){
      print ('Не удалось соединить порты');
      return;
    }
  }

  void addOutput(Block blockIn, int portIn, int portOut){
    var blockOut = this;
    if (blockIn.numIn < portIn || blockOut.numOut < portOut){
      print ('Не удалось соединить порты');
      return;
    }
  }

  void removeInput(PortInput portIn){
    if (IO.contains(portIn)){
      IO.remove(portIn);
    }
  }

  void removeOutput(PortOutput portOut){
    if (IO.contains(portOut)){
      IO.remove(portOut);
    }
  }

  Map<String, dynamic> getPreference(){
    return {'name': name};
  }

  void setPreference(Map<String, dynamic> preference){
    name = preference['name'];
  }

  List<String> getDisplay() {
    return [this.name];
  }

  List<double> evaluate(double T){
    time += T;
  }
}