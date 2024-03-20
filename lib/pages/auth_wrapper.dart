import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/pages/auth/email_verification_screen.dart';
import 'package:group_project/pages/auth/login_screen.dart';
import 'package:group_project/pages/layout/app_layout.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return const LoginScreen();
    } else {
      if (!user.emailVerified) {
        return const EmailVerificationScreen();
      }
      return const AppLayout();
    }
  }
}
