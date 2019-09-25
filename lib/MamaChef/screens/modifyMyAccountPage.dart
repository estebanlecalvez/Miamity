import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miamitymds/MamaChef/screens/myAccountPage.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityTextField.dart';
import 'package:miamitymds/Widgets/MiamityTextFormField.dart';
import 'package:miamitymds/auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';

const kGoogleApiKey = "AIzaSyDGduKhs9Z1sqpz0i6GBGEr3O8XBzqKxFg";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final StorageReference storageReference = FirebaseStorage().ref();

class ModifyMyAccountPage extends StatefulWidget {
  ModifyMyAccountPage({this.auth, this.onSignedOut, this.user});
  final BaseAuth auth;
  final DocumentSnapshot user;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() => _ModifyMyAccountPageState();
}

class _ModifyMyAccountPageState extends State<ModifyMyAccountPage> {
  final _formKey = GlobalKey<FormState>();

  Firestore _instance = Firestore.instance;
  bool isThereAUser = false;
  String userId;
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

  @override
  initState() {
    imageURL = widget.user["profile_picture"];
    waitingForUploadImage = false;
    isAddressSelected = false;
    longitude = null;
    latitude = null;
    sampleImage = null;
    _errorMessage = "";
    selectedAddress = widget.user["address"];
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
    return new Scaffold(
      appBar: AppBar(
        title: Text("Modifier mon compte"),
      ),
      body: ListView(children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                MiamityTextFormField(
                    icon: Icons.person,
                    label: widget.user["firstname"] ?? "Firstname",
                    onSaved: (value) => _userFirstname = value),
                MiamityTextFormField(
                    icon: Icons.person,
                    label: widget.user["lastname"] ?? "Lastname",
                    onSaved: (value) => _userLastname = value),
                MiamityTextFormField(
                  icon: Icons.phone,
                  label: widget.user["phone"] ?? 'Phone',
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => _userPhone = value,
                ),
                MiamityTextFormField(
                    icon: Icons.email,
                    label: widget.user["email"] ?? 'Email*',
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    onSaved: (value) => _userEmail = value),
                MiamityTextFormField(
                    icon: Icons.tag_faces,
                    label: widget.user["username"] ?? 'Username*',
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
                    icon: Icons.lock,
                    label: 'Password confirmation*',
                    keyboardType: TextInputType.visiblePassword,
                    isObscureText: true,
                    validator: validatePasswordConfirmation,
                    onChanged: (value) => _userPasswordConfirmation = value,
                    onSaved: (value) => _userPasswordConfirmation = value),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                _userPasswordConfirmation == _userPassword
                    ? Text("")
                    : Text(
                        "Les mots de passes ne correspondent pas",
                        style: TextStyle(color: Colors.red),
                      ),
                Wrap(
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
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Hero(
                            tag: "user_profile_picture_modify_account",
                            child: FadeInImage.memoryNetwork(
                              height: 100,
                              placeholder: kTransparentImage,
                              fadeInDuration: const Duration(seconds: 1),
                              image: imageURL ?? "",
                            ),
                          )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MiamityGreenButton(
                            title: "CHANGER",
                            onPressed: () {
                              getImage();
                            }),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
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
                )),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: _isAllOk()
                            ? MiamityButton(
                                title: "TODO MODIFICATION",
                                onPressed: () {
                                  sendForm();
                                })
                            : MiamityButton(title: "TODO MODIFICATION")),
                  ],
                ),
              ],
            )),
      ]),
    );
  }
}
