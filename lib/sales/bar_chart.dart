import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class Bar extends StatefulWidget {
  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> {


  QuerySnapshot snap;

  @override
  Widget build(BuildContext context) {
    var dates = new DateTime.now().subtract(Duration(days: 7,hours: 0,minutes: 0)).toString();
    var dateParse = DateTime.parse(dates);
    var formattedDate =
    DateFormat('yyyy-MM-dd').format(DateTime.parse(dateParse.toString()));
    var endDate = DateTime.now().toString();
    var endParse = DateTime.parse(endDate);
    var currentDate =
    DateFormat('yyyy-MM-dd').format(DateTime.parse(endDate.toString()));
    return
    StreamBuilder<QuerySnapshot>(
      stream:FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser.displayName)
          .doc('completedPayment')
          .collection('weeklySales')
          .where(
          'dates',
          isGreaterThanOrEqualTo: formattedDate).snapshots(),

        builder: (context, snapshot) {
      if (snapshot.hasError || !snapshot.hasData) {
        return Text(
            'We run into an error ${snapshot.error}');
      }

      switch (snapshot.connectionState) {
        case ConnectionState.waiting:


          return Center(
            child: CircularProgressIndicator(),
          );
        case ConnectionState.none:
          return Text('Oops no data present');
        case ConnectionState.done:

          return Text('We are done');
        default:  snap =  snapshot.data;
        print(snapshot.data.docs.isEmpty ? ('Empty') : ('Data Available'));
          return

            BarChartOne(snap: snap.docs.isEmpty ? null : snap,);
      }
    },
    );
  }
}



class BarChartOne extends StatefulWidget {
  var snap;

  BarChartOne({this.snap});
  @override
  State<StatefulWidget> createState() => BarChartOneState();
}

class BarChartOneState extends State<BarChartOne> {

  var maxx;
  var minx;
  final List<double> weeklyData = [ ];
  final List <String> Dates = [];
  int touchedIndex;
  var lastIndex;
  TextStyle dateTextStyle =
  TextStyle(fontSize: 10,wordSpacing: 2.0,  color: const Color(0xff379982), fontWeight: FontWeight.bold);
  getData(){

    var dates = new DateTime.now().subtract(Duration(days: 7,hours: 0,minutes: 0)).toString();
    var dateParse = DateTime.parse(dates);
    var formattedDate =
    DateFormat('yyyy-MM-dd').format(DateTime.parse(dateParse.toString()));
    var endDate = DateTime.now().toString();
    var endParse = DateTime.parse(endDate);
    var currentDate =
    DateFormat('yyyy-MM-dd').format(DateTime.parse(endDate.toString()));


    int start =  int.parse(formattedDate.split('-').last);
    int end =  int.parse(currentDate.split('-').last);


    if( widget.snap == null){
     setState(() {
       for( int i = start; i<= end; i++) {
         print(i);
         Dates.add(i.toString());
         weeklyData.add(0);
         maxx = 100;
         minx = 0;

       }
     });
     Dates.removeLast();
    }
    else
      {
        String dr ;
        setState(() {
          widget.snap.docs.forEach((element){

            weeklyData.add(element.get('amount'));
            dr = element.get('date');
            Dates.add(dr.split('-').first);
            lastIndex  = Dates.length;


          });

          Dates.removeLast();

        });
        if (weeklyData != null && weeklyData.isNotEmpty) {
          maxx = weeklyData.map<int>((e) => e.toInt()).reduce(max);
          minx = weeklyData.map<int>((e) => e.toInt()).reduce(min);
        }
        else
        {
          print('nulll');
        }
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;





    return Container(
      height: size.height * 0.39,
      width:  size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: const Color(0xff81e5cd),
      ),
      margin: EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Sales For Last 7 Days',
            style: TextStyle(
                color: const Color(0xff379982),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BarChart(
                mainBarData(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBar(
    int x,
    double y, {
    bool isTouched = false,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y >= 20000 ? 1000 : y ,
          colors: [isTouched ? Colors.yellow : Colors.white,],
          width: 22,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxx,
            colors: [Color(0xff72d8bf)],
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildAllBars() {
    return List.generate(
      Dates.length,
      (index) => _buildBar(index, weeklyData[index],
          isTouched: index == touchedIndex),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: _buildBarTouchData(),
      titlesData: _buildAxes(),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: _buildAllBars(),
      maxY:maxx,
      minY: minx,
      axisTitleData: FlAxisTitleData(
          leftTitle: AxisTitle(showTitle: true, titleText: 'Price',textStyle: dateTextStyle, margin: 4),
          bottomTitle: AxisTitle(
              showTitle: true,
              margin: 0,
              titleText: 'Date',
              textStyle: dateTextStyle,
              textAlign: TextAlign.right)),
    );
  }

  FlTitlesData _buildAxes() {
    return FlTitlesData(
      // Build X axis.
      bottomTitles: SideTitles(

        showTitles: true,
        getTextStyles: (value) => TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        margin: 16,
        getTitles: ( double value) {
          switch (value.toInt()) {
            case 0:
              return Dates[0].toString();
            case 1:
              return Dates[1].toString();
            case 2:
              return Dates[2].toString();
            case 3:
              return Dates[3].toString();
            case 4:
              return Dates[4].toString();
            case 5:
              return Dates[5].toString();
            case 6:
              return Dates[6].toString();
            default:
              return '';
          }
        },
      ),
      // Build Y axis.
      leftTitles: SideTitles(
        getTextStyles: (value) =>dateTextStyle,
        margin: 32,
        reservedSize: 30,
        showTitles: false,
        getTitles: (double value) {
          if(value == 0){
            return '0';
          }
          else if(value == 10){
            return '10';
          }
          else if(value == 20){
            return '20';
          }
          else if(value == 30){
            return '30';
          }else if(value == 40){
            return '40';
          }
          else if(value == 50){
            return '50';
          }
          else if(value == 50){
            return '50';
          } else if(value == 60){
            return '60';
          } else if(value == 70){
            return '70';
          } else if(value == 80){
            return '80';
          } else if(value == 90){
            return '90';
          } else if(value == 100){
            return '100';
          }
          else
          {
            return '';
          }
        },
      ),
    );
  }


  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.blueGrey,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          String weekDay;
          switch (group.x.toInt()) {
            case 0:
              weekDay = 'Monday';
              break;
            case 1:
              weekDay = 'Tuesday';
              break;
            case 2:
              weekDay = 'Wednesday';
              break;
            case 3:
              weekDay = 'Thursday';
              break;
            case 4:
              weekDay = 'Friday';
              break;
            case 5:
              weekDay = 'Saturday';
              break;
            case 6:
              weekDay = 'Sunday';
              break;
          }
          return BarTooltipItem(
            weekDay + '\n' + (rod.y).toString(),
            TextStyle(color: Colors.yellow),
          );
        },
      ),
      touchCallback: (barTouchResponse) {
        setState(() {
          if (barTouchResponse.spot != null &&
              barTouchResponse.touchInput is! PointerUpEvent &&
              barTouchResponse.touchInput is! PointerExitEvent) {
            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          } else {
            touchedIndex = -1;
          }
        });
      },
    );
  }
}
