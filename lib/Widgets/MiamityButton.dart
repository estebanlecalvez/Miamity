import 'package:flutter/material.dart';

/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityButton extends StatelessWidget {
  MiamityButton({this.title, this.onPressed, this.width, this.btnColor});

  final String title;
  final Function onPressed;
  final double width;
  final Color btnColor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: btnColor ?? Colors.orange[700],
      child: Container(
          alignment: Alignment.bottomLeft,
          child: Container(
              padding:EdgeInsets.symmetric(vertical:20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(title ?? "",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300)),
                      Padding(padding: EdgeInsets.only(right: 10)),
                    ],
                  )
                ],
              ))),
    );
  }
}
