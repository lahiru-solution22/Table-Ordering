import 'package:dropin_pos/layout.dart';
import 'package:dropin_pos/screens/home.dart';
import 'package:dropin_pos/screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../controllers/auth_controller.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    Config().init(context);
    return Scaffold(body: GetBuilder<AuthController>(
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Config.screenWidth! * 0.04),
            child: authController.displayName.isNotEmpty
                ? SiteLayout()
                : const SignInPage(),
          ),
        );
      },
    ));
  }
}
