import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/whatIsNearMePage.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/MamaChef/screens/userListPage.dart';

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
              MaterialPageRoute(builder: (context) => route),
            );
          });
        },
      );
    }

    var myNavChildren = [
      DrawerHeader(
        child: CircleAvatar(child: Icon(Icons.restaurant,color: Colors.orange,),),
        decoration: BoxDecoration(color: Colors.green),
      ),
      // getNavItem(Icons.settings, "Settings", SettingsScreen.routeName),
      getNavItem(Icons.home, "Accueil", HomeScreen()),
      getNavItem(Icons.restaurant, "Ajouter un plat", AddPlate(title: 'Ajouter un plat',)),
      // getNavItem(Icons.restaurant, "Historique",),
      getNavItem(Icons.person, "Liste des utilisateurs", UserList()),
      getNavItem(Icons.map, "Plats proche de moi", WhatIsNearMePage()),
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
