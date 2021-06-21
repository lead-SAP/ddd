import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';


class UtilityScanner{
  UtilityScanner._();

  static Future<CameraDescription> getCamera(CameraLensDirection cameraLensDirection) async
  {
    return await availableCameras().then(
        (List<CameraDescription> cameras) => cameras.firstWhere(
                (CameraDescription cameraDescription) => cameraDescription.lensDirection == cameraLensDirection) );
  }

  static Future<dynamic> detect({CameraImage image, Future<dynamic> Function(FirebaseVisionImage image) detectInImage, int imageRotation}) async{
    return detectInImage(
      FirebaseVisionImage.fromBytes(
        concatenatePlanes(image.planes),
        buildMetaData(image, rotationIntToImageRotation(imageRotation))
      ),
    );
  }

  static Uint8List concatenatePlanes(List<Plane> planes){
    final WriteBuffer allBytes = WriteBuffer();
    for(Plane plane in planes){
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  static FirebaseVisionImageMetadata buildMetaData(CameraImage image, ImageRotation rotation){
    return FirebaseVisionImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rawFormat: image.format.raw,
        rotation: rotation,
        planeData: image.planes.map((Plane plane){
          return FirebaseVisionImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width
          );
        }).toList(),
    );
  }

  static ImageRotation rotationIntToImageRotation(int rotation){
    switch(rotation){
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      default:
        assert(rotation == 270);
        return ImageRotation.rotation270;

    }
  }
}