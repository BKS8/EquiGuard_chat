import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/MyBox.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner=false;

  get textController => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 150.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              TextField(
                controller: textController,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your name"),
              ),
              SizedBox(height: 8.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your email"),
                onChanged: (value) {
                  email=value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(hintText: "Enter your password"),
                onChanged: (value) {
                  password=value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              MyButton(
                Color(0xff76ABAE),
                "Register",
                () async {
                  setState(() {
                  showSpinner=true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      Navigator.pushNamed(context, '/ChatScreen');
                    }
                    setState(() {
                      showSpinner=false;
                    });
                  }
                  catch(e){
                    print(e);
                  }
                  }),
              Container(
                height: 50,
                width: 50,
                color: Colors.grey,
                child: TextButton(
                  onPressed: (){AuthService().signInWithGoogle();},
                  child: Text("G"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
