import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:intl/intl.dart';

class DisplayPostImageScreen extends StatelessWidget {
  final Post post;
  const DisplayPostImageScreen({
    super.key,
    required this.post,
  });
  // TODO: display exercise details & comments
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'My Post',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              '${DateFormat.yMMMMd().format(post.date)} ${DateFormat.jm().format(post.date)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        backgroundColor: AppColours.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColours.primary,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InteractiveImageViewer(
              imagePath: post.firstImageUrl,
              imagePath2: post.secondImageUrl,
            ),
            Divider(
              height: 30,
              color: AppColours.primaryBright,
            ),
          ],
        ),
      ),
    );
  }
}
