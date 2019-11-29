import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/commons/DishesCard.dart';
import 'package:miamitymds/auth.dart';

class DishesListPage extends StatefulWidget {
  DishesListPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  createState() => DishesListState();
}

class DishesListState extends State<DishesListPage> {
  bool surPlace = false;
  _filterResults(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("A emporter"),
                      Switch(
                        value: surPlace,
                        inactiveTrackColor: Colors.green[200],
                        activeTrackColor: Colors.green[500],
                        activeColor: Colors.white,
                        onChanged: (bool newValue) {
                          setState(() {
                            surPlace = newValue;
                          });
                          print("Sur place: " + surPlace.toString());
                        },
                      ),
                      Text("Sur place"),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(
                      color: Colors.green[200],
                      width: 1.0,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text("Type"), Text("Origine")],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Végan")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Végétarien")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Sucré")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Salé")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Sans gluten")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Diéthétique")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Bio")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Gras")),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Française")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Italienne")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Espagnol")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Asiatique")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Libanaise")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Indienne")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Turque")),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Algérienne"))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              MiamityButton(
                title: "OK",
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Liste des plats"),
        actions: <Widget>[
          FlatButton(
              child: Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              onPressed: () async {
                _filterResults(context);
              }),
        ],
      ),
      body: PageView(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance.collection('dish').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      childAspectRatio: 9.0 / 13.0,
                      mainAxisSpacing: 10),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => DishesCardWidget(
                    document: snapshot.data.documents[index],
                    auth: widget.auth,
                    onSignedOut: widget.onSignedOut,
                  ),
                );
              }),
        ],
      ),
      endDrawer: MiamityAppBar(
        auth: widget.auth,
        onSignedOut: widget.onSignedOut,
      ),
    );
  }
}
