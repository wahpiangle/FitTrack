import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'package:group_project/pages/exercises_screen.dart';
import 'package:group_project/pages/history_screen.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 4;
  final List<Widget Function()> pages = [
        () => const Home(),
        () => const HistoryScreen(),
        () => const ProfileScreen(),
        () => const ExercisesListScreen(),
        () => const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index >= 0 && index < pages.length) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => pages[index]()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // center title horizontally
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Will lead to the Search friends page or your desired action
          },
        ),
      ),
      body: const Center(
        child: Text('Settings'),
    ),
      // Nav Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

