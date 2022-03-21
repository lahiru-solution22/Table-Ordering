import 'package:dropin_pos/config.dart';
import 'package:dropin_pos/layout.dart';
import 'package:dropin_pos/routing/routes.dart';
import 'package:dropin_pos/screens/overview/overview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/home.dart';
import '../screens/root.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  var displayName = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;
  @override
  void onInit() {
    displayName = userProfile != null ? displayName : '';
    super.onInit();
  }

  Future<void> signUp(
      String firstName, String lastName, String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        displayName = firstName;
        auth.currentUser!.updateDisplayName(firstName);
      });
      update();
      Get.offAll(() => const Root());
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email';
      } else {
        message = e.message.toString();
      }
      Get.snackbar(title, message,
          backgroundColor: kPrimaryColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error Occured', e.toString(),
          backgroundColor: kPrimaryColor, colorText: Colors.white);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        //displayName = userProfile!.displayName!;
        Get.toNamed(OverViewPageRoute);
      });
      update();
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (e.code == 'wrong-password') {
        message = 'The password is incorrect, Please try again!';
      } else if (e.code == 'user-not-found') {
        message =
            'The account does not exist for $email. Create your account by Signing up. ';
      } else {
        message = e.message.toString();
      }
      Get.snackbar(title, message,
          backgroundColor: kPrimaryColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error Occured', e.toString(),
          backgroundColor: kPrimaryColor, colorText: Colors.white);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String title = e.code.replaceAll(RegExp('-'), ' ').capitalize!;
      String message = '';

      if (e.code == 'user-not-found') {
        message = 'The account does not exist for $email ';
      } else {
        message = e.message.toString();
      }
      Get.snackbar(title, message,
          backgroundColor: kPrimaryColor, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error Occured', e.toString(),
          backgroundColor: kPrimaryColor, colorText: Colors.white);
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      displayName = '';
      Get.offAll(() => const Root());
      update();
    } catch (e) {
      Get.snackbar('Error Occured', e.toString(),
          backgroundColor: kPrimaryColor, colorText: Colors.white);
    }
  }
}
