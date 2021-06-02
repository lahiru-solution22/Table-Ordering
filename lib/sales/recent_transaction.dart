import 'dart:convert';
import 'dart:html' as html;
import 'package:check_in_system/AdminPage/dashboard/admin_dashboard.dart';
import 'package:check_in_system/AdminPage/dashboard/customer_visits.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';

class RecentTrans extends StatefulWidget {
  @override
  _RecentTransState createState() => _RecentTransState();
}

class Record {
  final String name;
  final String paymentType;
  final String orderId;
  final String date;
  final String time;
  final double amount;
  final DocumentReference reference;

  Record(this.name, this.paymentType, this.orderId, this.date, this.time,
      this.reference, this.amount);
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['paymentType'] != null),
        assert(map['orderId'] != null),
        assert(map['date'] != null),
        assert(map['time'] != null),
        assert(map['amount'] != null),
        name = map['name'],
        paymentType =
            map['paymentType'] == null ? 'Cash Payment' : map['paymentType'],
        orderId = map['orderId'],
        date = map['date'],
        amount = map['amount'],
        time = map['time'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class _RecentTransState extends State<RecentTrans> {
  List<List<dynamic>> csvrow = [];
  DateTime currentDate = DateTime.now();
  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime fromSelected;
  DateTime toSelected;
  bool filter;
  int sortColumnIndex;
  List<DataRow> dataRows = [];
  List<DataRow> showModelRows = [];
  List<Record> record;

  List<User> usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    usersFiltered = dataRows.cast<User>();
  }

  _showDateTimePicker() async {
    fromSelected = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    setState(() {});
  }

  _showDateTimePickerTo() async {
    toSelected = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var dates = new DateTime.now().subtract(Duration(days: 7,hours: 0,minutes: 0)).toString();
    var dateParse = DateTime.parse(dates);
    var formattedDate =
    DateFormat('yyyy-MM-dd').format(DateTime.parse(dateParse.toString()));
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Recent  Transactions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.02,
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(FirebaseAuth.instance.currentUser.displayName)
                .doc('completedPayment')
                .collection('totalPayment')
                .where('date', isGreaterThanOrEqualTo: formattedDate.toString(),)
                .orderBy(
                  'date',
                  descending: true,
                )
                // .orderBy('time',descending: true)
                .limit(4)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                print(snapshot.connectionState);
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                    showBottomBorder: true,
                    columnSpacing: size.width * 0.09,
                    columns: [
                      DataColumn(
                          label: Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.02,
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        'Date/Time',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.02,
                        ),
                      )),
                      DataColumn(
                        label: Text(
                          'OrderType',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.02,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Flexible(
                          child: Text(
                            'Order value',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02,
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Payment Type',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.02,
                          ),
                        ),
                      ),
                    ],
                    rows: _buildList(context, snapshot.data.documents,
                        snapshot.data.docs.length, _searchResult),
                  ),
                );
              }
            },
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SidebarPage(salesReport: 2,)));
                },
                child: Card(
                  color: Colors.yellow.shade400,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('See All Transactions'),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> data,
      int snap, String _searchKey) {
    dataRows.clear();
    int k = 1;
    String ordertype;
    String dr;
    for (int i = 0; i < snap; i++) {
      var record = Record.fromSnapshot(data[i]);
      dr = record.orderId.toString();
      ordertype = dr.split('0').first;
      // print('len $snap');
      if (record.name.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.orderId.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.paymentType.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.time.toLowerCase().contains(_searchKey.toLowerCase())) {
        dataRows.add(DataRow(cells: [
          DataCell(Text(
            record.name.toString(),
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          )),
          DataCell(
            Row(
              children: [
                Text(
                  '${record.date.toString()} ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  '${(record.time.toString())}',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          DataCell(Text(
            '${ordertype == 'TA' ? "TakeAway" : ordertype == 'DY' ? 'Delivery' : ordertype == 'DI' ? 'Dine IN' : 'Type'}',
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          )),
          DataCell(Text(
            ' \$ ${record.amount.toStringAsFixed(2)}',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontStyle: FontStyle.normal),
          )),
          DataCell(Text(
            record.paymentType.toString(),
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          )),
        ]));
      }
    }
    return dataRows;
  }
}
