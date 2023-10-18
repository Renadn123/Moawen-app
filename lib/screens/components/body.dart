import 'package:flutter/material.dart';
import 'add_post_button.dart';

class Body extends StatelessWidget {
  const Body({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AddPostPutton(),
      ],

    );
  }
}
