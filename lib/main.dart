import 'package:chat_app/Gui/FriendListScreen.dart';
import 'package:chat_app/Gui/ProfileInfo.dart';
import 'package:chat_app/Gui/SignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp (MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home:
      StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (context, snapshot) {
        if(snapshot.hasData){
          return FriendListScreen();
        }else{
          return SignIn();
        }
      },),
    );
  }
}