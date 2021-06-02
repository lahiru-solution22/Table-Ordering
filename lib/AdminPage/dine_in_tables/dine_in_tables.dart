import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';



class DineInTables extends StatefulWidget {
  @override
  _DineInTablesState createState() => _DineInTablesState();
}

class Record {
  final int name;
  final String Status;
  final String NoOfGuests;
  final DocumentReference reference;

  Record(this.name,
      this.reference, this.Status,this.NoOfGuests);
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['Name'] != null),
        assert(map['Status'] != null),
        assert(map['NoOfGuests'] != null),
        name = map['Name'],
        Status = map['Status'] == null ? '' : map['Status'],
        NoOfGuests = map['NoOfGuests'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

class _DineInTablesState extends State<DineInTables> {
  List<List<dynamic>> csvTable = [];
  Uint8List uploadedCsv;
  String option1Text;
  var maskFormatter = new MaskTextInputFormatter(mask: '+61 (##) ####-####', filter: { "#": RegExp(r'[0-9]') });
  TextEditingController controller = TextEditingController();
  String _searchResult = '';


  var record ;
  List<DataRow> dataRows = [];
  List usersFiltered = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;


  getData() async{
    var snap = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.displayName)
        .doc("tableDetails")
        .collection('TableNo')
        .get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    usersFiltered = dataRows;
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton:  InkWell(
        onTap: (){
          _startFilePicker();
        },
        child: Card(
          color: Color(0xFFF37325),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Import CSV'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                          shape: BoxShape.circle,color: Color(0xFFF37325),
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
                            color: Colors.deepOrange[300],
                            fontSize: size.width * 0.0150,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.people,
                        size: size.width * 0.0150,
                      ),
                      SizedBox(
                        width: size.width* 0.01,
                      ),
                      Text(
                        'Create Dine In Table',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: SizedBox(
                    height: size.height * 0.06,
                    width: size.width * 0.4,
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
                SizedBox(
                  height: size.height * 0.06,
                  width: size.width * 0.2,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        showAlertDialogCreateItems(context,);
                      });
                    },
                    child: Card(
                      color: Color(0xFFF37325),
                      child: Center(child: Text(  'Create Dine In Table',style: TextStyle(color: Colors.white,),)),
                    ),
                  ),
                )
              ],
            ),
            StreamBuilder(
              stream:  FirebaseFirestore.instance
                  .collection(FirebaseAuth.instance.currentUser.displayName)
                  .doc('tableDetails')
                  .collection('TableNo')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  // print(snapshot.data.docs[2]['cat'][0]);
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: _currentSortColumn,
                      sortAscending: _isAscending,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                      showBottomBorder: true,
                      columnSpacing: size.width * 0.12,
                      columns: [
                        DataColumn(
                            label: Text(
                              'Table No ',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.02,
                              ),
                            )),
                        DataColumn(
                            label: Text(
                              'No Of Guests',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.02,
                              ),
                            )),
                        DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.02,
                              ),
                            )),
                        DataColumn(
                            label: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.02,
                              ),
                            )),
                      ],
                      rows: _buildList(context, snapshot.data.documents,
                          snapshot.data.docs.length, _searchResult),
                    ),
                  );
                }
              },
            ),
            SingleChildScrollView(
              child: csvTable.isEmpty
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.only(left: 80,right: 80),
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FixedColumnWidth(100.0),
                      },
                      border: TableBorder.symmetric(
                        outside: BorderSide(
                          //                   <--- left side
                          color: Colors.black,
                          width: 2.0,
                        ),
                        inside: BorderSide(
                          //                   <--- left side
                          color: Colors.grey,
                          width: 1.0,
                        ),),
                      children: csvTable.map((item) {
                        return TableRow(
                            children: item.map((row) {
                              return Container(
                                // color: row.toString().contains("NA")
                                //     ? Colors.red
                                //     : Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    row.toString().replaceAll('ï»¿', ''),
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                              );
                            }).toList());
                      }).toList(),
                    ),
                    csvTable.isEmpty ? Container():  InkWell(onTap: (){
                       csvTable.removeAt(0);
                      csvTable.forEach((element) {
                        String intToString0 = element[0].toString();
                        String intToString1 = element[1].toString();
                       print('element : ${element}');
                       print('csv : ${csvTable}');
                        FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.displayName).doc('tableDetails').collection('TableNo').add({
                          'Name' : element.length >= 1 ?  intToString0 :'',
                          'NoOfGuests' : element.length >= 2 ? intToString1 : '',
                          'Status' : '',
                          "dateStamp" : DateTime.now().toIso8601String(),
                        }).then((value) {
                          setState(() {
                            print('firebase updated');
                            csvTable.clear();
                          });
                        }
                        );
                      });
                    }, child: Card(
                      color: Color(0xFFF37325),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Save',style: TextStyle(color: Colors.white),),
                      ),),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> data,
      int snap, String _searchKey) {
    dataRows.clear();
    int k = 1;
    String docId;
    // int j = data.docs
    for (int i = 0; i < snap; i++) {
      record = Record.fromSnapshot(data[i]);
      // print(data[i]['cat']);
      // print('len $snap');
      bool check;
      // ignore: unnecessary_statements
      if (
          record.NoOfGuests.toString().toLowerCase().contains(_searchKey.toLowerCase()) ||
    record.Status.toString().toLowerCase().contains(_searchKey.toLowerCase())) {
        dataRows.add(DataRow(cells: [
          DataCell(InkWell(
              onTap: (){
                docId = data[i].id;
                showAlertDialogEditItems( context,  Record.fromSnapshot(data[i]),  docId );
              },
              child: Text(record.name.toString()))),
          DataCell(InkWell(
              onTap: (){
                docId = data[i].id;
                showAlertDialogEditItems( context,  Record.fromSnapshot(data[i]),  docId );
              },
              child: Text(record.NoOfGuests.toString()))),
          DataCell(InkWell(
            onTap: (){
              docId = data[i].id;
              showAlertDialogEditItems( context,  Record.fromSnapshot(data[i]),  docId );
            },
              child: Text(record.Status.toString()))),
          DataCell(InkWell(
              onTap: (){
                setState(() {
                  docId = data[i].id;
                  FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser.displayName)
                      .doc('tableDetails')
                      .collection('TableNo').doc(docId).delete();
                });
              },
              child: Center(child: Icon(Icons.delete_forever,color: Colors.black,)))),
        ]));
      }
    }
    return dataRows;
  }
  _startFilePicker() {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      final files = uploadInput.files;
      if (files.length == 1) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedCsv = Base64Decoder()
                .convert(reader.result.toString().split(",").last);
            csvTable =
                CsvToListConverter().convert(String.fromCharCodes(uploadedCsv));
          });
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            option1Text = "Some Error occured while reading the file";
          });
        });

        reader.readAsDataUrl(file);
      }
    });
  }

  Widget showAlertDialogEditItems(BuildContext context,var  lis,String  docId ) {
    Size size = MediaQuery.of(context).size;
    // set up the buttons
    TextEditingController noOfGuestsController = TextEditingController();
    TextEditingController statusController = TextEditingController();
    TextEditingController itemNameController = TextEditingController();
    String itemName;
    print('no of guests ${lis.NoOfGuests}');
    String Status;
    String NoOfGuests;
    int tableNo;
    Widget continueButton = FlatButton(
      child: Text(
        "Save",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.white,
          fontSize: size.width * 0.01,
        ),
      ),
      onPressed: () async {
        Status = statusController.text;
        itemName = itemNameController.text;
        NoOfGuests = noOfGuestsController.text;
        tableNo = int.parse(itemName);
        await FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.displayName)
            .doc("tableDetails").collection('TableNo').doc(docId)
            .update({
          "Name" : tableNo  == null || tableNo  == '' ? lis.name : tableNo,
          "Status" : Status  == null || Status  == '' ? lis.Status : Status,
          "NoOfGuests" : NoOfGuests  == null || NoOfGuests  == '' ? lis.NoOfGuests : NoOfGuests,
          // "Status" : status,
        }).then((value) {
          Navigator.pop(context);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: size.width * 0.02,
            ),
          ),
          Spacer(),
          Text(
            'Edit Dine In Table',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.02),
          ),
          Spacer(),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
            builder:   (BuildContext context,
                StateSetter showstate) {
              return Container(
                height: size.height * 0.43,
                width: size.width * 0.4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Details',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20,),),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(color: Colors.grey.shade400)),
                              height: size.height * 0.06,
                              width: size.width * 0.1,
                              child: Center(
                                child: Text(
                                  'Table No',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: size.width * 0.01,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.06,
                              width: size.width * 0.275,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400)),
                              child: TextFormField(
                                validator: (String value) {
                                  if (value.length < 3)
                                    return " Enter at least 3 character from Customer Name";
                                  else
                                    return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[1-9 0 ]')),],
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                controller: itemNameController,
                                onChanged: (value){
                                  itemName = value;
                                },
                                autofillHints: [AutofillHints.givenName],
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: lis.name != 0 ? lis.name.toString() : 'Item Name',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: size.width * 0.01,
                                    ),
                                    hoverColor: Colors.white,
                                    filled: true,
                                    focusColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(color: Colors.grey.shade400)),
                              height: size.height * 0.06,
                              width: size.width * 0.1,
                              child: Center(
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: size.width * 0.01,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.06,
                              width: size.width * 0.275,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400)),
                              child: TextFormField(
                                validator: (String value) {
                                  if (value.length < 3)
                                    return " Enter at least 3 character from Customer Name";
                                  else
                                    return null;
                                },
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                controller: statusController,
                                onChanged: (value){
                                  Status = value;
                                },
                                autofillHints: [AutofillHints.givenName],
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: lis.Status != 0 ? lis.Status.toString() : ' Status',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: size.width * 0.01,
                                    ),
                                    hoverColor: Colors.white,
                                    filled: true,
                                    focusColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(color: Colors.grey.shade400)),
                              height: size.height * 0.06,
                              width: size.width * 0.1,
                              child: Center(
                                child: Text(
                                  'No Of Guests',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: size.width * 0.01,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.06,
                              width: size.width * 0.275,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400)),
                              child: TextFormField(
                                validator: (String value) {
                                  if (value.length < 3)
                                    return " Enter at least 3 character from Customer Name";
                                  else
                                    return null;
                                },
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                controller: noOfGuestsController,
                                onChanged: (value){
                                  Status = value;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[1-9 0 ]')),],
                                autofillHints: [AutofillHints.givenName],
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: lis.NoOfGuests != 0 ? lis.NoOfGuests.toString() : 'No Of Guests',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: size.width * 0.01,
                                    ),
                                    hoverColor: Colors.white,
                                    filled: true,
                                    focusColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                                width:  size.width * 0.05,
                                child: Card(
                                  color: Colors.deepOrange[500],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: continueButton,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Widget showAlertDialogCreateItems(BuildContext context, ) {
    Size size = MediaQuery.of(context).size;
    // set up the buttons
    TextEditingController noOfGuestsController = TextEditingController();
    TextEditingController statusController = TextEditingController();
    TextEditingController itemNameController = TextEditingController();
    String itemName;
    String Status;
    String NoOfGuests;
    int tableNo;
    Widget continueButton = FlatButton(
      child: Text(
        "Save",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.white,
          fontSize: size.width * 0.01,
        ),
      ),
      onPressed: () async {
        tableNo = int.parse(itemName);
        Status = statusController.text;
        itemName = itemNameController.text;
        NoOfGuests = noOfGuestsController.text;
        await FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.displayName)
            .doc("tableDetails").collection('TableNo').doc()
            .set({
          "Name" : tableNo,
          "NoOfGuests" : NoOfGuests,
          "Status" : '',
          "dateStamp" : DateTime.now().toIso8601String(),
        }).then((value) {
          Navigator.pop(context);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              size: size.width * 0.02,
            ),
          ),
          Spacer(),
          Text(
            'Create Dine In Table',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.02),
          ),
          Spacer(),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StatefulBuilder(
            builder:   (BuildContext context,
                StateSetter showstate) {
              return Container(
                height: size.height * 0.3,
                width: size.width * 0.4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Details',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:20,),),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(color: Colors.grey.shade400)),
                              height: size.height * 0.06,
                              width: size.width * 0.1,
                              child: Center(
                                child: Text(
                                  'Table No',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: size.width * 0.01,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.06,
                              width: size.width * 0.275,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400)),
                              child: TextFormField(
                                validator: (String value) {
                                  if (value.length < 3)
                                    return " Enter at least 3 character from Customer Name";
                                  else
                                    return null;
                                },
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                controller: itemNameController,
                                onChanged: (value){
                                  itemName = value;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[1-9 0 ]')),],
                                autofillHints: [AutofillHints.givenName],
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Table No',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: size.width * 0.01,
                                    ),
                                    hoverColor: Colors.white,
                                    filled: true,
                                    focusColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(color: Colors.grey.shade400)),
                              height: size.height * 0.06,
                              width: size.width * 0.1,
                              child: Center(
                                child: Text(
                                  'No Of Guests',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: size.width * 0.01,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * 0.06,
                              width: size.width * 0.275,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400)),
                              child: TextFormField(
                                validator: (String value) {
                                  if (value.length < 3)
                                    return " Enter at least 3 character from Customer Name";
                                  else
                                    return null;
                                },
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                controller: noOfGuestsController,
                                onChanged: (value){
                                  Status = value;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[1-9 0 ]')),],
                                autofillHints: [AutofillHints.givenName],
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText:  'No Of Guests',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                      fontSize: size.width * 0.01,
                                    ),
                                    hoverColor: Colors.white,
                                    filled: true,
                                    focusColor: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                                width:  size.width * 0.05,
                                child: Card(
                                  color: Colors.deepOrange[500],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: continueButton,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
