import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/auth/login_screen.dart';
import 'package:group_project/pages/profile_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(
        context); //look for MyUser type data from the provider
    if (user == null) {
      return ProfileScreen();
    } else {
      return ProfileScreen();
    }
  }
}
