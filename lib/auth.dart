import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<bool> isAUserConnected();
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

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseInstance.currentUser();
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }
}
