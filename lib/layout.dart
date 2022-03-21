import 'package:dropin_pos/helpers/responsiveness.dart';
import 'package:dropin_pos/widgets/large_screen.dart';
import 'package:dropin_pos/widgets/side_menu.dart';
import 'package:dropin_pos/widgets/small_screen.dart';
import 'package:dropin_pos/widgets/top_nav.dart';
import 'package:flutter/material.dart';
class SiteLayout extends StatelessWidget {
  SiteLayout({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: const Drawer(child:SideMenu()),
      body: const ResponsiveWidget(
        largeScreen: LargeScreen(),
        smallScreen: SmallScreen(),
      ),
    );
  }
}
