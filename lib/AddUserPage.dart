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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
      padding: EdgeInsets.only(top:50.0,right:20.0,left:20.0),
      child:Wrap(
        children: <Widget>[
          Text("Add user",style: TextStyle(fontSize: 25.0,color: Colors.green),),
          TextField(
            decoration: InputDecoration(labelText: 'Firstname'),
            controller: userFirstnameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Lastname'),
            controller: userLastNameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Phone'),
            controller: userPhoneController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Email*'),
            controller: userEmailController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Username*'),
            controller: userUsernameController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password*'),
            controller: userPasswordController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Password confirmation*'),
            controller: userPasswordConfirmationController,
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
                      Firestore.instance
                        .collection('users')
                        .add({
                          "firstname": userFirstnameController.text,
                          "lastname": userLastNameController.text,
                          "email": userEmailController.text,
                          "phone": userPhoneController.text,
                          "username": userUsernameController.text,
                          "password": userPasswordController.text,
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
              





