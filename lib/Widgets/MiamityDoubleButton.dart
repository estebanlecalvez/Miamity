import 'package:flutter/material.dart';

/// Classical MiamityButton which is green (Everything's fine!) , you can define a title, a onPressed function and a width (by default 150)
class MiamityDoubleButton extends StatelessWidget {
  MiamityDoubleButton(
      {this.title1,
      this.title2,
      this.onPressed1,
      this.onPressed2,
      this.btnColor1,
      this.btnColor2,
      this.verticalPadding});

  final String title1;
  final Function onPressed1;
  final String title2;
  final Function onPressed2;
  final Color btnColor1;
  final Color btnColor2;
  final EdgeInsets verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: onPressed1,
                  textColor: Colors.white,
                  color: btnColor1 ?? Colors.orange[700],
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: verticalPadding ??
                          EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Text(title1 ?? "",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w300)),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: onPressed2,
                  textColor: Colors.white,
                  color: btnColor2 ?? Colors.orange[700],
                  child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: verticalPadding ??
                          EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Text(title2 ?? "",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w300)),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
