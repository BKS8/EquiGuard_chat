import 'dart:convert';
import 'package:flash_chat/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
final _firestore=FirebaseFirestore.instance;
late User CurrentUser;

// void isToxic(Function callback)

class ChatScreen extends StatefulWidget {
  List<dynamic> users = [];
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageEditingController=TextEditingController();
  final _auth =FirebaseAuth.instance;
  late String message;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        CurrentUser = user;
        print(CurrentUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Google.Inc'),
        backgroundColor: Color(0xff76ABAE),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
           MessageStreamer(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageEditingController,
                      onChanged: (value) {
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async{

                      messageEditingController.clear();
                      _firestore.collection('message').add({
                        'text':message,
                        'senderText':CurrentUser.email,
                      });
                      final uri =Uri.parse('http://13.232.204.142/');
                      final response = await http.get(uri);
                      final body = response.body;
                      final json = jsonDecode(body);
                      final result=json['response'];
                      globals.res=result;
                    },

                      child: Icon(Icons.send)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('message').snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff76ABAE),
              ),
            );
          }
          final messages = snapshot.data?.docs.reversed;
          List<MessageBubble>messageWidgets = [];
          for (var message in messages!) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['senderText'];
            final currentuser=CurrentUser.email;
            final messageWidget = MessageBubble(messageSender, messageText,currentuser==messageSender);
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
              children: messageWidgets,
            ),
          );
        }
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble(this.sender, this.text,this.isMe);

  final String sender;
  String warning='it is toxic';
  final String text;
  late final bool isMe;
  String getSenderText() {
    if (globals.res=="toxic") {
      return warning;
    } else {
      return text;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe==true ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black45,
          ),),
          Material(
            borderRadius: isMe==true ? BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0)
            ):
            BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                topRight: Radius.circular(30.0)
            ),
            elevation: 5.0,
            color: isMe==true ? Color(0xff76ABAE):Colors.white,
            child: Padding(
              padding:EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                  getSenderText(),
                style: TextStyle(
                  fontSize: 25.0,
                  color: isMe==true ? Colors.white:Colors.black45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
