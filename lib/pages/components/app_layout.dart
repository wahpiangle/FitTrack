import 'package:flutter/material.dart';
import 'package:group_project/pages/components/bottom_nav_bar.dart';
import 'package:group_project/pages/components/top_nav_bar.dart';
import 'package:group_project/pages/exercise/exercise_list.dart';
import 'package:group_project/pages/history_screen.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/workout/workout_screen.dart';
import 'package:group_project/pages/settings_screen.dart';



class AppLayout extends StatefulWidget {
  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0; // Initial index, can be changed based on your needs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: TopNavBar(
      //   pageIndex: _currentIndex,
      //   title: _getPageTitle(),
      // ),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          _changePage(index);
        },
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'History';
      case 2:
        return 'Workout';
      case 3:
        return 'Exercise List';
      case 4:
        return 'Settings';
      default:
        return '';
    }
  }

  Widget _buildBody() {
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
        return const SizedBox.shrink();
    }
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
