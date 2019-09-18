import 'package:flutter/material.dart';


/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityGreenButton extends StatelessWidget {
  MiamityGreenButton({this.title, this.onPressed,this.width,this.icon});

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
                Color(0xFF00bf3d),
                Color(0xFF009e32),
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
