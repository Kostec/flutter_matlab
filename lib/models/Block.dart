class Block {
  String name;
  Block({this.name = 'Block'});

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
}