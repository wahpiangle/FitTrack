import 'package:flutter/material.dart';

class CustomFriendsNavigationTab extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const CustomFriendsNavigationTab(
      {super.key,
      required this.text,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: SizedBox(
        height: 40,
        width: 100,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
