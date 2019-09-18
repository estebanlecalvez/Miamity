import 'package:flutter/material.dart';


/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityGreenButton extends StatelessWidget {
  MiamityGreenButton({this.title, this.onPressed,this.width});

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
              Color(0xFF00bf3d),
              Color(0xFF009e32),
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
        )
      ),
    );
}
}
