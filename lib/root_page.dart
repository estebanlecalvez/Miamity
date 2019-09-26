import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/LoginPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/auth.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => RootPageState();
}

enum AuthStatus { notSignedIn, signedIn, awaiting }

class RootPageState extends State<RootPage> {
  AuthStatus _authStatus = AuthStatus.awaiting;

  @override
  void initState() {
    super.initState();
    //On verifie si le user est connecté
    widget.auth.currentUser().then((userId) {
      if (userId == null) {
        setState(() {
          _authStatus = AuthStatus.notSignedIn;
        });
      } else {
        setState(() {
          _authStatus = AuthStatus.signedIn;
        });
      }
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
      case AuthStatus.awaiting:
        return new Scaffold(body: PageView(children: <Widget>[MiamityProgressIndicator()]));
    }
  }
}
