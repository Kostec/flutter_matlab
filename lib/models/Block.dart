abstract class Block {
  String name;
  Block({this.name = 'Block'});
  List<double> input;
  List<double> output;

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

  List<double> evaluate();
}