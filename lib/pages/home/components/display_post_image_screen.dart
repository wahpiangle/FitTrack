import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';

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
        title: const Text(
          'My Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColours.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColours.primary,
      body: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: MediaQuery.of(context).size.height * 0.5,
        child: InteractiveImageViewer(
          imagePath: post.firstImageUrl,
          imagePath2: post.secondImageUrl,
        ),
      ),
    );
  }
}
