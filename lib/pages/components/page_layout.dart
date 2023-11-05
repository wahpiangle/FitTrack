import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'top_nav_bar.dart';
import 'bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({super.key});

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  final int _currentIndex = 2; // Initialize the selected page index

  //  page titles
  final List<String> _pageTitles = [
    'Home', // 0
    'History', // 1
    'Workout',
    'Exercises',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: TopNavBar(
        title: _pageTitles[_currentIndex],
        user: user,
      ),
    );
  }
}
