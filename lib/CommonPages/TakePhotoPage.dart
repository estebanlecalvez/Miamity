import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:miamitymds/MamaChef/screens/addPlatPage.dart';
import 'package:miamitymds/auth.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakeAPhotoPage extends StatefulWidget {
  TakeAPhotoPage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() => _TakeAPhotoPageState();
}

class _TakeAPhotoPageState extends State<TakeAPhotoPage> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  File image;

  @override
  void initState() {
    super.initState();
    // 1
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }

// 1, 2
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onCapturePressed(context) async {
    try {
      // 1
      final path = join(
        (await getTemporaryDirectory()).path,
        'image_${DateTime.now()}.png',
      );
      // 2
      await controller.takePicture(path);
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: path,
        ratioX: 1.3,
        ratioY: 1.0,
        maxWidth: 400,
        maxHeight: 400,
      );
      setState(() {
        image = croppedFile;
      });
      print("Picture saved on path : " + path);
      // 3
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPlate(
              auth: widget.auth, onSignedOut: widget.onSignedOut, image: image),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prendre une photo")),
      body: _cameraPreviewWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: () {
          _onCapturePressed(context);
        },
      ),
    );
  }
}
