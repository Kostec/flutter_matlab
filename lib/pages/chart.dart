import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    workspace.selectedMathModel.mathModel.blocks.forEach((block) {
      var chart = MyChart(name: block.name);
      block.state.forEach((key, value) {
        chart.addChartData(ChartData(time: key, value: value[0]));
      });
      charts.add(chart);
      column.add(chart.buildChart());
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

  String name;

  double previousMaxX;
  double previousMaxY;

  MyChart({this.name});

  void addChartData(ChartData data){
    if (_chartData.length == 0){
      maxX = data.time;
      maxY = data.value;
    }
    _chartData.add(data);
    if (data.value > maxY) maxY = data.value;
    if (data.time > maxX) maxX = data.time;
  }

  LineChart buildChart() {
    return LineChart(LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(show: true,),
      titlesData: FlTitlesData(
        // ось X
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) { // цифры на оси X
            if (value == maxX)
              return value.toString();
            switch (value.toInt()) {
              case 0:
              case 2:
              case 4:
              case 6:
              case 8:
              case 10:
              case 12:
                return value.toString();
            }
            return '';
          },
        ),
        // ось Y
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) { // цифры на оси Y
            return value.toString();
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      // Стиль осей
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minY: -1.5,
      maxY: maxY + 1.5,
      maxX: maxX + 1.5,
      minX: 0,
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