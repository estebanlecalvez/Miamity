import 'package:flutter/material.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/MamaChef/screens/userListPage.dart';
import 'package:miamitymds/Utils/Transitions/NoPageTransition.dart';
import 'package:miamitymds/Utils/Transitions/ScalePageTransition.dart';

class MiamityAppBar extends StatefulWidget {
  MiamityAppBar({Key key, this.title}) : super(key: key);
  final String title;
  @override
  MiamityAppBarState createState() => MiamityAppBarState();
}

class MiamityAppBarState extends State<MiamityAppBar> {
  Drawer getNavDrawer(BuildContext context) {
    //   var headerChild = DrawerHeader(child: Text("Header"));
    var aboutChild = AboutListTile(
        child: Text("About"),
        applicationName: "Application Name",
        applicationVersion: "v1.0.0",
        applicationIcon: Icon(Icons.adb),
        icon: Icon(Icons.info));

    ListTile getNavItem(var icon, String s, Widget route) {
      return ListTile(
        leading: Icon(icon),
        title: Text(s),
        onTap: () {
          setState(() {
            // pop closes the drawer
            Navigator.pop(context);
            Navigator.push(
              context,
              NoPageTransition(builder: (context) => route),
            );
          });
        },
      );
    }

    var myNavChildren = [
      // getNavItem(Icons.settings, "Settings", SettingsScreen.routeName),
      getNavItem(Icons.home, "Accueil", HomeScreen()),
      // getNavItem(Icons.restaurant, "Ajouter un plat", "/addPlate"),
      // getNavItem(Icons.restaurant, "Historique",),
      getNavItem(Icons.restaurant, "Liste des utilisateurs", UserList()),
      // getNavItem(Icons.account_box, "Account", AccountScreen.routeName),
      aboutChild
    ];

    ListView listView = ListView(children: myNavChildren);

    return Drawer(
      child: listView,
    );
  }

  @override
  Drawer build(BuildContext context) {
    return getNavDrawer(context);
  }
}
