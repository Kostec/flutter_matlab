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
      IO.add(PortInput(blockOut: null, blockIn: this, numOut: null, numIn: i));
    }
    for(int i = 0; i < numOut; i++){
      IO.add(PortOutput(blockOut: this, blockIn: null, numOut: i, numIn: null));
    }
  }

  @override
  String toString() {
    return this.runtimeType.toString();
  }

  void addInput(Block blockOut, int portIn, int portOut){
    var blockIn = this;
    if (blockIn.numIn < portIn || blockOut.numOut < portOut){
      print ('Не удалось соединить порты');
      return;
    }
    var input = new PortInput(blockIn: this, blockOut: blockOut, numIn: portIn, numOut: portOut);
    var output = new PortOutput(blockIn: this, blockOut: blockOut, numIn: portIn, numOut: portOut);
    input.Input = input;
    input.Output = output;
    output.Input = input;
    output.Output = output;
    var inputs = Inputs;
    var checkIn = inputs.length > 0 ? inputs.firstWhere((element) => element.blockOut== blockOut && element.blockIn == blockIn && numIn == portIn && numOut == portOut) : null;
    if (checkIn == null) this.IO.add(input);
    var out_outputs = blockOut.Outputs;
    var checkOut = out_outputs.length > 0 ? out_outputs.firstWhere((element) => element.blockOut== blockOut && element.blockIn == blockIn && numIn == portIn && numOut == portOut) : null;
    if (checkOut == null) blockOut.IO.add(output);
  }

  void addOutput(Block blockIn, int portIn, int portOut){
    var blockOut = this;
    if (blockIn.numIn < portIn || blockOut.numOut < portOut){
      print ('Не удалось соединить порты');
      return;
    }
    var input = new PortInput(blockIn: blockIn, blockOut: this, numIn: portIn, numOut: portOut);
    var output = new PortOutput(blockIn: blockIn, blockOut: this, numIn: portIn, numOut: portOut);
    input.Input = input;
    input.Output = output;
    output.Output = output;
    output.Input = input;
    var outputs = Outputs;
    var checkOut = outputs.length > 0 ? outputs.firstWhere((element) => element.blockOut== blockOut && element.blockIn == blockIn && numIn == portIn && numOut == portOut, orElse: null) : null;
    if (checkOut == null)this.IO.add(output);
    var out_inputs = blockIn.Inputs;
    var checkIn = out_inputs.length > 0 ? out_inputs.firstWhere((element) => element.blockOut== blockOut && element.blockIn == blockIn && numIn == portIn && numOut == portOut, orElse: null) : null;
    if (checkIn == null) blockIn.IO.add(input);
  }

  void removeInput(PortInput portIn){
    if (IO.contains(portIn)){
      IO.remove(portIn);
      var out_io = portIn.blockOut.IO;
      var port = out_io.length > 0 ? out_io.firstWhere((element) => element.Input == portIn, orElse: null) : null;
      if (port != null) portIn.blockOut.removeOutput(port);
    }
  }

  void removeOutput(PortOutput portOut){
    if (IO.contains(portOut)){
      IO.remove(portOut);
      var out_io = portOut.blockIn.IO;
      var port = out_io.length > 0 ? out_io.firstWhere((element) => element.Output == portOut, orElse: null) : null;
      if (port != null) portOut.blockIn.removeInput(port);
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