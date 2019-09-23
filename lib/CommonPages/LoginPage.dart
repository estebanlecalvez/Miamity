import 'package:flutter/material.dart';
import 'package:miamitymds/CommonPages/RegisterPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/Utils/Transitions/NoPageTransition.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miamitymds/Widgets/MiamityTextFormField.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  static String routeName = "/login";
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _success = false;
  String _userEmail = "";
  bool _smthngIsWrong = false;
  String _errorMessage = "";
  bool _isLoading = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  validateAndSubmit() async {
    try {
      if (validateAndSave()) {
        setState(() {
          _isLoading = true;
        });
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _email.text, password: _password.text))
            .user;
        if (user != null) {
          setState(() {
            _success = true;
            _smthngIsWrong = false;
            _userEmail = user.email;
            _errorMessage = "";
            _isLoading = false;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          setState(() {
            _success = false;
            _smthngIsWrong = true;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (e.code == "ERROR_USER_NOT_FOUND") {
        setState(() {
          _smthngIsWrong = true;
          _errorMessage = "Utilisateur non trouvé.";
        });
      } else if (e.code == "ERROR_WRONG_PASSWORD") {
        setState(() {
          _smthngIsWrong = true;
          _errorMessage = "Mot de passe incorrect";
        });
      }
      print("Got an error : $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Se connecter"),
      ),
      body: new Container(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              new MiamityTextFormField(
                controller: _email,
                label: "Email",
                validator: (String value) =>
                    value.isEmpty ? 'Vous devez entrer votre Email' : null,
                onSaved: (value) => _email.text = value,
              ),
              new MiamityTextFormField(
                controller: _password,
                label: "Mot de passe",
                validator: (String value) => value.isEmpty
                    ? 'Vous devez entrer votre mot de passe'
                    : null,
                onSaved: (value) => _password.text = value,
                isObscureText: true,
              ),
              _smthngIsWrong
                  ? Text(_errorMessage,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0))
                  : Text(""),
              FlatButton(
                child: Text("Vous n'avez pas de compte?",
                    style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
              ),
              new MiamityButton(
                  title: "SE CONNECTER",
                  onPressed: () {
                    validateAndSubmit();
                  }),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}
