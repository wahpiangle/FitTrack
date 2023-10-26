import 'package:flutter/material.dart';
import 'exercise_list.dart'; // Import the ExerciseListScreen

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // set this to 0 to disable the text below the icons
      selectedFontSize: 14,
      currentIndex: widget.currentIndex,
      onTap: (index) {
        // Check the tapped index and navigate accordingly
        if (index == 3) {
          // If "Exercises" icon is tapped, navigate to ExerciseListScreen
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ExerciseListScreen(),
          ));
        } else {
          // For other icons, call the provided onItemTapped function
          widget.onItemTapped(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.insights_rounded),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Container(
            // uncomment this when selected text font size is set to 0
            // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE1F0CF), // Background color of the circle
            ),
            child: Container(
              padding: EdgeInsets.all(8),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.black54, // Icon color
                  size: 35,
                ),
              ),
            ),
          ),
          label: '',
        ), // Nav bar for middle "add workout" button
        const BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center_rounded),
          label: 'Exercises',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
