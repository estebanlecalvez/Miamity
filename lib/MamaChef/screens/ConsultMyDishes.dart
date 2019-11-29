import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/auth.dart';
import 'package:transparent_image/transparent_image.dart';

class ConsultMyDishes extends StatefulWidget {
  ConsultMyDishes(
      {this.title, this.auth, this.onSignedOut, @required this.currentUserId});
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String currentUserId;

  @override
  _ConsultMyDishesState createState() => _ConsultMyDishesState();
}

class _ConsultMyDishesState extends State<ConsultMyDishes> {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return new GestureDetector(
        child: new Card(
      child: Container(
          child: Column(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage.memoryNetwork(
                              height: 100,
                              width: 100,
                              placeholder: kTransparentImage,
                              fadeInDuration: const Duration(seconds: 1),
                              fit: BoxFit.cover,
                              image: document["photo"] ??
                                  "https://p8.storage.canalblog.com/88/72/717345/113739915.jpg",
                            ),
                          ),
                        ),
                        MiamityButton(
                          title: 'Delete',
                          btnColor: Colors.red,
                          verticalPadding: EdgeInsets.symmetric(vertical: 5),
                          onPressed: () {
                            _showDialogSuppression(document);
                          },
                        )
                      ],
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Nom:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                  child:
                                      Text(document["dish_title"].toString())),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Nombre de parts:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(document["nb_parts"].toString()),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Prix:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(document["price"].toString()),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Type:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(document["locally"].toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    ));
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
                      .document("dish/" + document.documentID)
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
      appBar: AppBar(title: Text("Mes plats")),
      body: PageView(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance
                  .collection("dish")
                  .where("user_id", isEqualTo: widget.currentUserId)
                  .snapshots(),
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
    );
  }
}
