import 'package:flutter/material.dart';

/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityButtonWithIcon extends StatelessWidget {
  MiamityButtonWithIcon(
      {this.title,
      this.onPressed,
      this.btnColor,
      this.verticalPadding,
      this.icon});

  final String title;
  final IconData icon;
  final Function onPressed;
  final Color btnColor;
  final EdgeInsets verticalPadding;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      textColor: Colors.white,
      color: btnColor ?? Colors.orange[700],
      child: Container(
          padding: verticalPadding ?? EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: <Widget>[
              Spacer(),
              Icon(
                icon,
                color: Colors.white,
              ),
              Spacer(flex: 2),
              Text(title ?? "", style: TextStyle(fontSize: 16)),
              Spacer(flex: 3),
            ],
          )),
    );
  }
}
