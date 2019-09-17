import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';

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
      padding: EdgeInsets.only(top:5,right:20.0,left:20.0),
      child:ListView(
        children: <Widget>[
          Text("Add user",style: TextStyle(fontSize: 25.0,color: Colors.green),),
          TextField(
            decoration: InputDecoration(labelText: 'Firstname',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller: userFirstnameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Lastname',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller: userLastNameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Phone',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            keyboardType: TextInputType.phone,
            controller: userPhoneController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Email*',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            keyboardType: TextInputType.emailAddress,
            controller: userEmailController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Username*',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller: userUsernameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password*',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller: userPasswordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password confirmation*',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller: userPasswordConfirmationController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Profile Picture',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller: userProfilePictureController,
          ),
          TextField(
            decoration:InputDecoration(labelText: 'Address',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller:userAddressController,
          ),
          TextField(
            decoration:InputDecoration(labelText: 'Country',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller:userCountryController,
          ),
          TextField(
            decoration:InputDecoration(labelText: 'City',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            controller:userCityController,
          ),
          TextField(
            decoration:InputDecoration(labelText: 'Postal Code',labelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.w600)),
            keyboardType: TextInputType.number,
            maxLength:5,
            controller:userPostalCodeController,
          ),
          Container(
            padding: EdgeInsets.only(top:20.0),
            child: Row(
              children: <Widget>[
                MiamityRedButton(title:'Cancel',onPressed:() {Navigator.pop(context);}),
                MiamityGreenButton(title:"Add",width:150,onPressed:(){
                    if(userUsernameController.text.isNotEmpty &&
                      userPasswordController.text.isNotEmpty &&
                      userEmailController.text.isNotEmpty &&
                      userPasswordConfirmationController.text.isNotEmpty &&
                      userPasswordConfirmationController.text == userPasswordController.text){
                        if(userProfilePictureController.text.isEmpty){
                          userProfilePictureController.text = "https://static.thenounproject.com/png/340719-200.png";
                        }
                        if(userFirstnameController.text.isEmpty) {
                          userFirstnameController.text = "No";
                        }
                        if(userLastNameController.text.isEmpty){
                          userLastNameController.text = "name";
                        }
                        if(userPhoneController.text.isEmpty){
                          userPhoneController.text = null;
                        }
                      Firestore.instance
                        .collection('users')
                        .add({
                          "profile_picture":userProfilePictureController.text ,
                          "firstname": userFirstnameController.text ,
                          "lastname": userLastNameController.text,
                          "email": userEmailController.text,
                          "phone": userPhoneController.text,
                          "username": userUsernameController.text,
                          "password": userPasswordController.text,
                          "liste_plats": [],
                          "adresse":null,
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
                  }
                ),
          ],),)

          
          ],
          ),
          )
    );
  }
}
              





