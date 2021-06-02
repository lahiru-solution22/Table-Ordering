import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)


class PieChartMain extends StatefulWidget {
  @override
  _PieChartMainState createState() => _PieChartMainState();
}

class _PieChartMainState extends State<PieChartMain> {
  QuerySnapshot snap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var dates = new DateTime.now().subtract(Duration(days: 7,hours: 0,minutes: 0)).toString();
    var dateParse = DateTime.parse(dates);
    var formattedDate =
    DateFormat('yyyy-MM-dd').format(DateTime.parse(dateParse.toString()));
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.displayName)
            .doc('completedPayment')
            .collection('totalPayment')
            .where(
            'date',
            isGreaterThanOrEqualTo: formattedDate.toString()).get(),
        builder:(BuildContext context,snapshot){
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          snap = snapshot.data;
          return
            PieChartS(snap: snap.docs.isEmpty ? null : snap,);

        });
  }
}


class PieChartS extends StatefulWidget {
  var snap;
PieChartS({this.snap});
  @override
  State<StatefulWidget> createState() => PieChartSState();
}

class PieChartSState extends State<PieChartS> {
  int touchedIndex;
  List weekData = [];
  List weekDate = [];
  List weekDay = [];
  Map<String, int> countDate = {};
  Map<String, int> countDay = {};

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

// print('widget.snap ${widget.snap}');
    if( widget.snap == null){
      setState(() {
        for( int i = start; i<= end; i++) {
          // print(i);
          weekDate.add(i.toString());
          weekDay = ['Monday ', 'Tuesday', 'Wednesday','Thursday', 'Friday',' Saturday','Sunday'];
          // weekData.add(1);
          // print(weekData);
          weekData = [0,0,0,0,0,0,0];
        }
      });

    }
    else
      {
        // print('else');
        String dr ;
        setState(() {
          widget.snap.docs.forEach((element){
            countDate['${element.get('date')}'] = countDate.containsKey('${element.get('date')}') ? countDate['${element.get('date')}'] + 1: 1;
            countDay['${element.get('day')}'] = countDay.containsKey('${element.get('day')}') ? countDay['${element.get('day')}'] + 1: 1;
            // print(element.get('date'));

          });
        });
        countDate.forEach((key, value) {
          // print(value);
          // print(key);
          String dr = key.toString();
          weekDate.add(dr.split('-').last);
          weekData.add(value);

          // weekDate.add(key);
          // print(weekData);
        });
        weekDate.removeLast();
        weekData.removeLast();
        countDay.forEach((key, value) {
          weekDay.add(key);
        });
        // print(weekDate);
        // print(weekDay);
        // print(weekData);
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

    return SizedBox(
      height: size.height * 0.39,
      width: size .width * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 20,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text('Customer Visit Last 7 Days ',style: TextStyle(color:Color(0xFFF37325),fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
              AspectRatio(
                aspectRatio: 1.7,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch && pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: showingSections()),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 Padding(
                   padding: const EdgeInsets.only(right: 90),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       new DotsIndicator(
                         dotsCount: 1,
                         position: 0,
                         decorator: DotsDecorator(
                           shape: const Border(),
                           activeShape: RoundedRectangleBorder(),color: Colors.black,activeColor:Colors.black,
                         ),
                       ),
                       Text('Date',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                     ],
                   ),
                 ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      new DotsIndicator(
                        dotsCount: 1,
                        position: 0,
                        decorator: DotsDecorator(
                          shape: const Border(),
                          activeShape: RoundedRectangleBorder(),color: Color(0xFFF37325),activeColor: Color(0xFFF37325),
                        ),
                      ),
                      Text('No Of Customers',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),),
                    ],
                  ),
                )

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    Size size = MediaQuery.of(context).size;
    return List.generate(weekData.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ?  size .width * 0.01 : size .width * 0.01;
      final double radius = isTouched ? size .width * 0.09 : size .width * 0.07;
      final double widgetSize = isTouched ? 55 : 40;

      switch (i) {
        case 0:
          return PieChartSectionData(showTitle: true,
            color: const Color(0xffE0D7C6),
            value: 14.28,
            title: isTouched !=true ?'${weekData[0]}' : '${weekDay[0]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color:  Color(0xFFF37325),),
            badgeWidget: Text('${weekDate[0]}',style: TextStyle(fontSize: size .width * 0.01),),
            badgePositionPercentageOffset: .67,
            titlePositionPercentageOffset: .40,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xffF5EBE1),
            value: 14.28,
            title: isTouched !=true ?'${weekData[1]}' : '${weekDay[1]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color:  Color(0xFFF37325),),
            badgeWidget: Text('${weekDate[1]}',style: TextStyle(fontSize: size .width * 0.01),),
            badgePositionPercentageOffset: .70,
            titlePositionPercentageOffset: .40,
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xffF3F0E8),
            value: 14.28,
            title: isTouched !=true ?'${weekData[2]}' : '${weekDay[2]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color:  Color(0xFFF37325),),
            badgeWidget: Text('${weekDate[2]}',style: TextStyle(fontSize: size .width * 0.01),),
            badgePositionPercentageOffset: .90,
            titlePositionPercentageOffset: .40,
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xffEFECDE),
            value: 14.28,
            title:  isTouched !=true ?'${weekData[3]}' : '${weekDay[3]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color:  Color(0xFFF37325),),
            badgeWidget: Text('${weekDate[3]}',style: TextStyle(fontSize: size .width * 0.01),),
            badgePositionPercentageOffset: .70,
            titlePositionPercentageOffset: .40,
          );
        case 4:
          return PieChartSectionData(
            color:  Color(0xffEBF5F0),
            value: 14.28,
            title:isTouched !=true ?'${weekData[4]}' : '${weekDay[4]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color:  Color(0xFFF37325),),
            badgeWidget: Text('${weekDate[4]}',style: TextStyle(fontSize: size .width * 0.01),),
            badgePositionPercentageOffset: .70,
            titlePositionPercentageOffset: .40,
          );
        case 5:
          return PieChartSectionData(
            color:  Color(0xffF6EED5),
            value: 14.28,
            title:isTouched !=true ?'${weekData[5]}' : '${weekDay[5]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color:  Color(0xFFF37325),),
            badgeWidget: Text('${weekDate[5]}',style: TextStyle(fontSize: size .width * 0.01),),
            badgePositionPercentageOffset: .70,
            titlePositionPercentageOffset: .40,
          );
        case 6:
          return PieChartSectionData(
            color:  Color(0xffF3E5DC),
            value: 14.28,
            title:isTouched !=true ?'${weekData[6]}' : '${weekDay[6]}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: Color(0xFFF37325),),
            badgeWidget: Text('${weekDate[6]}',style: TextStyle(fontSize: size .width * 0.01),),
            badgePositionPercentageOffset: .70,
            titlePositionPercentageOffset: .40,
          );
        default:
          return null;
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
      this.svgAsset, {
        Key key,
        @required this.size,
        @required this.borderColor,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
