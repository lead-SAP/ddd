import 'package:ddd/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
class MySplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: CameraScreen(),
      title: Text(
        'Driver Distraction Detection',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      image: Image.asset("images/logo.png"),
      photoSize: 200,
      backgroundColor: Colors.white,
      loaderColor: Colors.black,
      loadingText: Text(
        "by AMR ABDULLAH",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
