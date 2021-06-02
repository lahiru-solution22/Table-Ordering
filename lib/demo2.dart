import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Generate a list of fiction prodcts
  // final List<Map> _products = List.generate(30, (i) {
  //   return {"id": i, "name": "Product $i", "price": Random().nextInt(200) + 1};
  // });
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  int _currentSortColumn = 0;
  List<TableData> usersFiltered = [];
  bool _isAscending = true;
  List<TableData> tabledata = [];
  List<Map> _products = [];
  List <DataRow> datarows = [];
  getdata() async {
    await FirebaseFirestore.instance
        .collection('posshop')
        .doc('itemDetails')
        .collection('items')
        .get().then((value) {
      value.docs.forEach((element) {
        List dat = element.get('cat');
        tabledata.add(TableData(
          item: element.get('name'),
          image: element.get('imgUrl'),
          price: element.get('price'),
          category: dat.join('').toString(),

        ));
      });
    });
    tabledata.map((data){
      if(data.item.contains(controller.text.toLowerCase())){
        // print('if search ${_searchResult}');
            _products.add({'item': data.item, 'image': data.image, 'price': data.price, 'category': data.category});
            usersFiltered = tabledata.where((TableData) => TableData.item.contains(_searchResult.toLowerCase())).toList();
      }
      return
          _products;
    } ).toList();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    getdata();
  }
  @override
  Widget build(BuildContext context) {
Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Kindacode.com'),
        ),
        body: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
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
                              usersFiltered = tabledata.where((TableData) => TableData.item.contains(_searchResult.toLowerCase())).toList();

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
                DataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  headingRowColor: MaterialStateProperty.all(Colors.amber[200]),
                  columns: [
                    DataColumn(label: Text('Item')),
                    DataColumn(label: Text('Category')),

                    DataColumn(
                        label: Text(
                          'Price',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),

                        // Sorting function
                        onSort: (columnIndex, _) {
                          setState(() {
                            _currentSortColumn = columnIndex;
                            if (_isAscending == true) {
                              _isAscending = false;
                              // sort the product list in Ascending, order by Price
                              usersFiltered.sort((productA, productB) =>
                                  productB.price.compareTo(productA.price));
                            } else {
                              _isAscending = true;
                              // sort the product list in Descending, order by Price
                              usersFiltered.sort((productA, productB) =>
                                  productA.price.compareTo(productB.price));
                            }
                          });
                        }
                        ),
                    DataColumn(label: Text('Image')),
                  ],
                  rows:
                  // tabledata.forEach((element) {
                  //   if(element.item.contains(_searchResult.toLowerCase())){
                  //     datarows.add(
                  //       DataRow(cells: [
                  //         DataCell(Text(element.item.toString())),
                  //         DataCell(Text(element.category.toString())),
                  //         DataCell(Text(element.price.toString())),
                  //         DataCell(Text(element.image.toString())),
                  //       ]),
                  //     );
                  //     return
                  //       datarows;
                  //   }
                  // });
                List.generate(usersFiltered.length, (index) {
                  print(usersFiltered[index].item);
                  bool check;
                  usersFiltered[index].image.toString().contains('NI') ? check = false : true ;

                  return
                  DataRow(cells: [
                  DataCell(Text(usersFiltered[index].item.toString())),
                  DataCell(Text(usersFiltered[index].category.toString())),
                  DataCell(Text(usersFiltered[index].price.toString())),
                  DataCell(check != false ? Text('Image') : Text('No Image')),
                ]);
                },)
                ),
              ],
            ),
          ),
        ));
  }
}

class TableData{
  String item;
  String category;
  double price;
  String image;
  TableData({this.item,this.price,this.image,this.category});
}