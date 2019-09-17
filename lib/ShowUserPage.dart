import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:  FadeInImage.memoryNetwork(
                      height: 300,
                      placeholder: kTransparentImage,
                      fadeInDuration: const Duration(seconds:1),
                      image:document["profile_picture"] ?? "",
                    ),
                    
                  ),
                   
                  Padding(padding: EdgeInsets.only(top:30),),                 
                  Row(
                    children: <Widget>[
                      Text("Email: ",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                      Text(document["email"],style:TextStyle(fontSize: 15)),
                    ],
                  ),
              ]
            )
          )
        ],
      )
    );
  }
}