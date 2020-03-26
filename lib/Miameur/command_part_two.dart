import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommandPartTwo extends StatefulWidget {
  final DocumentSnapshot dish;
  final double total_price;

  const CommandPartTwo({this.dish, this.total_price});
  @override
  _CommandPartTwoState createState() => _CommandPartTwoState();
}

class _CommandPartTwoState extends State<CommandPartTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Paiement de la commande"),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          children: <Widget>[],
        )));
  }
}
