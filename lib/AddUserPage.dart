import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Widgets/MiamityTextField.dart';
import 'package:image_picker/image_picker.dart';

final StorageReference storageReference = FirebaseStorage().ref();

class AddUser extends StatefulWidget {
  AddUser({Key key, this.title}) : super(key: key);
  static const String routeName = "/addUser";
  final String title;

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
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
  bool waitingForUploadImage = false;

  @override
  initState() {
    userFirstnameController = new TextEditingController();
    userLastNameController = new TextEditingController();
    userEmailController = new TextEditingController();
    userUsernameController = new TextEditingController();
    userPasswordController = new TextEditingController();
    userPhoneController = new TextEditingController();
    userPasswordConfirmationController = new TextEditingController();
    super.initState();
  }

  Future getImage() async {
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
    if (permissionCamera.value == PermissionStatus.granted &&
        permissionPhoto.value == PermissionStatus.granted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 5, right: 20.0, left: 20.0),
      child: ListView(
        children: <Widget>[
          Text(
            "Add user",
            style: TextStyle(fontSize: 25.0, color: Colors.green),
          ),
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
          MiamityTextField(
            text: 'Address',
            controller: userAddressController,
          ),
          MiamityTextField(
            text: 'Country',
            controller: userCountryController,
          ),
          MiamityTextField(
            text: 'City',
            controller: userCityController,
          ),
          MiamityTextField(
            text: 'Postal Code',
            keyboardType: TextInputType.number,
            isPostalCode: true,
            controller: userPostalCodeController,
          ),
          Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  sampleImage == null
                      ? Expanded(
                          child: MiamityGreenButton(
                              width: 200,
                              icon: Icons.file_download,
                              title: "Je choisis mon image",
                              onPressed: () {
                                getImage();
                              }))
                      : (Row(
                          children: <Widget>[
                            Image.file(sampleImage, height: 100, width: 100),
                            MiamityGreenButton(
                                icon: Icons.file_download,
                                width: 40,
                                onPressed: () {
                                  getImage();
                                }),
                            MiamityRedButton(
                                icon: Icons.cancel,
                                width: 40,
                                onPressed: () {
                                  setState(() {
                                    sampleImage = null;
                                  });
                                }),
                            
                          ],
                        )),
                ],
              )),
          Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MiamityRedButton(
                      title: 'Cancel',
                      icon: Icons.cancel,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                waitingForUploadImage
                                ? CircularProgressIndicator():Expanded(
                    child: MiamityGreenButton(
                        title: "Add",
                        icon: Icons.add,
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
                                  "firstname": userFirstnameController.text,
                                  "lastname": userLastNameController.text,
                                  "email": userEmailController.text,
                                  "phone": userPhoneController.text,
                                  "username": userUsernameController.text,
                                  "password": userPasswordController.text,
                                  "liste_plats": [],
                                  "adresse": null,
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
          )
        ],
      ),
    ));
  }
}
