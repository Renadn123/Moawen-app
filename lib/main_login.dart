import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moawen/login_screen.dart';
import 'package:moawen/screens/AddPosts.dart';
import 'package:moawen/secondscreen.dart';
import 'login_screen.dart';
import 'package:moawen/screens/AddPosts.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LoginScreen();
          } else {
            return AddPosts();
          }
        },
      ),
    );
  }
}
