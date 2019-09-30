import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/LoginPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/auth.dart';
import 'package:miamitymds/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miamity',
      theme:
          ThemeData(primarySwatch: Colors.green, cardColor: Colors.grey[100]),
      home: RootPage(auth: new Auth()),
    );
  }
}
