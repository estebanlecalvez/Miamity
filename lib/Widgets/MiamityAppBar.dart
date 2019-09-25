import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/LoginPage.dart';
import 'package:miamitymds/CommonPages/whatIsNearMePage.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/MamaChef/screens/myAccountPage.dart';
import 'package:miamitymds/MamaChef/screens/userListPage.dart';
import 'package:miamitymds/auth.dart';
import 'package:miamitymds/root_page.dart';

class MiamityAppBar extends StatefulWidget {
  MiamityAppBar({this.title, this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String title;
  @override
  MiamityAppBarState createState() => MiamityAppBarState();
}

class MiamityAppBarState extends State<MiamityAppBar> {
  Drawer getNavDrawer(BuildContext context) {
    //   var headerChild = DrawerHeader(child: Text("Header"));
    var aboutChild = AboutListTile(
        child: Text("A propos"),
        applicationName: "Miamity",
        applicationVersion: "beta_0.0.5",
        applicationIcon: Icon(Icons.restaurant),
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

    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignedOut();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RootPage(
                    auth: widget.auth,
                  )),
        );
      } catch (e) {
        print(e);
      }
    }

    ListTile getSignOutItem() {
      return ListTile(
        leading: Icon(Icons.power_settings_new),
        title: Text("Se déconnecter"),
        onTap: () {
          _signOut();
        },
      );
    }

    var myNavChildren = [
      DrawerHeader(
        child: CircleAvatar(
          child: Icon(
            Icons.restaurant,
          ),
          backgroundColor: Colors.green,
        ),
        decoration: BoxDecoration(),
      ),
      // getNavItem(Icons.settings, "Settings", SettingsScreen.routeName),
      getNavItem(
          Icons.home,
          "Accueil",
          HomeScreen(
            auth: widget.auth,
            onSignedOut: widget.onSignedOut,
          )),
      getNavItem(
          Icons.person,
          "Mon compte",
          MyAccountPage(
            auth: widget.auth,
            onSignedOut: widget.onSignedOut,
          )),
      getNavItem(
          Icons.restaurant,
          "Ajouter un plat",
          AddPlate(
            auth: widget.auth,
            onSignedOut: widget.onSignedOut,
          )),
      // getNavItem(Icons.restaurant, "Historique",),
      getNavItem(
          Icons.person,
          "Liste des utilisateurs",
          UserList(
            auth: widget.auth,
            onSignedOut: widget.onSignedOut,
          )),
      getNavItem(
          Icons.map,
          "Plats proche de moi",
          WhatIsNearMePage(
            auth: widget.auth,
            onSignedOut: widget.onSignedOut,
          )),
      aboutChild,

      getSignOutItem() // getNavItem(Icons.account_box, "Account", AccountScreen.routeName),
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
