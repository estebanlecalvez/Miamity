import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miamitymds/CommonPages/RegisterPage.dart';
import 'package:miamitymds/Utils/Transitions/NoPageTransition.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/auth.dart';
import 'package:transparent_image/transparent_image.dart';
import 'ShowUserPage.dart';

class UserList extends StatefulWidget {
  UserList({this.title, this.auth, this.onSignedOut});
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              NoPageTransition(
                  builder: (context) => ShowUserPage(document: document)));
        },
        child: new Card(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(children: <Widget>[
                        Hero(
                          tag:"profile_picture_of"+document["firstname"],
                          child: FadeInImage.memoryNetwork(
                          height: 130,
                          width: 120,
                          placeholder: kTransparentImage,
                          fadeInDuration: const Duration(seconds: 1),
                          image: document["profile_picture"],
                        ),)
                      ]),
                      Container(
                        child: Text(
                          document["firstname"] + " " + document["lastname"],
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  MiamityRedButton(
                    title: 'Delete',
                    width: 100,
                    onPressed: () {
                      _showDialogSuppression(document);
                    },
                  )
                ],
              )
            ],
          ),
        )));
  }

  void _showDialogSuppression(DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Are you sure?",
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "This action is irreversible",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              MiamityRedButton(
                title: "Yes!",
                width: 80,
                onPressed: () {
                  ///So simple :o
                  Firestore.instance
                      .document("users/" + document.documentID)
                      .delete();
                  Navigator.pop(context);
                },
              ),
              MiamityGreenButton(
                title: "Forget it!",
                width: 100,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des utilisateurs")),
      body: PageView(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]),
                );
              }),
        ],
      ),
      drawer: MiamityAppBar(auth:widget.auth,onSignedOut: widget.onSignedOut,),
    );
  }
}
