import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miamitymds/Widgets/MiamityAppBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WhatIsNearMePage extends StatefulWidget {
  WhatIsNearMePage({Key key}) : super(key: key);
  @override
  static String routeName = "/whatIsNearMe";
  WhatIsNearMePageState createState() => WhatIsNearMePageState();
}

class WhatIsNearMePageState extends State<WhatIsNearMePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Maps"),),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
