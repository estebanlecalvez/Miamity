import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:miamitymds/CommonPages/LoginPage.dart';
import 'package:miamitymds/Widgets/MiamityAllergenicInfo.dart';
import 'package:miamitymds/Widgets/MiamityButton.dart';
import 'package:miamitymds/Widgets/MiamityMultiSelect.dart';
import 'package:miamitymds/Widgets/MiamityProgressIndicator.dart';
import 'package:miamitymds/Widgets/MiamityRedButton.dart';
import 'package:miamitymds/Widgets/MiamityGreenButton.dart';
import 'package:miamitymds/Widgets/MiamityTextFormField.dart';
import 'package:miamitymds/Widgets/MiamityDisabledTextFormField.dart';
import 'package:miamitymds/Widgets/PageTitle.dart';
import 'package:miamitymds/auth.dart';
import 'package:miamitymds/root_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:miamitymds/Widgets/MiamityTextField.dart';
import 'package:image_picker/image_picker.dart';

const kGoogleApiKey = "AIzaSyCw8uPn9J95k31zGuZFukWmJPYOx1q-1Sw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final kInitialPosition = LatLng(-33.8567844, 151.213108);

final StorageReference storageReference = FirebaseStorage().ref();

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  static const String routeName = "/addUser";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _userFirstname;
  String _userLastname;
  String _userEmail;
  String _userUsername;
  String _userPassword;
  String _userPhone;
  String _userPasswordConfirmation = "";
  String imageURL;
  File sampleImage;
  bool waitingForUploadImage;
  String selectedAddress;
  bool isAddressSelected;
  double longitude;
  double latitude;
  String _errorMessage;
  String _encryptedPassword;
  bool isAllergic;
  String _allergenic;
  List<String> centresdinteret = [
    "Bénévolat",
    "Footing",
    "Football",
    "Basketball",
    "Musique",
    "Danse",
    "Théâtre",
    "Peinture",
    "Cuisine",
    "Poterie",
    "Sculpture",
    "Ecriture",
    "Couture",
    "Blogging",
    "Handball",
    "Vélo",
    "Marathon",
    "Netflix",
    "Youtube",
    "Facebook",
    "Instagram",
    "Twitter",
    "TikTok",
    "Manger",
    "Courir",
    "Sport",
    "Jeux vidéos",
    "Séries",
    "Boxe",
    "Musculation",
    "Industrie",
    "Médecine",
    "Nouvelles technologies",
    "Mode",
    "Dessin",
    "Golf",
    "Patinage",
    "Evenementiel",
    "Voyages",
    "Tennis",
    "Yoga",
    "Méditation",
    "Bowling",
    "Escape game",
    "Transports en commun",
    "Apéro",
    "Produits région",
    "Hygiène de vie",
    "Abduction",
    "Monde du digital",
    "Pompier",
    "Société",
    "Littérature",
    "Histoire",
    "Géographie",
    "Biologie",
    "Piano",
    "Shopping",
    "DIY",
    "Travaux manuels",
    "Opéra",
    "Bricolage",
    "Décoration",
    "Variété",
    "Logistique",
    "Entrepreunariat",
    "Sports nautiques",
    "Animé",
    "Automobile",
    "Religion",
    "Relationnel",
    "Découvrir les autres",
    "Partage",
    "Passion",
    "Psychologie",
    "Pâtisserie",
    "Végétarisme",
    "Eco-responsabilité",
    "Marche",
    "Activités en plein air",
    "Aviation",
  ];
  List<String> selectedCentresDinteret=null;
  PickResult selectedPlace;

  @override
  initState() {
    imageURL = "";
    waitingForUploadImage = false;
    isAddressSelected = false;
    isAllergic = false;
    longitude = null;
    latitude = null;
    sampleImage = null;
    _errorMessage = "";
    super.initState();
  }

  Future getImage() async {
    _openFileExplorer();
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: tempImage.path,
      aspectRatio:CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxWidth: 400,
      maxHeight: 400,
    );
    setState(() {
      sampleImage = croppedFile;
    });
  }

  _showTypeAllergenicDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog();
        });
  }

  _showCentreDinteretDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Centre d'intérêts"),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                children: <Widget>[
                  MiamityMultiSelect(
                    centresdinteret,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedCentresDinteret = selectedList;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  _buildSelectedCentreDinteretList() {
    List<Widget> choices = List();
    if (selectedCentresDinteret != null) {
      selectedCentresDinteret.forEach((item) {
        choices.add(Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Chip(
            label: Text(item),
          ),
        ));
      });
    }
    return choices;
  }

  _showInfoAllergenicDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return MiamityAllergenicInfo();
        });
  }

  validateForm() {
    final formState = _formKey.currentState;
    if (formState != null) {
      if (formState.mounted) {
        formState.validate();
      }
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void _openFileExplorer() async {
    ///Check si les permissions ont été données. Sinon les demande.
    var permissionCamera =await Permission.camera.request().isGranted;
    var permissionPhoto =await Permission.photos.request().isGranted;
    if (permissionCamera && permissionPhoto) {
      print("permission already granted");
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.photos,
      ].request();
     print(statuses[Permission.location]);

    }
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

  wait() {
    if (waitingForUploadImage) {
      return CircularProgressIndicator();
    } else {}
  }

  _storeData() async {
    String uid = await widget.auth
        .createUserWithEmailAndPassword(_userEmail, _userPassword);
    Firestore.instance
        .collection('users')
        .document(uid)
        .setData({
          "profile_picture": imageURL,
          "firstname": _userFirstname,
          "lastname": _userLastname,
          "email": _userEmail,
          "phone": _userPhone,
          "username": _userUsername,
          "liste_plats": [],
          "address": selectedAddress,
          "latitude": latitude,
          "longitude": longitude,
          "centres_interet":selectedCentresDinteret,
          "alergenic": _allergenic,
        })
        .then((result) => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RootPage(
                            auth: widget.auth,
                          )))
            })
        .catchError((err) => err);
  }

  bool _isAllOk() {
    return isAddressSelected &&
        validateAndSave() &&
        _userPassword == _userPasswordConfirmation;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Veuillez entrer une adresse email';
    }
    if (!regex.hasMatch(value))
      return 'Entrez un email valide';
    else
      return null;
  }

  String validatePasswordConfirmation(String value) {
    if (value.isEmpty) {
      return "Vous devez confirmer votre mot de passe.";
    } else {
      return null;
    }
  }

  sendForm() async {
    //Si tous les champs mandatory sont renseignés.
    if (validateAndSave()) {
      //Si on a selectionner une adresse (essentiel pour la creation d'un compte.)
      if (isAddressSelected) {
        if (sampleImage != null) await uploadImage();
        if (_userFirstname.isEmpty) {
          _userFirstname = "No";
        }
        if (_userLastname.isEmpty) {
          _userLastname = "name";
        }
        try {
          await _storeData();
          widget.auth.changePage(
              context,
              RootPage(
                auth: widget.auth,
              ));
        } catch (e) {
          setState(() {
            _errorMessage = e.toString();
          });
          print(_errorMessage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(children: <Widget>[
      Stack(
        children: <Widget>[
          Opacity(
            opacity: waitingForUploadImage ? 0.5 : 1,
            child: ListView(
              children: <Widget>[
                Form(
                  onChanged: validateForm(),
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      PageTitle(title: "Créer un compte"),
                      FlatButton(
                        child: Text("Vous avez déjà un compte?",
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                          auth: widget.auth,
                                        )));
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      MiamityTextFormField(
                          icon: Icons.person,
                          label: "Firstname",
                          onSaved: (value) => _userFirstname = value),
                      MiamityTextFormField(
                          icon: Icons.person,
                          label: "Lastname",
                          onSaved: (value) => _userLastname = value),
                      MiamityTextFormField(
                        icon: Icons.phone,
                        label: 'Phone',
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _userPhone = value,
                      ),
                      MiamityTextFormField(
                          icon: Icons.email,
                          label: 'Email*',
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          onSaved: (value) => _userEmail = value),
                      MiamityTextFormField(
                          icon: Icons.tag_faces,
                          label: 'Username*',
                          validator: (String value) => value.isEmpty
                              ? 'Vous devez entrer un nom d\'utilisateur.'
                              : null,
                          onSaved: (value) => _userUsername = value),
                      MiamityTextFormField(
                          icon: Icons.lock,
                          label: 'Password*',
                          keyboardType: TextInputType.visiblePassword,
                          isObscureText: true,
                          onChanged: (value) => _userPassword = value,
                          validator: (String value) => value.isEmpty
                              ? 'Vous devez entrer un mot de passe.'
                              : null,
                          onSaved: (value) => _userPassword = value),
                      MiamityTextFormField(
                          icon: Icons.lock,
                          label: 'Password confirmation*',
                          keyboardType: TextInputType.visiblePassword,
                          isObscureText: true,
                          validator: validatePasswordConfirmation,
                          onChanged: (value) =>
                              _userPasswordConfirmation = value,
                          onSaved: (value) =>
                              _userPasswordConfirmation = value),
                               selectedCentresDinteret == null
                                ? MiamityTextFormField(
                                    label: "Centres d'intérets",
                                    onTap: () => _showCentreDinteretDialog(),
                                    readOnly: true,
                                  )
                                : Text("Centres d'intérets:"),
                            FlatButton(
                                onPressed: () => _showCentreDinteretDialog(),
                                child: Wrap(
                                  children: _buildSelectedCentreDinteretList(),
                                )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("J'ai des allergènes"),
                          Checkbox(
                            value: isAllergic,
                            onChanged: (bool value) {
                              setState(() {
                                isAllergic = value;
                              });
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.info_outline),
                              onPressed: _showInfoAllergenicDialog)
                        ],
                      ),
                      isAllergic
                          ? MiamityDisabledTextFormField(
                              icon: Icons.assignment_late,
                              label: 'Allergenic*',
                              validator: (String value) => value.isEmpty
                                  ? 'Vous devez renseigner vos allergènes.'
                                  : null,
                              disabled: isAllergic,
                              onSaved: (value) => _allergenic = value)
                          : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      )
                    ],
                  ),
                ),
                _userPasswordConfirmation == _userPassword
                    ? Text("")
                    : Text(
                        "Les mots de passes ne correspondent pas",
                        style: TextStyle(color: Colors.red),
                      ),
                isAddressSelected
                    ? Wrap(
                        children: <Widget>[
                          MiamityTextField(
                              text: selectedAddress,
                              isReadOnly: true,
                              onTapFunction: () async {
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey: kGoogleApiKey,   // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) { 
                                      selectedPlace = result;
                                      Navigator.of(context).pop();
                                      setState(() {
                                        selectedAddress=selectedPlace.formattedAddress;
                                        isAddressSelected = true;
                                        latitude = selectedPlace.geometry.location.lat;
                                        longitude = selectedPlace.geometry.location.lng;});
                                    },
                                    initialPosition:kInitialPosition,
                                    useCurrentLocation: false,
                                  ),
                                ),
                              );
                              }),
                          MiamityButton(
                              btnColor: Colors.orange[700],
                              title: "CHANGER L'ADRESSE",
                              onPressed: () async {
                                setState(() {
                                  selectedAddress = null;
                                  isAddressSelected = false;
                                });
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey: kGoogleApiKey,   // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) { 
                                      selectedPlace = result;
                                      Navigator.of(context).pop();
                                      setState(() {
                                        selectedAddress= selectedPlace.formattedAddress;
                                        isAddressSelected = true;
                                        latitude = selectedPlace.geometry.location.lat;
                                        longitude = selectedPlace.geometry.location.lng;
                                        }
                                        );
                                    },
                                    initialPosition:kInitialPosition,
                                    useCurrentLocation: true,
                                  ),
                                ),
                              );
                              })
                        ],
                      )
                    : MiamityButton(
                        btnColor: Colors.blue,
                        title: "JE SELECTIONNE MON ADRESSE",
                        onPressed: () async {
                          // show input autocomplete with selected mode
                          // then get the Prediction selected
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey: kGoogleApiKey,   // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) { 
                                      selectedPlace = result;
                                      Navigator.of(context).pop();
                                      setState(() {
                                        selectedAddress=selectedPlace.formattedAddress; 
                                        isAddressSelected = true;
                                        latitude = selectedPlace.geometry.location.lat;
                                        longitude = selectedPlace.geometry.location.lng;
                                      });
                                    },
                                    initialPosition:kInitialPosition,
                                    useCurrentLocation: true,
                                  ),
                                ),
                              );
                        }),
                Container(
                    child: Row(
                  children: <Widget>[
                    sampleImage == null
                        ? Expanded(
                            child: MiamityButton(
                                btnColor: Colors.blue,
                                title: "JE SELECTIONNE MA PHOTO DE PROFIL",
                                onPressed: () {
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
                                      onPressed: () {
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
                  children: <Widget>[
                    Expanded(
                        child: _isAllOk()
                            ? MiamityButton(
                                title: "TERMINER L'INSCRIPTION",
                                onPressed: () {
                                  sendForm();
                                })
                            : MiamityButton(title: "TERMINER L'INSCRIPTION")),
                  ],
                ),
              ],
            ),
          ),
          Opacity(
            opacity: waitingForUploadImage ? 1.0 : 0,
            child: MiamityProgressIndicator(),
          )
        ],
      ),
    ]));
  }
}
