import 'package:check_in_system/AdminPage/dashboard/admin_dashboard.dart';
import 'package:check_in_system/AdminPage/login/admin_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminRegisterPage extends StatefulWidget {
  @override
  _AdminRegisterPageState createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var nameKey = GlobalKey<FormState>();
  var emailKey = GlobalKey<FormState>();
  var passwordKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool secureText = true;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.5,
                width: size.width <= 800? size.width* 0.6 : size.width * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black26,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Image.asset(
                            "images/wel.png",
                            width: size.width * 0.5,
                            height: size.height * 0.1,
                          ),
                        ),
                      ),
                      Form(
                        key: emailKey,
                        child: TextFormField(
                          validator: (String value){
                            if(value.length < 5)
                              return " Enter at least 8 character from your email";
                            else
                              return null;
                          },
                          controller: emailController,
                          onChanged: (value) {
                          },

                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(

                              hintText: "Email\*",
                              hintStyle: TextStyle(
                                fontSize: size.width* 0.02,
                                color:Colors.white,
                              ),
                              suffixIcon: Icon(Icons.email_rounded),
                              hoverColor: Colors.yellow,
                              filled: true,
                              focusColor: Colors.yellow),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Form(
                        key: nameKey,
                        child: TextFormField(
                          validator: (String value) {
                            if (value.length < 3)
                              return " Enter at least 3 character from Customer Name";
                            else
                              return null;
                          },
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text ,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-z,A-Z]')),],
                          controller: nameController,
                          autofillHints: [AutofillHints.givenName],

                          decoration: InputDecoration(
                              labelText: 'Name\*',
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.02,
                              ),
                              suffixIcon: Icon(Icons.person),
                              hoverColor: Colors.yellow,
                              filled: true,
                              focusColor: Colors.yellow),
                        ),
                      ),
                      Form(
                        key: passwordKey,
                        child: TextFormField(
                          controller: passwordController,
                          validator: (String value){
                            if(value.length < 4)
                              return " Enter at least 4 character from your password";
                            else
                              return null;
                          },
                          obscureText: secureText,
                          onChanged: (value){
                          },
                          decoration: InputDecoration(

                              hintText: "Password\*",
                              hintStyle: TextStyle(
                                fontSize: size.width* 0.02,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon( secureText ? Icons.remove_red_eye_outlined : Icons.security),
                                onPressed: () {
                                  setState(() {
                                    secureText = !secureText;
                                  });

                                },
                                color: Colors.deepOrange,
                              ),
                              hoverColor: Colors.yellow,
                              filled: true,
                              focusColor: Colors.yellow),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          elevation: 5.0,
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(30.0),
                          child: MaterialButton(
                            onPressed: () async {

                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                print(emailController.text);
                                print(nameController.text);
                                print(passwordController.text);
                                await _auth
                                    .createUserWithEmailAndPassword(
                                  email: emailController.text, password:passwordController.text, )
                                    .then((signedInUser) async{
                                  await FirebaseFirestore.instance
                                      .collection(nameController.text)
                                      .doc("AdminDetails")
                                      .set({
                                    'email' : FirebaseAuth.instance.currentUser.email,
                                    'uid' : FirebaseAuth.instance.currentUser.uid,
                                    'shopName' : nameController.text ,
                                    'password' : passwordController.text,
                                  }).then((value)async {
                                    await FirebaseFirestore.instance
                                        .collection(nameController.text)
                                        .doc("businessProfile")
                                        .set({
                                      "shopName": '',
                                      "address": '',
                                      "stateCountry": '',
                                      "phone": '',
                                      "gstIN": '',
                                      "staffId" : '',
                                      "inclusiveGST" : true,
                                      "kotPrinterIP": '',
                                      "posPrinterIP": '',
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AdminLoginPage(),),
                                    );
                                  }).catchError((e){
                                    print(e);
                                  });
                                  signedInUser.user.updateProfile(displayName: nameController.text );
                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                  //   content: Text(' deleted'),
                                  // ));
                                }).catchError((e) {
                                  print(e);
                                  var snackbar = SnackBar(
                                      content: Text(
                                          'Email ID and password is incorrect please check the user name and password....'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                }); //Go to login screen.

                                setState(() {
                                  showSpinner = false;
                                  emailKey.currentState.validate();
                                  passwordKey.currentState.validate();
                                  nameKey.currentState.validate();
                                  passwordController.clear();
                                });
                              } catch (e) {
                                print(e);
                              }
                              nameController.clear();
                              passwordController.clear();
                            },
                            minWidth: 120,
                            height: 42.0,
                            child: Text(
                              'REGISTER',
                              style: TextStyle(
                                fontSize: size.width* 0.02,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
