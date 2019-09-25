import 'package:flutter/material.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/auth.dart';

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
        child: Column(
          children: <Widget>[
            Text("Accueil"),
          ],
        ),
      )),

      // Set the nav drawer
      drawer: MiamityAppBar(auth: widget.auth, onSignedOut: widget.onSignedOut),
    );
  }
}
