import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/LoginPage.dart';
import 'package:miamitymds/CommonPages/RegisterPage.dart';
import 'package:miamitymds/CommonPages/whatIsNearMePage.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/MamaChef/screens/userListPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miamity',
      theme: ThemeData(
      primarySwatch: Colors.green,
      cardColor: Colors.grey[100]
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        UserList.routeName: (BuildContext context) => UserList(),
        RegisterPage.routeName: (BuildContext context) => RegisterPage(),
        AddPlate.routeName : (BuildContext context) => AddPlate(),
        WhatIsNearMePage.routeName:(BuildContext context)=> WhatIsNearMePage(),
        LoginPage.routeName:(BuildContext context)=> LoginPage(),
      },
    );
  }
}



              





