import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/whatIsNearMePage.dart';
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
                ClipRRect(
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                MiamityButton(
                    title: "J'AJOUTE UN PLAT",
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPlate(
                                  auth: widget.auth,
                                )),
                      );
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                ClipRRect(
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                MiamityButton(
                  title: "JE REGARDE LES PLATS PROCHE DE MOI",
                  onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WhatIsNearMePage(
                                  auth: widget.auth,
                                )),
                      );
                    }
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child:  FadeInImage.memoryNetwork(
                        height: 200,
                        width: 200,
                        placeholder: kTransparentImage,
                        fadeInDuration: const Duration(seconds: 1),
                        fit: BoxFit.cover,
                        image:
                            "https://p8.storage.canalblog.com/88/72/717345/113739915.jpg",
                      ),
                    ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                MiamityButton(
                  title: "JE MODIFIE MON COMPTE",
                  onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAccountPage(
                                  auth: widget.auth,
                                )),
                      );
                    }
                ),
              ],
            )
          ],
        ),
      )),

      // Set the nav drawer
      drawer: MiamityAppBar(auth: widget.auth, onSignedOut: widget.onSignedOut),
    );
  }
}
