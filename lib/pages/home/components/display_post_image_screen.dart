import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:intl/intl.dart'; // Import intl package for DateFormat

class DisplayPostImageScreen extends StatelessWidget {
  final Post post;
  const DisplayPostImageScreen({
    super.key,
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
        backgroundColor: AppColours.primary,
        flexibleSpace: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'My Post',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                '${formatDateTime(post.date)}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColours.primary,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: InteractiveImageViewer(
            imagePath: post.firstImageUrl,
            imagePath2: post.secondImageUrl,
          ),
        ),
      ),
    );
  }
}
