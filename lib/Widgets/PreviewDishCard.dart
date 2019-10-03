import 'dart:io';

import 'package:flutter/material.dart';

class PreviewDishCard extends StatefulWidget {
  PreviewDishCard(
      {this.name, this.price, this.nombrePart, this.distance, this.image});
  final String name;
  final String price;
  final String nombrePart;
  final String distance;
  final File image;

  @override
  createState() => PreviewDishCardState();
}

class PreviewDishCardState extends State<PreviewDishCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 200,
      child: Card(
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
                    widget.image != null
                        ? Expanded(
                            child: Image.file(
                              widget.image,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Text("")
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
                    // Padding(
                    //   padding: EdgeInsets.only(right: 5, left: 5),
                    // ),
                    Flexible(
                        child: Center(
                      child: Text(
                        widget.name ?? "Nom du plat",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 18),
                      ),
                    ))
                  ],
                ),
              ),
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
                      width: 80,
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
                                  widget.nombrePart ?? "parts",
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.grey[500]),
                                )
                              ],
                            ),
                          ),
                          //Localisation
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.near_me,
                                  size: 20.0,
                                  color: Colors.grey[500],
                                ),
                                Text(
                                  '800 m',
                                  style: TextStyle(color: Colors.grey[500]),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                                          widget.price ?? "4.50",
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
            ],
          ),
        ),
      ),
    );
  }
}
