import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:miamitymds/Widgets/commons/DishesCard.dart';

class DishesListPage extends StatefulWidget {
  @override
  createState() => DishesListState();
}

class DishesListState extends State<DishesListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Liste des plats"),
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
                      document: snapshot.data.documents[index]),
                );
              }),
        ],
      ),
    );
  }
}
