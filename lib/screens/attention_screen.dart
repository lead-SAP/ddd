import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ddd/components/rounded_button.dart';
import 'dart:io';

import 'package:flutter/widgets.dart';

class AttentionScreen extends StatefulWidget {
  static String id = 'attention_screen';


  @override
  _AttentionScreenState createState() => _AttentionScreenState();
}

class _AttentionScreenState extends State<AttentionScreen> {

  void playLocal() async {

    AudioCache audioCache = AudioCache();
    audioCache.play('PayAttention.mp3');
    await Future.delayed(const Duration(seconds: 3), (){});
    // sleep(const Duration(seconds: 4)); //dart.io method
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    this.playLocal();
  }

  Expanded buildLight({Color color}) {
    return Expanded(
      child: Container(
        color: color,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     body: SafeArea(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //          buildLight(color: Colors.red),
  //           buildLight(color: Colors.white),
  //           buildLight(color: Colors.blue),
  //           buildLight(color: Colors.white),
  //           buildLight(color: Colors.red),
  //           buildLight(color: Colors.white),
  //           buildLight(color: Colors.blue),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/police1.jpeg'),
          fit: BoxFit.cover,
        ),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ Text(
              "Pay Attention!!!",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 35,
                color: Colors.white,
              ),
            ),
          ]
          ),
        ],

      ),
      );
  }
}


