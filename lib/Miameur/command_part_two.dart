import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miamitymds/Widgets/MiamityTextField.dart';

class CommandPartTwo extends StatefulWidget {
  final DocumentSnapshot dish;
  final double total_price;

  const CommandPartTwo({this.dish, this.total_price});
  @override
  _CommandPartTwoState createState() => _CommandPartTwoState();
}

class _CommandPartTwoState extends State<CommandPartTwo> {
  String _cardNumber = "0000000000000000";
  String _cardOwner = "MR DUPONT BERNARD";
  String _expirationDate = "02/22";
  String _validationNumber = "435";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiement de la commande"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image(image: new AssetImage('images/bank_card.png')),
                    Padding(
                      padding: const EdgeInsets.only(top: 160.0, left: 50),
                      child: Text(_cardNumber, style: TextStyle(fontSize: 25)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 190.0, left: 50),
                      child: Text(_cardOwner, style: TextStyle(fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 210.0, left: 50),
                      child:
                          Text(_expirationDate, style: TextStyle(fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 130.0, left: 300),
                      child: Text(_validationNumber,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _cardNumber = value.toString();
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Card number"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _cardOwner = value;
                      });
                    },
                    decoration: InputDecoration(hintText: "Card Owner name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _expirationDate = value;
                      });
                    },
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(hintText: "Expiration date"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _validationNumber = value;
                      });
                    },
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(hintText: "Validation number"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        child: RaisedButton(
          color: Colors.orange[700],
          child: Text(
            'PAYER',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
