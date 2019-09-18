import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';

import 'Widgets/MiamityTextField.dart';

class AddUser extends StatefulWidget {
  AddUser({Key key, this.title}) : super(key: key);
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

  @override
  initState() {
    userFirstnameController = new TextEditingController();
    userLastNameController = new TextEditingController();
    userEmailController = new TextEditingController();
    userUsernameController = new TextEditingController();
    userPasswordController = new TextEditingController();
    userPhoneController = new TextEditingController();
    userPasswordConfirmationController = new TextEditingController();
    userProfilePictureController = new TextEditingController();
    super.initState();
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
            text: 'Profile Picture',
            controller: userProfilePictureController,
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
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                MiamityRedButton(
                    title: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                MiamityGreenButton(
                    title: "Add",
                    width: 150,
                    onPressed: () {
                      if (userUsernameController.text.isNotEmpty &&
                          userPasswordController.text.isNotEmpty &&
                          userEmailController.text.isNotEmpty &&
                          userPasswordConfirmationController.text.isNotEmpty &&
                          userPasswordConfirmationController.text ==
                              userPasswordController.text) {
                        if (userProfilePictureController.text.isEmpty) {
                          userProfilePictureController.text =
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
                              "profile_picture":
                                  userProfilePictureController.text,
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
                                  userPasswordConfirmationController.clear(),
                                  userPasswordController.clear(),
                                  userUsernameController.clear(),
                                })
                            .catchError((err) => err);
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
