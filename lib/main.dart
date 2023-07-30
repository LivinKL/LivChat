import 'package:dochat/helper/helper_function.dart';
import 'package:dochat/pages/auth/login_page.dart';
import 'package:dochat/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'pages/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // if (kIsWeb){
  //   await Firebase.initializeApp(
  //     options: FirebaseOptions(apiKey: Constants.apiKey, appId: Constants.appId, messagingSenderId: Constants.messagingSenderId, projectId: Constants.projectId)
  //   );
  // }
  // else{
  //   await Firebase.initializeApp();
  // }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isSignedIn = false;

  @override
  void initState(){
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value!=null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      home: _isSignedIn ? const HomeScreen() : const LoginPage(),
    );
  }
}

