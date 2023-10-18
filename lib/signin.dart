import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/widget/flushbar_widget.dart';
import 'package:moawen/layout.dart';
import 'package:moawen/postmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

class signin extends StatefulWidget {
  const signin({super.key});
  @override
  State<signin> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<signin> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  TextEditingController f_name = TextEditingController();
  TextEditingController l_name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  DateTime date = DateTime.now();
  //bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 247, 246),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Image.asset('lib/images/moawen.png'),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              ' Sign in',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              'Create new account',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Text(
                            ' First name ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(
                                  255, 218, 216, 216), //background field text
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'must enter value into this TextFiled';
                                }
                                return null;
                              },
                              controller: f_name,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 12, 11, 11)),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.assignment_ind,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                hintText: 'First name',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 148, 146, 146)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Last name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 218, 216, 216),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'must enter value into this TextFiled';
                                }
                                return null;
                              },
                              controller: l_name,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 12, 11, 11)),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.assignment_ind,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                hintText: 'Last name',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 148, 146, 146)),
                              ),
                            ),
                          ),
                          const Text(
                            '  username',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(
                                  255, 218, 216, 216), //backgroud field text
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'must enter value into this TextFiled';
                                }
                                return null;
                              },
                              controller: username,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 12, 11, 11)),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                hintText: 'username',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 148, 146, 146)),
                              ),
                            ),
                          ),
                          const Text(
                            ' Email ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(
                                  255, 218, 216, 216), //backgroud field text
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'most enter value into this TextFiled';
                                } else if (!value.contains('@')) {
                                  return 'Plz enter valid Email!';
                                }
                                return null;
                              },
                              controller: email,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 12, 11, 11)),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 148, 146, 146)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromARGB(255, 218, 216, 216),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'must enter value into this TextFiled';
                                } else if (value.length <= 8) {
                                  return 'password at least 8 character';
                                }
                                return null;
                              },
                              controller: password,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 12, 11, 11)),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 148, 146, 146)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), //xxx
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _auth
                                    .createUserWithEmailAndPassword(
                                        email: email.text,
                                        password: password.text)
                                    .then((value) {
                                  _firestore
                                      .collection("users")
                                      .doc(value.user!.uid)
                                      .set({
                                    'NID': value.user!.uid,
                                    'fname': f_name.text,
                                    'lname': l_name.text,
                                    'username': username.text,
                                    'Email': email.text,
                                    'Password': password.text,
                                    'status': 0,
                                    'type':"user",
                                    'doc': DateTime.now().toString(),
                                  }).then((val) {
                                    CatchHelper.setData(value.user!.uid)
                                        .then((v) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                //const MainLayout(),
                                                const LoginScreen(),
                                          ),
                                          (route) {
                                            return false;
                                          },
                                        );
                                    }).catchError((e) {
                                      flushbar(context, e.toString());
                                    });
                                  });
                                }).catchError((e) {
                                  flushbar(context, e.toString());
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color.fromARGB(255, 78, 218, 171),
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    ' Sign In',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 2, 2, 2),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
