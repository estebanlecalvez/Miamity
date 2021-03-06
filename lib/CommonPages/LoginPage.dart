import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:miamitymds/CommonPages/RegisterPage.dart';
import 'package:miamitymds/MamaChef/screens/homePage.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityFormBuilderTextField.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/Widgets/MiamityTextFormField.dart';
import 'package:miamitymds/Widgets/PageTitle.dart';
import 'package:miamitymds/auth.dart';
import 'package:miamitymds/root_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  static String routeName = "/login";
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email;
  String _password;
  bool _success = false;
  String _userEmail = "";
  bool _smthngIsWrong = false;
  String _errorMessage = "";
  bool _isLoading = false;

  bool validateAndSave() {
    if (formKey.currentState.saveAndValidate()) {
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

        var form = formKey.currentState.value;
        var formValues = form.values.toList();
        await widget.auth
            .signInWithEmailAndPassword(formValues[0], formValues[1]);
        String userId = await widget.auth.currentUser();
        if (userId != null) {
          print("Signed in as user with id $userId");
          widget.onSignedIn();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => RootPage(
                        auth: widget.auth,
                      )),
              (Route<dynamic> route) => false);
        }
      }
    } catch (e) {
      setState(() {
        _smthngIsWrong = true;
        _errorMessage = "Utilisateur non trouvé.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new PageView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Opacity(
                opacity: _isLoading ? 0.7 : 1,
                child: ListView(
                  children: <Widget>[
                    FormBuilder(
                        autovalidate: true,
                        initialValue: {'email': null, 'password': null},
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            PageTitle(title: "Se connecter"),
                            new MiamityFormBuilderTextField(
                              controller: _emailController,
                              icon: Icons.email,
                              label: "Email",
                              keyboardType: TextInputType.emailAddress,
                              attribute: "email",
                              validators: [
                                FormBuilderValidators.required(
                                    errorText: 'Veuillez entrer un email.'),
                                FormBuilderValidators.max(300),
                                FormBuilderValidators.email(),
                              ],
                            ),
                            new MiamityFormBuilderTextField(
                              controller: _passwordController,
                              label: "Mot de passe",
                              attribute: "password",
                              icon: Icons.lock,
                              validators: [
                                FormBuilderValidators.required(
                                    errorText:
                                        "Veuillez entrer votre mot de passe.")
                              ],
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
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage(auth: widget.auth)));
                                });
                              },
                            ),
                            new MiamityButton(
                                title: "SE CONNECTER",
                                onPressed: () {
                                  validateAndSubmit();
                                }),
                          ],
                        )),
                  ],
                ),
              ),
              Opacity(
                opacity: _isLoading ? 1.0 : 0,
                child: MiamityProgressIndicator(),
              )
            ],
          )
        ],
      ),
    );
  }
}
