import 'package:camera/camera.dart';
import 'package:ddd/screens/attention_screen.dart';
import 'package:ddd/components/UtilityScanner.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  static String id = 'camera_screen';
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool attention = false;
  CameraController cameraController;
  bool isWorking = false;
  FaceDetector faceDetector;
  Size size;
  List<Face> facesList;
  CameraDescription description;
  CameraLensDirection cameraDirection = CameraLensDirection.front;



  initCamera() async{

    description = await UtilityScanner.getCamera(cameraDirection);
    cameraController = CameraController(description, ResolutionPreset.medium);
    faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      minFaceSize: 0.1, // the smallest face to search for is roughly 10% of the width of the image being searched.
      mode: FaceDetectorMode.fast,
    ));

    await cameraController.initialize().then((values) {
      if(!mounted){
        return;
      }
      cameraController.startImageStream((imageFromStream) => {
        if(!isWorking){
          isWorking = true,
          //face detection
          performDetectionOnStreamFrame(imageFromStream),
        }
      });
    });

    // await for(Face face in scanResults){
    //   double lE = face.leftEyeOpenProbability;
    //   double rE = face.rightEyeOpenProbability;
    //
    //   if(lE<0.4 || rE <0.4){
    //     Navigator.pushNamed(context, ActionScreen.id);
    //   }
    // }

    // await checkAttention();
  }

  dynamic scanResults;

  performDetectionOnStreamFrame(CameraImage cameraImage) async{
    UtilityScanner.detect(
      image: cameraImage,
      detectInImage: faceDetector.processImage,
      imageRotation: description.sensorOrientation,
    ).then((dynamic results){
      setState(() {
        scanResults = results;
      });
    }).whenComplete(() {
      isWorking = false;
    });

  }

@override
  void initState() {
    super.initState();
    initCamera();
  }
  @override
  void dispose() {
    super.dispose();
    cameraController?.dispose();
    faceDetector.close();
  }

  Widget buildResult(){
    if(scanResults == null || cameraController == null || !cameraController.value.isInitialized){
      return Text("");
    }
    final Size imageSize = Size(cameraController.value.previewSize.height, cameraController.value.previewSize.width);

    CustomPainter customPainter = FaceDetectorPainter(cameraDirection, imageSize, scanResults);
    return CustomPaint(painter: customPainter,);
  }

  Widget normalScreen(){
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }

  // Widget distractedScreen(){
  //   attention = true;
  //   return AttentionScreen();
  // }

  Widget distractedScreen(){
    return Scaffold(
      backgroundColor: Colors.red,
    );
  }


  // void checkAttention() async{
  //   for(Face face in scanResults){ //draw rectangle
  //     double leftEye = face.leftEyeOpenProbability;
  //     double rightEye = face.rightEyeOpenProbability;
  //     if(( leftEye < 0.1 || rightEye < 0.1 )){
  //       Navigator.pushNamed(context, AttentionScreen.id);
  //     }
  //   }
  // }
  void checkAttention(){
    // Navigator.pushNamed(context, AttentionScreen.id);
    print("Detection-----Detection--------Detection");
      attention = true;
  }


  toggleCameraToFrontOrBack() async{
    if(cameraDirection == CameraLensDirection.back){
      cameraDirection = CameraLensDirection.front;
    }
    else{
      cameraDirection = CameraLensDirection.back;
    }
    await cameraController.stopImageStream();
    await cameraController.dispose();

    setState(() {
      cameraController = null;
    });

    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackWidgetChildren = [];
    size = MediaQuery.of(context).size;
    if(cameraController != null){
      stackWidgetChildren.add(
        Positioned(
          top: 0,
          left: 0,
          width: size.width,
          height: size.height - 250,
          // height: size.height,
          child: Container(
            child: (cameraController.value.isInitialized)
                ? AspectRatio(
               aspectRatio: cameraController.value.aspectRatio,
              child: CameraPreview(cameraController),
            )
                : Container(),
          ),
        ),
      );
    }
    //build result
    stackWidgetChildren.add(
      Positioned(
        top: 0,
        left: 0,
        width: size.width,
        height: size.height - 250,
        child: buildResult(),
      ),
    );

    stackWidgetChildren.add(
      Positioned(
        top: size.height - 250,
        left: 0,
        width: size.width,
        height: 250,
        child: Scaffold(
          body: SafeArea(
            child: attention == false ? normalScreen() : distractedScreen(),
          ),
        ),
        ),
    );

    //toggle between front and back cameras
    stackWidgetChildren.add(
      Positioned(
        top: size.height - 250,
        left: 0,
        width: size.width,
        height: 250,
        child: Container(
          margin: EdgeInsets.only(bottom: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              IconButton(
                  icon: Icon(Icons.flip_camera_android_sharp, color: Colors.blueAccent),
                  iconSize: 50,
                  color: Colors.black,
                  onPressed: (){
                    toggleCameraToFrontOrBack();
                  },
              ),
              IconButton(
                icon: Icon(Icons.tab_unselected_rounded, color: Colors.white),
                iconSize: 50,
                color: Colors.black,
                onPressed: (){
                  Navigator.pushNamed(context, AttentionScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );


    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top:0),
        color: Colors.black,
        child: Stack(
          children: stackWidgetChildren,
        ),
      ),
    );
  }
}


class FaceDetectorPainter extends CustomPainter{
  final Size absoluteImageSize;
  final List<Face> faces;
  CameraLensDirection cameraLensDirection;
  FaceDetectorPainter(this.cameraLensDirection, this.absoluteImageSize, this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final textStyle = TextStyle(
      color: Colors.red,
      fontSize: 12,
    );
    final textStyle2 = TextStyle(
      color: Colors.yellow,
      fontSize: 12,
    );
    final Paint paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..color = Colors.green;

    for(Face face in faces){ //draw rectangle
      double leftEye = face.leftEyeOpenProbability;
      double rightEye = face.rightEyeOpenProbability;

      final textSpan = TextSpan(
        text: "L.E - " + leftEye.toString(),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      // final offset = Offset(50, 100);
      final offset = Offset(cameraLensDirection == CameraLensDirection.front?(absoluteImageSize.width-face.boundingBox.right)*scaleX:face.boundingBox.left*scaleX,
          face.boundingBox.top*scaleY-face.boundingBox.bottom*scaleY+face.boundingBox.bottom*scaleY);
      textPainter.paint(canvas, offset);
      final textSpan2 = TextSpan(
        text: "R.E - " + rightEye.toString(),
        style: textStyle2,
      );
      final textPainter2 = TextPainter(
        text: textSpan2,
        textDirection: TextDirection.ltr,
      );
      textPainter2.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final offset2 = Offset(cameraLensDirection == CameraLensDirection.front?(absoluteImageSize.width-face.boundingBox.right)*scaleX:face.boundingBox.left*scaleX,
          face.boundingBox.top*scaleY-face.boundingBox.bottom*scaleY+face.boundingBox.bottom*scaleY+20);
      textPainter2.paint(canvas, offset2);

      canvas.drawRect(
        Rect.fromLTRB(
          cameraLensDirection == CameraLensDirection.front?(absoluteImageSize.width-face.boundingBox.right)*scaleX:face.boundingBox.left*scaleX,
          face.boundingBox.top*scaleY,
          cameraLensDirection == CameraLensDirection.front?(absoluteImageSize.width-face.boundingBox.left)*scaleX:face.boundingBox.right*scaleX,
          face.boundingBox.bottom*scaleY,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize || oldDelegate.faces != faces;
  }

}