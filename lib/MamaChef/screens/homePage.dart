import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/DishesList.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/MamaChef/screens/myAccountPage.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityButtonWithIcon.dart';
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
  bool _isTraducted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
        centerTitle: true,
      ),
      body: Container(
          child: Center(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  _isTraducted = !_isTraducted;
                });
              },
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                    color: Colors.orange[700],
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(10))),
                child: Icon(Icons.language, color: Colors.white),
              ),
            ),
            Column(
              children: <Widget>[
                Spacer(),
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.memoryNetwork(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.height * 0.25,
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
                Spacer(),
                MiamityButtonWithIcon(
                    title:
                        _isTraducted ? "JE VEUX CUISINER" : "JE VEUX MIAMINER",
                    icon: Icons.cake,
                    onPressed: () async {
                      widget.auth.changePage(
                          context,
                          AddPlate(
                              auth: widget.auth,
                              onSignedOut: widget.onSignedOut));
                    }),
                Spacer(),
                GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.memoryNetwork(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.height * 0.25,
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
                Spacer(),
                MiamityButtonWithIcon(
                    title: _isTraducted ? "JE VEUX MANGER" : "JE VEUX MIAMER",
                    icon: Icons.restaurant_menu,
                    onPressed: () {
                      widget.auth.changePage(
                          context,
                          DishesListPage(
                              auth: widget.auth,
                              onSignedOut: widget.onSignedOut));
                    }),
              ],
            ),
          ],
        ),
      )),
      // Set the nav drawer
      endDrawer:
          MiamityAppBar(auth: widget.auth, onSignedOut: widget.onSignedOut),
    );
  }
}
