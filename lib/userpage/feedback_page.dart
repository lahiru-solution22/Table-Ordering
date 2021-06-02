// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_esc_printer/flutter_esc_printer.dart';
// import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:pos_app_2/config/palette.dart';
// import 'package:pos_app_2/screens/dashboard/Bottom%20navbar/botttom%20navbar.dart';
// import 'package:pos_app_2/screens/dashboard/Bottom%20navbar/localWidgets/orderBottomBar.dart';
// import 'package:pos_app_2/widgets/loader.dart';
//
// class AmountPay extends StatefulWidget {
//   final name;
//   final mobile;
//   final amount;
//   final tableIndex;
//   final tableNo;
//   final orderId;
//   final bool isDine;
//   final bool isTakeAway;
//   const AmountPay(
//       {Key key,
//         this.amount,
//         this.tableIndex,
//         this.tableNo,
//         this.orderId,
//         this.isDine,
//         this.isTakeAway,
//         this.name,
//         this.mobile})
//       : super(key: key);
//   @override
//   _AmountPayState createState() => _AmountPayState();
// }
//
// class _AmountPayState extends State<AmountPay>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController customAmountController = TextEditingController();
//
//   bool boldText = false;
//   double fontSizeAmount = 30;
//   double fontSizeAmountAmountToPay = 30;
//   TextStyle textStyleAmount;
//   TextStyle textStyleAmountToPay;
//   FontWeight fontWeight;
//   FontStyle fontStyle;
//   Color color = Colors.black;
//   TextDecoration textDecoration;
//   MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
//   var cashGiven;
//   var calculationInt;
//   double cash;
//   String calculation;
//   String paymentType = 'Cash;
//   var orderSnap;
//   var firebaseAmount = 0.0;
//   var customerSnap;
//   bool custom = false;
//   bool loop = false;
//   bool loop2 = false;
//   bool mainAxis = true;
//   bool customNumber = false;
//
//   AnimationController _controller;
//   Animation<double> _animation;
//
//
//   getData() async {
//     print('getData');
//     var dates = new DateTime.now().toString();
//     var dateParse = DateTime.parse(dates);
//     var currentDate = DateFormat('dd-MM-yyyy')
//         .format(DateTime.parse(dateParse.toString()));
//     var snap = await FirebaseFirestore.instance
//         .collection(FirebaseAuth.instance.currentUser.displayName)
//         .doc("completedPayment")
//         .collection('weeklySales').doc(currentDate.toString())
//         .get();
//     firebaseAmount = snap['amount'];
//     print('snap ${snap['amount']}');
//     print('firebaseAmount ${firebaseAmount}');
//
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     getData();
//     textStyleAmount = TextStyle(fontSize: fontSizeAmount, color: color);
//     textStyleAmountToPay = TextStyle(fontSize: fontSizeAmount, color: color);
//
//     AnimationController _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     );
//   }
//
//   void animateState() {
//     setState(() {
//       textStyleAmount = TextStyle(
//         fontSize: fontSizeAmount,
//         color: color,
//         fontWeight: fontWeight,
//         fontStyle: fontStyle,
//       );
//       textStyleAmountToPay = TextStyle(
//         fontSize: fontSizeAmount,
//         color: color,
//         fontWeight: fontWeight,
//         fontStyle: fontStyle,
//       );
//     });
//   }
//
//   decreaseFontSize() {
//     loop = false;
//     fontSizeAmount = 20;
//     fontSizeAmountAmountToPay = 30;
//     animateState();
//   }
//
//   endCallback2() {
//     fontSizeAmount = 100;
//     fontWeight = boldText ? FontWeight.w900 : FontWeight.w100;
//     boldText = !boldText;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     var dates = new DateTime.now().toString();
//     var dateParse = DateTime.parse(dates);
//     var formattedDate = DateFormat('yyyy-MM-dd')
//         .format(DateTime.parse(dateParse.toString()));
//     var currentDate = DateFormat('dd-MM-yyyy')
//         .format(DateTime.parse(dateParse.toString()));
//     String day = DateFormat('EEEE').format(DateTime.now());
//     Future<Ticket> testTicket(PaperSize paper) async {
//       final Ticket ticket = Ticket(paper);
//       double total = 0;
//
//       ticket.text(
//         customerSnap['shopName'],
//         styles: PosStyles(
//           bold: true,
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//       );
//       ticket.text(
//         customerSnap['address'],
//         styles: PosStyles(
//           align: PosAlign.center,
//         ),
//       );
//       ticket.text(
//         customerSnap['phone'],
//         styles: PosStyles(
//           align: PosAlign.center,
//         ),
//         linesAfter: 1,
//       );
//
//       for (var i = 0; i < orderSnap['itemname'].length; i++) {
//         total += orderSnap['productPriceList'][i];
//         ticket.text(orderSnap['itemname'][i]);
//         ticket.row([
//           PosColumn(
//               text:
//               '${orderSnap['productPriceList'][i].toStringAsFixed(2)} x ${orderSnap['quantity'][i]}',
//               width: 6),
//           PosColumn(
//               text: ' \$${orderSnap['productPriceList'][i].toStringAsFixed(2)}',
//               width: 6),
//         ]);
//       }
//
//       ticket.feed(1);
//       ticket.row([
//         PosColumn(text: 'Paid Amount', width: 6, styles: PosStyles(bold: true)),
//         PosColumn(
//             text: '\$${cashGiven.toStringAsFixed(2)}',
//             width: 6,
//             styles: PosStyles(bold: true)),
//       ]);
//       ticket.feed(1);
//       ticket.row([
//         PosColumn(text: 'Total', width: 6, styles: PosStyles(bold: true)),
//         PosColumn(
//             text: '\$${total.toStringAsFixed(2)}',
//             width: 6,
//             styles: PosStyles(bold: true)),
//       ]);
//       ticket.feed(1);
//       ticket.row([
//         PosColumn(text: 'Change', width: 6, styles: PosStyles(bold: true)),
//         PosColumn(
//             text: '\$${(cash - calculationInt).toStringAsFixed(2)}',
//             width: 6,
//             styles: PosStyles(bold: true)),
//       ]);
//       ticket.feed(2);
//       ticket.text('Thank You!',
//           styles: PosStyles(
//             align: PosAlign.center,
//             bold: true,
//             height: PosTextSize.size2,
//             width: PosTextSize.size2,
//           ));
//       ticket.cut();
//
//       return ticket;
//     }
//
//     calculationInt = widget.amount * 1.1;
//     return KeyboardSizeProvider(
//       smallSize: 200.0,
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         backgroundColor: Colors.grey.shade200,
//         body: StatefulBuilder(
//             builder: (BuildContext context, StateSetter showstate) {
//               return Column(
//                 children: [
//                   Expanded(
//                     flex: 5,
//                     child: ListView(
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Row(
//                                 children: [
//                                   TextButton.icon(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     icon: Icon(
//                                       Ionicons.arrow_back_circle_outline,
//                                       size: screenSize.width * 0.024,
//                                       color: Palette.black,
//                                     ),
//                                     label: Text(
//                                       'Back to menu',
//                                       style: TextStyle(
//                                         fontSize: screenSize.width * 0.014,
//                                         color: Palette.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 50),
//                               child: Row(
//                                 mainAxisAlignment: mainAxis
//                                     ? MainAxisAlignment.center
//                                     : MainAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       AnimatedDefaultTextStyle(
//                                         style: textStyleAmountToPay,
//                                         duration: Duration(seconds: 1),
//                                         onEnd: loop2 ? endCallback2 : null,
//                                         child: Text(
//                                           'Amount To Pay',
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: screenSize.width * 0.014,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: AnimatedDefaultTextStyle(
//                                           style: textStyleAmount,
//                                           duration: Duration(seconds: 1),
//                                           onEnd: loop2 ? endCallback2 : null,
//                                           child: Text(
//                                             '\$ ${(widget.amount * 1.1).toStringAsFixed(2)}',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Palette.secondaryColor,
//                                               fontSize: screenSize.width * 0.03,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       cashGiven != null
//                                           ? Column(
//                                         children: [
//                                           AnimatedDefaultTextStyle(
//                                             style: textStyleAmountToPay,
//                                             duration: Duration(seconds: 1),
//                                             onEnd:
//                                             loop2 ? endCallback2 : null,
//                                             child: Text(
//                                               'Paid',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize:
//                                                 screenSize.width * 0.014,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding:
//                                             const EdgeInsets.all(8.0),
//                                             child: AnimatedDefaultTextStyle(
//                                               style: textStyleAmount,
//                                               duration: Duration(seconds: 1),
//                                               onEnd:
//                                               loop2 ? endCallback2 : null,
//                                               child: Text(
//                                                 '\$ ${double.parse(cashGiven).toStringAsFixed(2)}',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color:
//                                                   Palette.secondaryColor,
//                                                   fontSize:
//                                                   screenSize.width * 0.03,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                           : Container(),
//                                     ],
//                                   ),
//                                   Spacer(),
//                                   cashGiven != null
//                                       ? StatefulBuilder(builder:
//                                       (BuildContext context,
//                                       StateSetter showstate) {
//                                     return Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.end,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.end,
//                                           children: [
//                                             Text(
//                                               'Balance',
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize:
//                                                 screenSize.width * 0.02,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Text(
//                                           '\$${(cash - calculationInt).toStringAsFixed(2)}',
//                                           style: TextStyle(
//                                             color: Palette.secondaryColor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: screenSize.width * 0.04,
//                                           ),
//                                         )
//                                       ],
//                                     );
//                                   })
//                                       : Container(),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 50.0),
//                               child: Divider(
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     flex: 10,
//                     child: Padding(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: StatefulBuilder(
//                               builder:
//                                   (BuildContext context, StateSetter showstate) {
//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Divider(thickness: 2),
//                                     SizedBox(height: screenSize.height * 0.01),
//                                     Text(
//                                       'Choose a payment below',
//                                       style: TextStyle(
//                                         fontSize: screenSize.width * 0.014,
//                                         color: Palette.lightGrey,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: screenSize.height * 0.02),
//                                     // cash container
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: screenSize.width * 0.005,
//                                         horizontal: screenSize.width * 0.01,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Palette.white,
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Ionicons.cash_outline,
//                                             size: screenSize.width * 0.02,
//                                             color: Palette.darkGrey,
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                           Text(
//                                             'Cash',
//                                             style: TextStyle(
//                                                 color: Palette.darkGrey,
//                                                 fontSize: screenSize.width * 0.014),
//                                           ),
//                                           Spacer(),
//                                           TextButton(
//                                             onPressed: () {
//                                               showstate(() {
//                                                 custom = false;
//                                                 decreaseFontSize();
//                                                 customAmountController.text =
//                                                     10.toString();
//                                                 cashGiven = 10.toString();
//                                                 cash = double.parse(cashGiven);
//                                                 calculationInt -= cash;
//                                                 print('cashgiven $calculationInt');
//                                               });
//                                             },
//                                             child: Text(
//                                               '\$10',
//                                               style: TextStyle(
//                                                   color: Palette.primaryColor,
//                                                   fontSize:
//                                                   screenSize.width * 0.014),
//                                             ),
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                           TextButton(
//                                             onPressed: () {
//                                               showstate(() {
//                                                 custom = false;
//                                                 decreaseFontSize();
//                                                 customAmountController.text =
//                                                     20.toString();
//                                                 cashGiven = 20.toString();
//                                                 cash = double.parse(cashGiven);
//                                                 calculationInt -= cash;
//                                                 print('cashgiven $calculationInt');
//                                               });
//                                             },
//                                             child: Text(
//                                               '\$20',
//                                               style: TextStyle(
//                                                   color: Palette.primaryColor,
//                                                   fontSize:
//                                                   screenSize.width * 0.014),
//                                             ),
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                           TextButton(
//                                             onPressed: () {
//                                               showstate(() {
//                                                 custom = false;
//                                                 decreaseFontSize();
//                                                 customAmountController.text =
//                                                     50.toString();
//                                                 cashGiven = 50.toString();
//                                                 cash = double.parse(cashGiven);
//                                                 calculationInt -= cash;
//                                                 print('cashgiven $calculationInt');
//                                               });
//                                             },
//                                             child: Text(
//                                               '\$50',
//                                               style: TextStyle(
//                                                   color: Palette.primaryColor,
//                                                   fontSize:
//                                                   screenSize.width * 0.014),
//                                             ),
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                           TextButton(
//                                             onPressed: () {
//                                               showstate(() {
//                                                 custom = false;
//                                                 decreaseFontSize();
//                                                 customAmountController.text =
//                                                     100.toString();
//                                                 cashGiven = 100.toString();
//                                                 cash = double.parse(cashGiven);
//                                                 calculationInt -= cash;
//                                                 print('cashgiven $calculationInt');
//                                               });
//                                             },
//                                             child: Text(
//                                               '\$100',
//                                               style: TextStyle(
//                                                   color: Palette.primaryColor,
//                                                   fontSize:
//                                                   screenSize.width * 0.014),
//                                             ),
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                           TextButton(
//                                             onPressed: () {
//                                               showstate(() {
//                                                 customAmountController.clear();
//                                                 custom = true;
//                                               });
//                                             },
//                                             child: Text(
//                                               'Custom',
//                                               style: TextStyle(
//                                                   color: Palette.darkGrey,
//                                                   fontSize:
//                                                   screenSize.width * 0.014),
//                                             ),
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: screenSize.height * 0.03),
//                                     // Custom amount
//                                     custom
//                                         ? Container(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: screenSize.width * 0.005,
//                                         horizontal: screenSize.width * 0.01,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Palette.white,
//                                         borderRadius:
//                                         BorderRadius.circular(10.0),
//                                       ),
//                                       child: Form(
//                                         child: TextFormField(
//                                           keyboardType:
//                                           TextInputType.numberWithOptions(
//                                               decimal: true),
//                                           inputFormatters: <
//                                               TextInputFormatter>[
//                                             FilteringTextInputFormatter
//                                                 .digitsOnly
//                                           ],
//                                           onChanged: (val) {
//                                             if (val.isEmpty) {
//                                               val = '0';
//                                             }
//                                             showstate(() {
//                                               cashGiven = val.toString();
//                                               cash =
//                                                   double.parse(cashGiven) ??
//                                                       0;
//                                               calculationInt -= cash;
//                                               print(cash);
//                                               print(calculationInt);
//                                               decreaseFontSize();
//                                               mainAxis = false;
//                                               customNumber = false;
//                                             });
//                                           },
//                                           controller: customAmountController,
//                                           decoration: InputDecoration(
//                                             prefixIcon: Icon(Icons.money),
//                                             hintText: '\$0.00',
//                                             hintStyle: TextStyle(
//                                                 color: Colors.grey[400]),
//                                             labelStyle: TextStyle(
//                                                 color: Palette.lightGrey),
//                                             border: InputBorder.none,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                         : SizedBox.shrink(),
//                                     custom
//                                         ? SizedBox(height: screenSize.height * 0.03)
//                                         : SizedBox.shrink(),
//
//                                     // card container
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         vertical: screenSize.width * 0.005,
//                                         horizontal: screenSize.width * 0.01,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: Palette.white,
//                                         borderRadius: BorderRadius.circular(10.0),
//                                       ),
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Ionicons.card_outline,
//                                             size: screenSize.width * 0.02,
//                                             color: Palette.darkGrey,
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                           Text(
//                                             'Card Payment',
//                                             style: TextStyle(
//                                                 color: Palette.darkGrey,
//                                                 fontSize: screenSize.width * 0.014),
//                                           ),
//                                           Spacer(),
//                                           IconButton(
//                                             icon: Icon(Ionicons
//                                                 .arrow_forward_circle_outline),
//                                             iconSize: screenSize.width * 0.022,
//                                             color: Palette.darkGrey,
//                                             onPressed: () {
//                                               showDialog(
//                                                   context: context,
//                                                   builder: (
//                                                       context,
//                                                       ) {
//                                                     return AlertDialog(
//                                                       title: Text(
//                                                         "Payment Method",
//                                                       ),
//                                                       content:
//                                                       SingleChildScrollView(
//                                                         child: ListBody(
//                                                           children: [
//                                                             TextButton(
//                                                               onPressed: () {
//                                                                 showstate(() {
//                                                                   paymentType =
//                                                                   'Card';
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                 });
//                                                               },
//                                                               child: Text(
//                                                                 'Credit Card Payment',
//                                                                 style: TextStyle(
//                                                                   color:
//                                                                   Palette.black,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             TextButton(
//                                                               onPressed: () {
//                                                                 showstate(() {
//                                                                   paymentType =
//                                                                   'Card';
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                 });
//                                                               },
//                                                               child: Text(
//                                                                 'Debit Card Payment',
//                                                                 style: TextStyle(
//                                                                   color:
//                                                                   Palette.black,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             TextButton(
//                                                               onPressed: () {
//                                                                 showstate(() {
//                                                                   paymentType =
//                                                                   'Cash';
//                                                                   Navigator.pop(
//                                                                       context);
//                                                                 });
//                                                               },
//                                                               child: Text(
//                                                                 'cash Payment',
//                                                                 style: TextStyle(
//                                                                   color:
//                                                                   Palette.black,
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   });
//                                             },
//                                           ),
//                                           SizedBox(width: screenSize.width * 0.01),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: screenSize.height * 0.03),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(height: screenSize.height * 0.02),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               StreamBuilder(
//                                 stream: FirebaseFirestore.instance
//                                     .collection(FirebaseAuth
//                                     .instance.currentUser.displayName)
//                                     .doc('businessProfile')
//                                     .snapshots(),
//                                 builder: (context, snapshotBiz) {
//                                   if (!snapshotBiz.hasData) {
//                                     return Center(
//                                       child: Loader(),
//                                     );
//                                   }
//
//                                   return StreamBuilder(
//                                     stream: FirebaseFirestore.instance
//                                         .collection(FirebaseAuth
//                                         .instance.currentUser.displayName)
//                                         .doc("/kitchenOrderTicket")
//                                         .collection('/' + currentDate.toString())
//                                         .doc(widget.orderId)
//                                         .snapshots(),
//                                     builder: (context, AsyncSnapshot snapshot) {
//                                       if (!snapshot.hasData || snapshot.hasError) {
//                                         // your code here
//                                         return CircularProgressIndicator(
//                                           valueColor: AlwaysStoppedAnimation<Color>(
//                                               Theme.of(context).hintColor),
//                                         );
//                                       }
//                                       orderSnap = snapshot.data;
//                                       return StreamBuilder(
//                                         stream: FirebaseFirestore.instance
//                                             .collection('posshop')
//                                             .doc("/businessProfile")
//                                             .snapshots(),
//                                         builder: (context, snapshot) {
//                                           if (!snapshot.hasData) {
//                                             return Loader();
//                                           }
//
//                                           customerSnap = snapshot.data;
//                                           return buildButton(
//                                             screenSize,
//                                             'Pay',
//                                             Colors.green,
//                                                 () async {
//                                               await FirebaseFirestore.instance
//                                                   .collection(FirebaseAuth.instance
//                                                   .currentUser.displayName)
//                                                   .doc("/completedPayment")
//                                                   .collection('totalPayment')
//                                                   .doc(widget.orderId)
//                                                   .set({
//                                                 "name": widget.name,
//                                                 "mobile": widget.mobile,
//                                                 'amount': calculationInt,
//                                                 'amountPaidByCustomer': cashGiven,
//                                                 'amountReturned':
//                                                 (cash - calculationInt)
//                                                     .toStringAsFixed(2),
//                                                 'day' : day,
//                                                 'dateTime': DateTime.now()
//                                                     .toIso8601String(),
//                                                 'date': formattedDate.toString(),
//                                                 "itemname": orderSnap['itemname'],
//                                                 "productPriceList":
//                                                 orderSnap['productPriceList'],
//                                                 "quantity": orderSnap['quantity'],
//                                                 "tableId": orderSnap['tableId'],
//                                                 "time":
//                                                 DateFormat('hh:mm a').format(
//                                                   DateTime.now(),
//                                                 ),
//                                                 "orderId": widget.orderId,
//                                                 "paymentType": paymentType,
//                                                 'refunded': false,
//                                               }).then((value) async {
//                                                 await FirebaseFirestore.instance
//                                                     .collection(FirebaseAuth
//                                                     .instance
//                                                     .currentUser
//                                                     .displayName)
//                                                     .doc("/completedPayment")
//                                                     .collection(
//                                                     currentDate.toString())
//                                                     .doc(widget.orderId)
//                                                     .set({
//                                                   'amount': calculationInt,
//                                                   'date Time': DateTime.now()
//                                                       .toIso8601String(),
//                                                   'date': formattedDate.toString(),
//                                                   "time":
//                                                   DateFormat('hh:mm a').format(
//                                                     DateTime.now(),
//                                                   ),
//                                                   "orderId": widget.orderId,
//                                                 }).then((value) async{
//                                                   await FirebaseFirestore.instance
//                                                       .collection(FirebaseAuth.instance
//                                                       .currentUser.displayName)
//                                                       .doc("/completedPayment")
//                                                       .collection('/weeklySales')
//                                                       .doc(currentDate.toString())
//                                                       .set({
//                                                     'amount': (calculationInt + firebaseAmount),
//                                                     'dates' : formattedDate.toString(),
//                                                     'date': currentDate,
//                                                   });
//                                                 });
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (
//                                                       context,
//                                                       ) {
//                                                     if (widget.isDine == true) {
//                                                       Future.delayed(
//                                                           Duration(seconds: 2),
//                                                               () async {
//                                                             await FirebaseFirestore
//                                                                 .instance
//                                                                 .collection(FirebaseAuth
//                                                                 .instance
//                                                                 .currentUser
//                                                                 .displayName)
//                                                                 .doc("/tableDetails")
//                                                                 .collection('/TableNo')
//                                                                 .doc(widget.tableIndex)
//                                                                 .update({
//                                                               'Status': '',
//                                                             }).then((value) async {
//                                                               print('Occupied Updated');
//                                                               await Navigator.push(
//                                                                   context,
//                                                                   MaterialPageRoute(
//                                                                       builder: (context) =>
//                                                                           OrderBottomBar(
//                                                                             screenSize:
//                                                                             screenSize,
//                                                                             tabIndex: 0,
//                                                                           )));
//                                                             });
//                                                           });
//                                                     } else if (widget.isTakeAway ==
//                                                         true) {
//                                                       Future.delayed(
//                                                           Duration(seconds: 2),
//                                                               () async {
//                                                             await FirebaseFirestore
//                                                                 .instance
//                                                                 .collection(FirebaseAuth
//                                                                 .instance
//                                                                 .currentUser
//                                                                 .displayName)
//                                                                 .doc("takeWay")
//                                                                 .collection('/' +
//                                                                 formattedDate
//                                                                     .toString())
//                                                                 .doc(widget.orderId)
//                                                                 .delete()
//                                                                 .then((value) async {
//                                                               await Navigator.push(
//                                                                   context,
//                                                                   MaterialPageRoute(
//                                                                       builder: (context) =>
//                                                                           BottomNavbar(
//                                                                             tabIndex: 1,
//                                                                           )));
//                                                             });
//                                                           });
//                                                     } else {
//                                                       {
//                                                         Future.delayed(
//                                                             Duration(seconds: 2),
//                                                                 () async {
//                                                               await FirebaseFirestore
//                                                                   .instance
//                                                                   .collection(
//                                                                   FirebaseAuth
//                                                                       .instance
//                                                                       .currentUser
//                                                                       .displayName)
//                                                                   .doc("Delivery")
//                                                                   .collection('/' +
//                                                                   formattedDate
//                                                                       .toString())
//                                                                   .doc(widget.orderId)
//                                                                   .delete()
//                                                                   .then((value) async {
//                                                                 await Navigator.push(
//                                                                     context,
//                                                                     MaterialPageRoute(
//                                                                         builder:
//                                                                             (context) =>
//                                                                             BottomNavbar(
//                                                                               tabIndex:
//                                                                               2,
//                                                                             )));
//                                                               });
//                                                             });
//                                                       }
//                                                     }
//
//                                                     return AlertDialog(
//                                                       shape: RoundedRectangleBorder(
//                                                         borderRadius:
//                                                         BorderRadius.all(
//                                                             Radius.circular(
//                                                                 20.0)),
//                                                       ),
//                                                       title: Text(
//                                                         "Payment Method",
//                                                       ),
//                                                       content:
//                                                       SingleChildScrollView(
//                                                         child: Column(
//                                                           children: [
//                                                             FadeTransition(
//                                                               opacity: _animation,
//                                                               child: Icon(
//                                                                 Icons.check,
//                                                                 color: Colors.green,
//                                                                 size: screenSize
//                                                                     .width *
//                                                                     0.05,
//                                                               ),
//                                                             ),
//                                                             Center(
//                                                               child: Text(
//                                                                   'Payment Successful'),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                 );
//                                               }).catchError((e) {
//                                                 print(e);
//                                                 createSnackBar(
//                                                     'please mention cash payment');
//                                               });
//
//                                               const PaperSize paper =
//                                                   PaperSize.mm80;
//                                               String address =
//                                               snapshotBiz.data['posPrinterIP'];
//
//                                               if (address.isIpAddress) {
//                                                 //print vai ip address
//
//                                                 PrinterNetworkManager
//                                                 _printerNetworkManager =
//                                                 PrinterNetworkManager();
//                                                 _printerNetworkManager
//                                                     .selectPrinter(address);
//                                                 final res =
//                                                 await _printerNetworkManager
//                                                     .printTicket(
//                                                     await testTicket(
//                                                         paper));
//
//                                                 print(res.msg);
//                                               } else if (address.isMacAddress) {
//                                                 //print vai mac address
//                                                 PrinterBluetoothManager
//                                                 _printerBluetoothManager =
//                                                 PrinterBluetoothManager();
//                                                 _printerBluetoothManager
//                                                     .selectPrinter(address);
//                                                 final res =
//                                                 await _printerBluetoothManager
//                                                     .printTicket(
//                                                     await testTicket(
//                                                         paper));
//
//                                                 print(res.msg);
//                                               } else {
//                                                 //print("Error :e");
//                                               }
//                                             },
//                                           );
//                                         },
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                               buildButton(
//                                 screenSize,
//                                 'Cancel Order',
//                                 Colors.red,
//                                     () {
//                                   showstate(() {
//                                     Navigator.pop(context);
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             }),
//       ),
//     );
//   }
//
//   Widget buildButton(
//       Size screenSize, String text, Color color, Function onPressed) =>
//       ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           primary: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: new BorderRadius.circular(10.0),
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: screenSize.width * 0.08,
//             vertical: screenSize.width * 0.01,
//           ),
//         ),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: screenSize.width * 0.016,
//           ),
//         ),
//       );
//
//   void createSnackBar(String message) {
//     final snackBar =
//     new SnackBar(content: new Text(message), backgroundColor: Colors.red);
//
//     // Find the Scaffold in the Widget tree and use it to show a SnackBar!
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }