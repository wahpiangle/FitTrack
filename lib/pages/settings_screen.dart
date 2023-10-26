import 'package:flutter/material.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'components/bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(title: 'Settings', user: null),
      body: const Center(
        child: Text('Settings'),
      ),
      // Nav Bar
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
