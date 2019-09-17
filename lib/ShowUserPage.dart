import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowUserPage extends StatelessWidget {
  ShowUserPage({@required this.document});

  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(document["firstname"] + " " + document["lastname"]),
        ),
        body: Wrap(
          children: <Widget>[
            Container(
              padding:EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Image.network(
                    document["profile_picture"] ?? "",height: 300,
                  ),    
                  Padding(padding: EdgeInsets.only(top:30),),                 
                  Row(children: <Widget>[
                    Text("Email: ",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                    Text(document["email"],style:TextStyle(fontSize: 15)),
                  ],
                )
              ]
            )
          )
        ],
      )
    );
  }
}