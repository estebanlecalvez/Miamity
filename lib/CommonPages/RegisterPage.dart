import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:miamitymds/Widgets/MiamityTextField.dart';
import 'package:image_picker/image_picker.dart';

const kGoogleApiKey = "AIzaSyDGduKhs9Z1sqpz0i6GBGEr3O8XBzqKxFg";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

final StorageReference storageReference = FirebaseStorage().ref();

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/addUser";
  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userFirstnameController;
  TextEditingController userLastNameController;
  TextEditingController userEmailController;
  TextEditingController userUsernameController;
  TextEditingController userPasswordController;
  TextEditingController userPhoneController;
  TextEditingController userPasswordConfirmationController;
  TextEditingController userProfilePictureController;
  TextEditingController userAddressController;
  TextEditingController userCityController;
  TextEditingController userPostalCodeController;
  TextEditingController userCountryController;
  String imageURL;
  File sampleImage;
  bool waitingForUploadImage;
  String selectedAddress;
  bool isAddressSelected;
  double longitude;
  double latitude;

  @override
  initState() {
    userFirstnameController = new TextEditingController();
    userLastNameController = new TextEditingController();
    userEmailController = new TextEditingController();
    userUsernameController = new TextEditingController();
    userPasswordController = new TextEditingController();
    userPhoneController = new TextEditingController();
    userPasswordConfirmationController = new TextEditingController();
    imageURL = "";
    waitingForUploadImage = false;
    isAddressSelected = false;
    longitude = null;
    latitude = null;
    super.initState();
  }

  Future getImage() async {
    _openFileExplorer();
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  void _openFileExplorer() async {
    ///Check si les permissions ont été données. Sinon les demande.
    PermissionStatus permissionCamera =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus permissionPhoto =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    if (permissionCamera.value.toString() == PermissionStatus.granted.toString() &&
        permissionPhoto.value.toString() == PermissionStatus.granted.toString()) {
      print("permission already granted");
    } else {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.camera, PermissionGroup.photos]);
    }
  }

  uploadImage() async {
    if (sampleImage == null) {
      return;
    }
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(Random().nextInt(10000000).toString() + ".jpg");
    final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
    final StorageTaskSnapshot taskSnapshot = (await task.onComplete);
    imageURL = await taskSnapshot.ref.getDownloadURL();
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
      print(this.latitude);
      print(this.longitude);
      print("isAdressSelected: " + this.isAddressSelected.toString());
      print(this.selectedAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajouter un utilisateur"),
        ),
        body: PageView(children: <Widget>[
          ListView(
            children: <Widget>[
              Text(
                "Ajouter un utilisateur",
                style: TextStyle(fontSize: 20.0, color: Colors.green),
              ),
              Column(
                children: <Widget>[
                  MiamityTextField(
                      text: "Firstname", controller: userFirstnameController),
                  MiamityTextField(
                      text: "Lastname", controller: userLastNameController),
                  MiamityTextField(
                      text: 'Phone',
                      keyboardType: TextInputType.phone,
                      controller: userPhoneController),
                  MiamityTextField(
                      text: 'Email*',
                      keyboardType: TextInputType.emailAddress,
                      controller: userEmailController),
                  MiamityTextField(
                      text: 'Username*', controller: userUsernameController),
                  MiamityTextField(
                      text: 'Password*',
                      controller: userPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      isPasswordField: true),
                  MiamityTextField(
                    text: 'Password confirmation*',
                    controller: userPasswordConfirmationController,
                    keyboardType: TextInputType.visiblePassword,
                    isPasswordField: true,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  )
                ],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                MiamityGreenButton(
                                    title: "CHANGER",
                                    onPressed: () {
                                      getImage();
                                    }),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0)),
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
                  waitingForUploadImage
                      ? Center(child:CircularProgressIndicator())
                      : Expanded(
                          child: MiamityButton(
                              title: "TERMINER L'INSCRIPTION",
                              onPressed: () async {
                                if (userUsernameController.text.isNotEmpty &&
                                    userPasswordController.text.isNotEmpty &&
                                    userEmailController.text.isNotEmpty &&
                                    userPasswordConfirmationController
                                        .text.isNotEmpty &&
                                    userPasswordConfirmationController.text ==
                                        userPasswordController.text) {
                                  setState(() {
                                    waitingForUploadImage = true;
                                  });
                                  await uploadImage();
                                  if (imageURL == null) {
                                    imageURL =
                                        "https://static.thenounproject.com/png/340719-200.png";
                                  }
                                  if (userFirstnameController.text.isEmpty) {
                                    userFirstnameController.text = "No";
                                  }
                                  if (userLastNameController.text.isEmpty) {
                                    userLastNameController.text = "name";
                                  }
                                  if (userPhoneController.text.isEmpty) {
                                    userPhoneController.text = null;
                                  }
                                  Firestore.instance
                                      .collection('users')
                                      .add({
                                        "profile_picture": imageURL,
                                        "firstname":
                                            userFirstnameController.text,
                                        "lastname": userLastNameController.text,
                                        "email": userEmailController.text,
                                        "phone": userPhoneController.text,
                                        "username": userUsernameController.text,
                                        "password": userPasswordController.text,
                                        "liste_plats": [],
                                        "address": selectedAddress,
                                        "latitude": latitude,
                                        "longitude": longitude,
                                      })
                                      .then((result) => {
                                            Navigator.pop(context),
                                            userEmailController.clear(),
                                            userFirstnameController.clear(),
                                            userLastNameController.clear(),
                                            userPasswordConfirmationController
                                                .clear(),
                                            userPasswordController.clear(),
                                            userUsernameController.clear(),
                                          })
                                      .catchError((err) => err);
                                }
                              })),
                ],
              ),
            ],
          ),
        ]));
  }
}
