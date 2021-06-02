import 'dart:convert';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomerVisits extends StatefulWidget {
  @override
  _CustomerVisitsState createState() => _CustomerVisitsState();
}

class Record {
  final String name;
  final String paymentType;
  final String mobile;
  final String orderId;
  final String date;
  final String time;
  final double amount;
  final DocumentReference reference;

  Record(this.name, this.mobile, this.orderId, this.date, this.time,
      this.reference, this.amount,this.paymentType);
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['mobile'] != null),
        assert(map['orderId'] != null),
        assert(map['date'] != null),
        assert(map['time'] != null),
        assert(map['amount'] != null),
        assert(map['paymentType'] != null),
        name = map['name'],
        mobile = map['mobile'] == null ? '0' : map['mobile'],
        orderId = map['orderId'],
        date = map['date'],
        paymentType = map['paymentType'],
        amount = map['amount'],
        time = map['time'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class _CustomerVisitsState extends State<CustomerVisits> {
  String dropdownValuePayment = 'All Payment';
  String dropdownValueOrder = 'Order Type';
  var maskFormatter = new MaskTextInputFormatter(mask: '+61 (##) ####-####', filter: { "#": RegExp(r'[0-9]') });
  List<List<dynamic>> csvrow = [];
  DateTime currentDate = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');
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
    var date = dateFormat.format(currentDate);
    var dates = new DateTime.now().toString();
    var dateParse = DateTime.parse(dates);
    var formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(dateParse.toString()));
    var dateStringParsing = new Column(
      children: <Widget>[
        fromSelected != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  new DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(fromSelected.toString())),
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.0180,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  new DateFormat(date)
                      .format(DateTime.parse("2018-09-15 20:18:04Z")),
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.0180,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
      ],
    );
    var dateStringParsingTo = new Column(
      children: <Widget>[
        toSelected != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  new DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(toSelected.toString())),
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.0180,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  new DateFormat(date)
                      .format(DateTime.parse("2018-09-15 20:18:04Z")),
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.0180,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
      ],
    );

    return Scaffold(
      body: SingleChildScrollView(
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
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,color:  Color(0xFFF37325),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "images/wel.png",
                            width: size.width * 0.01,
                            height: size.height * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width* 0.01,
                      ),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.0150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '/',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: size.width * 0.0150,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.person,
                        size: size.width * 0.0150,
                      ),
                      Text(
                        'Sales Report',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.0150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                    'Sales Transactions',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.02,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: size.height * 0.06,
                        // margin: const EdgeInsets.all(7.0),
                        // padding: const EdgeInsets.all(3.0),
                        width: size.width * 0.02,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                fromSelected = fromSelected.subtract(Duration(days: 1,hours: 0,minutes: 0));
                              });
                            },
                            child:Icon(
                              Icons.arrow_back_ios,
                              size:  size.width * 0.02,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            _showDateTimePicker();
                          });
                        },
                        child: Container(
                          height: size.height * 0.06,
                          // margin: const EdgeInsets.all(7.0),
                          // padding: const EdgeInsets.all(3.0),
                          // width:  size.width* 0.1,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                              // border: Border(
                              //   right: BorderSide(
                              //     color: Colors.black,
                              //     width: 1.0,
                              //   ),
                              // ),
                              ),
                          child: dateStringParsing,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            fromSelected = fromSelected.add(Duration(days: 1,hours: 0,minutes: 0));
                          });
                        },
                        child: Container(
                          width: size.width <= 800
                              ? size.width * 0.08
                              : size.width * 0.02,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              // border: Border(
                              //   right: BorderSide(
                              //     color: Colors.black,
                              //     width: 1.0,
                              //   ),
                              // ),
                              ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size:  size.width * 0.02,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: size.height * 0.06,
                        width: size.width * 0.02,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                toSelected = toSelected.subtract(Duration(days: 1,hours: 0,minutes: 0));

                              });
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size:  size.width * 0.02,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          _showDateTimePickerTo();
                        },
                        child: Container(
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            ),
                          child: dateStringParsingTo,
                        ),
                      ),
                      Container(
                        width : size.width * 0.02,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              toSelected = toSelected.add(Duration(days: 1,hours: 0,minutes: 0));
                            });
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size:  size.width * 0.02,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height * 0.06,
                  width: size.width  * 0.09,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: dropdownValueOrder,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.grey.shade300,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValueOrder = newValue;
                          dropdownValueOrder == 'Dine In' ? _searchResult = 'Di': dropdownValueOrder == 'Take Away' ? _searchResult = 'TA' : dropdownValueOrder == 'Delivery' ? _searchResult = 'DY' : _searchResult = '';
                          print(_searchResult);
                        });
                      },
                      items: <String>['Order Type','Dine In', 'Take Away', 'Delivery', ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.06,
                  width: size.width  * 0.09,
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: dropdownValuePayment,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.grey.shade300,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValuePayment = newValue;
                          dropdownValuePayment == 'Cash' ? _searchResult = 'Cash': dropdownValuePayment == 'Card' ? _searchResult = 'Card'  : _searchResult = '';
                          print(_searchResult);
                        });
                      },
                      items: <String>['All Payment','Cash', 'Card', ]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.2,
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                          controller: controller,
                          decoration: new InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _searchResult = value;
                              // usersFiltered = users.where((user) => user.name.contains(_searchResult)).toList();
                            });
                          }),
                      trailing: new IconButton(
                        icon: new Icon(controller.text != ''
                            ? Icons.cancel
                            : Icons.more_horiz),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                            _searchResult = '';
                            // usersFiltered = users;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: fromSelected != null && toSelected != null
                  ? FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser.displayName)
                      .doc('completedPayment')
                      .collection('totalPayment')
                      .where(
                        'date',
                        isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(fromSelected.toString())),
                      )
                      .where(
                        'date',
                        isLessThanOrEqualTo: DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(toSelected.toString())),
                      )
                      .orderBy(
                        'date',descending: true,
                      )
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser.displayName)
                      .doc('completedPayment')
                      .collection('totalPayment')
                      .where('date',
                          isGreaterThanOrEqualTo: formattedDate.toString())
                      .where('date',
                          isLessThanOrEqualTo: formattedDate.toString())
                      .orderBy(
                        'date',descending: true,
                      )
                      .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // print(snapshot.data.docs[0]['amount']);
                  getlist(snapshot);
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortAscending: true,
                      sortColumnIndex: sortColumnIndex,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black,
                        width: 1,
                      )),
                      showBottomBorder: true,
                      columnSpacing: size.width * 0.03,
                      columns: [
                        DataColumn(
                            label: Text(
                          'Order ID',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.02,
                          ),
                        )),
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
                              'Mobile',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.02,
                              ),
                            )),
                        DataColumn(
                          label: Text(
                            'Date / Time',
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
                              'Order Value ',
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
                            'Status',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.02,
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
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                      onPressed: () async {
                        final csvData = ListToCsvConverter().convert(csvrow);
                        html.AnchorElement()
                          ..href =
                              '${Uri.dataFromString(csvData, mimeType: 'text/csv', encoding: utf8)}'
                          ..download = '${formattedDate.toString()}, ${  DateFormat('hh:mm a').format(DateTime.now(),)} .csv'
                          ..style.display = 'none'
                          ..click();
                      },
                      child: Text('Export as CSV')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List getlist(AsyncSnapshot snapshot) {
    csvrow.clear();
    csvrow.add([
      'Name',
      'Mobile Number',
      'ORDER ID',
      'Date',
      'Time',
    ]);
    return snapshot.data.docs.forEach((element) {
      csvrow.add([
        element.get('name'),
        element.get('mobile'),
        element.get('orderId'),
        element.get('date'),
        element.get('time'),
        // element.get('amount')
      ]);
    });
  }

  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> data,
      int snap, String _searchKey) {
    dataRows.clear();
    int k = 1;
    for (int i = 0; i < snap; i++) {
      var record = Record.fromSnapshot(data[i]);

      // print('len $snap');
      if (record.name.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.orderId.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.mobile.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.paymentType.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.amount.toString().contains(_searchKey.toLowerCase()) ||
          record.date.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.time.toLowerCase().contains(_searchKey.toLowerCase())) {
        dataRows.add(DataRow(cells: [
          DataCell(Text(record.orderId.toString())),
          DataCell(InkWell(
              onTap: () {
                print(i);
                print(record.orderId.toString());
                print(data[i]['amount']);
                showModal(data, i);
              },
              child: Text(record.name.toString()))),
          DataCell(Text(record.mobile.toString())),
          DataCell(
            Row(
              children: [
                Text('${record.date.toString()} '),
                Text('${(record.time.toString())}'),
              ],
            ),
          ),
          DataCell(Text(record.amount.toStringAsFixed(2))),
          DataCell(Text('Paid')),
          DataCell(Text(record.paymentType.toString())),
        ]));
      }
    }
    return dataRows;
  }

  showModal(var snapshot, int index) {
    String ordertype;
    String dr;
    double subTotalFinder = ((snapshot[index]['amount']) / (10));
    double subTotal = ((snapshot[index]['amount']) - (subTotalFinder));
    dr = snapshot[index]['orderId'];
    ordertype = dr;
    ordertype = dr.split('0').first;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        return StatefulBuilder(builder: (context, StateSetter setstate) {
          return AlertDialog(
              shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),),
            content: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400)
              ),
              height: screenSize.height * 0.8,
              width: screenSize.width * 0.2,
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(' \$${snapshot[index]['amount'].toStringAsFixed(2)} Payment ',
                         style: TextStyle(
                           color: Colors.black,fontWeight: FontWeight.bold,
                           fontSize: screenSize.width * 0.02,
                         ),
                       ),
                       SizedBox(
                         height: screenSize.height * 0.02,
                       ),
                       Text('${snapshot[index]['date']} ${snapshot[index]['time']}',
                         style: TextStyle(
                           color: Colors.grey.shade600,
                           fontSize: screenSize.width * 0.01,
                         ),
                       ),
                       SizedBox(
                         height: screenSize.height * 0.001,
                       ),
                       Text('Ticket : ${snapshot[index]['orderId']}',
                         style: TextStyle(
                           color: Colors.grey.shade600,
                           fontSize: screenSize.width * 0.01,
                         ),
                       ),
                       SizedBox(
                         height: screenSize.height * 0.001,
                       ),
                       Text('Collected at : ${snapshot[index]['name']}',
                         style: TextStyle(
                           color: Colors.grey.shade600,
                           fontSize: screenSize.width * 0.01,
                         ),
                       ),
                       SizedBox(
                         height: screenSize.height * 0.02,
                       ),
                       const Divider(
                         color: Colors.grey,
                         height: 20,
                         thickness: 2,
                         indent: 3,
                         endIndent: 20,
                       ),
                       Text('${ordertype == 'TA' ? 'Take Away' : ordertype == 'DI' ? " Dine IN" : ordertype == "DY" ? "Delivery" : " order Type"}',
                         style: TextStyle(
                           color: Colors.black,
                           fontWeight: FontWeight.bold,
                           fontSize: screenSize.width * 0.01,
                         ),
                       ),
                       const Divider(
                         color: Colors.grey,
                         height: 20,
                         thickness: 2,
                         indent: 3,
                         endIndent: 20,
                       ),
                       ListView.builder(
                         scrollDirection: Axis.vertical,
                         shrinkWrap: true,
                         itemCount: snapshot[index]['itemname'].length,
                         itemBuilder: (context, int i) {
                           return ListTile(
                             title: Text(snapshot[index]['itemname'][i].toString(),
                               style: TextStyle(
                                 color: Colors.black,
                                 fontWeight: FontWeight.bold,
                                 fontSize: screenSize.width * 0.01,
                               ),
                             ),
                             subtitle: Text('\$${((snapshot[index]['productPriceList'][i])/(snapshot[index]['quantity'][i]) )} X ${snapshot[index]['quantity'][i].toString()}',
                               style: TextStyle(
                                 color: Colors.grey.shade400,
                                 fontSize: screenSize.width * 0.01,
                               ),
                             ),
                             trailing: Text(snapshot[index]['productPriceList'][i].toString(),
                               style: TextStyle(
                                 color: Colors.black,
                                 fontWeight: FontWeight.bold,
                                 fontSize: screenSize.width * 0.01,
                               ),
                             ),
                           );
                         }
                       ),
                       const Divider(
                         color: Colors.grey,
                         height: 20,
                         thickness: 2,
                         indent: 3,
                         endIndent: 20,
                       ),
                       ListTile(
                         title: Text('SubTotal',
                           style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.bold,
                             fontSize: screenSize.width * 0.01,
                           ),
                         ),
                         subtitle: Text(' Tax Included : 10%',
                           style: TextStyle(
                             color: Colors.grey.shade400,
                             fontSize: screenSize.width * 0.01,
                           ),
                         ),
                         trailing: Text(subTotal.toStringAsFixed(2),
                           style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.bold,
                             fontSize: screenSize.width * 0.01,
                           ),
                         ),
                       ),
                       const Divider(
                         color: Colors.grey,
                         height: 20,
                         thickness: 2,
                         indent: 3,
                         endIndent: 20,
                       ),
                       ListTile(
                         title: Text('Total',
                           style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.bold,
                             fontSize: screenSize.width * 0.01,
                           ),
                         ),
                         trailing: Text(snapshot[index]['amount'].toStringAsFixed(2),
                           style: TextStyle(
                             color: Colors.black,
                             fontWeight: FontWeight.bold,
                             fontSize: screenSize.width * 0.01,
                           ),
                         ),
                       ),
                     ],
                   ),
                    ],
                  )),
            ),
          );
        });
      },
    );
  }

}


