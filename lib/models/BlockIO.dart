import 'package:fluttermatlab/other/enums.dart';

typedef PortIOCallback = Function(PortIO io);

abstract class PortIO{
  String name;
  int num;
  IOtype type;
  double value;
  PortIO connectedTo;
  PortIO({this.name = 'IO'});
  void disconnect() {}

  PortIOCallback onDisconnect = (io) => {};
  PortIOCallback onConnect = (io) => {};
}

class PortInput extends PortIO{
  IOtype type = IOtype.input;
  PortInput({num, name = 'In'}){
    this.num = num;
    this.name = name;
  }

  void connect(PortOutput portOutput){
    if (connectedTo != portOutput){
      connectedTo = portOutput;
      portOutput.connect(this);
      onConnect(this);
    }
    else print('Уже подключено');
  }

  @override
  void disconnect(){
    if (connectedTo != null){
      PortOutput portOutput = connectedTo;
      connectedTo = null;
      portOutput.disconnectPort(this);
      onDisconnect(this);
    }
  }
}

class PortOutput extends PortIO{
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
      onConnect(this);
    }
  }

  void disconnectPort(PortInput portInput){
    var input = connections.firstWhere((element) => element == portInput, orElse: null);
    if (input != null){
      if (input.connectedTo != this) {
        connections.remove(input);
        input.disconnect();
        onConnect(this);
      }
    }
  }

  @override
  void disconnect(){
    onDisconnect(this);
  }

  void setValue(double value){
    this.value = value;
    connections.forEach((element) {
      element.value = value;
    });
  }
}