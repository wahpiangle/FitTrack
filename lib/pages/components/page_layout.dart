import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../exercise/exercise_list.dart';
import '../history_screen.dart';
import '../home.dart';
import '../settings_screen.dart';
import '../workout/workout_screen.dart';
import 'top_nav_bar.dart';
import 'bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({super.key});

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  late int _currentIndex = 2; // Initialize the selected page index to New Workout Screen

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
      ), body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          // Update the selected page when a navigation item is tapped.
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    // Switch  content based on the selected page index
    switch (_currentIndex) {
      case 0:
        return const Home();
      case 1:
        return const HistoryScreen();
      case 2:
        return const WorkoutScreen();
      case 3:
        return const ExerciseListScreen();
      case 4:
        return const SettingsScreen();
      default:
        return Container(); // Handle other cases as needed
    }
  }
}