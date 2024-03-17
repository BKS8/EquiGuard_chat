import 'package:flash_chat/screens/intro.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //     bodyText1: TextStyle(color: Colors.black54),
      //   ),
      // ),
      initialRoute: '/',
      routes: {
        '/':(context)=>Intro(),
        '/welcomeScreen':(context)=>WelcomeScreen(),
        '/ChatScreen':(context)=>ChatScreen(),
        '/LoginScreen':(context)=>LoginScreen(),
        '/RegistrationScreen':(context)=>RegistrationScreen(),
      },
    );
  }
}
