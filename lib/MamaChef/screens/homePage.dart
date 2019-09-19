import 'package:flutter/material.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
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
        child: Text("Accueil"),
      )),
      // Set the nav drawer
      drawer:MiamityAppBar(),
    );
  }
}