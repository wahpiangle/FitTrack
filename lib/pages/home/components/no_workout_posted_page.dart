import 'package:flutter/material.dart';
import 'package:group_project/constants/page_enums.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/layout/app_layout.dart';

class NoWorkoutPostedPage extends StatelessWidget {
  const NoWorkoutPostedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Start a Workout & add a post!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppColours.secondary,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppLayout(
                      currentIndex: Pages.NewWorkoutPage,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: const Text(
                'Start a Workout',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
    );
  }
}
