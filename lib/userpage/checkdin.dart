import 'package:check_in_system/userpage/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckedIn extends StatefulWidget {
final urlData;

  const CheckedIn({Key key, this.urlData}) : super(key: key);


  @override
  _CheckedInState createState() => _CheckedInState();
}

class _CheckedInState extends State<CheckedIn> {

  String currentTime;
  String currentDate;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    currentTime =
        DateFormat('hh:mm a').format(
          DateTime.now(),
        );
    currentDate =
        DateFormat(" d MMMM yyyy").format(DateTime.now());
    return Scaffold(
      backgroundColor:   Color(0xFFFEFEFE),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.urlData,
              style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Image.asset(
                  "images/checked.gif",
                  width: 300,
                  height: 100,
                ),
              ),
            ),
            Text(
              'Checked In ',
              style: TextStyle(
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$currentDate at $currentTime', style: TextStyle(
                    fontSize: size.width * 0.04,),),
              ],
            ),

            SizedBox(
              width: size.width * 0.5,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                    elevation: 20,
                    side: BorderSide(width: 1,
                      color:  Colors.red,),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    primary:  Colors.deepOrange,
                    onPrimary: Colors.white),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackPage(),));
                  // print(dateController.text);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5% Offer ',
                        style: TextStyle(
                          color:  Colors.white,
                          fontSize: size.width * 0.02,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Icon(
                        Icons.local_offer_sharp,
                        color:Colors.white,
                        size: size.width * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
