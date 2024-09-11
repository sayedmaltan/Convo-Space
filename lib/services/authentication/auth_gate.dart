import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/modules/messenger/login_and_register/login_shop_screen/login.dart';
import 'package:iti_project/modules/messenger/messenger.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
          //   user is loged in
            if(snapshot.hasData)
              return Messenger();
            else
              return LoginScreen();
          },) ,
    );
  }
}
