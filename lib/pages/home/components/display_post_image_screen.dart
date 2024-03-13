import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:intl/intl.dart'; // Import intl package for DateFormat

class DisplayPostImageScreen extends StatelessWidget {
  final Post post;
  const DisplayPostImageScreen({
    Key? key,
    required this.post,
  });

  // Function to format the date
  String formatDateTime(DateTime dateTime) {
    return DateFormat('EEEE, hh:mm:ss a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColours.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true, // Align the title in the middle
      ),
      backgroundColor: AppColours.primary,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${formatDateTime(post.date)}', // Display formatted date
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5, // Specify the desired height
              child: InteractiveImageViewer(
                imagePath: post.firstImageUrl,
                imagePath2: post.secondImageUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
