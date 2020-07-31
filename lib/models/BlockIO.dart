import 'Block.dart';

enum IOtype { input, output }

class BlockIO{
  String name;
  IOtype type;
  Block blockIn;
  Block blockOut;
  double value;
  int numOut;
  int numIn;
  BlockIO Output;
  BlockIO Input;
  BlockIO({this.blockOut, this.blockIn, this.numOut, this.numIn, this.name = 'IO'});
}

class PortInput extends BlockIO{
  @override
  String name;
  @override
  IOtype type = IOtype.input;
  @override
  Block blockIn;
  @override
  Block blockOut;
  @override
  int numIn;
  @override
  int numOut;
  PortInput({this.blockOut, this.blockIn, this.numOut, this.numIn, this.name = 'In'});
}

class PortOutput extends BlockIO{
  @override
  String name;
  @override
  IOtype type = IOtype.output;
  @override
  Block blockIn;
  @override
  Block blockOut;
  @override
  int numIn;
  @override
  int numOut;
  @override
  PortOutput({this.blockOut, this.blockIn, this.numOut, this.numIn, this.name = 'Out'});
}