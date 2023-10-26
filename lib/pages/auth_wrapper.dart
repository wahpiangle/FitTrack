import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/auth/login_screen.dart';
import 'package:group_project/pages/workout/workout_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      // TODO set this to the login screen during production
      return WorkoutScreen();
    } else {
      return WorkoutScreen();
    }
  }
}