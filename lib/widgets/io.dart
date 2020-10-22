import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermatlab/models/BlockIO.dart';
import 'package:fluttermatlab/other/enums.dart';

typedef IOGestureCallback = Function(IOWidget io, GestureEnum gesture);

typedef IOWidgetCallback = Function(IOWidget io);

Map<IOPortState, Color> portStateColor = {
  IOPortState.connected : Colors.green,
  IOPortState.disconnected : Colors.grey,
  IOPortState.selected : Colors.yellow,
};


class IOWidget extends StatefulWidget{

  IOWidgetCallback onConnect = (io) => {};
  IOWidgetCallback onDisconnect = (io) => {};

  static IOWidget SelectedPort;
  static int count = 0;
  BuildContext context;
  PortIO io;
  IOWidget(this.io,);
  IOGestureCallback gestureCallback;
  VoidCallback update;

  @override
  State<StatefulWidget> createState() => IOWidgetState();
}

class IOWidgetState extends State<IOWidget>{
  Color portColor;
  IOPortState portState;

  PortIO io;

  Map<String, Function> dialogItems = { };


  @override
  void initState() {
    io = widget.io;
    portColor = portStateColor[portState];
    io.onConnect = OnPortConnect;
    io.onDisconnect = OnPortDisconnect;

    dialogItems = {
      'Отключить' : () {
        if (io is PortInput)
          (io as PortInput).disconnect();
        else if (io is PortOutput) {
          var out = (io as PortOutput);
          while (out.connections.length != 0) out.connections[0].disconnect();
          Navigator.of(context).pop();
        }
      },
      'Отмена' : () => Navigator.of(context).pop(),
    };
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    widget.update = () => setState((){});
    if (IOWidget.SelectedPort == widget) portState = IOPortState.selected;
    else {
      if (io is PortInput)
        portState = (io as PortInput).connectedTo == null
            ? IOPortState.disconnected
            : IOPortState.connected;
      else if (io is PortOutput) portState =
      (io as PortOutput).connections.length < 1
          ? IOPortState.disconnected
          : IOPortState.connected;
    }
    portColor = portStateColor[portState];

    return widget.io is PortInput ? _buildInput() : _buildOutput();
  }

  Widget _buildInput(){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 20,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border.all(color: Colors.black), color: portColor),
        child: Center(child: Text('${widget.io.num}')),
      ),
    );
  }

  Widget _buildOutput(){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 20,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(border: Border.all(color: Colors.black), color: portColor),
        child: Center(child: Text('${widget.io.num}')),
      )
    );
  }

  void onTap(){
    if (widget.gestureCallback != null) widget.gestureCallback(widget, GestureEnum.tap);
    print('output tap');
    if (portState == IOPortState.selected) showDialog(context);
  }

  void showDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 200,
            child: ListView.builder(
                itemCount: dialogItems.length,
                itemBuilder: (BuildContext context, int index){
                  var key = dialogItems.keys.toList()[index];
                  var func = dialogItems[key];
                  return Container(
                    child: FlatButton(child: Text(key, style: TextStyle(color: Colors.black, fontSize: 32),), onPressed: func,),
                  );
                }),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            padding: EdgeInsets.only(bottom: 12, top: 12, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void OnPortConnect(PortIO port){
    setState(() { });
    widget.onConnect(widget);
  }

  void OnPortDisconnect(PortIO port){
    setState(() { });
    widget.onDisconnect(widget);
  }
}