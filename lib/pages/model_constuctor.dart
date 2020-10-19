import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
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
  final GlobalKey bodyKey = GlobalKey();

  double width = 2048;
  double heigh = 2048;

  Map<String, Function> moreItems;

  List<Widget> lines = [];
  List<Widget> blocks = [];
  List<Widget> stackChild = [];

  bool _builded = false;

  @override
  void initState() {
    workspace.selectedMathModel = workspace.selectedMathModel ?? createTestModel();
    createTestModel();
    addEvents();

    SchedulerBinding.instance.addPostFrameCallback((_){
      _builded = true;
      _buildLines();
      setState(() {

      });
    });

  }

  ViewMathModel createTestModel(){
    ViewMathModel model = new ViewMathModel();
    model = new ViewMathModel();
    List<Block> blocks = [];

    var constant = new Constant(value: 3);
    var transfer = new TransferFcn(nums: [1], dens: [1,1]);
    var integrator = new Integrator(coef: 2.1);

    blocks.add(constant);
    blocks.add(transfer);
    blocks.add(integrator);
    double countX = 20;
    double countY = 20;

    (constant.Outputs[0] as PortOutput).connect(transfer.Inputs[0]);
//    (constant.Outputs[0] as PortOutput).connect(integrator.Inputs[0]);

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
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: (){
            workspace.selectedMathModel.mathModel.Solve();
          },
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
    blocks = [];
    workspace.selectedMathModel.blockWidgets.forEach((element) => blocks.add(element));
    if (_builded) _buildLines();
    stackChild = [];
    stackChild.addAll(blocks);
    stackChild.addAll(lines);

    return GestureDetector(
      onTapDown: (details) => print('OnTap'),
      child: Zoom(
        key: bodyKey,
        width: width,
        height: heigh,
        doubleTapZoom: true,
        enableScroll: true,
        child: Stack(children: stackChild,),
    ));
  }

  void _buildLines(){
    lines = [];
    workspace.selectedMathModel.blockWidgets.forEach((blockWidget) {
      blockWidget.block.Inputs.forEach((input) {
        var output = workspace.selectedMathModel.blockWidgets.firstWhere( (w) => w.block.Outputs.contains(input.connectedTo), orElse: () => null);
        if (output != null){

          IOWidget inputWidget = blockWidget.inputs.firstWhere((i) => (i as IOWidget).io == input, orElse: () => null);
          IOWidget outputWidget = output.outputs.firstWhere((o) => (o as IOWidget).io == input.connectedTo, orElse: () => null);

          if (inputWidget != null && outputWidget != null) {
            if (inputWidget.context != null && outputWidget.context != null) {
              RenderBox inputBox = inputWidget.context.findRenderObject() as RenderBox;
              RenderBox outpuBox = outputWidget.context.findRenderObject() as RenderBox;

              var thisBox = bodyKey.currentContext.findRenderObject() as RenderBox;
              Offset thisOffset = thisBox.localToGlobal(Offset.zero);
              print('this: ${thisOffset.dx}, ${thisOffset.dy}');

              var outputWidgetRB = output.context.findRenderObject() as RenderBox;
              var outSize = outputWidgetRB.size;
              var oOffset = outputWidgetRB.localToGlobal(Offset(-thisOffset.dx, -thisOffset.dy));

              var inputWidgetRB = blockWidget.context.findRenderObject() as RenderBox;
              var inSize = inputWidgetRB.size;
              var iOffset = outputWidgetRB.localToGlobal(Offset(-thisOffset.dx, -thisOffset.dy));

              Offset inOffset = Offset(-35, -105);
              Offset outOffset = Offset(-thisOffset.dx, -thisOffset.dy);

              Offset inputOffset = inputBox.localToGlobal(Offset.zero);
              Offset outputOffset = outpuBox.localToGlobal(outOffset);

//              AddLine(inputOffset.dx, inputOffset.dy, outputOffset.dx, outputOffset.dy);
              AddLine(inputOffset.dx, inputOffset.dy, inputOffset.dx - 10, inputOffset.dy);

              print('input: ${inputOffset.dx}, ${inputOffset.dy}, output: ${outputOffset.dx}, ${outputOffset.dy}');
            }
            else{
              print("inputWidget: ${inputWidget.context != null}, outputWidget: ${outputWidget.context != null}");
            }
          }
        }
      });
    });
  }

  void AddLine(double start_x, double start_y, double end_x, double end_y){
    lines.add(Positioned(top: start_y, left: start_x,child: CustomPaint(size: Size(0,0), painter: MyPainter(start_x, start_y, end_x, end_y),)));
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
