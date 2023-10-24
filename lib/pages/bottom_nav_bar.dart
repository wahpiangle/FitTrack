import 'package:flutter/material.dart';

// Can try with New workout page and settings page
class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //set this to 0 to disable the text below the icons
      selectedFontSize: 14,
      currentIndex: widget.currentIndex,
      onTap: widget.onItemTapped,
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
