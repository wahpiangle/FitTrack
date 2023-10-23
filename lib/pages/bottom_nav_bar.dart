import 'package:flutter/material.dart';
// Can try with New workout page and settings page
class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({
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
      height: 80,
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onItemTapped,
        type: BottomNavigationBarType.fixed,
        items:  <BottomNavigationBarItem>[
           BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.insights_rounded),
            ),
            label: '',
          ),
        BottomNavigationBarItem(
            icon: Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE1F0CF), // Circle background color
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 36,
                )
            ),
          label: '',
    ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.fitness_center_rounded),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Icon(Icons.settings_outlined),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
