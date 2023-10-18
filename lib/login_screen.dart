// ignore_for_file: dead_code
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/widget/flushbar_widget.dart';
import 'package:moawen/layout.dart';
import 'package:moawen/postmodel.dart';
import 'package:moawen/signin.dart';
import 'package:moawen/forgotpassword.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'admin/main_Admin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //controller

  //final _auth = FirebaseAuth.instance;
  //final _firestore = FirebaseFirestore.instance;

  GlobalKey<FormState> formKey = GlobalKey();
  final username = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passToggle = true;
  String? email;
  String? password;
  final _firestore = FirebaseFirestore.instance;

  /* vaildglobal(String val) async {
    if (val.isEmpty) {
      return "field can't empty";
    }
  }*/

  /* login() {
    var formdata = formstatesignin.currentState;
    if (formdata!.validate()) {
      print("valid");
    } else {
      print("not valid");
    }
  }*/
/*
  Future si() async {
    //await FirebaseAuth.instance.signInWithEmailAndPassword(
    email:
    _emailController.text.trim();
    password:
    _passwordController.text.trim();
  }*/

  /* @override
  disppse() {
    _emailController.dispose();
    _passwordController.dispose();
    _user.dispose();

    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 247, 246),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
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
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3),
                            const Center(
                              child: Text(
                                ' Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            const Text(
                              'Username or Email',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(
                                    255, 218, 216, 216), //backgroud field text
                              ),
                              child: TextFormField(
                                onChanged: (data) {
                                  email = data;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'must enter value into this TextFiled';
                                  }
                                  bool emailVaild = RegExp(
                                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!emailVaild) {
                                    return "Enter Vaild Email.com";
                                  }
                                  return null;
                                },
                                controller: _emailController,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 12, 11, 11)),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  hintText: 'Username or Email',
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromARGB(255, 148, 146, 146)),
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
                            const SizedBox(height: 3),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(255, 218, 216, 216),
                              ),
                              child: TextFormField(
                                onChanged: (data) {
                                  password = data;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'must enter value into this TextFiled';
                                  } else if (_passwordController.text.length <=
                                      8) {
                                    return 'password at least 8 character';
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                                obscureText: true,
                                onTap: () {
                                  setState(() {
                                    passToggle = !passToggle;
                                  });
                                },
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
                                      color:
                                          Color.fromARGB(255, 148, 146, 146)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return const ForgotPasswordPage();
                                }));
                              },
                              child: const Text(
                                'Forgot your Password?',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 5, 5, 5),
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    height: 0.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {});

                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  )
                                      .then((value) {
                                    CatchHelper.setData(value.user!.uid);
                                    _firestore
                                        .collection("users")
                                        .doc(value.user!.uid)
                                        .get()
                                        .then((value) => {
                                              //print (value.data()!.values)
                                              //print (value.data()!['type'].toString()),
                                            CatchHelper.setDataType(value.data()!['type'].toString()),
                                              if (value
                                                      .data()!['type']
                                                      .toString() ==
                                                  'admin')
                                                {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MainLayoutAdmin(),
                                                    ),
                                                  )
                                                }
                                              else
                                                {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MainLayout()),
                                                  ),
                                                }
                                            });
                                  }).catchError((e) {
                                    flushbar(context, e.toString());
                                  });

                                  //} //on FirebaseAuthException catch (ex) {
                                  //f (ex.code == 'user-not-found') {
                                  //  showSnackBar(context, 'user not found');
                                  // } else if (ex.code == 'wrong-password') {
                                  //   showSnackBar(context, 'wrong password');
                                  // }

                                  /* () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {});
                      */
                                  /*  UserCredential User= await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email:email!,
                  password: password!,
                        );*/
                                  // ignore: use_build_context_synchronously
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => ProfilePage()),
                                  // );
                                }
                              },

                              // ?//}).catchError((e) {
                              //ScaffoldMessenger.of(context).showSnackBar(
                              ///    SnackBar(content: Text(e.toString())));*?
                              // });

                              //  },
                              // (_formKey.currentState!.validate())
                              /* {
                              _auth
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text)
                                  .then((value) {
                                _firestore
                                    .collection("users")
                                    .doc(value.user!.uid)
                                    .set({
                                  'NID': value.user!.uid,
                                  'Email': _emailController.text,
                                  'Password': _passwordController.text,
                                  'status': 0,
                                  'doc': DateTime.now().toString(),
                                }).then((value) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddPosts())));
                              })
                              .catchError((e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              });
                            }*/
                              //},

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      const Color.fromARGB(255, 78, 218, 171),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      ' Log In',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Dose not have account?'),
                                TextButton(
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                      color: Color.fromARGB(255, 7, 7, 7),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return const signin();
                                    }));
                                  },
                                )
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
