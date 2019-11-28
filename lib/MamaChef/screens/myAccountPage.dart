import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:miamitymds/MamaChef/screens/ConsultMyDishes.dart';
import 'package:miamitymds/MamaChef/screens/modifyMyAccountPage.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/Widgets/MiamityTextFormField.dart';
import 'package:miamitymds/auth.dart';
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
        centerTitle: true,
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
      endDrawer: MiamityAppBar(
        auth: widget.auth,
        onSignedOut: widget.onSignedOut,
      ),
    );
  }
}
