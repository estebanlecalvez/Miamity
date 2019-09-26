import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/auth.dart';

class Dish {
  List<DateTime> date;
  String locally, dishTitle, description, price;
  int nbParts;

  Dish(
      {this.date,
      this.dishTitle,
      this.description,
      this.locally,
      this.price,
      this.nbParts});
  factory Dish.fromJson(Map<String, dynamic> json) => _formFieldFromJson(json);
}

Dish _formFieldFromJson(Map<String, dynamic> json) {
  return Dish(
      date: json['date'] as List<DateTime>,
      dishTitle: json['dishTitle'] as String,
      description: json['description'] as String,
      locally: json['locally'] as String,
      price: json['price'] as String,
      nbParts: json['nbParts'] as int);
}

class AddPlate extends StatefulWidget {
  AddPlate({this.title, this.auth, this.onSignedOut});
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _AddPlateState createState() => _AddPlateState();
}

class _AddPlateState extends State<AddPlate> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  String userId;
  String message;
  bool isSuccess;

  @override
  void initState() {
    super.initState();
    message = "";
    isSuccess = true;
    widget.auth.currentUser().then((currentUserId) {
      print("Current user id from AddPlatPage $currentUserId");
      if (currentUserId == null) {
        widget.onSignedOut;
      } else {
        setState(() {
          userId = currentUserId;
        });
      }
    });
  }

  _submit() async {
    if (formKey.currentState.saveAndValidate()) {
      var formField = formKey.currentState.value;
      Dish dish = Dish.fromJson(formField);
      Firestore.instance
          .collection('dish')
          .add({
            "user_id": userId,
            "dish_title": dish.dishTitle,
            "description": dish.description,
            "price": dish.price,
            "nb_parts": dish.nbParts,
            "date": dish.date,
            "locally": dish.locally
          })
          .then((result) => {print('C\'est fait')})
          .catchError((err) => err);
      setState(() {
        isSuccess = true;
        message = "Plat ajouté avec succès";
      });
    } else {
      setState(() {
        isSuccess = false;
        message = "Veuillez renseigner les champs du formulaire.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un plat"),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              FlatButton(
                child: Text("getUserId"),
                onPressed: () async {
                  String userId = await widget.auth.currentUser();
                  print("Current user id : $userId");
                },
              ),
              FormBuilder(
                  key: formKey,
                  initialValue: {
                    'date': [DateTime.now(), DateTime.now()],
                    'locally': null,
                    'nbParts': 1,
                    'dishTitle': null,
                    'description': null,
                    'price': null
                  },
                  autovalidate: true,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        attribute: 'dishTitle',
                        decoration:
                            InputDecoration(labelText: 'Intitulé du plat'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Le champ est requis'),
                          FormBuilderValidators.max(70)
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'description',
                        decoration: InputDecoration(
                            labelText: 'Description du plat',
                            hintText: 'Je suis le placeholder'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Le champ est requis'),
                          FormBuilderValidators.max(300)
                        ],
                      ),
                      FormBuilderStepper(
                        initialValue: 1,
                        step: 1,
                        attribute: 'nbParts',
                        decoration: InputDecoration(
                          labelText: 'Nombres de parts',
                        ),
                        validators: [
                          FormBuilderValidators.required(),
                        ],
                      ),
                      FormBuilderTextField(
                        attribute: 'price',
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Le champs est requis'),
                          FormBuilderValidators.numeric(
                              errorText:
                                  "La valeur ne doit pas comprendre de lettres")
                        ],
                      ),
                      FormBuilderDateRangePicker(
                        firstDate:
                            DateTime.now().subtract(new Duration(days: 1)),
                        lastDate: DateTime.now().add(new Duration(days: 50)),
                        format: DateFormat("dd/MM/yyyy"),
                        attribute: 'date',
                        decoration: InputDecoration(
                            labelText: 'Heure de disponibilité'),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Le champs est requis'),
                        ],
                      ),
                      FormBuilderDropdown(
                        attribute: 'locally',
                        decoration: InputDecoration(
                            labelText: 'Sur place ou emporté ?'),
                        items: ['Sur place', 'A emporté']
                            .map((locally) => DropdownMenuItem(
                                value: locally, child: Text("$locally")))
                            .toList(),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Le champs est requis')
                        ],
                      )
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.green,
                      onPressed: _submit,
                      child: Text('Mettre en ligne'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: Colors.grey,
                      onPressed: () => {
                        formKey.currentState.reset(),
                      },
                      child: Text('Reset'),
                    ),
                  ),
                ],
              ),
              Wrap(
                children: <Widget>[
                  isSuccess
                      ? Text(message,
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold))
                      : Text(message,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ),
      ),
      drawer: MiamityAppBar(
        auth: widget.auth,
        onSignedOut: widget.onSignedOut,
      ),
    );
  }
}
