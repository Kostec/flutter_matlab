import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermatlab/models/Scope.dart';
import 'package:fluttermatlab/services/workspace.dart';
import 'package:fluttermatlab/widgets/menu.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatefulWidget{
  @override
  State createState() {
    return _ChartPageState();
  }

  static void OpenPage(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChartPage()));
  }
}

class _ChartPageState extends State<ChartPage> {

  List<MyChart> charts = [];

  List<Widget> column = [];

  Timer timer;
  @override
  void initState() {

    var scopes = workspace.selectedMathModel.mathModel.blocks.where((element) => element is Scope);
    scopes.forEach((scope) {
      for (int i = 0; i < (scope as Scope).stateInputs.length; i++){
        var input = (scope as Scope).stateInputs[i] ;
        MyChart chart = MyChart(name: 'scope.name in$i');
        input.forEach((key, listInputs) {
          listInputs.forEach((value) {
            chart.addChartData(ChartData(time: key, value: value));
          });
        });
        charts.add(chart);
        column.add(chart.buildChart());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var drawer = MainMenu.menu;
    var body = _buildBody();

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(title: Text('ChartPage'),),
      body: body,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(5.0),
          child: ListView.builder(
            itemCount: charts.length,
            itemBuilder: (context, idx){
              return ListTile(
                title: Center(child: Text(charts[idx].name)),
                subtitle: charts[idx].buildChart(),
              );
            },
          )
        )
    );
  }

}

class ChartData{
  final double time;
  final double value;
  ChartData({this.value, this.time});
}

class MyChart{
  List<ChartData> _chartData = [];
  double maxX;
  double maxY;
  double minX;
  double minY;

  String name;

  MyChart({this.name});

  void addChartData(ChartData data){
    if (_chartData.length == 0){
      maxX = data.time;
      maxY = data.value;
      minX = data.time;
      minY = data.value;
    }
    _chartData.add(data);
    if (data.value > maxY) maxY = data.value;
    if (data.time > maxX) maxX = data.time;
    if (data.value < minY) minY = data.value;
    if (data.time < minX) minX = data.time;
  }

  LineChart buildChart() {
    if (minY == maxY){
      minY = minY - 5;
      maxY = maxY +5;
    }

    return LineChart(LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.blueGrey.withOpacity(0.8),),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(show: true,),
      titlesData: FlTitlesData(
        // ось X
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(color: Color(0xff72719b), fontWeight: FontWeight.bold, fontSize: 16,),
          margin: 10,
          interval: (_chartData.length/10000).toDouble(),
        ),
        // ось Y
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(color: Color(0xff75729e), fontWeight: FontWeight.bold, fontSize: 14,),
          interval: maxY/5,
          margin: 8,
          reservedSize: 30,
        ),
      ),
      // Стиль осей
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4,),
          left: BorderSide(color: Colors.transparent,),
          right: BorderSide(color: Colors.transparent,),
          top: BorderSide(color: Colors.transparent,),
        ),
      ),
      minY: minY,
      maxY: maxY,
      maxX: maxX,
      minX: minX,
      lineBarsData: _buildLineChartBar(),
    ));
  }

  List<LineChartBarData> _buildLineChartBar() {
    List<FlSpot> spots = new List<FlSpot>();

    _chartData.forEach((element) {
      spots.add(FlSpot(element.time, element.value));
    });

    LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: [
        const Color(0xff000000),
      ],
      barWidth: 4,
      isStrokeCapRound: false,
      dotData: FlDotData(show: false,),
      belowBarData: BarAreaData(show: false,),
    );
    return [lineChartBarData1];
  }
}