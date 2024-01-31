import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/constants/page_enums.dart';
import 'package:group_project/pages/layout/bottom_nav_bar.dart';
import 'package:group_project/pages/layout/top_nav_bar.dart';
import 'package:group_project/pages/exercise/exercise_list.dart';
import 'package:group_project/pages/history/history_screen.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/workout/workout_screen.dart';
import 'package:group_project/pages/settings/settings_screen.dart';

class AppLayout extends StatefulWidget {
  final int? currentIndex;

  const AppLayout({
    super.key,
    this.currentIndex = Pages.NewWorkoutPage,
  });

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late int _currentIndex;
  User? user;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? Pages.NewWorkoutPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        pageIndex: _currentIndex,
        title: _getPageTitle(),
        user: user,
      ),
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
      case Pages.HomePage:
        return 'Home';
      case Pages.HistoryPage:
        return 'History';
      case Pages.NewWorkoutPage:
        return 'New Workout';
      case Pages.ExerciseListPage:
        return 'Exercise List';
      case Pages.SettingsPage:
        return 'Settings';
      default:
        return '';
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case Pages.HomePage:
        return const Home();
      case Pages.HistoryPage:
        return const HistoryScreen(
          exerciseData: [],
        );
      case Pages.NewWorkoutPage:
        return const WorkoutScreen();
      case Pages.ExerciseListPage:
        return const ExerciseListScreen();
      case Pages.SettingsPage:
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
