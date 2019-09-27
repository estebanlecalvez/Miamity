import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/auth.dart';
import 'package:permission_handler/permission_handler.dart';

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
  File sampleImage;
  String imageURL;
  bool waitingForUploadImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    message = "";
    _isLoading = false;
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

  uploadImage() async {
    if (sampleImage == null) {
      imageURL =
          "https://cdn.samsung.com/etc/designs/smg/global/imgs/support/cont/NO_IMG_600x600.png";
      return;
    } else {
      setState(() {
        waitingForUploadImage = true;
      });
      final StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(Random().nextInt(10000000).toString() + ".jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
      final StorageTaskSnapshot taskSnapshot = (await task.onComplete);
      imageURL = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        waitingForUploadImage = false;
      });
    }
  }

  void _openFileExplorer() async {
    ///Check si les permissions ont été données. Sinon les demande.
    PermissionStatus permissionCamera =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    PermissionStatus permissionPhoto =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    if (permissionCamera.value.toString() ==
            PermissionStatus.granted.toString() &&
        permissionPhoto.value.toString() ==
            PermissionStatus.granted.toString()) {
      print("permission already granted");
    } else {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.camera, PermissionGroup.photos]);
    }
  }

  Future getImage() async {
    _openFileExplorer();
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: tempImage.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 400,
      maxHeight: 400,
    );
    setState(() {
      sampleImage = croppedFile;
    });
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (formKey.currentState.saveAndValidate()) {
      if (sampleImage != null) {
        await uploadImage();
      }
      var formField = formKey.currentState.value;
      Dish dish = Dish.fromJson(formField);
      Firestore.instance
          .collection('dish')
          .add({
            "user_id": userId,
            "photo": imageURL,
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un plat"),
      ),
      body: PageView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Opacity(
                opacity: _isLoading ? 0.7 : 1.0,
                child: Card(
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
                                  decoration: InputDecoration(
                                      labelText: 'Intitulé du plat'),
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
                                  firstDate: DateTime.now()
                                      .subtract(new Duration(days: 1)),
                                  lastDate: DateTime.now()
                                      .add(new Duration(days: 50)),
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
                                          value: locally,
                                          child: Text("$locally")))
                                      .toList(),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'Le champs est requis')
                                  ],
                                )
                              ],
                            )),
                        Container(
                            child: Row(
                          children: <Widget>[
                            sampleImage == null
                                ? Expanded(
                                    child: MiamityButton(
                                        btnColor: Colors.blue,
                                        title:
                                            "JE CHOISIS LA PHOTO DE MON PLAT",
                                        onPressed: () async {
                                          getImage();
                                        }))
                                : Row(
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Image.file(sampleImage,
                                              height: 100, width: 100)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          MiamityGreenButton(
                                              title: "CHANGER",
                                              onPressed: () async {
                                                getImage();
                                              }),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0)),
                                          MiamityRedButton(
                                              title: "SUPPRIMER",
                                              onPressed: () {
                                                setState(() {
                                                  sampleImage = null;
                                                });
                                              }),
                                        ],
                                      ),
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
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold))
                                : Text(message,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Opacity(
                  opacity: _isLoading ? 1.0 : 0.0,
                  child: MiamityProgressIndicator())
            ],
          ),
        ],
      ),
      drawer: MiamityAppBar(
        auth: widget.auth,
        onSignedOut: widget.onSignedOut,
      ),
    );
  }
}
