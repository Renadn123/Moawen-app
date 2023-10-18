import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moawen/layout.dart';

class postForm extends StatefulWidget {
  const postForm({super.key});
  @override
  State<postForm> createState() => _postFormState();
}

class _postFormState extends State<postForm> {
  File? imageFile;

  _showOption(builContext) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Gallery"),
                  onTap: () => _imageFromGallery(context),
                ),
                // ListTile(
                //   leading: Icon(Icons.camera),
                //   title: Text("Camera"),
                //   onTap:() => _imageFromCameraAlt (context),
                // ),
                // Add a third option for selecting from the camera
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Camera"),
                  onTap: () => _imageFromCameraAlt(context),
                ),
              ],
            ),
          ));
        });
  }

  Future _imageFromCameraAlt(BuildContext context) async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future _imageFromGallery(BuildContext context) async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
    if (!mounted) return;
    Navigator.pop(context);
  }

  final _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  String? _postContent;
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFF2F6968),
        body: Column(
          children: [
            Container(
              color: const Color(0XFF2F6968),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0XFF2F6968),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromARGB(255, 240, 247, 246),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          _postContent = value;
                                        });
                                      },
                                      controller: _textEditingController,
                                      maxLines: 20,
                                      maxLength: 500,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 12, 11, 11)),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              ' What is happening?Character limit is 500',
                                          hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 160, 165, 164),
                                          )),
                                    ),
                                  ),
                                  imageFile == null
                                      ? Container()
                                      : Image.file(
                                          imageFile!,
                                          width: 130,
                                          height: 130,
                                        ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: IconButton(
                                  onPressed: () => _showOption(context),
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                WidgetsFlutterBinding.ensureInitialized();

                                if (_postContent?.isNotEmpty == true) {
                                  if (imageFile != null) {
                                    FirebaseStorage storage =
                                        FirebaseStorage.instance;
                                    Reference ref = storage.ref().child(
                                        File(imageFile!.path).toString() +
                                            DateTime.now().toString());
                                    await ref.putFile(File(imageFile!.path));
                                    String imageUrl =
                                        await ref.getDownloadURL();
                                    await FirebaseFirestore.instance
                                        .collection("Post")
                                        .add({
                                      'PostText': _postContent,
                                      'UserID': FirebaseAuth
                                          .instance.currentUser?.uid,
                                      'Time': DateTime.now().toString(),
                                      'image': imageUrl,
                                    });
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection("Post")
                                        .add({
                                      'PostText': _postContent,
                                      'UserID': FirebaseAuth
                                          .instance.currentUser?.uid,
                                      'Time': DateTime.now().toString(),
                                      'image': null,
                                    });
                                  }
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainLayout(),
                                    ),
                                  );
                                } else {
                                  // Show an alert to the user
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: const Text(
                                          "Post content can't be empty from texts Click Cancel if you do not want to write anything"),
                                      actions: [
                                        TextButton(
                                          child: const Text("ok"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      const Color.fromARGB(255, 240, 247, 246),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Post',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 2, 2, 2),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              //cancel Button
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainLayout()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      const Color.fromARGB(255, 240, 247, 246),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// TextButton(//Camera button
//     onPressed: ()=> _showOption(context),
//   child: Container(
//     padding: const EdgeInsets.symmetric(
//         horizontal: 10, vertical: 1),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(30),
//       color: const Color.fromARGB(255, 150, 209, 165),
//     ),
//     child: const Padding(
//       padding: EdgeInsets.all(20.0),
//       child:
//       Icon(
//         Icons.camera_alt,
//         color: Color.fromARGB(255, 2, 2, 2),
//         size: 20,
//       ),
//     ),
//   ),
// )