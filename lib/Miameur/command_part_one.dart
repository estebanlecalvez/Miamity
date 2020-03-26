import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/Miameur/command_part_two.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';

import '../auth.dart';

class CommandPartOne extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final DocumentSnapshot dish;

  CommandPartOne({this.auth, this.onSignedOut, this.dish});

  @override
  _CommandPartOneState createState() => _CommandPartOneState();
}

class _CommandPartOneState extends State<CommandPartOne> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  int _currentSelectedParts = 0;
  String _currentPriceText = "";
  String _currentGestionPriceText = "";
  String _currentTotalPrice = "";
  double _price;
  @override
  void initState() {
    _price = double.parse(widget.dish["price"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Commander"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: FormBuilder(
              onChanged: (value) {},
              key: formKey,
              initialValue: {'nbParts': 1},
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Hero(
                          tag: "picture_dish_of_" + widget.dish['photo'],
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(widget.dish['photo']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.dish['dish_title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.pie_chart),
                                  Container(width: 12),
                                  Text(widget.dish["nb_parts"].toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[700]),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Icon(Icons.remove),
                            onPressed: () {
                              if (_currentSelectedParts > 1) {
                                setState(() {
                                  _currentSelectedParts -= 1;
                                });
                              }

                              double result = (_currentSelectedParts * _price);
                              double fraisDeGestion = (result * 0.1);
                              double total = result + fraisDeGestion;
                              setState(() {
                                _currentPriceText = result.toStringAsFixed(2);
                                _currentGestionPriceText =
                                    fraisDeGestion.toStringAsFixed(2);
                                _currentTotalPrice = total.toStringAsFixed(2);
                              });
                            },
                          ),
                          Text(_currentSelectedParts.toString()),
                          FlatButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              if (_currentSelectedParts <
                                  widget.dish["nb_parts"]) {
                                setState(() {
                                  _currentSelectedParts += 1;
                                });
                              }
                              double result = (_currentSelectedParts * _price);
                              double fraisDeGestion = (result * 0.1);
                              double total = result + fraisDeGestion;
                              setState(() {
                                _currentPriceText = result.toStringAsFixed(2);
                                _currentGestionPriceText =
                                    fraisDeGestion.toStringAsFixed(2);
                                _currentTotalPrice = total.toStringAsFixed(2);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Sous-total", style: TextStyle(fontSize: 16)),
                        Text(_currentPriceText + " €",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Frais de gestion",
                            style: TextStyle(fontSize: 16)),
                        Text(_currentGestionPriceText + " €",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("TOTAL",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(_currentTotalPrice + " €",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: RaisedButton(
          color: Colors.orange[700],
          child: Text(
            'Commander',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
          ),
          onPressed: () {
            widget.auth.changePage(
                context,
                CommandPartTwo(
                    dish: widget.dish,
                    total_price: double.parse(_currentTotalPrice)));
          },
        ),
      ),
      endDrawer:
          MiamityAppBar(auth: widget.auth, onSignedOut: widget.onSignedOut),
    );
  }
}
