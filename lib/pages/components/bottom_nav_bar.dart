import 'package:flutter/material.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 14,
      currentIndex: currentIndex,
      onTap: onTabTapped,
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
