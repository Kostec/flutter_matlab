import 'package:flutter/material.dart';
import 'package:fluttermatlab/models/TransferFcn.dart';
import 'package:fluttermatlab/widgets/block.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Path path;
  Paint paint;
  Canvas canvas;

  @override
  void initState() {

    TransferFcn model = new TransferFcn();
    model.nums = [1, 2, 3, 0, 5,];
    model.dens = [6, 7, 8, 9, 10, 11,];
    var nums = model.numsToString();
    var dens = model.densToString();
    print(nums);
    print(dens);
//    path = Path();
//    path.lineTo(25.0, 25.0);
//    paint = Paint();
//    paint.color = Colors.black;
//    paint.style = PaintingStyle.stroke;
//    paint.strokeWidth = 2.0;
//    canvas.drawPath(path, paint);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          BlockWidget(x: 20.0, y: 20.0,),
          BlockWidget(x: 80.0, y: 20.0,),
          BlockWidget(x: 20.0, y: 80.0,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){print('Float');},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
