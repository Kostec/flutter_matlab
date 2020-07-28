import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/services/modeling.dart';
import 'package:fluttermatlab/widgets/block.dart';
import 'package:fluttermatlab/widgets/menu.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ModelPage extends StatefulWidget{

  @override
  State createState() => _ModelPageState();
    static void OpenPage(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ModelPage()));
  }
}

class _ModelPageState extends State<ModelPage>{
  Path path;
  Paint paint;
  Canvas canvas;

  double width = 2048;
  double heigh = 2048;

  List<Block> blocks = [];

  List<BlockWidget> blockWidgets = [];

  Map<String, Function> moreItems;

  @override
  void initState() {
    blocks.add(new Constant(value: 3));
    blocks.add(new TransferFcn(nums: [1], dens: [1,1]));

    double countX = 20;
    double countY = 20;

    blocks.forEach((block) {
      blockWidgets.add(BlockWidget(x: countX, y: countY, block: block));
      countX += 150;
    });

    Solver solver = new Solver();
  }

  @override
  Widget build(BuildContext context) {
    var drawer = Menu();
    var appBar = _buildAppBar();
    var body = _buildBody();
    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  AppBar _buildAppBar(){
    moreItems = {
      'Новыя модель' : newModel,
      'Добавить блок' : addBlock,
      'Сохранить' : save,
      'Загрузить' : load,
      'Настройки' : settings,
      'Выход': exit,
    };
    return AppBar(
      title: Text('Model'),
      actions: [
        PopupMenuButton(
          onSelected: (value) => {moreItems[value]()},
          itemBuilder: (BuildContext context) {
            return moreItems.keys.map((choise) {
              return PopupMenuItem<String>(
                value: choise,
                child: Text(choise),
              );
            }).toList();
          }
        )
      ],
    );
  }

  Widget _buildBody(){
    return Zoom(
      width: width,
      height: heigh,
      doubleTapZoom: true,
      enableScroll: true,
      child: Stack(children: blockWidgets,),
    );
  }

  void exit(){
    print('Вы выходите из приложения');
  }
  void settings(){
    print('Настройки приложения');
  }
  void save(){
    print('Сохранить можель');
  }
  void load(){
    print('Загрузить модель');
  }
  void newModel(){
    print('Создать новую модель');
  }
  void addBlock(){
    print('Добавить новый блок');
  }
}