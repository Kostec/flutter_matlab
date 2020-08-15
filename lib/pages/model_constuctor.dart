import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/models/Constant.dart';
import 'package:fluttermatlab/models/Derivative.dart';
import 'package:fluttermatlab/models/Integrator.dart';
import 'package:fluttermatlab/models/MathModel.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/services/Factory.dart';
import 'package:fluttermatlab/services/library.dart';
import 'package:fluttermatlab/services/modeling.dart';
import 'package:fluttermatlab/services/workspace.dart';
import 'package:fluttermatlab/widgets/block.dart';
import 'package:fluttermatlab/widgets/io.dart';
import 'package:fluttermatlab/widgets/menu.dart';
import 'package:fluttermatlab/widgets/line.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ModelPage extends StatefulWidget{
  _ModelPageState _instance;
  @override
  State createState() {
    if (_instance == null) _instance = _ModelPageState();
    return _instance;
  }

  static void OpenPage(BuildContext context) async{
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ModelPage()));
  }
}

class _ModelPageState extends State<ModelPage>{

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Path path;
  Paint paint;
  Canvas canvas;

  double width = 2048;
  double heigh = 2048;

  Map<String, Function> moreItems;

  @override
  void initState() {
    workspace.selectedMathModel = workspace.selectedMathModel ?? createTestModel();
    createTestModel();
    addEvents();
  }

  ViewMathModel createTestModel(){
    ViewMathModel model = new ViewMathModel();
    model = new ViewMathModel();
    List<Block> blocks = [];

    var constant = new Constant(value: 3);
    var transfer = new TransferFcn(nums: [1], dens: [1,1]);
    var integrator = new Integrator(coef: 2.1);
    var derivative = new Derivative();

    blocks.add(constant);
    blocks.add(transfer);
    blocks.add(integrator);
    blocks.add(derivative);
    double countX = 20;
    double countY = 20;

    (constant.Outputs[0] as PortOutput).connect(transfer.Inputs[0]);
    (transfer.Outputs[0] as PortOutput).connect(integrator.Inputs[0]);
    (constant.Outputs[0] as PortOutput).connect(derivative.Inputs[0]);

    blocks.forEach((block) {
      workspace.selectedMathModel.addBlockWidget(PositionedBlockWidget(x: countX, y: countY, block: block));
      countX += 150;
    });
    return model;
  }

  @override
  Widget build(BuildContext context) {
    var _drawer = MainMenu.menu;
    var _appBar = _buildAppBar();
    var _body = _buildBody();
    return PageView(
      children: [
        Scaffold(
          key: scaffoldKey,
          drawer: _drawer,
          appBar: _appBar,
          body: _body,
          floatingActionButton: FloatingActionButton(
            tooltip: 'Increment',
            child: Icon(Icons.add),
            onPressed: (){
              addBlock();
//              scaffoldKey.currentState.showBottomSheet((context) => Container(height: 200, child: Text('Text'),));
            },
          ),
    )]);
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
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: (){setState((){});},
        ),
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
    var widgets = workspace.selectedMathModel.blockWidgets;

    List<Widget> child = [];
    workspace.selectedMathModel.blockWidgets.forEach((element) {
      child.add(element);
    });

    for(int i = 0; i < widgets.length; i++)
    {
      widgets[i].block.Inputs.forEach((element) {
        var cl = widgets.firstWhere( (w) => w.block.Outputs.contains(element.connectedTo), orElse: () => null);
        if (cl != null){
          var y =  cl.y -  widgets[i].y;
          var x =  cl.x -  widgets[i].x;
          child.add(Positioned(top: widgets[i].y, left: widgets[i].x,child: CustomPaint(size: Size(0,0), painter: MyPainter(30, 25, x, y),)));
        }
      });
    }

    return GestureDetector(
      onTapDown: (details) => print('OnTap'),
      child: Zoom(
        width: width,
        height: heigh,
        doubleTapZoom: true,
        enableScroll: true,
        child: Stack(children: child,),
    ));
  }

  void showAddBlockDialog(BuildContext context) {
    scaffoldKey.currentState.showBottomSheet((context){
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)), color: Colors.grey),
        height: 200,
        child: ListView.builder(
          itemCount: Library.blocks.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            var key = Library.blocks.keys.toList()[index];
            var block = Library.blocks[key];
            var widget = BlockWidget(block: block);
            var type = block.runtimeType;
            return GestureDetector(
              onTap: (){
                Factory factory = Factory();
                var count =  workspace.selectedMathModel.mathModel.blocks.where((element) => element.runtimeType == type).length;
                var name = '${block.toString()}_$count';
                workspace.selectedMathModel.addBlockWidget(PositionedBlockWidget(x: 20, y: 20, block: factory.CreateBlock(type, name)));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: widget,
            ));
          },
        )
      );
    });
  }

  void addEvents(){
    workspace.selectedMathModel.removeBlockCallback.add(BlockWasRemoved);
    workspace.selectedMathModel.addBlockCallback.add(BlockWasAdded);
  }

  void RemoveEvents(){
    workspace.selectedMathModel.removeBlockCallback.remove(BlockWasRemoved);
    workspace.selectedMathModel.addBlockCallback.remove(BlockWasAdded);
  }

  void BlockWasRemoved(PositionedBlockWidget blockWidget){
    print('main remove block');
    setState(() { });
  }
  void BlockWasAdded(PositionedBlockWidget blockWidget){
    print('main add block');
    setState(() { });
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
    RemoveEvents();
    workspace.selectedMathModel = new ViewMathModel();
    addEvents();
    setState((){});
  }
  void addBlock(){
    showAddBlockDialog(context);
    setState(() {});
  }

  @override
  void dispose() {
    print('dispose');
    RemoveEvents();
  }
}
