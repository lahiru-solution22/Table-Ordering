import 'package:dropin_pos/constants/controllers.dart';
import 'package:dropin_pos/routing/router.dart';
import 'package:dropin_pos/routing/routes.dart';
import 'package:flutter/material.dart';

Navigator localNavigator() => Navigator(
  key: navigationController.navigationKey,
  initialRoute: OverViewPageRoute,
  onGenerateRoute: generateRoute,
);
