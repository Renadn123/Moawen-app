import 'package:firebase_auth/firebase_auth.dart';
import 'package:moawen/login_screen.dart';
import 'package:moawen/postmodel.dart';

class LogoutPage {

 
  Future <LoginScreen> signOut()  async{
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.uid);
      await FirebaseAuth.instance.signOut();
      CatchHelper.setData(null);
      CatchHelper.setDataType(null);
    }
    return const LoginScreen();
  }

}