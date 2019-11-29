import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miamitymds/Widgets/commons/ShowDishesDetails.dart';
import 'package:miamitymds/auth.dart';

class DishesCardWidget extends StatefulWidget {
  DishesCardWidget({this.document, this.auth, this.onSignedOut});
  final DocumentSnapshot document;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  createState() => DishesCardState();
}

class DishesCardState extends State<DishesCardWidget> {
  String distance;

  //Fonction gérant le calcul de la distance
  _calculateDistance() {
    var rngDistance = 0;
    rngDistance = Random().nextInt(2000);
    if (rngDistance >= 1000) {
      setState(() {
        distance = (rngDistance / 1000).floor().toString() +
            ", " +
            rngDistance.remainder(1000).toString() +
            " km";
      });
      return this.distance;
    } else {
      setState(() {
        distance = rngDistance.toString() + " m";
      });
      return this.distance;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.auth.changePage(
            context,
            ShowDishesDetailsPage(
              document: widget.document,
              auth: widget.auth,
              onSignedOut: widget.onSignedOut,
              authorDishId: widget.document['user_id'],
              rngDistance: this.distance,
            ));
      },
      child: Card(
          elevation: 10,
          borderOnForeground: true,
          //Container principal(entier)
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Container image
                Container(
                  height: 130,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Hero(
                          tag: "picture_dish_of_" + widget.document['photo'],
                          child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(widget.document['photo'])),
                        ),
                      )
                    ],
                  ),
                ),
                //Titre
                Container(
                    height: 55,
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Flexible(
                              child: Center(
                            child: Text(
                              widget.document['dish_title'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 18),
                            ),
                          ))
                        ])),
                //Prix + Quantité + Localisation
                Expanded(
                    child: Container(
                  height: 46,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //Quantité + Localisation
                      Container(
                        width: 70,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200])),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Quantité
                            Container(
                                child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  size: 20.0,
                                  color: Colors.grey[500],
                                ),
                                Text(
                                  widget.document['nb_parts'].toString(),
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.grey[500]),
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                      //Localisation
                      Container(
                        child: Expanded(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.near_me,
                                size: 20.0,
                                color: Colors.grey[500],
                              ),
                              Container(
                                child: Text(
                                  _calculateDistance(),
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                //Prix
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Center(
                                    child: Text(
                                      widget.document['price'],
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                      overflow: TextOverflow.visible,
                                    ),
                                  )),
                              Container(
                                child: Icon(
                                  Icons.euro_symbol,
                                  size: 15,
                                  color: Colors.orange,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
