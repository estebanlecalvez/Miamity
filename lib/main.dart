import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miamitymds/auth.dart';
import 'package:miamitymds/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Map<int, Color> color = {
    50: Colors.orange[50],
    100: Colors.orange[100],
    200: Colors.orange[200],
    300: Colors.orange[300],
    400: Colors.orange[400],
    500: Colors.orange[500],
    600: Colors.orange[600],
    700: Colors.orange[700],
    800: Colors.orange[800],
    900: Colors.orange[900],
  };

  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFEB6E1E, color);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Miamity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: colorCustom, fontFamily: 'Raleway'),
      home: RootPage(auth: new Auth()),
    );
  }
}
