import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:check_in_system/AdminPage/dashboard/admin_dashboard.dart';
import 'package:check_in_system/AdminPage/dashboard/order_items.dart';
import 'package:check_in_system/AdminPage/login/admin_login.dart';
import 'package:check_in_system/demo2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'AdminPage/login/admin_register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    // print(Uri.base);
    // var url = window.location.href;
    // print('url $url');
    // print(url.split('#').last);
    return  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'POS Admin',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
            initialRoute:  'adminLogin',
            routes:  {
            // 'BP' : (context)=> BusinessProfile(),
            //   'dashboard' : (context) => AdminDashboard(),
              'SP' : (context) => SidebarPage(),
            //   'CustomerVisits' : (context) => CustomerVisits(),
              'adminRegister' : (context) =>  AdminRegisterPage(),
              'adminLogin' : (context) =>  AdminLoginPage(),
              'HP' : (context) =>  HomePage(),
              'TB' : (context) =>  ToggleButton(),
              // 'cat' : (context) =>  Categories(),
              // 'OI' : (context) =>  OrderItems(),
              // 'HP' : (context) =>  HomePage(),
              // 'TL' : (context) =>  TableLayout(),
              // 'HP' : (context) =>  MyHomePage(),
              // 'DIT' : (context) =>  DineInTables(),


            },
      // home: AdminLoginPage(),
        );
      }
  }






// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   // Generate a list of fiction prodcts
//   final List<Map> _products = List.generate(30, (i) {
//     return {"id": i, "name": "Product $i", "price": Random().nextInt(200) + 1};
//   });
//
//   int _currentSortColumn = 0;
//   bool _isAscending = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Kindacode.com'),
//         ),
//         body: Container(
//           width: double.infinity,
//           child: SingleChildScrollView(
//             child: DataTable(
//               sortColumnIndex: _currentSortColumn,
//               sortAscending: _isAscending,
//               headingRowColor: MaterialStateProperty.all(Colors.amber[200]),
//               columns: [
//                 DataColumn(label: Text('Id')),
//                 DataColumn(label: Text('Name')),
//                 DataColumn(
//                     label: Text(
//                       'Price',
//                       style: TextStyle(
//                           color: Colors.blue, fontWeight: FontWeight.bold),
//                     ),
//                     // Sorting function
//                     onSort: (columnIndex, _) {
//                       setState(() {
//                         _currentSortColumn = columnIndex;
//                         if (_isAscending == true) {
//                           _isAscending = false;
//                           // sort the product list in Ascending, order by Price
//                           _products.sort((productA, productB) =>
//                               productB['price'].compareTo(productA['price']));
//                         } else {
//                           _isAscending = true;
//                           // sort the product list in Descending, order by Price
//                           _products.sort((productA, productB) =>
//                               productA['price'].compareTo(productB['price']));
//                         }
//                       });
//                     }),
//               ],
//               rows: _products.map((item) {
//                 return DataRow(cells: [
//                   DataCell(Text(item['id'].toString())),
//                   DataCell(Text(item['name'])),
//                   DataCell(Text(item['price'].toString()))
//                 ]);
//               }).toList(),
//             ),
//           ),
//         ));
//   }
// }



class TableLayout extends StatefulWidget {
  @override
  _TableLayoutState createState() => _TableLayoutState();
}

class _TableLayoutState extends State<TableLayout> {
  List<List<dynamic>> csvTable = [];

  Uint8List uploadedCsv;
  String option1Text;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            _startFilePicker();
            print(csvTable);
          }),
      appBar: AppBar(
        title: Text("Table Layout and CSV"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: csvTable.isEmpty
                ? Container()
                : Table(
              columnWidths: {
                0: FixedColumnWidth(100.0),
                1: FixedColumnWidth(200.0),
              },
              border: TableBorder.all(width: 1.0),
              children: csvTable.map((item) {
                return TableRow(
                    children: item.map((row) {
                      return Container(
                        color: row.toString().contains("NA")
                            ? Colors.red
                            : Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            row.toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      );
                    }).toList());
              }).toList(),
            ),
          ),
          csvTable.isEmpty ? Container():  TextButton(onPressed: (){
            csvTable.forEach((element) {
              print(element.length);
              FirebaseFirestore.instance.collection('posshop').doc('demo').collection('democol').add({
                'name' : element.length >= 1 ?  element[0] :'' ,
                'phone' : element.length >= 2 ?  element[1] :'' ,
                'Order ID' : element.length >= 3 ? element[2] : ''  ,
                'date' : element.length >= 4 ? element[3] :'',
                'time' : element.length >= 5 ? element[4] : '',
              }).then((value) => print('firebase updated'));
            });
          }, child: Text('Save'))
        ],
      ),
    );
  }
}