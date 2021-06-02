import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class StaffMembers extends StatefulWidget {
  @override
  _StaffMembersState createState() => _StaffMembersState();
}

class Record {
  String firstName;
  String staffId;
  String lastName;
  String memberId;
  String phone;
  bool status;
  String docId;
  String email;
  Record(
      {this.firstName,
      this.lastName,
      this.memberId,
      this.status,
      this.docId,
        this.email,
        this.staffId,
      this.phone});
}


class _StaffMembersState extends State<StaffMembers> {
  var maskFormatter = new MaskTextInputFormatter(mask: '+61 (##) ####-####', filter: { "#": RegExp(r'[0-9]') });
  List<DataRow> dataRows = [];
  List<User> usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';
  bool sort;
  List<dynamic> snap;
  List ss = [];
  int snapIndex;
  List finalList = [];
  List listDemo = [];
   bool check;
  @override
  void initState() {
    super.initState();
    sort = false;
    usersFiltered = dataRows.cast<User>();
    getData();
  }

  getData() async {
    var snap = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.displayName)
        .doc("staff")
        .collection('staffLogin')
        .get();
    snap.docs.forEach((element) {
      finalList.add(Record(
          firstName: element.get('firstName'),
          lastName: element.get('lastName'),
          memberId: element.get('memberId'),
          status: element.get('status'),
          phone:  element.get('phone'),
          email:  element.get('email'),
          staffId:  element.get('staffId'),
          docId: element.id));
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: screenSize.width,
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
                        width: screenSize.width * 0.01,
                        height: screenSize.height * 0.01,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenSize.width* 0.01,
                  ),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.width * 0.0150,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '/',
                          style: TextStyle(
                            color: Colors.deepOrange[300],
                            fontSize: screenSize.width * 0.0150,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.people,
                        size: screenSize.width * 0.0150,
                      ),
                      Text(
                        'Create Team Member',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenSize.width * 0.0150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: SizedBox(
                height: screenSize.height * 0.6,
                width: screenSize.width * 0.6,
                child: Card(
                  // color: Colors.transparent,
                  elevation: 20,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        Container(
                    color: Colors.grey[300],
                          height: screenSize.height * 0.8,
                          width: screenSize.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: screenSize.height * 0.06,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          finalList = finalList.reversed.toList();
                                          sort = !sort;
                                        });
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                sort == true
                                                    ? 'View By :  Last-First '
                                                    : 'View By : First-Last ',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Icon(
                                                sort == true
                                                    ? Icons.arrow_drop_up
                                                    : Icons.arrow_drop_down,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Card(
                                  //   shape: RoundedRectangleBorder(
                                  //       side: new BorderSide(
                                  //           color: Colors.grey.shade400, width: 2.0),
                                  //       borderRadius: BorderRadius.circular(4.0)),
                                  //   child: SizedBox(
                                  //     height: screenSize.height * 0.06,
                                  //     width: screenSize.width * 0.2,
                                  //     child: new ListTile(
                                  //       leading: new Icon(Icons.search),
                                  //       title: new TextField(
                                  //           controller: controller,
                                  //           decoration: new InputDecoration(
                                  //               hintStyle: TextStyle(color: Colors.grey),
                                  //               hintText: 'Filter Team Members',
                                  //               border: InputBorder.none),
                                  //           onChanged: (value) {
                                  //             setState(() {
                                  //               _searchResult = value;
                                  //               // usersFiltered = users.where((user) => user.name.contains(_searchResult)).toList();
                                  //             });
                                  //           }),
                                  //       trailing: new IconButton(
                                  //         icon: new Icon(controller.text != ''
                                  //             ? Icons.cancel
                                  //             : Icons.more_horiz),
                                  //         onPressed: () {
                                  //           setState(() {
                                  //             controller.clear();
                                  //             _searchResult = '';
                                  //             // usersFiltered = users;
                                  //           });
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      showAlertDialogStaff(context,0,false);
                                    },
                                    child: Card(
                                        color: Color(0xFFF37325),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.0)),
                                      child: SizedBox(
                                          height: screenSize.height * 0.06,
                                          width: screenSize.width * 0.2,
                                          child: Center(
                                              child: Text(
                                            'Create Team Member',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: screenSize.height * 0.6,
                                width: screenSize.width * 0.3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Container(
                                        // color: Colors.green,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: InkWell( onTap: () {
                                                  setState(() {
                                                    finalList =
                                                        finalList.reversed.toList();
                                                    sort = !sort;
                                                  });
                                                },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Name',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      Icon(
                                                        sort == true
                                                            ? Icons.arrow_drop_up
                                                            : Icons.arrow_drop_down,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(right: 8),
                                                  child: Text(
                                                    'Status',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ListView.builder(
                                          // reverse: sort,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: finalList.length,
                                          itemBuilder: (context, int index) {
                                            String dr = finalList[index].firstName;
                                           if (dr.contains(_searchResult)){
                                             return SingleChildScrollView(
                                               child: ListTile(
                                                 focusColor: Colors.deepOrange,
                                                 hoverColor: Colors.deepOrange,
                                                   title: InkWell(
                                                       onTap: (){
                                                         passwordField( context,  index,);
                                                       },
                                                       child: Text(dr)),
                                                   subtitle: Text(finalList[index].staffId),
                                                   leading: InkWell(
                                                     onTap: (){
                                                     setState(() {
                                                       String docId = finalList[index].docId;
                                                       FirebaseFirestore.instance
                                                           .collection(FirebaseAuth.instance.currentUser.displayName)
                                                           .doc('staff')
                                                           .collection('staffLogin').doc(docId).delete();
                                                       print('DocId ${docId}');
                                                     });
                                                     },
                                                       child: Icon(Icons.delete_forever)),
                                                   trailing: TextButton(
                                                       onPressed: () async {
                                                         await FirebaseFirestore.instance
                                                             .collection(FirebaseAuth
                                                             .instance
                                                             .currentUser
                                                             .displayName)
                                                             .doc("staff")
                                                             .collection('staffLogin')
                                                             .doc(finalList[index].docId)
                                                             .update({
                                                           "staffId" : finalList[index].staffId,
                                                           "firstName": finalList[index].firstName,
                                                           "lastName": finalList[index].lastName,
                                                           "memberId": finalList[index].memberId,
                                                           "phone":finalList[index].phone,
                                                           "email": finalList[index].email,
                                                           "status": '${finalList[index].status}' ==
                                                               'true'
                                                               ? false
                                                               : true,

                                                         });
                                                         setState(() {
                                                           finalList[index].status =
                                                           !finalList[index].status;
                                                         });
                                                       },
                                                       child: Text(
                                                         '${finalList[index].status}' ==
                                                             'true'
                                                             ? "Active"
                                                             : 'De-Activated',
                                                         style: TextStyle(
                                                             color:
                                                             finalList[index].status !=
                                                                 true
                                                                 ? Colors.black
                                                                 : Colors.deepOrange,
                                                             fontWeight: FontWeight.bold,
                                                             fontSize: 20),
                                                       ))),
                                             );
                                           };
                                            return ListTile(
                                              title: finalList[index].firstName,
                                            );
                                          }),
                                    ],
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
          ],
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget showAlertDialogStaff(BuildContext context, var index, bool check ) {
    Size size = MediaQuery.of(context).size;
    // set up the buttons
    var snap ;
    check == false ? snap = null : snap = finalList[index];
    print('double ${finalList[index]}');
    print('double ${[snap]}');
    String firstName;
    String lastName;
    String phoneNumber;
    String email;
    String memberId;
    String staffId;
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController memberIdController = TextEditingController();
    TextEditingController staffIdController = TextEditingController();
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
        firstName = firstNameController.text == '' ?  snap.firstName : firstNameController.text;
        lastName = lastNameController.text == '' ? snap.lastName :lastNameController.text ;
        memberId = memberIdController.text  == '' ? snap.memberId : memberIdController.text;
        phoneNumber = phoneNumberController.text == '' ? snap.phone: phoneNumberController.text;
        email = emailController.text  == '' ? snap.email : emailController.text ;
        staffId = staffIdController.text  == '' ? snap.staffId : staffIdController.text ;

       if(check == true){
         await FirebaseFirestore.instance
             .collection(FirebaseAuth.instance.currentUser.displayName)
             .doc("staff")
             .collection('staffLogin')
             .doc(finalList[index].docId)
             .update({
           "firstName": firstName,
           "lastName": lastName,
           "memberId": memberId,
           "phone": phoneNumber,
           "email": email,
           "status": true,
           "staffId": staffId,
           // "Status" : status,
         }).then((value) {
           Navigator.pop(context);
         });
       }
       else
         {
           await FirebaseFirestore.instance
               .collection(FirebaseAuth.instance.currentUser.displayName)
               .doc("staff")
               .collection('staffLogin')
               .doc()
               .set({
             "firstName": firstName,
             "lastName": lastName,
             "memberId": memberId,
             "phone": phoneNumber,
             "email": email,
             "status": true,
             "staffId": staffId,
             // "Status" : status,
           }).then((value) {
             Navigator.pop(context);
           });
         }
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
         check == false ?    "Create Team  Members" : "Edit Team  Members",
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
          height: size.height * 0.5,
          width: size.width * 0.4,
          // decoration: BoxDecoration(
          //   border: Border(
          //     left: BorderSide(
          //       //                   <--- left side
          //       color: Colors.blue[100],
          //       width: 15.0,
          //     ),
          //     top: BorderSide(
          //       //                    <--- top side
          //       color: Colors.blue[100],
          //       width: 10.0,
          //     ),
          //     right: BorderSide(
          //       //                    <--- top side
          //       color: Colors.blue[500],
          //       width: 5.0,
          //     ),
          //     bottom: BorderSide(
          //       //                    <--- top side
          //       color: Colors.blue[800],
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
                          'First Name',
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
                          controller: firstNameController,
                          autofillHints: [AutofillHints.givenName],
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-z,A-Z]')),],
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // focusedBorder:OutlineInputBorder(
                              // borderSide: new BorderSide(color: Colors.deepOrange.shade500,)),
                              // border: new OutlineInputBorder(
                              //     borderSide: new BorderSide(color: Colors.grey)),
                              // labelText: 'Staff Name',
                              hintText:  check == false ?  'First Name':  snap.firstName,
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
                            'Staff ID',
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
                          controller: staffIdController,
                          autofillHints: [AutofillHints.givenName],
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // focusedBorder:OutlineInputBorder(
                              // borderSide: new BorderSide(color: Colors.deepOrange.shade500,)),
                              // border: new OutlineInputBorder(
                              //     borderSide: new BorderSide(color: Colors.grey)),
                              // labelText: 'Staff Name',
                              hintText:  check == false ?  'Staff ID':  snap.staffId,
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
                            'Last Name',
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
                          controller: lastNameController,
                          autofillHints: [AutofillHints.givenName],
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // focusedBorder:OutlineInputBorder(
                              // borderSide: new BorderSide(color: Colors.deepOrange.shade500,)),
                              // border: new OutlineInputBorder(
                              //     borderSide: new BorderSide(color: Colors.grey)),
                              // labelText: 'Staff Name',
                              hintText:  check == false ? 'Last Name' : snap.lastName,
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
                  SizedBox(
                    height: size.height * 0.07,
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
                            'Phone Number',
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
                          keyboardType: TextInputType.number,
                          controller: phoneNumberController,
                          autofillHints: [AutofillHints.givenName],
                          inputFormatters: [
                            maskFormatter,
                          ],
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // focusedBorder:OutlineInputBorder(
                              // borderSide: new BorderSide(color: Colors.deepOrange.shade500,)),
                              // border: new OutlineInputBorder(
                              //     borderSide: new BorderSide(color: Colors.grey)),
                              // labelText: 'Staff Name',
                              hintText:  check == false ? 'phone Number' : snap.phone,
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
                            'Email Addresses',
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
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          autofillHints: [AutofillHints.givenName],
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // focusedBorder:OutlineInputBorder(
                              // borderSide: new BorderSide(color: Colors.deepOrange.shade500,)),
                              // border: new OutlineInputBorder(
                              //     borderSide: new BorderSide(color: Colors.grey)),
                              // labelText: 'Staff Name',
                              hintText:  check == false  ? 'Email' : snap.email,
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
                            'Team Member ID',
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
                          keyboardType: TextInputType.number,
                          controller: memberIdController,
                          autofillHints: [AutofillHints.givenName],
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // focusedBorder:OutlineInputBorder(
                              // borderSide: new BorderSide(color: Colors.deepOrange.shade500,)),
                              // border: new OutlineInputBorder(
                              //     borderSide: new BorderSide(color: Colors.grey)),
                              // labelText: 'Staff Name',
                              hintText:  check == false  ? 'Member ID' : snap.memberId,
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
                          width:  size.width * 0.05,
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
  // ignore: missing_return
  Widget passwordField(BuildContext context, var index,){
    Size size = MediaQuery.of(context).size;
    TextEditingController passwordController = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: Text('Enter the Password '),
      content: SizedBox(
        height: 100,
        width:  100,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 200,
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
                    keyboardType: TextInputType.number,
                    controller: passwordController,
                    autofillHints: [AutofillHints.givenName],
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp('[1-9,0]')),],
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        // focusedBorder:OutlineInputBorder(
                        // borderSide: new BorderSide(color: Colors.deepOrange.shade500,)),
                        // border: new OutlineInputBorder(
                        //     borderSide: new BorderSide(color: Colors.grey)),
                        // labelText: 'Staff Name',
                        hintText:   'pin',
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
                if(passwordController.text == '0'){
                  showAlertDialogStaff(context, index,true);
                  print('pin');
                }
                else
                  {
                    Navigator.pop(context);
                  }
              },
              child: Card(
                color: Color(0xFFF37325),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ok'),
                ),
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
