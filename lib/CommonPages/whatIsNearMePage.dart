import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:miamitymds/auth.dart';

class WhatIsNearMePage extends StatefulWidget {
  WhatIsNearMePage({this.title, this.auth, this.onSignedOut});
  final String title;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  WhatIsNearMePageState createState() => WhatIsNearMePageState();
}

class WhatIsNearMePageState extends State<WhatIsNearMePage> {
  Completer<GoogleMapController> _controller = Completer();

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    //TODO Faire un stream builder qui va chercher en temps réel en base les plats.
    //TODO Afficher les plats dans des cards en bas de la map..
    //TODO pour chaque plat, aller chercher l'utilisateur , puis mettre Lat/Lng dans une List<Marker>. Autre StreamBuilder??
    //TODO On click sur un plat dans les cards, déplacer la map vers le Marker lié.
    //TODO Ajouter un bouton aux cards qui OnClick redirige vers la page de consultation du plat > Pour aller ensuite vers la commande.
    return null;
  }

  Widget _listDishes() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              SizedBox(width: 10.0),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Center(
                        child: Text("Cards with markers linked to them")),
                  )),
              SizedBox(width: 10.0),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Center(
                        child: Text("Cards with markers linked to them")),
                  )),
              SizedBox(width: 10.0),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Center(
                        child: Text("Cards with markers linked to them")),
                  )),
              SizedBox(width: 10.0),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Center(
                        child: Text("Cards with markers linked to them")),
                  )),
              SizedBox(width: 10.0),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Center(
                        child: Text("Cards with markers linked to them")),
                  )),
              SizedBox(width: 10.0),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Center(
                        child: Text("Cards with markers linked to them")),
                  ))
            ],
          )),
    );
  }

  Widget _googleMap() {
    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(48.1185897, -1.6211725),
      zoom: 14.4746,
    );

    Marker rennesMarker = Marker(
        position: LatLng(48.1185897, -1.6211725),
        markerId: MarkerId("rennesMarker"),
        infoWindow: InfoWindow(title: "Rennes"));

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {
            rennesMarker,
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Maps"),
        ),
        body: Stack(
          children: <Widget>[
            _googleMap(),
            _listDishes(),
          ],
        ),
        endDrawer: MiamityAppBar(
          auth: widget.auth,
          onSignedOut: widget.onSignedOut,
        ));
  }
}
