import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:miamitymds/CommonPages/LoginPage.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityTextFormField.dart';
import 'package:miamitymds/Widgets/PageTitle.dart';
import 'package:miamitymds/auth.dart';
import 'package:miamitymds/root_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:miamitymds/Widgets/MiamityTextField.dart';
import 'package:image_picker/image_picker.dart';

const kGoogleApiKey = "AIzaSyDGduKhs9Z1sqpz0i6GBGEr3O8XBzqKxFg";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

final StorageReference storageReference = FirebaseStorage().ref();

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  static const String routeName = "/addUser";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _userFirstname;
  String _userLastname;
  String _userEmail;
  String _userUsername;
  String _userPassword;
  String _userPhone;
  String _userPasswordConfirmation = "";
  String imageURL;
  File sampleImage;
  bool waitingForUploadImage;
  String selectedAddress;
  bool isAddressSelected;
  double longitude;
  double latitude;
  String _errorMessage;
  String _encryptedPassword;

  @override
  initState() {
    imageURL = "";
    waitingForUploadImage = false;
    isAddressSelected = false;
    longitude = null;
    latitude = null;
    sampleImage = null;
    _errorMessage = "";
    super.initState();
  }

  Future getImage() async {
    _openFileExplorer();
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  validateForm() {
    final formState = _formKey.currentState;
    if (formState != null) {
      if (formState.mounted) {
        formState.validate();
      }
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _openFileExplorer() async {
    ///Check si les permissions ont été données. Sinon les demande.
    PermissionStatus permissionCamera =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus permissionPhoto =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    if (permissionCamera.value.toString() ==
            PermissionStatus.granted.toString() &&
        permissionPhoto.value.toString() ==
            PermissionStatus.granted.toString()) {
      print("permission already granted");
    } else {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.camera, PermissionGroup.photos]);
    }
  }

  uploadImage() async {
    if (sampleImage == null) {
      imageURL =
          "https://cdn.samsung.com/etc/designs/smg/global/imgs/support/cont/NO_IMG_600x600.png";
      return;
    } else {
      setState(() {
        waitingForUploadImage = true;
      });
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(Random().nextInt(10000000).toString() + ".jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
      final StorageTaskSnapshot taskSnapshot = (await task.onComplete);
      imageURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        waitingForUploadImage = false;
      });
    }
  }

  wait() {
    if (waitingForUploadImage) {
      return CircularProgressIndicator();
    } else {}
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      // var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      setState(() {
        this.selectedAddress = address[0].addressLine;
        this.isAddressSelected = true;
        this.latitude = lat;
        this.longitude = lng;
      });
    }
  }

  _storeData() async {
    String uid = await widget.auth
        .createUserWithEmailAndPassword(_userEmail, _userPassword);
    Firestore.instance
        .collection('users')
        .document(uid)
        .setData({
          "profile_picture": imageURL,
          "firstname": _userFirstname,
          "lastname": _userLastname,
          "email": _userEmail,
          "phone": _userPhone,
          "username": _userUsername,
          "liste_plats": [],
          "address": selectedAddress,
          "latitude": latitude,
          "longitude": longitude,
        })
        .then((result) => {
              Navigator.pop(context),
            })
        .catchError((err) => err);
  }

  bool _isAllOk() {
    return isAddressSelected &&
        validateAndSave() &&
        _userPassword == _userPasswordConfirmation;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Veuillez entrer une adresse email';
    }
    if (!regex.hasMatch(value))
      return 'Entrez un email valide';
    else
      return null;
  }

  String validatePasswordConfirmation(String value) {
    if (value.isEmpty) {
      return "Vous devez confirmer votre mot de passe.";
    } else {
      return null;
    }
  }

  sendForm() async {
    //Si tous les champs mandatory sont renseignés.
    if (validateAndSave()) {
      //Si on a selectionner une adresse (essentiel pour la creation d'un compte.)
      if (isAddressSelected) {
        if (sampleImage != null) await uploadImage();
        if (_userFirstname.isEmpty) {
          _userFirstname = "No";
        }
        if (_userLastname.isEmpty) {
          _userLastname = "name";
        }
        try {
          await _storeData();
          setState(() {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                          auth: widget.auth,
                        )));
          });
        } catch (e) {
          setState(() {
            _errorMessage = e.toString();
          });
          print(_errorMessage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(children: <Widget>[
      Stack(
        children: <Widget>[
          Opacity(
            opacity: waitingForUploadImage ? 0.5 : 1,
            child: ListView(
              children: <Widget>[
                Form(
                  onChanged: validateForm(),
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      PageTitle(title: "Créer un compte"),
                      FlatButton(
                        child: Text("Vous avez déjà un compte?",
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                          auth: widget.auth,
                                        )));
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      MiamityTextFormField(
                        icon:Icons.person,
                          label: "Firstname",
                          onSaved: (value) => _userFirstname = value),
                      MiamityTextFormField(
                        icon: Icons.person,
                          label: "Lastname",
                          onSaved: (value) => _userLastname = value),
                      MiamityTextFormField(
                        icon:Icons.phone,
                        label: 'Phone',
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _userPhone = value,
                      ),
                      MiamityTextFormField(
                        icon: Icons.email,
                          label: 'Email*',
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          onSaved: (value) => _userEmail = value),
                      MiamityTextFormField(
                          icon: Icons.tag_faces,
                          label: 'Username*',
                          validator: (String value) => value.isEmpty
                              ? 'Vous devez entrer un nom d\'utilisateur.'
                              : null,
                          onSaved: (value) => _userUsername = value),
                      MiamityTextFormField(
                          icon: Icons.lock,
                          label: 'Password*',
                          keyboardType: TextInputType.visiblePassword,
                          isObscureText: true,
                          onChanged: (value) => _userPassword = value,
                          validator: (String value) => value.isEmpty
                              ? 'Vous devez entrer un mot de passe.'
                              : null,
                          onSaved: (value) => _userPassword = value),
                      MiamityTextFormField(
                          icon:Icons.lock,
                          label: 'Password confirmation*',
                          keyboardType: TextInputType.visiblePassword,
                          isObscureText: true,
                          validator: validatePasswordConfirmation,
                          onChanged: (value) =>
                              _userPasswordConfirmation = value,
                          onSaved: (value) =>
                              _userPasswordConfirmation = value),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      )
                    ],
                  ),
                ),
                _userPasswordConfirmation == _userPassword
                    ? Text("")
                    : Text(
                        "Les mots de passes ne correspondent pas",
                        style: TextStyle(color: Colors.red),
                      ),
                isAddressSelected
                    ? Wrap(
                        children: <Widget>[
                          MiamityTextField(
                              text: selectedAddress,
                              isReadOnly: true,
                              onTapFunction: () async {
                                Prediction p = await PlacesAutocomplete.show(
                                    context: context, apiKey: kGoogleApiKey);
                                displayPrediction(p);
                              }),
                          MiamityButton(
                              btnColor: Colors.orange[700],
                              title: "CHANGER L'ADRESSE",
                              onPressed: () async {
                                setState(() {
                                  selectedAddress = null;
                                  isAddressSelected = false;
                                });
                                Prediction p = await PlacesAutocomplete.show(
                                    context: context, apiKey: kGoogleApiKey);
                                displayPrediction(p);
                              })
                        ],
                      )
                    : MiamityButton(
                        btnColor: Colors.blue,
                        title: "JE SELECTIONNE MON ADRESSE",
                        onPressed: () async {
                          // show input autocomplete with selected mode
                          // then get the Prediction selected
                          Prediction p = await PlacesAutocomplete.show(
                              context: context, apiKey: kGoogleApiKey);
                          displayPrediction(p);
                        }),
                Container(
                    child: Row(
                  children: <Widget>[
                    sampleImage == null
                        ? Expanded(
                            child: MiamityButton(
                                btnColor: Colors.blue,
                                title: "JE SELECTIONNE MA PHOTO DE PROFIL",
                                onPressed: () {
                                  getImage();
                                }))
                        : Row(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Image.file(sampleImage,
                                      height: 100, width: 100)),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  MiamityGreenButton(
                                      title: "CHANGER",
                                      onPressed: () {
                                        getImage();
                                      }),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.0)),
                                  MiamityRedButton(
                                      title: "SUPPRIMER",
                                      onPressed: () {
                                        setState(() {
                                          sampleImage = null;
                                        });
                                      }),
                                ],
                              ),
                            ],
                          )
                  ],
                )),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: _isAllOk()
                            ? MiamityButton(
                                title: "TERMINER L'INSCRIPTION",
                                onPressed: () {
                                  sendForm();
                                })
                            : MiamityButton(title: "TERMINER L'INSCRIPTION")),
                  ],
                ),
              ],
            ),
          ),
          Opacity(
            opacity: waitingForUploadImage ? 1.0 : 0,
            child: MiamityProgressIndicator(),
          )
        ],
      ),
    ]));
  }
}
