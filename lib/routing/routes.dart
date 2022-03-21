// ignore_for_file: constant_identifier_names
const RootRoute = "/";

const OverViewPageDisplayName = "Overview";
const OverViewPageRoute = "/overview";

const CreateClientPageDisplayName = "Create Client";
const CreateClientPageRoute = "create-client";

const ViewClientsPageDisplayName = "Clients";
const ViewClientsPageRoute = "/clients";

const SignInPageDisplayName = "Log Out";
const SignInPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItems = [
  MenuItem(OverViewPageDisplayName, OverViewPageRoute),
  MenuItem(CreateClientPageDisplayName, CreateClientPageRoute),
  MenuItem(ViewClientsPageDisplayName, ViewClientsPageRoute),
  MenuItem(SignInPageDisplayName, SignInPageRoute)
];
