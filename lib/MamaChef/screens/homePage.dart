import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/DishesList.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/MamaChef/screens/myAccountPage.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/auth.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.title, this.auth, this.onSignedOut});
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
        centerTitle: true,
      ),
      body: Container(
          child: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.memoryNetwork(
                      height: 200,
                      width: 200,
                      placeholder: kTransparentImage,
                      fadeInDuration: const Duration(seconds: 1),
                      fit: BoxFit.cover,
                      image:
                          "https://journalmetro.com/wp-content/uploads/2014/05/carriecc80res_chef-cuisinier_c100.jpg?w=860",
                    ),
                  ),
                  onTap: () async {
                    widget.auth.changePage(
                        context,
                        AddPlate(
                            auth: widget.auth,
                            onSignedOut: widget.onSignedOut));
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                MiamityButton(
                    title: "J'AJOUTE UN PLAT",
                    onPressed: () async {
                      widget.auth.changePage(
                          context,
                          AddPlate(
                              auth: widget.auth,
                              onSignedOut: widget.onSignedOut));
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.memoryNetwork(
                      height: 200,
                      width: 200,
                      placeholder: kTransparentImage,
                      fadeInDuration: const Duration(seconds: 1),
                      fit: BoxFit.cover,
                      image:
                          "https://p8.storage.canalblog.com/88/72/717345/113739915.jpg",
                    ),
                  ),
                  onTap: () async {
                    widget.auth.changePage(
                        context,
                        DishesListPage(
                            auth: widget.auth,
                            onSignedOut: widget.onSignedOut));
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                MiamityButton(
                    title: "JE REGARDE LES PLATS PROCHE DE MOI",
                    onPressed: () {
                      widget.auth.changePage(
                          context,
                          DishesListPage(
                              auth: widget.auth,
                              onSignedOut: widget.onSignedOut));
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ],
            )
          ],
        ),
      )),
      // Set the nav drawer
      endDrawer:
          MiamityAppBar(auth: widget.auth, onSignedOut: widget.onSignedOut),
    );
  }
}
