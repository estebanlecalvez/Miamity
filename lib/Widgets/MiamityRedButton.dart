import 'package:flutter/material.dart';

/// Classical MiamityButton which is red (Cancel), you can define a title, a onPressed function and a width (by default 150)
class MiamityRedButton extends StatelessWidget {
  MiamityRedButton({this.title, this.onPressed,this.width,this.icon});

  // Fields in a Widget subclass are always marked "final".
  final String title;
  final Function onPressed;
  final double width;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      textColor: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:  BorderRadius.all(const Radius.circular(30.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFd10e00),
              Color(0xFF9e0b00),
            ],
          ),
        ),
        padding: const EdgeInsets.only(top:7,bottom:7),
        width: width ?? 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              icon != null? Icon(icon) : Text(""),
              Text(
                 icon !=null? " "+title ?? "": title ??"",
                style: TextStyle(fontSize: 15)
            ),
            ],
          )
        ),
    );

}
}
