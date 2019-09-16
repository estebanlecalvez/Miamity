import 'package:flutter/material.dart';

class ShowUserPage extends StatelessWidget {
  ShowUserPage();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(""),
                RaisedButton(
                    child: Text('Back To HomeScreen'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () => Navigator.pop(context)),
              ]),
        ));
  }
}