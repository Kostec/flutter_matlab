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
import 'package:fluttermatlab/other/enums.dart';

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

  double scaleX = 1;
  double scaleY = 1;

  Offset zoomOffset = Offset.zero;

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
    (constant.Outputs[0] as PortOutput).connect(integrator.Inputs[0]);

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
    workspace.selectedMathModel.blockWidgets.forEach((block){
      blocks.add(block);
      block.inputs.forEach((io) {
        (io as IOWidget).gestureCallback = BlockGestureCallback;
      });
      block.outputs.forEach((io) {
        (io as IOWidget).gestureCallback = BlockGestureCallback;
      });
    });

    if (_builded) _buildLines();
    stackChild = [];
    stackChild.addAll(lines);
    stackChild.addAll(blocks);

    return GestureDetector(
      onTapDown: (details) => print('OnTap'),
      child: Zoom(
        width: width,
        height: heigh,
        doubleTapZoom: true,
        enableScroll: true,
        onScaleUpdate: (x,y){
          scaleX = x;
          scaleY = y;
          print('scale: $x, $y');
        },
        onPositionUpdate: (offset){
          zoomOffset = offset;
          print('position: ${offset.dx}, ${offset.dy}');
        },
        child: Stack(key: bodyKey, children: stackChild,),
    ));
  }

  void _buildLines(){
    lines = [];
    workspace.selectedMathModel.blockWidgets.forEach((blockWidget) {
      blockWidget.block.Inputs.forEach((inputIO) {
        var output = workspace.selectedMathModel.blockWidgets.firstWhere( (w) => w.block.Outputs.contains(inputIO.connectedTo), orElse: () => null);
        if (output != null){
          IOWidget inputIOWidget = blockWidget.inputs.firstWhere((i) => (i as IOWidget).io == inputIO, orElse: () => null);
          IOWidget outputIOWidget = output.outputs.firstWhere((o) => (o as IOWidget).io == inputIO.connectedTo, orElse: () => null);
          if (inputIOWidget != null && outputIOWidget != null) {
            if (inputIOWidget.context != null && outputIOWidget.context != null) {
              RenderBox inputIOBox = inputIOWidget.context.findRenderObject() as RenderBox;
              RenderBox inputRenderBox = blockWidget.context.findRenderObject() as RenderBox;

              RenderBox outputIOBox = outputIOWidget.context.findRenderObject() as RenderBox;
              RenderBox outputRenderBox = output.context.findRenderObject() as RenderBox;

              double inX = blockWidget.x/2 + inputIOBox.size.width/4;
              double inY = blockWidget.y/2 + inputRenderBox.size.height/4 - inputIOBox.size.height/4;
              double outX = output.x/2 + outputRenderBox.size.width/2 - outputIOBox.size.width/4;
              double outY = output.y/2 + outputRenderBox.size.height/4 - outputIOBox.size.height/4;

              AddLine(inX, inY, outX, outY);
              AddLine(outX, outY, inX, inY);

              print('input: ${blockWidget.x}, ${blockWidget.y}');
            }
            else{
              print("inputWidget: ${inputIOWidget.context != null}, outputWidget: ${outputIOWidget.context != null}");
            }
          }
        }
      });
    });
  }

  void AddLine(double start_x, double start_y, double end_x, double end_y){
    lines.add(Positioned(top: start_y, left: start_x,child: CustomPaint(painter: MyPainter(start_x, start_y, end_x, end_y),)));
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

  void BlockGestureCallback(BlockIO blockIO, GestureEnum gestureEnum){
    switch(gestureEnum){
      case GestureEnum.tap:
        if (LastTappedIO != null){
          if (blockIO.type != LastTappedIO.type){
            if (blockIO.type == IOtype.output){
              (blockIO as PortOutput).connect(LastTappedIO);
              setState(() {});
            }
            else if (LastTappedIO.type == IOtype.output) {
              (LastTappedIO as PortOutput).connect(blockIO);
              setState(() {});
            }
            LastTappedIO == null;
          }
        }
        else LastTappedIO = blockIO;
        break;
      case GestureEnum.double_tap: break;
      case GestureEnum.long_press: break;
    }
  }

  BlockIO LastTappedIO;

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
