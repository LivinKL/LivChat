import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dochat/pages/auth/register_page.dart';
import 'package:dochat/service/auth_service.dart';
import 'package:dochat/service/database_service.dart';
import 'package:dochat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helper/helper_function.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
        
                const Text("DoChat", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
        
                const SizedBox(height: 10,),
        
                Text("Login now to see what they are talking", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
        
                Image.asset("assets/images/login.png"),
        
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  onChanged: (val) {
                    email = val;
                  },
                  validator: (val) {
                    return RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$').hasMatch(val!) ? null : "Please enter a valid email";
                  },
                ),
        
                SizedBox(height: 15,),
        
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  onChanged: (val) {
                    password = val;
                  },
                  validator: (val) {
                    if (val!.length<6){
                      return "Password must be atleast 6 characters";
                    }
                    else{
                      return null;
                    }
                  },
                ),
        
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor ,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                    onPressed: () {
                      login();
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                ),
        
                const SizedBox(height: 10,),
        
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Register here",
                        style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          nextScreen(context, const RegisterPage());
                        }
                      )
                    ]
                  )
                )
        
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameandPassword(email, password)
      .then((value) async {
        if(value==true){
          QuerySnapshot snapshot =  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);

          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullname']);

          nextScreenReplace(context, const HomeScreen());
        }
        else{
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      }
      );
    }
  }
}