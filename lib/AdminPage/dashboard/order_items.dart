import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';


class OrderItems extends StatefulWidget {
  @override
  _OrderItemsState createState() => _OrderItemsState();
}
class Animal {
  final String name;
  final int id;
  Animal({
    this.name,
    this.id,
  });
}

class Record {
  final String name;
  final List category;
  final double price;
  final String image;
  final DocumentReference reference;

  Record(this.name,
      this.reference, this.price,this.category,this.image);
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['cat'] != null),
        assert(map['price'] != null),
        assert(map['imgUrl'] != null  ),
        name = map['name'],
        category = map['cat'],
        image = map['imgUrl']  ,
        price = map['price'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
class _OrderItemsState extends State<OrderItems> {
  var maskFormatter = new MaskTextInputFormatter(mask: '+61 (##) ####-####', filter: { "#": RegExp(r'[0-9]') });
  List _items = [];
  var attributesName = [];
  var attributesPrice = [];
  String dropdownValueCategory = 'All Categories';
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  List <String> items =['All Categories',];
  List<DataRow> dataRows = [];
  int sortColumnIndex;
  List<User> usersFiltered = [];
  int _currentSortColumn = 0;
  bool _isAscending = true;
  List _products = [];
  List<List<dynamic>> csvTable = [];
  List<List<dynamic>> csvTableAttributes = [];
  var record ;
  Uint8List uploadedCsv;
  String option1Text;
  String image;
  static List<Animal> _animals = [
    // Animal( name: "Lion"),
    // Animal( name: "Flamingo"),
  ];

  List _selectedAnimals5 = [ ];
  getData() async {
    var snap = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.displayName)
        .doc("categories")
        .collection('category')
        .get();
    snap.docs.forEach((element) {
     setState(() {
       items.add(element.get('category'));
       _animals.add(Animal(name: element.get('category')));
     });
    });
   setState(() {
     _items = _animals
        .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
        .toList();
  });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    usersFiltered = dataRows.cast<User>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton:  Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: (){
                _startFilePicker();
              },
              child: Card(
                color: Color(0xFFF37325),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Import Order CSV'),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                _startFilePickerAttributes();
              },
              child: Card(
                color: Color(0xFFF37325),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Import Attributes CSV'),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
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
                      'Create an Item',
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
            padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 50),
            child: SizedBox(
              height:size .height * 0.8 ,
              width: size.width,
              child: Card(
                elevation: 20,
                color: Colors.grey[300],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: size.height * 0.06,
                              width: size.width  * 0.1,
                              color: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: dropdownValueCategory,
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
                                      dropdownValueCategory = newValue;
                                       _searchResult = newValue;
                                      dropdownValueCategory == 'All Categories' ? _searchResult = '': dropdownValueCategory;
                                    });
                                  },
                                  items: items
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
                                    showAlertDialogCreateItems(context,items);
                                  });
                                },
                                child: Card(
                                  color: Color(0xFFF37325),
                                  child: Center(child: Text('Create an Item',style: TextStyle(color: Colors.white,),)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream:  FirebaseFirestore.instance
                            .collection(FirebaseAuth.instance.currentUser.displayName)
                            .doc('itemDetails')
                            .collection('items')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                sortColumnIndex: _currentSortColumn,
                                sortAscending: _isAscending,
                                headingRowColor: MaterialStateProperty.all(Colors.amber[200]),
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
                                        'Item ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.02,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        'Category',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.02,
                                        ),
                                      )),
                                  DataColumn(
                                      label: Text(
                                        'Price',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width * 0.02,
                                        ),
                                      ),

                                    ),
                                  DataColumn(
                                      label: Text(
                                        'Image',
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
                      Column(
                        children: [
                          SingleChildScrollView(
                            child: csvTable.isEmpty
                                ? Container()
                                : Padding(
                                  padding: const EdgeInsets.only(left: 80,right: 80),
                                  child: Table(
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
                                ),
                          ),
                          csvTable.isEmpty ? Container():  InkWell(onTap: (){
                            csvTable.removeAt(0);
                            csvTable.forEach((element) {
                              String removeMark = element[0];
                              print(removeMark.replaceAll('ï»¿', ''));
                              String string =  '${element[1]}';
                              var cat = [];
                              string.split(',').forEach((element) {
                                cat.add(element);
                              });
                              FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.displayName).doc('itemDetails').collection('items').add({
                                'name' : element.length >= 1 ?  removeMark :'' ,
                                'cat' : element.length >= 2 ?  cat :'' ,
                                'price' : element.length >= 3 ? element[2] : ''  ,
                                'imgUrl' : 'NI',
                              }).then((value) {
                               setState(() {
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height:size .height * 0.6 ,
              width: size.width * 0.3,
              child: Card(
                elevation: 20,
                color:  Colors.grey[300],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Attributes',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.02,
                        ),),
                      StreamBuilder(
                          stream:  FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser.displayName)
                      .doc('itemDetails')
                      .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot snapshot ){
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            else
                              {
                                // print(snapshot.data['attributesName'].length);
                                return
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data['attributesName'].length,
                                        itemBuilder: (context, int index) {
                                          return ListTile(
                                            title: Text(snapshot.data['attributesName'][index]),
                                            trailing: Text(snapshot.data['attributesPrice'][index].toString()),
                                            // subtitle: InkWell(
                                            //   onTap: (){
                                            //     FirebaseFirestore.instance
                                            //         .collection(FirebaseAuth.instance.currentUser.displayName)
                                            //         .doc('itemDetails').update({'attributesName': FieldValue.delete()}).whenComplete((){
                                            //       print('Field Deleted');
                                            //     });
                                            //   },
                                            //   child: Icon(Icons.delete),
                                            // ),
                                          );
                                        }
                                      ),
                                    );
                              }

                      }),
                      Column(
                        children: [
                          SingleChildScrollView(
                            child: csvTableAttributes.isEmpty
                                ? Container()
                                : Padding(
                              padding: const EdgeInsets.only(left: 80,right: 80),
                              child: Table(
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
                                children: csvTableAttributes.map((item) {
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
                            ),
                          ),
                          csvTableAttributes.isEmpty ? Container():  InkWell(onTap: (){
                            csvTableAttributes.removeAt(0);
                            csvTableAttributes.forEach((element) {
                              String removeMark = element[0];
                              print(removeMark.replaceAll('ï»¿', ''));
                              String string =  '${element[1]}';

                              attributesName.add(element[0]);
                              attributesPrice.add(element[1]);

                              FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.displayName).doc('itemDetails').update({
                                'attributesName' : element.length >= 1 ?  attributesName :'' ,
                                'attributesPrice' : element.length >= 1 ? attributesPrice : ''  ,
                              }).then((value) {
                                setState(() {
                                  csvTableAttributes.clear();
                                });
                              }
                              );
                            });
                            print('attri $attributesName');
                            print('attriprice $attributesPrice');
                          }, child: Card(
                            color: Color(0xFFF37325),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Save',style: TextStyle(color: Colors.white),),
                            ),),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> data,
      int snap, String _searchKey) {
    dataRows.clear();
    int k = 1;
    String docId;
    // int j = data.docs
    for (int i = 0; i < snap; i++) {
       record = Record.fromSnapshot(data[i]);
       bool check;
       // ignore: unnecessary_statements
       record.image.toString().contains('NI') ? check = false : true ;
       if (record.name.toLowerCase().contains(_searchKey.toLowerCase()) ||
           record.price.toString().contains(_searchKey) ||
           record.image.toLowerCase().contains(_searchKey.toLowerCase()) ||
          record.category.toString().toLowerCase().contains(_searchKey.toLowerCase())) {
        dataRows.add(DataRow(cells: [
          DataCell(InkWell(
              onTap: (){
                setState(() {
                  docId = data[i].id;
                  showAlertDialogEditItems( context,  Record.fromSnapshot(data[i]),dataRows,docId);
                });
              },
              child: Text(record.name.toString()))),
          DataCell(InkWell(
              onTap: (){
                setState(() {
                  docId = data[i].id;
                  showAlertDialogEditItems( context,  Record.fromSnapshot(data[i]),dataRows,docId);
                });
              },
              child: Text(record.category.toString().replaceAll('[', '').replaceAll(']', '')))),
          DataCell(InkWell(
              onTap: (){
                setState(() {
                  docId = data[i].id;
                  showAlertDialogEditItems( context,  Record.fromSnapshot(data[i]),dataRows,docId);
                });
              },
              child: Text(record.price.toStringAsFixed(2)))),
          DataCell(InkWell(
              onTap: (){
                setState(() {
                  docId = data[i].id;
                  showAlertDialogEditItems( context,  Record.fromSnapshot(data[i]),dataRows,docId);
                });
              },
              child: Center(child: check != false ? Text('Image') : Text('No Image')))),
          DataCell(InkWell(
              onTap: (){
                setState(() {
                  docId = data[i].id;
                  FirebaseFirestore.instance
                      .collection(FirebaseAuth.instance.currentUser.displayName)
                      .doc('itemDetails')
                      .collection('items').doc(docId).delete();
                });
              },
              child: Center(child: Icon(Icons.delete_forever,color: Colors.black,)))),
        ]));
      }
    }
    return dataRows;
  }

  Widget showAlertDialogEditItems(BuildContext context,var  lis,List cat,String  docId ) {
    Size size = MediaQuery.of(context).size;
    // set up the buttons
    print( 'lis ${lis.category.toString().replaceAll('[', '').replaceAll(']', '')}');
    String cate = lis.category.toString().replaceAll('[', '').replaceAll(']', '');
    List categories= [];
    // ignore: non_constant_identifier_names
    List MultiCategories= [];
    cate.split(',').forEach((element) {
      categories.add(element);
    });

   // setState(() {
   //   _selectedAnimals5 = categories;
   // });


    print( 'cate ${cate}');

    String dropdownValueDialog = 'All Categories';
    String firstName;
    TextEditingController categoryController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    String itemName;

    double price;
    print('catt : $categories');
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
        firstName = categoryController.text;

        await FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.displayName)
            .doc("itemDetails").collection('items').doc(docId)
            .update({
          "cat": MultiCategories.isEmpty ? categories : MultiCategories,
          "imgUrl" : image == null ? lis.image : image,
          "name" : itemName  == null ? lis.name : itemName,
          "price" : price  == null ? lis.price : price,
          // "Status" : status,
        }).then((value) {
          MultiCategories.clear();
          _selectedAnimals5.clear();
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
            "Edit an Item ",
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
              // decoration: BoxDecoration(
              //   border: Border(
              //     left: BorderSide(
              //       //                   <--- left side
              //       color: Colors.deepOrange[100],
              //       width: 15.0,
              //     ),
              //     top: BorderSide(
              //       //                    <--- top side
              //       color: Colors.deepOrange[100],
              //       width: 10.0,
              //     ),
              //     right: BorderSide(
              //       //                    <--- top side
              //       color: Colors.deepOrange[500],
              //       width: 5.0,
              //     ),
              //     bottom: BorderSide(
              //       //                    <--- top side
              //       color: Colors.deepOrange[800],
              //       width: 3.0,
              //     ),
              //   ),
              // ),
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
                                   'Name',
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
                                  RegExp('[a-z,A-Z]')),],
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              controller: categoryController,
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
                            height: size.height * 0.09,
                            width: size.width * 0.1,
                            child: Center(
                              child: Text(
                                'Category',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                  fontSize: size.width * 0.01,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.275,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade400)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  MultiSelectDialogField(
                                onConfirm: (val) {
                                  _selectedAnimals5 = val;
                                  print(' _selectedAnimals5 ${ _selectedAnimals5}');
                                  setState(() {
                                    // val.map((e) => categories.add(Animal(name: e)));
                                    print('_selectedAnimals5 ${_selectedAnimals5.map((e) => MultiCategories.add(e.name))}');
                                    print('---> $MultiCategories');
                                  });

                                },
                                items: _items,
                                initialValue:
                                _selectedAnimals5, // setting the value of this in initState() to pre-select values.
                              ),
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
                                'Price',
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
                                    RegExp('[1-9 0 .]')),],
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              controller: priceController,
                              onChanged: (value){
                                price = double.parse(value);
                                print('price $price');
                              },
                              autofillHints: [AutofillHints.givenName],
                              decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: lis.price != 0 ? lis.price.toString() : '\$0.00',
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

                      InkWell(
                        onTap: (){
                          setState(() {
                            // categoryController.text == null ||   categoryController.text ==''? print('Null Name'):
                            uploadToStorage(fileName: categoryController.text ==''? lis.name.toString() :categoryController.text );
                            print(categoryController.text);
                          });
                        },
                        child: Card(color:Colors.deepOrange[300],
                          elevation: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Upload',style: TextStyle(color: Colors.white),),
                          ),
                        ),
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
  Widget showAlertDialogCreateItems(BuildContext context,List cat) {
    Size size = MediaQuery.of(context).size;
    // set up the buttons
    // print( 'lis ${lis.name}');
    String dropdownValueDialog = 'All Categories';
    String firstName;
    TextEditingController categoryController = TextEditingController();
    TextEditingController taxesController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    String itemName;
    List categories= [];
    int taxes;
    double price;
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
        firstName = categoryController.text;

        await FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.displayName)
            .doc("itemDetails").collection('items').doc()
            .set({
          "cat": categories,
          "imgUrl" : image == null ? 'NI' : image,
          "name" : itemName,
          "price" : price,
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
            "Create an Item ",
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
                // decoration: BoxDecoration(
                //   border: Border(
                //     left: BorderSide(
                //       //                   <--- left side
                //       color: Colors.deepOrange[100],
                //       width: 15.0,
                //     ),
                //     top: BorderSide(
                //       //                    <--- top side
                //       color: Colors.deepOrange[100],
                //       width: 10.0,
                //     ),
                //     right: BorderSide(
                //       //                    <--- top side
                //       color: Colors.deepOrange[500],
                //       width: 5.0,
                //     ),
                //     bottom: BorderSide(
                //       //                    <--- top side
                //       color: Colors.deepOrange[800],
                //       width: 3.0,
                //     ),
                //   ),
                // ),
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
                                   'Name',
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
                                controller: categoryController,
                                onChanged: (value){
                                  itemName = value;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[a-z,A-Z]')),],
                                autofillHints: [AutofillHints.givenName],
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: 'Item Name',
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
                              height: size.height * 0.09,
                              width: size.width * 0.1,
                              child: Center(
                                child: Text(
                                  'Category',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: size.width * 0.01,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * 0.275,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade400)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:  MultiSelectDialogField(
                                  onConfirm: (val) {
                                    _selectedAnimals5 = val;
                                    print(' _selectedAnimals5 ${ _selectedAnimals5}');
                                    setState(() {
                                      // val.map((e) => categories.add(Animal(name: e)));
                                      print('_selectedAnimals5 ${_selectedAnimals5.map((e) => categories.add(e.name))}');
                                    });

                                  },
                                  items: _items,
                                  initialValue:
                                  _selectedAnimals5, // setting the value of this in initState() to pre-select values.
                                ),
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
                                  'Price',
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
                                      RegExp('[1-9 0 .]')),],
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                controller: priceController,
                                onChanged: (value){
                                  price = double.parse(value);
                                },
                                autofillHints: [AutofillHints.givenName],
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: '\$0.00',
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
                        InkWell(
                          onTap: (){
                            setState(() {
                              categoryController.text == null ||   categoryController.text ==''? print('Null Name'):
                              uploadToStorage(fileName: categoryController.text);
                              print(categoryController.text);
                            });
                          },
                          child: Card(color:Colors.deepOrange[300],
                            elevation: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Upload',style: TextStyle(color: Colors.white),),
                            ),
                          ),
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

  void uploadImage({@required Function(File file) onSelected}) {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
        showDialog(
            context:context,
            builder: (BuildContext context) {
              return
                AlertDialog(content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircularProgressIndicator(),
                      Text('Loading...')
                    ]
                ),);

            }
        );
      });
    });
  }

  void uploadToStorage({fileName}) {
    final path = '${FirebaseAuth.instance.currentUser.displayName}items/$fileName';
    uploadImage(onSelected: (file) {
      fb
          .storage()
          .refFromURL('gs://restaurantpos-6ceb4.appspot.com/')
          .child(path)
          .put(file)
          .future
          .then((data) async {
        Uri uri = await data.ref.getDownloadURL();
        image = uri.toString();
        Navigator.pop(context);
      });
    });
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
            print(csvTable);
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
  _startFilePickerAttributes() {
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
            csvTableAttributes =
                CsvToListConverter().convert(String.fromCharCodes(uploadedCsv));
            print(csvTableAttributes);
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
}


// FirebaseAuth.instance.currentUser.displayName

// dropdownValueDialog == 'Cash' ? _searchResult = 'Cash': dropdownValueCategory == 'Debit' ? _searchResult = 'Debit' : dropdownValueCategory == 'Credit' ? _searchResult = 'Credit' : _searchResult = '';



class ToggleButton extends StatefulWidget {
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Flutter Switch Example"),
      ),
      body: Center(
        child: Switch(
          value: isSwitched,
          onChanged: (value){
            setState(() {
              isSwitched=value;
              print(isSwitched);
            });
          },
          activeTrackColor: Colors.lightGreenAccent,
          activeColor: Colors.green,
        ),
      ),
    );
  }
}