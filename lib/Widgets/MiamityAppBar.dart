import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/MessagesPage.dart';
import 'package:miamitymds/CommonPages/whatIsNearMePage.dart';
import 'package:miamitymds/CommonPages/DishesList.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/MamaChef/screens/myAccountPage.dart';
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
        aboutBoxChildren: <Widget>[
          Text("Miamer: Manger"),
          Text("Miaminer: Cuisiner"),
          Text("Miameur: Celui qui mange"),
          Text("Miamchef: Celui qui cuisine")
        ],
        applicationIcon: Icon(Icons.restaurant),
        icon: Icon(Icons.info));

    ListTile getNavItem(var icon, String s, Widget route) {
      return ListTile(
        leading: Icon(icon),
        title: Text(s),
        onTap: () {
          setState(() {
            Navigator.of(context, rootNavigator: true).pop('drawer');
            widget.auth.changePage(context, route);
          });
        },
      );
    }

    _signOut() async {
      try {
        widget.auth.signOut();
        widget.onSignedOut();
        widget.auth.changePage(context, RootPage(auth: widget.auth));
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
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                    image: new AssetImage('images/logo_without_text.jpg'),
                    fit: BoxFit.fitWidth),
              ))),
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
      // getNavItem(
      //   Icons.restaurant,
      //   "Historique",
      // ),
      getNavItem(
          Icons.map,
          "Plats proche de moi",
          DishesListPage(
            auth: widget.auth,
            onSignedOut: widget.onSignedOut,
          )),
      getNavItem(Icons.message, "Mes messages",
          MessagesPage(auth: widget.auth, onSignedOut: widget.onSignedOut)),
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
