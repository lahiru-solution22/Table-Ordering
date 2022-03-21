import 'package:dropin_pos/routing/routes.dart';
import 'package:dropin_pos/screens/404/error_page.dart';
import 'package:dropin_pos/screens/root.dart';
import 'package:dropin_pos/screens/sign_in/sign_in.dart';
import 'package:dropin_pos/widgets/controller_bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'layout.dart';

Future<void> main() async {
  //Firebase Initialization
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAL4G2icd7mOKm9fRgYBbpTtM9uFN6SAQo",
    appId: "1:591554188037:web:980aa8b68e26b83d871d6c",
    messagingSenderId: "591554188037",
    projectId: "dropin-pos-91d32",
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dropin POS Admin',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
          }),
          primaryColor: Colors.black),
      home: const Root(),
      initialBinding: ControllerBindings(),
      initialRoute: SignInPageRoute,
      unknownRoute: GetPage(
          name: "/not-found",
          page: () => const PageNotFound(),
          transition: Transition.fadeIn),
      getPages: [
        GetPage(
          name: RootRoute,
          page: () => SiteLayout(),
        ),
        GetPage(
          name: SignInPageRoute,
          page: () => const SignInPage(),
        ),
      ],
    );
  }
}
