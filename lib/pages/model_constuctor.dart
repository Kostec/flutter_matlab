import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttermatlab/models/Block.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/models/Blocks/Constant.dart';
import 'package:fluttermatlab/models/Blocks/Integrator.dart';
import 'package:fluttermatlab/models/Blocks/MathModel.dart';
import 'package:fluttermatlab/models/Blocks/Scope.dart';
import 'package:fluttermatlab/models/Blocks/Sum.dart';
import 'package:fluttermatlab/models/Blocks/TransferFcn.dart';
import 'package:fluttermatlab/services/Factory.dart';
import 'package:fluttermatlab/services/library.dart';
import 'package:fluttermatlab/services/workspace.dart';
import 'package:fluttermatlab/widgets/block.dart';
import 'package:fluttermatlab/widgets/io.dart';
import 'package:fluttermatlab/widgets/menu.dart';
import 'package:fluttermatlab/widgets/line.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:fluttermatlab/other/enums.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ModelPage extends StatefulWidget{
  static bool first = true;
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
    if (ModelPage.first) {
      workspace.selectedMathModel = workspace.selectedMathModel ?? createTestModel();
      createTestModel();
      ModelPage.first = false;
    }
    addEvents();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _builded = true;
      _buildLines();
      _update();
    });


  }

  ViewMathModel createTestModel(){
    ViewMathModel model = new ViewMathModel();
    model = new ViewMathModel();
    List<Block> blocks = [];

    var constant = new Constant(value: 3);
    var transfer = new TransferFcn(nums: [1], dens: [1,1]);
    var integrator = new Integrator(coef: 2.1);
    var scope = new Scope(numIn: 2);
    var sum = new Sum(operators: '+-');


    blocks.add(constant);
    blocks.add(transfer);
    blocks.add(integrator);
    blocks.add(scope);
    blocks.add(sum);
    double countX = 20;
    double countY = 20;

//    (constant.Outputs[0] as PortOutput).connect(transfer.Inputs[0]);
//    (constant.Outputs[0] as PortOutput).connect(integrator.Inputs[0]);
//    (integrator.Outputs[0] as PortOutput).connect(scope.Inputs[0]);

    blocks.forEach((block) {
      workspace.selectedMathModel.addBlockWidget(PositionedBlockWidget(x: countX, y: countY, block: block));
      countX += 150;
    });

    return model;
  }

  int progressStep = 0;
  int totalStep = 100;
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
            },
          ),
    )]);
  }

  void _update() {
    setState((){});
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
          onPressed: _update,
        ),
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: () async {

            // Network.Get();

            print('start');
            progressStep = 0;
            print('progressStep: $progressStep');
            _update();

            workspace.selectedMathModel.mathModel.onTimeChange = (time, start, end) {
              int currentStep = (time/end * 100).toInt();
              if (currentStep != progressStep) {
                print('progressStep: $progressStep');
                setState(() { progressStep = currentStep; });
              }
              if (progressStep >= totalStep){
                Fluttertoast.showToast(msg: 'Solved', backgroundColor: Colors.green);
              }
            };

            print('solve start');
            workspace.selectedMathModel.mathModel.Solve();
            print('post solve');
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
      bottom: PreferredSize(
        preferredSize: Size(0,8),
        child : StepProgressIndicator(
          totalSteps: totalStep,
          currentStep: progressStep,
          size: 8,
          padding: 0,
          selectedColor: Colors.yellow,
          unselectedColor: Colors.cyan,
          roundedEdges: Radius.circular(10),
          selectedGradientColor: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.yellowAccent, Colors.deepOrange],
          ),
          unselectedGradientColor: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.blue],
          ),
        ),
      )
    );
  }

  Widget _buildBody(){
    blocks.clear();
    stackChild.clear();

    workspace.selectedMathModel.blockWidgets.forEach((block){
      blocks.add(block);
      block.positionChangedCallback = (x,y) => _update();
      block.inputs.forEach((io) {
        (io as IOWidget).onConnect = IOWidgetConnectOrDisconnectIO;
        (io as IOWidget).onDisconnect = IOWidgetConnectOrDisconnectIO;
        (io as IOWidget).gestureCallback = BlockGestureCallback;
      });
      block.outputs.forEach((io) {
        (io as IOWidget).onDisconnect = IOWidgetConnectOrDisconnectIO;
        (io as IOWidget).onConnect = IOWidgetConnectOrDisconnectIO;
        (io as IOWidget).gestureCallback = BlockGestureCallback;
      });
    });

    if (_builded) _buildLines();

    stackChild.addAll(lines);
    stackChild.addAll(blocks);

    return GestureDetector(
      onTapDown: (details) => {},
      child: Zoom(
        maxZoomWidth: width,
        maxZoomHeight: heigh,
        doubleTapZoom: true,
        enableScroll: true,
        onScaleUpdate: (x,y){
          scaleX = x;
          scaleY = y;
          if (_builded) _update();
        },
        onPositionUpdate: (offset){
          zoomOffset = offset;
          if (_builded) _update();
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

              int inputsCount = blockWidget.inputs.length;
              int outputsCount = output.outputs.length;

              int idx = blockWidget.inputs.indexOf(inputIOWidget);

              double inX = blockWidget.x/2 + inputIOBox.size.width/4;
              double inY = blockWidget.y/2 + inputRenderBox.size.height/4 - inputIOBox.size.height/4;
              double outX = output.x/2 + outputRenderBox.size.width/2 - outputIOBox.size.width/4;
              double outY = output.y/2 + outputRenderBox.size.height/4 - outputIOBox.size.height/4;

              AddLine(inX, inY, outX, outY);
              AddLine(outX, outY, inX, inY);
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

  void BlockGestureCallback(IOWidget blockIO, GestureEnum gestureEnum){
    print('GestureCallback block tap');
    switch(gestureEnum){
      case GestureEnum.tap:
        if (SelectedPort == blockIO) SelectedPort = null;
        else if (SelectedPort != null){
          PositionedBlockWidget input = null;
          PositionedBlockWidget output = null;
          if (blockIO.io.type != SelectedPort.io.type){
            if (blockIO.io.type == IOtype.output){
              (blockIO.io as PortOutput).connect(SelectedPort.io);
              input = workspace.selectedMathModel.blockWidgets.firstWhere((b) => b.block.Inputs.contains(SelectedPort.io), orElse: () => null);
              output = workspace.selectedMathModel.blockWidgets.firstWhere((b) => b.block.Outputs.contains(blockIO.io), orElse: () => null);
              print('connected ${output.block.name} to ${input.block.name}');
            }
            else if (SelectedPort.io.type == IOtype.output) {
              (SelectedPort.io as PortOutput).connect(blockIO.io);
              input = workspace.selectedMathModel.blockWidgets.firstWhere((b) => b.block.Inputs.contains(blockIO.io), orElse: () => null);
              output = workspace.selectedMathModel.blockWidgets.firstWhere((b) => b.block.Outputs.contains(SelectedPort.io), orElse: () => null);
              print('connected ${output.block.name} to ${input.block.name}');
            }
            SelectedPort == null;
            input.update();
            output.update();
          }
          else {
            SelectedPort = blockIO;
          }
        }
        else SelectedPort = blockIO;
        SelectedPort?.update();
        break;
      case GestureEnum.double_tap: break;
      case GestureEnum.long_press: break;
    }
    _update();
  }

  IOWidget get SelectedPort => IOWidget.SelectedPort;
  set SelectedPort(value) {
    var port = SelectedPort;
    IOWidget.SelectedPort = value;
    if (value == null && port != null) port.update();
  }

  void BlockWasRemoved(PositionedBlockWidget blockWidget){
    print('main remove block ${blockWidget.block.name}');
    _update();
  }
  void BlockWasAdded(PositionedBlockWidget blockWidget){
    print('main add block');
    _update();
  }

  void IOWidgetConnectOrDisconnectIO(IOWidget io){
    _update();
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
    _update();
  }
  void addBlock(){
    showAddBlockDialog(context);
    _update();
  }

  @override
  void dispose() {
    print('dispose');
    RemoveEvents();
  }
}
