import 'package:ddd/screens/attention_screen.dart';
import 'package:ddd/screens/login_screen.dart';
import 'package:ddd/screens/registration_screen.dart';
import 'package:ddd/screens/splash_screen.dart';
import 'package:ddd/screens/camera_screen.dart';
import 'package:ddd/screens/tracking_screen.dart';
import 'package:flutter/material.dart';
import 'package:ddd/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this, //this current welcomeScreen object
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);

    controller.forward();
    // controller.reverse(from: 1.0);

    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 99.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Driver Distraction Detection'],
                  textStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,

                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              txt_colour: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              txt_colour: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
            RoundedButton(
              title: 'Demo 1 Photo Recog.', //skips authentication for quick demonstration
              colour: Colors.green,
              txt_colour: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, TrackingScreen.id);
              },
            ),
            RoundedButton(
              title: 'Demo 2 Video Recog.', //skips authentication for quick demonstration
              colour: Colors.yellowAccent,
              txt_colour: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, CameraScreen.id);
              },
            ),
            RoundedButton(
              title: 'Demo 3 Attention', //skips authentication for quick demonstration
              colour: Colors.yellowAccent,
              txt_colour: Colors.black,
              onPressed: () {
                Navigator.pushNamed(context, AttentionScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
