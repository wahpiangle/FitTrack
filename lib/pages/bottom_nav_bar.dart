import 'package:flutter/material.dart';
// Can try with New workout page and settings page
class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.insights_rounded),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 56,
              height: 56,
              margin: const EdgeInsets.only(top: 2.0), // Adjust the top value to move the container down
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE1F0CF), // Background color of the circle
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.black54, // Icon color
                  size: 30,
                ),
              ),
            ),
            label: '',
          ), // Nav bar for middle "add workout" button
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.fitness_center_rounded),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.settings_outlined),
            ),
            label: '',
          ),
        ],
      ),
    );
  }

}
