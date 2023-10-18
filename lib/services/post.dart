import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class post {
  Future savePost(text,imageFile) async {
    WidgetsFlutterBinding.ensureInitialized();
    await FirebaseFirestore.instance.collection("Post").add({
      'PostText': text,
      'UserID':FirebaseAuth.instance.currentUser?.uid,
      'Time': DateTime.now().toString(),
      'image': imageFile,
    });

  }
}