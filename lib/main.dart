import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:miamitymds/CommonPages/whatIsNearMePage.dart';
import './MamaChef/screens/homePage.dart';
import 'package:miamitymds/MamaChef/screens/userListPage.dart';
import 'package:miamitymds/MamaChef/screens/AddUserPage.dart';
// import './MamaChef/screens/AddPlatePage.dart';


const kGoogleApiKey = "AIzaSyDGduKhs9Z1sqpz0i6GBGEr3O8XBzqKxFg";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

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
      home: HomeScreen(title: 'Accueil'),
      routes: <String, WidgetBuilder>{
        UserList.routeName: (BuildContext context) => UserList(),
        AddUser.routeName: (BuildContext context) => AddUser(),
        WhatIsNearMePage.routeName:(BuildContext context)=> WhatIsNearMePage(),
      },
    );
  }
}



              





