import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';

import '../../Widgets/MiamityTextField.dart';

class AddPlate extends StateFullWidget {
  AddPlate({Key key, this.title}) : super(key: key);
  static const String routeName = "/addPlate";
  final String title;

  @override
  _AddPlateState createState() => _AddPlateState();
}

class _AddPlateState extends State<AddPlate> {
  TextEditingController plateUserIdController;
  TextEditingController plateTitleController;
  TextEditingController plateDescriptionController;
  TextEditingController plateIngredientsController;
  TextEditingController platePictureController;
  TextEditingController plateNumberPortionsController;
  TextEditingController platePriceController;
  TextEditingController plateDisponibilityHourController;

  @override
  void initState() {
    plateTitleController = new TextEditingController();
    plateDescriptionController = new TextEditingController();
    platePictureController = new TextEditingController();
    plateNumberPortionsController = new TextEditingController();
    platePriceController = new TextEditingController();
    plateDisponibilityHourController = new TextEditingController();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text(
              "Ajouter un plat",
              style: TextStyle(fontSize: 25.0, color: Colors.orange)
            ),
            MiamityTextField(
              text: "Intitulé du plat", controller: plateTitleController),
            MiamityTextField(
              text: "Description du plat", controller: plateDescriptionController),
            MiamityTextField(
              text:"Nombres de parts" ,
              keyboardType: TextInputType.number,
              controller: plateNumberPortionsController),
            MiamityTextField(
              text: "Prix",
              keyboardType: TextInputType.number,
              controller: platePriceController),
            MiamityTextField(
              text: "Heure de disponibilité du plat",
              keyboardType: TextInputType.datetime,
              controller: plateDisponibilityHourController),
          ],
        ),
      ));
  }
}