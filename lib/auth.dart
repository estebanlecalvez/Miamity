import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/root_page.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<bool> isAUserConnected();
  void changePage(BuildContext context, Widget route);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseInstance = FirebaseAuth.instance;
  bool isSignIn;
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await _firebaseInstance.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user =
        (await _firebaseInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
            .user;
    return user.uid;
  }

  Future<void> signOut() async {
    _firebaseInstance.signOut();
  }

  Future<bool> isAUserConnected() async {
    return await currentUser() != null;
  }

  void changePage(BuildContext context, Widget route) async {
    bool isConnected = await isAUserConnected();
    if (isConnected) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => route));
    } else {
      signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RootPage(auth: new Auth())),
          (Route<dynamic> route) => false);
    }
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseInstance.currentUser();
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }
}
