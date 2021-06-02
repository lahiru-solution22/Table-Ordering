import 'dart:core';
import 'dart:core';
import 'dart:math' as math show pi;
import 'package:check_in_system/AdminPage/business_profile/business_profile.dart';
import 'package:check_in_system/AdminPage/categories/categories.dart';
import 'package:check_in_system/AdminPage/dashboard/customer_visits.dart';
import 'package:check_in_system/AdminPage/dashboard/staff.dart';
import 'package:check_in_system/AdminPage/dine_in_tables/dine_in_tables.dart';
import 'package:check_in_system/AdminPage/login/admin_login.dart';
import 'package:check_in_system/sales/bar_chart.dart';
import 'package:check_in_system/sales/pie_chart.dart';
import 'package:check_in_system/sales/recent_transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'order_items.dart';
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  var maskFormatter = new MaskTextInputFormatter(mask: '+61 (##) ####-####', filter: { "#": RegExp(r'[0-9]') });
  bool dashboard = false;
  bool qrCode = false;
  bool customerVisits = false;
  String dropdownValue = '';
  List todayPrice = [];
getTodayPrice(setstate) async{
  var date = new DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  var formattedDate = DateFormat('dd-MM-yyyy')
      .format(DateTime.parse(dateParse.toString()));
  QuerySnapshot data = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser.displayName).doc('completedPayment').collection(formattedDate.toString()).get();

  data.docs.forEach((e) {
    
    print(e['orderId']);
    setState(() {
      todayPrice.add(e['amount']);
      print(todayPrice);
      print(' ${(todayPrice.fold(0, (previousValue, element) => previousValue + element)) .toStringAsFixed(2)}');

    });

     });

}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTodayPrice(StateSetter );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    dropdownValue = 'User Name';
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(dateParse.toString()));
        return Scaffold(
          // appBar: AppBar(
          //   flexibleSpace: Container(
          //     decoration: new BoxDecoration(
          //       gradient: new LinearGradient(
          //           colors: [
          //             Colors.deepOrange,
          //             Colors.white54,
          //           ],
          //           begin: const FractionalOffset(0.0, 0.0),
          //           end: const FractionalOffset(3.0, 5.0),
          //           stops: [0.0, 1.0],
          //           tileMode: TileMode.clamp),
          //     ),
          //   ),
          //   backgroundColor: Colors.deepOrange,
          //   leading: Image.asset(
          //     "images/wel.png",
          //     width: size.width * 0.5,
          //     height: size.height * 0.5,
          //   ),
          //   title: Row(
          //     children: [
          //       Text('Dropin | ',style: TextStyle(color: Colors.white,fontSize:size .width* 0.02 ),),
          //       Text(FirebaseAuth.instance.currentUser ==null ? 'Shop Name ' : FirebaseAuth.instance.currentUser.displayName,style: TextStyle(color: Colors.white,fontSize:size .width* 0.02 ),),
          //     ],
          //   ),
          //
          // ),
          body: SingleChildScrollView(
            child:
            size.width <= 700 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 300),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text('Please Open in Full Screen',textAlign: TextAlign.center,)),
                    CircularProgressIndicator(),
                  ],
                ),
              ],
            ) :
            Column(
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
                  Row(
                  children: [

                    Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        height: size.height,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  StreamBuilder(
                                    stream:  FirebaseFirestore.instance
                                      .collection(FirebaseAuth.instance.currentUser.displayName)
                                  .doc("/completedPayment")
                                  .collection(formattedDate.toString())
                                  .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData || snapshot.hasError) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SizedBox(
                                          height:size.width <= 700 ? size.height * 0.2:  size.height * 0.135,
                                          width:size.width <= 700 ? size.width * 0.3: size.width * 0.2,
                                          child: InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> SidebarPage(salesReport: 2,)));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.black
                                                // gradient: LinearGradient(
                                                //   colors: [
                                                //     Colors.deepOrange,
                                                //     Colors.white54,
                                                //   ],
                                                //   begin: const FractionalOffset(0.3, 0.6),
                                                //   end: const FractionalOffset(1.0, 2.0),
                                                //   stops: [0.0, 1.0],
                                                //   tileMode: TileMode.clamp,
                                                // ),
                                              ),
                                              child: ListTile(
                                                title: Text("Today Visits",style: TextStyle(color: Colors.white,fontSize: size.width * 0.02),),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.arrow_circle_up,size: size.width* 0.01,color: Colors.white,),
                                                      Text(snapshot.data.docs.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: size.width * 0.02),)
                                                    ],
                                                  ),
                                                ),
                                                trailing: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: Icon(Icons.calendar_today_outlined,color: Colors.white,size: size.width * 0.03,),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      height:size.width <= 700 ? size.height * 0.2:  size.height * 0.135,
                                      width:size.width <= 700 ? size.width * 0.3: size.width * 0.2,
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SidebarPage(salesReport: 2,)));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF37325),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: ListTile(
                                            title: Text("Today Sale",style: TextStyle(color: Colors.white,fontSize: size.width * 0.02),),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.arrow_circle_up,size: size.width* 0.01,color: Colors.white,),
                                                  Text(' \$${(todayPrice.fold(0, (previousValue, element) => previousValue + element)).toStringAsFixed(2)}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: size.width * 0.02),)
                                                ],
                                              ),
                                            ),
                                            trailing: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 20),
                                              child: Icon(Icons.person,color: Colors.white,size: size.width * 0.03,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      height: size.height * 0.135,
                                      width:  size.width * 0.2,
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection(FirebaseAuth.instance.currentUser.displayName)
                                            .doc("staff")
                                            .collection('staffLogin').snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          return InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=> SidebarPage(staffMembers: 5,check:  true,)));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                  color: Colors.black,
                                              ),
                                              child: ListTile(
                                                title: Text("Staff Members",style: TextStyle(color: Colors.white,fontSize: size.width * 0.02),),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.arrow_circle_up,size: size.width* 0.01,color: Colors.white,),
                                                      Text(snapshot.data.docs.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: size.width * 0.02),)
                                                    ],
                                                  ),
                                                ),
                                                trailing: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                                  child: Icon(Icons.people,color: Colors.white,size: size.width * 0.03,),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Bar(),
                                  PieChartMain(),
                                ],
                              ),
                              RecentTrans(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        );
      }

  }






class SidebarPage extends StatefulWidget {
  var salesReport; var staffMembers;
  bool check;
  SidebarPage({this.salesReport,this.staffMembers,this.check});
  @override
  _SidebarPageState createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {

  List<String> reorderText = [
    "venkat",
    "raman",
    "jayanthi",
    "mom",
    "dad",
    "priya",
  ];

  TextEditingController categoryController = TextEditingController();

  List<CollapsibleItem> _items;
  int _headline;
  NetworkImage _avatarImg =
  NetworkImage('https://image.shutterstock.com/image-vector/user-icon-person-profile-avatar-260nw-601712213.jpg',);




  Widget showAlertDialogFBURL(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // set up the buttons

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () async{

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Inventory Categories"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: size.height,
                width: size.width,
                child: ReorderableListView(
                    children: getListItems(),
                    onReorder: onReorder),
              ),
              TextFormField(
                validator: (String value) {
                  if (value.length < 3)
                    return " Enter at least 3 character from Customer Name";
                  else
                    return null;
                },
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                controller: categoryController,
                autofillHints: [AutofillHints.givenName],

                decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: size.width * 0.02,
                    ),
                    prefixIcon: Icon(Icons.data_usage),
                    hoverColor: Colors.yellow,
                    filled: true,
                    focusColor: Colors.yellow),
              ),
            ],
          ),
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
  @override
  void initState() {
    super.initState();
    _items = _generateItems;
   widget.salesReport == null? widget.staffMembers == null ?  _headline = 1 : _headline = 5 : _headline = widget.salesReport;
  }


  List<ListTile> getListItems()=> reorderText
      .asMap()
      .map((index, item) => MapEntry(index, buildReorderText( item, index)))
      .values
      .toList();
  ListTile buildReorderText(String item,int index)=> ListTile(
    key: ValueKey(item),
    title: Text(item),
    leading: Text('#${index + 1}'),
  );
void onReorder(int oldIndex, int  newIndex){
  if(newIndex > oldIndex ){
    newIndex = 1;
  }

  setState(() {
    String check = reorderText[oldIndex];
    
    reorderText.removeAt(oldIndex);
    reorderText.insert(newIndex, check);
  });
}
  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        text: 'Dashboard',
        icon: Icons.assessment,
        onPressed: () => setState(() => _headline = 1),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Sales Report ',
        icon: Icons.people,
        onPressed: () => setState(() => _headline = 2),
      ),
      CollapsibleItem(
        text: 'Order Items ',
        icon: Icons.fastfood,
        onPressed: () => setState(() {
          _headline = 3;
        }
        ),
      ),
      CollapsibleItem(
        text: 'Inventory Categories',
        icon: Icons.category,
        onPressed: () => setState(() {
          // showAlertDialogFBURL( context);
          _headline = 4;
        }
        ),
      ),
      CollapsibleItem(
        text: 'Staff',
        icon: Icons.people,
        onPressed: () => setState(() {
          _headline = 5;
        }),
      ),
      CollapsibleItem(
        text: 'Sign Out',
        icon: Icons.logout,
        onPressed: () => setState(() {
          _headline = 4;
          FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminLoginPage(),));
        }),
      ),
      CollapsibleItem(
        text: 'Business Profile',
        icon: Icons.business,
        onPressed: () => setState(() {
          _headline = 6;
        }),
      ),
      CollapsibleItem(
        text: 'Dine In Table',
        icon: Icons.table_chart_outlined,
        onPressed: () => setState(() {
          _headline = 7;
        }),
      ),
      // CollapsibleItem(
      //   text: 'Home',
      //   icon: Icons.home,
      //   onPressed: () => setState(() => _headline = 'Home'),
      // ),
      // CollapsibleItem(
      //   text: 'Alarm',
      //   icon: Icons.access_alarm,
      //   onPressed: () => setState(() => _headline = 'Alarm'),
      // ),
      // CollapsibleItem(
      //   text: 'Eco',
      //   icon: Icons.eco,
      //   onPressed: () => setState(() => _headline = 'Eco'),
      // ),
      // CollapsibleItem(
      //   text: 'Event',
      //   icon: Icons.event,
      //   onPressed: () => setState(() => _headline = 'Event'),
      // ),
      // CollapsibleItem(
      //   text: 'Email',
      //   icon: Icons.email,
      //   onPressed: () => setState(() => _headline = 'Email'),
      // ),
      // CollapsibleItem(
      //   text: 'Face',
      //   icon: Icons.face,
      //   onPressed: () => setState(() => _headline = 'Face'),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: CollapsibleSidebar(

          unselectedIconColor: Colors.white,
          selectedIconColor: Color(0xFFF37325),
          items: _items,
          body: landingWidget(page: _headline,),
          backgroundColor: Colors.black,
          toggleTitle: 'Developed By Dropin',
          selectedTextColor: Colors.white,
          avatarImg: _avatarImg,unselectedTextColor:  Color(0xFFF37325),
          title:FirebaseAuth.instance.currentUser ==null ? 'User Name ' : FirebaseAuth.instance.currentUser.displayName,
          textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          titleStyle: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
          toggleTitleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}

class landingWidget extends StatelessWidget {
  final int page;

  const landingWidget({Key key, this.page}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    switch(page)
    {
      case 1 : return AdminDashboard();
      case 2 : return CustomerVisits();
      case 3 : return OrderItems();
      case 4 : return Categories();
      case 5 : return StaffMembers();
      case 6 : return BusinessProfile();
      case 7 : return DineInTables();
      default : return Container(color: Colors.pink,);
    }
  }
}



class TopTenList extends StatefulWidget {
  @override
  _TopTenListState createState() => _TopTenListState();
}

class _TopTenListState extends State<TopTenList> {
  List<String> topTenGames = [
    "World of Warcraft",
    "Final Fantasy VII",
    "Animal Crossing",
    "Diablo II",
    "Overwatch",
    "Valorant",
    "Minecraft",
    "Dota 2",
    "Half Life 3",
    "Grand Theft Auto: Vice City"
  ];

  getCategory()async{
    List cat = [];
    List demo;
    print('get');
  var data =  await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.displayName).doc('itemDetails').collection('items')
        .get();


  data.docs.forEach((e){
    print(e.get('cat'));
    cat.add(e.get('cat'));
  });
  print(cat);
  print(cat[4][0]);
  }

  @override
  void initState() {
    // TODO: implement initState
    getCategory();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Ten"),
      ),
      body: ReorderableListView(
        onReorder: onReorder,
        children: getListItems(),
      ),
    );
  }

  List<ListTile> getListItems() => topTenGames
      .asMap()
      .map((i, item) => MapEntry(i, buildTenableListTile(item, i)))
      .values
      .toList();

  ListTile buildTenableListTile(String item, int index) {
    return ListTile(
      key: ValueKey(item),
      title: Text(item),
      leading: Text("#${index + 1}"),
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      String game = topTenGames[oldIndex];

      topTenGames.removeAt(oldIndex);
      topTenGames.insert(newIndex, game);
    });
  }
}



