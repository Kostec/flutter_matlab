import 'Block.dart';

enum IOtype { input, output }

class BlockIO{
  String name;
  int num;
  IOtype type;
  double value;
  BlockIO connectedTo;
  BlockIO({this.name = 'IO'});
}

class PortInput extends BlockIO{
  @override
  String name;
  @override
  int num;
  IOtype type = IOtype.input;
  PortInput({this.num, this.name = 'In'});
}

class PortOutput extends BlockIO{
  @override
  String name;
  @override
  int num;
  IOtype type = IOtype.output;
  @override
  PortOutput({this.num, this.name = 'Out'});
}