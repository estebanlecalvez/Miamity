import 'package:flutter/material.dart';

class MiamityRedButton extends StatelessWidget {
  MiamityRedButton({this.title, this.onPressed,this.width});

  // Fields in a Widget subclass are always marked "final".
  final String title;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return  FlatButton(
      onPressed: onPressed,
      textColor: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:  BorderRadius.all(const Radius.circular(5.0)),
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFFd10e00),
              Color(0xFF9e0b00),
            ],
          ),
        ),
         padding: const EdgeInsets.only(top:7,bottom:7),
        width: width ?? 150,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 15)
          ),
        ),
      ),
    );
}
}
