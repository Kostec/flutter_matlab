import 'Block.dart';
import 'package:fluttermatlab/other/enums.dart';


class BlockIO{
  String name;
  int num;
  IOtype type;
  double value;
  BlockIO connectedTo;
  BlockIO({this.name = 'IO'});
  void disconnect() {}
}

class PortInput extends BlockIO{
  IOtype type = IOtype.input;
  PortInput({num, name = 'In'}){
    this.num = num;
    this.name = name;
  }

  void connect(PortOutput portOutput){
    if (connectedTo != portOutput){
      connectedTo = portOutput;
      portOutput.connect(this);
    }
    else print('Уже подключено');
  }

  @override
  void disconnect(){
    if (connectedTo != null){
      PortOutput portOutput = connectedTo;
      connectedTo = null;
      portOutput.disconnectPort(this);
    }
  }
}

class PortOutput extends BlockIO{
  IOtype type = IOtype.output;
  @override
  PortOutput({num, name = 'Out'}){
    this.num = num;
    this.name = name;
  }

  List<PortInput> connections = [];

  void connect(PortInput portIntput){
    if (portIntput.connectedTo != null) return;
    if (!connections.contains(portIntput)){
      connections.add(portIntput);
      portIntput.connect(this);
    }
  }

  void disconnectPort(PortInput portInput){
    var input = connections.firstWhere((element) => element == portInput, orElse: null);
    if (input != null){
      if (input.connectedTo != this) {
        connections.remove(input);
        input.disconnect();
      }
    }
  }

  @override
  void disconnect(){

  }

  void setValue(double value){
    this.value = value;
    connections.forEach((element) {
      element.value = value;
    });
  }
}