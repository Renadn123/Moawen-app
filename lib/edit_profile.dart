import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moawen/flushbar_widget.dart';
import 'package:moawen/layout.dart';
import 'package:moawen/postmodel.dart';
import 'package:moawen/user.dart';

import 'admin/main_Admin.dart';
import 'forgotpassword.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.profile});

  final UserModel profile;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    fName.text = widget.profile.fName;
    lName.text = widget.profile.lName;
    email.text = widget.profile.email;
    username.text = widget.profile.username;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: const Color(0XFF2F6968),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                textFiled(
                  controller: fName,
                  hint: 'First Name',
                  valid: (val) {},
                ),
                const SizedBox(height: 20),
                textFiled(
                  controller: lName,
                  hint: 'Last Name',
                  valid: (val) {},
                ),
                const SizedBox(height: 20),
                textFiled(
                  controller: username,
                  hint: 'Username',
                  valid: (val) {},
                ),
                const SizedBox(height: 20),
                textFiled(
                  controller: email,
                  hint: 'E-mail',
                  valid: (val) {},
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ));
                  },
                  color: const Color(0XFF2F6968),
                  child: const Text(
                    'Rest Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (!isLoading)
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      isLoading = true;
                      setState(() {});
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.profile.userId)
                          .update(UserModel(
                            type: widget.profile.type,
                            email: email.text,
                            userId: widget.profile.userId,
                            date: widget.profile.date,
                            fName: fName.text,
                            lName: lName.text,
                            state: widget.profile.state,
                            username: username.text,
                          ).toMap())
                          .then((value) {
                        isLoading = false;
                        setState(() {});
                        flushbar(context, 'Change Profile Data Success');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CatchHelper.type == 'admin'
                                  ? const MainLayoutAdmin()
                                  : const MainLayout(),
                            ),
                            (route) => false);
                      }).catchError((e) {
                        isLoading = false;

                        setState(() {});
                        flushbar(context, 'has an error: ${e.toString()}');
                      });
                    },
                    color: const Color(0XFF2F6968),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                if (isLoading)
                  const CircularProgressIndicator(
                    color: Color(0XFF2F6968),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField textFiled({
    required TextEditingController controller,
    required String hint,
    required valid,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFF6FFFC))),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0XFF2F6968),
            width: 2,
          ),
        ),
        fillColor: const Color(0XFFF6FFFC),
        focusColor: const Color(0XFFF6FFFC),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFF6FFFC))),
        hintText: hint,
      ),
      validator: valid,
    );
  }
}
