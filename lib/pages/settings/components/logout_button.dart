import 'package:flutter/material.dart';
import 'package:group_project/services/firebase/auth_service.dart';

class LogoutButton extends StatelessWidget {
  final AuthService authService = AuthService();
  LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          authService.signOut();
          Future.microtask(
              () => Navigator.of(context).popAndPushNamed('/auth'));
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
          backgroundColor: Colors.transparent,
        ),
        child: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
