import 'package:flash_chat/Components/MyBox.dart';
import 'package:flutter/material.dart';
class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(image: AssetImage('images/logo.png')),
      ),
      bottomSheet: MyButton(Color(0xff76ABAE), "Get Started!", (){Navigator.pushNamed(context,'/welcomeScreen');}),
    );
  }
}
