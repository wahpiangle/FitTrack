import 'package:flutter/material.dart';
import 'package:group_project/constants/page_enums.dart';
import 'package:group_project/main.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:group_project/pages/complete_workout/capture_image/components/interactive_image_viewer.dart';
import 'package:group_project/pages/complete_workout/capture_image/upload_image_provider.dart';
import 'package:group_project/pages/layout/app_layout.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';
import 'package:group_project/services/firebase/firebase_user_service.dart';
import 'package:provider/provider.dart';

class DisplayImageScreen extends StatefulWidget {
  final Function toggleRetake;
  final String imagePath;
  final String imagePath2;
  final WorkoutSession workoutSession;
  final DateTime pictureTakenTime;

  const DisplayImageScreen({
    super.key,
    required this.toggleRetake,
    required this.imagePath,
    required this.imagePath2,
    required this.workoutSession,
    required this.pictureTakenTime,
  });

  @override
  State<DisplayImageScreen> createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen> {
  void submitImage(UploadImageProvider uploadImageProvider) async {
    if (!mounted) return;
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AppLayout(
            currentIndex: Pages.HistoryPage,
          );
        },
      ),
    );
    Post newPost = Post(
      postId: '',
      caption: '',
      firstImageUrl: widget.imagePath,
      secondImageUrl: widget.imagePath2,
      date: DateTime.now(),
      postedBy: FirebaseUserService.auth.currentUser!.uid,
      workoutSessionId: widget.workoutSession.id,
    );
    objectBox.postService.addPost(
      newPost,
    );
    uploadImageProvider.reset();
    await FirebasePostsService.createPost(newPost, uploadImageProvider);
  }

  @override
  Widget build(BuildContext context) {
    final UploadImageProvider uploadImageProvider =
        context.read<UploadImageProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InteractiveImageViewer(
          toggleRetake: widget.toggleRetake,
          imagePath: widget.imagePath,
          imagePath2: widget.imagePath2,
        ),
        const SizedBox(
          height: 20,
        ),
        TextButton.icon(
          onPressed: () {
            submitImage(uploadImageProvider);
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
            size: 30,
          ),
          label: const Text(
            'Send',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}
