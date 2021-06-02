import 'dart:html';
import 'package:check_in_system/userpage/feedback_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocation/geolocation.dart';

import 'package:check_in_system/userpage/checkdin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noOfGuestController = TextEditingController();
  TextEditingController tempController = TextEditingController();
  TextEditingController tableController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var mobileKey = GlobalKey<FormState>();
  var nameKey = GlobalKey<FormState>();
  var emailKey = GlobalKey<FormState>();
  var addressKey = GlobalKey<FormState>();
  var noOfGuestKey = GlobalKey<FormState>();
  var tempKey = GlobalKey<FormState>();
  var tableKey = GlobalKey<FormState>();
  var dateKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(mask: '+61 (##) ####-####', filter: { "#": RegExp(r'[0-9]') });

  bool _checkTile1 = false;
  bool _checkTile2 = false;
  DateTime _selectedDate;
String checkDemo = 'Dropin_Castle';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // MediaQuery.of(context).size.width <= 700== true ?? Container();
    // enableLocationServices();
    // print(enableLocationServices());
  }

  @override
  Widget build(BuildContext context) {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate =  DateFormat('dd-MM-yy')
        .format(DateTime.parse(dateParse.toString()));







    final url = window.location.href;
    print('url $url');
    print(url
        .split('#')
        .last);
    print(url.split('_'));
    var urlData = url
        .split('#')
        .last;
    Size size = MediaQuery
        .of(context)
        .size;


    const regex = ["#%&'()*+,-./:;<=>?@[\]^_`{|}~]/g"];
   var check = checkDemo.replaceAll('_', ' ');
   print(check);
    print('size width ${size.width}');
    print('size height ${size.height}');
      return Scaffold(
        backgroundColor: Color(0xFFFEFEFE),
        body: SingleChildScrollView(
          child: Center(
            child:  MediaQuery.of(context).size.width <= 700 ?Container(
              width: size.width >= 700 ?  size.width * 0.5: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width:  size.width ,
                    decoration: BoxDecoration(
                      image: DecorationImage( alignment: Alignment.center,
                          image: AssetImage("images/weltop.jpg",),fit: BoxFit.contain ,scale: 1.0),

                      borderRadius: BorderRadius.all(Radius.circular(20)),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset(
                            "images/logo.png",
                            width: 61,
                            height: 82,
                          ),
                          SizedBox(width: size.width * 0.07,),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Dropin',
                                  style: TextStyle(
                                      fontSize: size.width * 0.07,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'CHECKIN SYSTEM ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.042,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color(0xFFFEFEFE),
                        ),
                        child: Image.asset(
                          "images/wel.gif",
                          width: size.width * 0.5,
                          height: size.height * 0.3,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check -in to ',
                            style: TextStyle(
                                fontSize: size.width * 0.042,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              Text(
                                urlData == '/' ?   'Shop Name' : urlData,

                                style: TextStyle(
                                    fontSize: size.width * 0.07,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      AutofillGroup(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: nameKey,
                                child: TextFormField(
                                  validator: (String value) {
                                    if (value.length < 3)
                                      return " Enter at least 3 character from Customer Name";
                                    else
                                      return null;
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.text ,
                                    inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                RegExp('[a-z,A-Z]')),],
                                  controller: nameController,
                                  autofillHints: [AutofillHints.givenName],

                                  decoration: InputDecoration(
                                      labelText: 'Name\*',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: size.width * 0.048,
                                      ),
                                      prefixIcon: Image.asset(
                                        "images/person.png",
                                        width:size.width * 0.048,
                                      ),
                                      hoverColor: Colors.yellow,
                                      filled: false,
                                      focusColor: Colors.yellow),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: mobileKey,
                                child: TextFormField(
                                  validator: (String value) {
                                    if (value.length < 9)
                                      return " Enter at least 9 character from your mobile Number";
                                    else
                                      return null;
                                  },
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: [
                                    maskFormatter,
                                  ],
                                  controller: mobileNumberController,
                                  autofillHints: [AutofillHints.telephoneNumber],
                                  decoration: InputDecoration(
                                      labelText: 'Mobile Number\*',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: size.width * 0.048,
                                      ),
                                      prefixIcon:  Image.asset(
                                        "images/phone.png",
                                        width:size.width * 0.048,
                                      ),
                                      hoverColor: Colors.yellow,
                                      filled: false,
                                      focusColor: Colors.yellow),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: noOfGuestKey,
                                child: TextFormField(
                                  // validator: (String value) {
                                  //   if (value.length < 9)
                                  //     return " Enter at least 9 character from your mobile Number";
                                  //   else
                                  //     return null;
                                  // },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[1-9]')),],
                                  keyboardType: TextInputType.phone,
                                  controller: noOfGuestController,
                                  decoration: InputDecoration(
                                      labelText: 'No of Additional Guests\*',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: size.width * 0.048,
                                      ),
                                      prefixIcon: Image.asset(
                                        "images/user-plus.png",
                                        width:size.width * 0.048,
                                      ),
                                      hoverColor: Colors.yellow,
                                      filled: false,
                                      focusColor: Colors.yellow),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: emailKey,
                                child: TextFormField(
                                  // validator: (String value) {
                                  //   if (value.length < 9)
                                  //     return " Enter at least 9 character from your mobile Number";
                                  //   else
                                  //     return null;
                                  // },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailController,
                                  autofillHints: [AutofillHints.email],
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: size.width * 0.048,
                                      ),
                                      prefixIcon:  Image.asset(
                                        "images/email.png",
                                        width:size.width * 0.048,
                                      ),
                                      hoverColor: Colors.yellow,
                                      filled: false,
                                      focusColor: Colors.yellow),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: addressKey,
                          child: TextFormField(
                            // validator: (String value) {
                            //   if (value.length < 9)
                            //     return " Enter at least 9 character from your mobile Number";
                            //   else
                            //     return null;
                            // },
                            keyboardType: TextInputType.text,
                            controller: addressController,
                            autofillHints: [AutofillHints.streetAddressLevel1],
                            decoration: InputDecoration(
                                labelText: 'Address',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.width * 0.048,
                                ),
                                prefixIcon: Image.asset(
                                "images/address.png",
                                  width:size.width * 0.048,
                                ),
                                hoverColor: Colors.yellow,
                                filled: false,
                                focusColor: Colors.yellow),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          // validator: (String value) {
                          //   if (value.length < 9)
                          //     return " Enter at least 9 character from your mobile Number";
                          //   else
                          //     return null;
                          // },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('')),],
                          decoration: InputDecoration(
                              labelText:  formattedDate.toString(),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width * 0.048,
                              ),
                              prefixIcon: Image.asset(
                                "images/calendar.png",
                                width:size.width * 0.048,
                              ),

                              hoverColor: Colors.yellow,
                              filled: false,
                              focusColor: Colors.yellow),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          // validator: (String value) {
                          //   if (value.length < 9)
                          //     return " Enter at least 9 character from your mobile Number";
                          //   else
                          //     return null;
                          // },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('')),],
                          decoration: InputDecoration(
                              labelText:    DateFormat('hh:mm a').format(
                                DateTime.now(),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: size.width * 0.048,
                              ),
                              prefixIcon: Image.asset(
                                "images/clock.png",
                                width:size.width * 0.048,
                              ),

                              hoverColor: Colors.yellow,
                              filled: false,
                              focusColor: Colors.yellow),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: tempKey,
                          child: TextFormField(
                            // validator: (String value) {
                            //   if (value.length < 9)
                            //     return " Enter at least 9 character from your mobile Number";
                            //   else
                            //     return null;
                            // },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[1-9,0]')),],
                            keyboardType: TextInputType.text,
                            controller: tempController,
                            decoration: InputDecoration(
                                labelText: 'Temp',
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.width * 0.048,
                                ),
                                prefixIcon:  Image.asset(
                                  "images/temp.png",
                                  width:size.width * 0.048,
                                ),
                                hoverColor: Colors.yellow,
                                filled: false,
                                focusColor: Colors.yellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text("I accept to the Terms & Conditions",style: TextStyle(
                            color: Colors.grey,
                            fontSize: size.width * 0.035,
                          ),),
                          value: _checkTile1,
                          onChanged: (bool value) {
                            setState(() {
                              _checkTile1 = value;
                            });
                          },
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        CheckboxListTile(
                          title: Text("Assurance Text",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: size.width * 0.035,
                            ),),
                          value: _checkTile2,
                          onChanged: (bool value) {
                            setState(() {
                              _checkTile2 = value;
                              print(value);
                            });
                          },
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 20,
                          side: BorderSide(
                            width: 1,
                            color: _checkTile1 == true && _checkTile2 == true
                                ? Colors.deepOrange
                                : Colors.black26,
                          ),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: _checkTile1 == true && _checkTile2 == true
                              ? Colors.deepOrange
                              : Color(0xFFFFFFFF),
                          onPrimary: Colors.white),
                      onPressed: () async {
                        setState(() {
                          nameKey.currentState.validate();
                          mobileKey.currentState.validate();
                        });
                        if(mobileKey.currentState.validate() && nameKey.currentState.validate()){
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             FeedbackPage(urlName: urlData,)
                          //     ));
                        }

                        var snap = await FirebaseFirestore.instance.collection(urlData).doc('totalCustomers').collection('customerTotal').doc(mobileNumberController.text).get();
                        if(snap.exists){
                          // print(FirebaseFirestore.instance.collection('Dropin').doc('totalCustomers').collection('customerTotal').doc(mobileNumberController.text).snapshots().length);
                          print(snap.exists);
                          await FirebaseFirestore.instance.collection(urlData).doc('returnCustomers').collection('customerReturn').doc(mobileNumberController.text).set({
                            'mobile' : mobileNumberController.text,
                          });
                        }
                        else
                          {
                            await FirebaseFirestore.instance.collection(urlData).doc('NewCustomers').collection('NewCustomers').doc(mobileNumberController.text).set({
                              'mobile' : mobileNumberController.text,
                            });
                            print('fail');
                          }
                        await FirebaseFirestore.instance
                            .collection(urlData)
                            .doc("customerDetails")
                            .collection(
                          formattedDate.toString(),
                        )
                            .doc(mobileNumberController.text)
                            .set({
                          'name': nameController.text,
                          'mobile': mobileNumberController.text,
                          'date': formattedDate.toString(),
                          'email': emailController.text,
                          'address': addressController.text,
                          "time": DateFormat('hh:mm a').format(
                            DateTime.now(),
                          ),
                          'guests': noOfGuestController.text== '' ? '0' : noOfGuestController.text,
                          'temperature': tempController.text,
                          'table': tableController.text,
                        }).then((value)async {
                          print('firebase uploaded');
                          await FirebaseFirestore.instance.collection(urlData).doc('totalCustomers').collection('customerTotal').doc(mobileNumberController.text).set({
                            'mobile' : mobileNumberController.text,
                            'name': nameController.text,
                            'guests': noOfGuestController.text== '' ? '0' : noOfGuestController.text,
                            'date': formattedDate.toString(),
                          });
                          await FirebaseFirestore.instance.collection(urlData).doc('totalCustomers').collection('customerTotalIndex').doc(mobileNumberController.text).set({
                            'mobile' : mobileNumberController.text,
                          });
                        });


                        print(dateController.text);
                        print(mobileNumberController.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Check In',
                              style: TextStyle(
                                color: _checkTile1 == true && _checkTile2 == true
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: size.width * 0.03,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              color: _checkTile1 == true && _checkTile2 == true
                                  ? Colors.white
                                  : Colors.grey,
                              size: size.width * 0.03,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 70,right: 70),
                    child: Container(
                      height: size.height * 0.16,
                      child: Column(
                        children: [
                          Text(
                            "We'll only use these details for contact tracing. We'll delete in 28 days unless needed for contact tracing purposes. No account needed ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: size.width * 0.03,
                            ),
                          ),
                          SizedBox(
                            height:  size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment:MainAxisAlignment.center,
                            children: [
                              Text(
                                'Privacy, Security',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.grey,
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: size.width * 0.01,),
                              Text(
                                'and',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.grey,
                                    fontSize: size.width * 0.03,
                                ),
                              ),
                              SizedBox(width: size.width * 0.01,),
                              Text(
                                'Terms of Use',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.grey,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ) :
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Sorry This page can only  opened in Mobile',style: TextStyle(
                  color: Colors.black,fontSize: size.width * 0.1,
                ),)),
              ),
            ),
          ),
        ),
      );
    }
  }
