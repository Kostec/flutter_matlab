import 'Block.dart';

enum IOtype { input, output }

class BlockIO{
  IOtype type;
  Block blockIn;
  Block blockOut;
  double value;
  int numOut;
  int numIn;
  BlockIO Output;
  BlockIO Input;
  BlockIO({this.blockOut, this.blockIn, this.numOut, this.numIn});
}

class PortInput extends BlockIO{
  IOtype type = IOtype.input;
  Block blockIn;
  Block blockOut;
  int numIn;
  int numOut;
  PortInput({this.blockOut, this.blockIn, this.numOut, this.numIn});
}

class PortOutput extends BlockIO{
  IOtype type = IOtype.output;
  Block blockIn;
  Block blockOut;
  int numIn;
  int numOut;
  PortOutput({this.blockOut, this.blockIn, this.numOut, this.numIn});
}