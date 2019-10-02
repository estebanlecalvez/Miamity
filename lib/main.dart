import 'package:flutter/material.dart';
import 'package:miamitymds/auth.dart';
import 'package:miamitymds/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miamity',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: RootPage(auth: new Auth()),
    );
  }
}
