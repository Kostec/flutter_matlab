import 'package:fluttermatlab/models/MathModel.dart';

/// класс предназначен для хранения переменных рабочей среды программы
class workspace{
  static Map<String, dynamic> variables = {};
  static List<MathModel> mathModels = [];
  /// Очищает список переменных
  static clear(){
    variables.clear();
  }
  /// Добавляет переменную в рабочую область
  static void addVariable(String name, dynamic value){
    variables[name] = value;
  }
  /// Добавляет список переменных в рабочую область
  static void addVariableRange(Map<String, dynamic> vars){
    variables.addAll(vars);
  }
  /// Удаляет переменную из рабочей области
  static void removeVariable(String name){
    variables.remove(name);
  }
  /// Удаляет список переменных из рабочей области
  static void removeVariableRange(List<String> vars){
    vars.forEach((v){
      variables.remove(v);
    });
  }

}