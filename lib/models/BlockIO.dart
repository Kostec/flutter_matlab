import 'Block.dart';

enum IOtype { input, output }

class BlockIO{
  IOtype type;
  Block block;
  double value;
  int num;
}