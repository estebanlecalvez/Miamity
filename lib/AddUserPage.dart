import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

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
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;

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

  Future<void> _requestPhotoAndCameraPermission () async{

  }

 void _openFileExplorer() async {

   ///Check si les permissions ont été données. Sinon les demande.
    PermissionStatus permissionCamera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus permissionPhoto = await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    if(permissionCamera.value == PermissionStatus.granted && permissionPhoto.value == PermissionStatus.granted){
      print("permission already granted");
    }else{
      await PermissionHandler().requestPermissions([PermissionGroup.camera,PermissionGroup.photos]);
    }

      setState(() => _loadingPath = true);
      try {
        _paths = null;
        _path = await FilePicker.getFilePath(type: FileType.IMAGE);
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    
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
          // MiamityTextField(
          //   text: 'Profile Picture',
          //   onTapFunction: _requestPhotoAndCameraPermission,
          //   controller: userProfilePictureController,
          // ),

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
            padding: EdgeInsets.only(top:10.0),
            child:Row(
            children: <Widget>[
            Text("Profile Picture :",style: TextStyle(color: Colors.green),),
            _path !=null ?
              Row(children: <Widget>[
                Image.asset(_path,width: 100,height:100),
                MiamityGreenButton(icon:Icons.file_download,width:40,onPressed: _openFileExplorer)
              ],)
            :MiamityGreenButton(icon: Icons.file_download,title:"Choose image",onPressed: _openFileExplorer,),
          ],),
          ),
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
                Expanded(child:MiamityGreenButton(
                    title: "Add",
                    icon:Icons.add,
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
                    })),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
