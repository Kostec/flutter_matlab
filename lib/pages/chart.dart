import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  List<ChartData> data = new List<ChartData>();

  Timer timer;
  @override
  void initState() {
    data.add(ChartData(time: 0, value: 0));
    timer = Timer.periodic(Duration(microseconds: 100), timeCallback);
  }

  double time = 0;
  double value = 0;
  double T = 0.0001;
  int count = 0;

  List<ChartData> buffer = new List<ChartData>();

  void timeCallback (Timer timer){
    if (time < 12) {
      var chartData = ChartData(time: time, value: value);
        buffer.add(chartData);
        time += T;
        value = sin(time);
        if (buffer.length - count > 1000){
          setState(() {
            data = buffer;
            count = buffer.length;
          });
        }
    }
    else{
      setState(() {
        data = buffer;
      });
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawer = Menu();
    var body = _buildBody();

    return Scaffold(
      drawer: drawer,
      appBar: AppBar(title: Text('ChartPage'),),
      body: body,
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(5.0),
          child: LineChart(sampleData1()),
        ),
      ],
    );
  }


  LineChartData sampleData1() {
    return LineChartData(
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
      maxY: 1.5,
      maxX: 15,
      minX: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    List<FlSpot> spots = new List<FlSpot>();

    data.forEach((element) {
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

class ChartData{
  final double time;
  final double value;
  ChartData({this.value, this.time});
}