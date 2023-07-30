import 'package:dochat/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import '../widgets/widgets.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;

  ProfilePage({super.key, required this.userName, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile",
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[

            Icon(Icons.account_circle, size: 100, color: Colors.grey[700],),

            const SizedBox(height: 15,),

            Text(widget.userName, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),

            const SizedBox(height: 30,),

            const Divider(height: 2,),

            ListTile(
              onTap: () {
                nextScreenReplace(context, const HomeScreen());
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups", style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () {
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person_2),
              title: const Text("Profile", style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                barrierDismissible: false,
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    
                    title: Text("Log out"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, 
                        icon: Icon(Icons.cancel, color: Colors.red,)
                        ),
                        IconButton(
                        onPressed: () async {
                          await authService.signOut();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginPage()), (route) => false);
                        }, 
                        icon: Icon(Icons.done, color: Colors.green,)
                        )
                    ],
                    );
                }
                );
                // authService.signOut().whenComplete(() {
                //   nextScreenReplace(context, const LoginPage());
                // });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log Out", style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.grey[700],
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Full Name", style: TextStyle(fontSize: 17),),
                  Text(widget.userName, style: TextStyle(fontSize: 17),)
                ],
              ),
              const Divider(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Email", style: TextStyle(fontSize: 17),),
                  Text(widget.email, style: TextStyle(fontSize: 17),)
                ],
              ),
          ]
          ),
        ),
      ),
    );
  }
}