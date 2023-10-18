import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moawen/login_screen.dart';
import 'package:moawen/postmodel.dart';
import 'admin/main_Admin.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //name: "test",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await CatchHelper.init();
  CatchHelper.getUid();
  CatchHelper.getType();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    CatchHelper.getUid();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Moawen",
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginScreen()
          : CatchHelper.type == 'admin'
              ? const MainLayoutAdmin()
              : const MainLayout(),
    );
  }

  _homeLog() {
    if (CatchHelper.uid == null || FirebaseAuth.instance.currentUser == null) {
      return const LoginScreen();
    }

    if (CatchHelper.type == 'admin' && CatchHelper.uid != null) {
      return const MainLayoutAdmin();
    } else {
      return const MainLayout();
    }
  }
}
