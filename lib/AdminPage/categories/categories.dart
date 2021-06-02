import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<List<dynamic>> csvTable = [];
  Uint8List uploadedCsv;
  String option1Text;
  TextEditingController categoryController = TextEditingController();
  String catName;
  String docId;
  var maskFormatter = new MaskTextInputFormatter(mask: '+61 (##) ####-####', filter: { "#": RegExp(r'[0-9]') });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
      body: Column(
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
                        shape: BoxShape.circle, color: Color(0xFFF37325),
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
                      width: size.width * 0.01,
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
                      width: size.width * 0.01,
                    ),
                    Text(
                      'Create a Category ',
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
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: SizedBox(
              height: size.height * 0.6,
              width: size.width * 0.6,
              child: Card(
                elevation: 20,
                color: Colors.grey[300],
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      ListTile(
                        title: Text('Categories',
                          style: TextStyle(color: Colors.black,
                              fontSize: size.width * 0.02,
                              fontWeight: FontWeight.bold),),
                        subtitle: Text(
                          'Categories help you arrange and organize your items, report on item sales and route items to specific printers',
                          textAlign: TextAlign.justify,),
                        trailing: InkWell(
                          onTap: () {
                            setState(() {
                              showAlertDialogCategory(context);
                            });
                          },
                          child: Card(
                            color: Color(0xFFF37325),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Create a Category ',
                                style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SizedBox(
                        height: size.height * 0.5,
                        width: size.width * 0.3,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text('Categories', style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.01,
                                      fontWeight: FontWeight.bold),),
                                  const Divider(
                                    color: Colors.grey,
                                    height: 20,
                                    thickness: 2,
                                    indent: 3,
                                    endIndent: 20,
                                  ),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection(FirebaseAuth.instance.currentUser.displayName).doc(
                                          'categories')
                                          .collection('category')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: Column(
                                              children: [
                                                Text('Loading Please wait'),
                                                CircularProgressIndicator(),
                                              ],
                                            ),
                                          );
                                        }

                                        return
                                          ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: snapshot.data.docs
                                                  .length,
                                              itemBuilder: (context,
                                                  int index) {
                                                // String demo;
                                                // final List<GlobalObjectKey<FormState>> formKeyList = List.generate(snapshot.data.docs.length, (index) => GlobalObjectKey<FormState>(index));
                                                // demo = snapshot.data.docs[index]['category'];
                                                //   topTenGames.add(demo);
                                                //   print(demo);
                                                //   print(topTenGames);
                                                return
                                                  Container(
                                                    color: Colors.white,
                                                    child: ListTile(
                                                      title: Text(snapshot.data
                                                          .docs[index]['category'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: size.width *
                                                              0.01,
                                                          fontStyle: FontStyle
                                                              .italic,
                                                          letterSpacing: 2,),),
                                                      trailing: InkWell(
                                                          onTap: () {
                                                            docId =
                                                                snapshot.data
                                                                    .docs[index]
                                                                    .id;
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                FirebaseAuth.instance.currentUser.displayName).doc(
                                                                'categories')
                                                                .collection(
                                                                'category').doc(
                                                                docId)
                                                                .delete();
                                                          },
                                                          child: Icon(Icons
                                                              .delete_forever,
                                                            color: Color(
                                                                0xFFF37325),)),
                                                    ),
                                                  );
                                              });
                                      }),
                                  // SizedBox(
                                  //   width: 300,
                                  //   height: 200,
                                  //   child: ReorderableListView(
                                  //     shrinkWrap: true,
                                  //     onReorder: onReorder,
                                  //     children: getListItems(),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                                  0: FixedColumnWidth(300.0),
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
                                  String cat = element[0].toString();
                                  print('element : ${element}');
                                  print('csv : ${csvTable}');
                                  FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.displayName).doc('categories').collection('category').add({
                                    'category' : element.length >= 1 ?  cat :'',
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
              ),
            ),
          ),
        ],
      ),
    );
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
            csvTable.map((e) => print(e.toString()));
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
  Widget showAlertDialogCategory(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    // set up the buttons

    String firstName;
    TextEditingController categoryController = TextEditingController();
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
            .doc("categories").collection('category').doc()
            .set({
          "category": firstName,
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
            "Categories",
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
        child: Container(
          height: size.height * 0.2,
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
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey.shade400)),
                        height: size.height * 0.06,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-z,A-Z]')),],
                          autofillHints: [AutofillHints.givenName],
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Category',
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
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: size.height * 0.05,
                          width: size.width * 0.05,
                          child: Card(
                            color: Color(0xFFF37325),
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