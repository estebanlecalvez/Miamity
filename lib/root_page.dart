import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/LoginPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/auth.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    //On verifie si le user est connecté
    widget.auth.currentUser().then((userId) {
      setState(() {
        if (userId != null) {
          _authStatus = AuthStatus.signedIn;
        } else {
          _authStatus = AuthStatus.notSignedIn;
        }
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return new HomeScreen(auth: widget.auth, onSignedOut: _signedOut);
    }
  }
}
