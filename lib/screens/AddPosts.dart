import 'package:flutter/material.dart';
import 'components/body.dart';

class AddPosts extends StatelessWidget {
  const AddPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Posts'),
        ),body:const Body()


    );

  }
}








/*
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 174, 207, 230),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.asset('lib/images/moawen.png'),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 174, 207, 230),
                  borderRadius: const BorderRadius.only(
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
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromARGB(
                                255, 218, 216, 216), //backgroud field text
                          ),
                          child: const TextField(
                            style: TextStyle(
                                color: Color.fromARGB(255, 12, 11, 11)),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              hintText: 'Username or Email',
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
                        const SizedBox(height: 3),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromARGB(255, 218, 216, 216),
                          ),
                          child: const TextField(
                            style: TextStyle(
                                color: Color.fromARGB(255, 12, 11, 11)),
                            decoration: InputDecoration(
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
                        // const SizedBox(height: 3),
                        //const Align(
                        //alignment: Alignment.bottomRight,
                        //child: Text(
                        //' Forgot your password',
                        //style: TextStyle(
                        //color: Colors.black,
                        //fontSize: 13.5,
                        //fontWeight: FontWeight.w500,
                        //),
                        //),
                        //),
                        SizedBox(height: 5),
                        Row(children: [
                          Expanded(child: Container()),
                          GestureDetector(
                            child: Text(
                              'Forgot your Password?      ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                // onTap: () {
                                //   Navigator.push(
                                //    context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return ResetPassword();
                                //   }),
                                //   );
                                // },
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SecondScreen()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 150, 209, 165),
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
                        const SizedBox(height: 90),
                        const Center(
                          child: Text(
                            ' Do not have an account?Register',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
}*/
