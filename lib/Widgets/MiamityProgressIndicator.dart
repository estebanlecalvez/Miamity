import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiamityProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 70,
            width: 70,
            child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.orange[600]))));
  }
}
