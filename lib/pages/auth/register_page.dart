import 'package:dochat/helper/helper_function.dart';
import 'package:dochat/pages/auth/login_page.dart';
import 'package:dochat/pages/home_page.dart';
import 'package:dochat/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
        
                const Text("DoChat", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
        
                const SizedBox(height: 10,),
        
                Text("Create your account now to chat and explore", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
        
                Image.asset("assets/images/register.png"),
        
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    )
                  ),
                  onChanged: (val) {
                    fullName = val;
                  },
                  validator: (val) {
                    if (val!.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Name cannot be empty";
                    }
                  },
                ),
      
                const SizedBox(height: 15,),
      
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
        
                const SizedBox(height: 15,),
        
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
                      register();
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                ),
        
                const SizedBox(height: 10,),
        
                Text.rich(
                  TextSpan(
                    text: "Already have an account ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Login now",
                        style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          nextScreen(context, const LoginPage());
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

  register() async {
    if(formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.registerUserWithEmailandPassword(fullName, email, password)
      .then((value) async {
        if(value==true){
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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