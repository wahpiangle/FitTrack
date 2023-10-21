import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/login_screen.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //the user's information (name, emailm etc.) can be accessed from this variable
    final user = Provider.of<User?>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        title: Center(child: const
        Text(
            'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          //Will lead to Search friends page
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: const Text('Sign out'),
          )
        ],
      ),

      body: Container(
        color: Color(0xFF1A1A1A),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (user?.photoURL != null)
                ClipOval(
                  child: Image.network(
                    user?.photoURL ?? 'default_image_url',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 15),
              Text(
                user?.displayName ?? '',
              ),
              //const SizedBox(height: 32),
              //Start an Empty Widget
              Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Container(
                  width: 300,
                  height: 60,
                  child: TextButton(
                    onPressed: (){},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFFC1C1C1)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Set the border radius to make it round
                          ),
                        ),
                      ),
                      child: Text(
                          "Start an empty workout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          fontSize: 20,
                        ),
                      ),
                  ),
                ),
              ),
              //End of Start a widget
      ]
          ),
      ),
     ),
    );
  }
}
