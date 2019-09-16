import 'package:flutter/material.dart';

class MiamityGreenButton extends StatelessWidget {
  MiamityGreenButton(this.title);

  // Fields in a Widget subclass are always marked "final".
  final String title;

  @override
  Widget build(BuildContext context) {
    return  FlatButton(
      onPressed: () {},
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
        padding: const EdgeInsets.only(right:50,left:50,top:7,bottom:7),
        child: Text(
          title,
          style: TextStyle(fontSize: 15)
        ),
      ),
    );
}
}
