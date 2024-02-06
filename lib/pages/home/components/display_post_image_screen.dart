import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';

class DisplayPostImageScreen extends StatelessWidget {
  final String imagePath;
  final String imagePath2;
  final int workoutSessionId;
  const DisplayPostImageScreen({
    super.key,
    required this.imagePath,
    required this.imagePath2,
    required this.workoutSessionId,
  });
  // TODO: display exercise details
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColours.primary,
      ),
      backgroundColor: AppColours.primary,
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: MediaQuery.of(context).size.height * 0.5,
        child: InteractiveImageViewer(
          imagePath: imagePath,
          imagePath2: imagePath2,
        ),
      ),
    );
  }
}
