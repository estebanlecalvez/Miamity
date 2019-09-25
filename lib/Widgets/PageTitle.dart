import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  PageTitle({this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
        Center(
            child: Text(
          title,
          style: TextStyle(color: Colors.green, fontSize: 20.0),
        )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ],
    );
  }
}
