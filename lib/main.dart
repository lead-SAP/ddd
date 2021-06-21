import 'package:ddd/screens/attention_screen.dart';
import 'package:ddd/screens/camera_screen.dart';
import 'package:ddd/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ddd/screens/welcome_screen.dart';
import 'package:ddd/screens/login_screen.dart';
import 'package:ddd/screens/registration_screen.dart';
import 'package:ddd/screens/tracking_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(DDD());
}

class DDD extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id, // home property and initialRoute are substitutes
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        TrackingScreen.id: (context) => TrackingScreen(),
        MySplashScreen.id: (context) => MySplashScreen(),
        CameraScreen.id: (context) => CameraScreen(),
        AttentionScreen.id: (context) => AttentionScreen(),

      },
    );
  }
}

