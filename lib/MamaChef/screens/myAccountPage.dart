import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miamitymds/MamaChef/screens/ConsultMyDishes.dart';
import 'package:miamitymds/MamaChef/screens/modifyMyAccountPage.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityTextField.dart';
import 'package:miamitymds/Widgets/MiamityTextFormField.dart';
import 'package:miamitymds/auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';

const kGoogleApiKey = "AIzaSyDGduKhs9Z1sqpz0i6GBGEr3O8XBzqKxFg";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final StorageReference storageReference = FirebaseStorage().ref();

class MyAccountPage extends StatefulWidget {
  MyAccountPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final _formKey = GlobalKey<FormState>();

  Firestore _instance = Firestore.instance;
  bool isThereAUser = false;
  DocumentSnapshot user;
  bool _isModifyAccount = false;
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
  String _encryptedPassword;

  @override
  initState() {
    isUserCharged();
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

  Future<void> isUserCharged() async {
    bool result = await widget.auth.isAUserConnected();
    DocumentSnapshot document = await getUser();
    setState(() {
      user = document;
      isThereAUser = result;
    });
  }

  Future<DocumentSnapshot> getUser() async {
    DocumentSnapshot result = await _instance
        .collection("users")
        .document(await widget.auth.currentUser())
        .get();
    setState(() {
      user = result;
    });
    return user;
  }

  _showMyDishes() async {
    userId = await widget.auth.currentUser();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConsultMyDishes(
                  auth: widget.auth,
                  onSignedOut: widget.onSignedOut,
                  currentUserId: userId,
                )));
  }

  _modifyAccount() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ModifyMyAccountPage(auth: widget.auth, user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Mon compte"),
      ),
      body: isThereAUser
          ? ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Hero(
                        tag: "user_profile_picture_modify_account",
                        child: FadeInImage.memoryNetwork(
                          height: 100,
                          placeholder: kTransparentImage,
                          fadeInDuration: const Duration(seconds: 1),
                          image: user["profile_picture"] ?? "",
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  MiamityTextFormField(
                    icon: Icons.person,
                    label: user["firstname"],
                    readOnly: true,
                    onTap: null,
                  ),
                  MiamityTextFormField(
                    icon: Icons.person,
                    label: user["lastname"],
                    readOnly: true,
                    onTap: null,
                  ),
                  MiamityTextFormField(
                    icon: Icons.phone,
                    label: user["phone"],
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                    onTap: null,
                  ),
                  MiamityTextFormField(
                    icon: Icons.email,
                    label: user["email"],
                    readOnly: true,
                    onTap: null,
                  ),
                  MiamityTextFormField(
                    icon: Icons.tag_faces,
                    label: user["username"],
                    readOnly: true,
                    onTap: null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  MiamityButton(
                    title: "CONSULTER MES PLATS",
                    onPressed: () {
                      _showMyDishes();
                    },
                  ),
                  MiamityButton(
                    btnColor: Colors.green,
                    title: "MODIFIER MON COMPTE",
                    onPressed: () {
                      _modifyAccount();
                    },
                  ),
                ],
              )
            ])
          : MiamityProgressIndicator(),
      drawer: MiamityAppBar(
        auth: widget.auth,
        onSignedOut: widget.onSignedOut,
      ),
    );
  }
}
