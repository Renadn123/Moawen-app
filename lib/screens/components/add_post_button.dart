import 'package:flutter/material.dart';
import '../postForm.dart';
class AddPostPutton extends StatelessWidget {
  const AddPostPutton({super.key});


  @override
  Widget build(BuildContext context) {
    // Scaffold(
    //   floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,);
    return FloatingActionButton(onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const postForm()));
    },
      child:const Text('post'),
    );




  }
}
