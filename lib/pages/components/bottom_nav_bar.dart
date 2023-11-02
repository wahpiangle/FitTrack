import 'package:flutter/material.dart';
import 'package:group_project/pages/exercise/exercise_list.dart';
import 'package:group_project/pages/history_screen.dart';
import 'package:group_project/pages/home.dart';
import 'package:group_project/pages/workout/workout_screen.dart';
import 'package:group_project/pages/settings_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  CustomBottomNavigationBar({
    super.key,
    required this.currentIndex, required Function(int p1) onTabTapped,
  });

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final List<Widget Function()> pages = [
    () => const Home(),
    () => const HistoryScreen(),
    () => const WorkoutScreen(),
    () => const ExerciseListScreen(),
    () => const SettingsScreen(),
  ];
  void onItemTapped(int index) {
    if (index >= 0 && index < pages.length) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => pages[index](),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // set this to 0 to disable the text below the icons
      selectedFontSize: 14,
      currentIndex: widget.currentIndex,
      onTap: (index) {
        onItemTapped(index);
      },
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.home_outlined),
          ),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.insights_rounded),
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Container(
            // uncomment this when selected text font size is set to 0
            // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            margin: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE1F0CF), // Background color of the circle
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.add,
                color: Colors.black54,
                size: 30,
              ),
            ),
          ),
          label: '',
        ), // Nav bar for middle "add workout" button
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.fitness_center_rounded),
          ),
          label: 'Exercises',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(5.0),
            child: Icon(Icons.settings_outlined),
          ),
          label: 'Settings',
        ),
      ],
    );
  }
}
