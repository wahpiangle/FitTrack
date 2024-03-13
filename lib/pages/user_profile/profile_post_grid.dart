import 'package:flutter/material.dart';
import 'package:group_project/models/firebase/firebase_user.dart';
import 'package:group_project/models/post.dart';
import 'package:group_project/services/firebase/firebase_posts_service.dart';


class PostTile extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const PostTile({Key? key, required this.post, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.network(
        post.firstImageUrl, // The URL of the post image
        fit: BoxFit.cover,
      ),
    );
  }
}
