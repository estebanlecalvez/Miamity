import 'package:flutter/material.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';

class WhatIsNearMePage extends StatefulWidget {
  WhatIsNearMePage({Key key, this.title}) : super(key: key);
  static const String routeName = "/addUser";

  final String title;
  @override
  WhatIsNearMePageState createState() => WhatIsNearMePageState();
}

class WhatIsNearMePageState extends State<WhatIsNearMePage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Center(
        child: Text("Accueil"),
      )),
      // Set the nav drawer
      drawer: MiamityAppBar(),
    );
  }
}