import 'package:dochat/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../helper/helper_function.dart';

class AuthService {
  
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  //login
  Future loginWithUserNameandPassword(String email, String password) async {
    try{

      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if (user != null){
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }



  //register
  Future registerUserWithEmailandPassword(String fullName, String email, String password) async {
    try{

      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if (user != null){
        DatabaseService(uid: user.uid).saveUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //signOut
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

}