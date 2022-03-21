import 'package:dropin_pos/routing/routes.dart';
import 'package:dropin_pos/screens/clients/clients.dart';
import 'package:dropin_pos/screens/createClient/create_client.dart';
import 'package:dropin_pos/screens/overview/overview.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OverViewPageRoute:
      return _getPageRoute(const OverViewPage());
    case CreateClientPageRoute:
      return _getPageRoute(const CreateClientPage());
    case ViewClientsPageRoute:
      return _getPageRoute(const ClientsPage());
    default:
      return _getPageRoute(const OverViewPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
